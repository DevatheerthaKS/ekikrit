from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer
import numpy as np
import re


# ============================================================
# FASTAPI APP
# ============================================================

app = FastAPI(
    title="Ekikrit AI Duplicate Detection"
)


# ============================================================
# CORS
# Allows Flutter Web / Chrome to communicate with this API
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# AI MODEL
# ============================================================

model = SentenceTransformer(
    "all-MiniLM-L6-v2"
)


# ============================================================
# PROJECT MODEL
# ============================================================

class Project(BaseModel):

    title: str = ""

    description: str = ""

    category: str = ""

    department: str = ""

    location: str = ""


# ============================================================
# DUPLICATE REQUEST MODEL
# ============================================================

class DuplicateRequest(BaseModel):

    new_project: Project

    existing_projects: list[Project]


# ============================================================
# CLEAN TEXT
# ============================================================

def clean_text(text: str) -> str:

    text = text.lower()

    text = re.sub(
        r"[^a-z0-9\s]",
        " ",
        text
    )

    text = re.sub(
        r"\s+",
        " ",
        text
    )

    return text.strip()


# ============================================================
# CREATE TEXT FOR AI
# ============================================================

def project_text(project: Project) -> str:

    return (

        f"project title "
        f"{clean_text(project.title)}. "

        f"project description "
        f"{clean_text(project.description)}. "

        f"category "
        f"{clean_text(project.category)}. "

        f"department "
        f"{clean_text(project.department)}. "

        f"location "
        f"{clean_text(project.location)}."
    )


# ============================================================
# COSINE SIMILARITY
# ============================================================

def cosine_similarity(a, b):

    denominator = (
        np.linalg.norm(a)
        *
        np.linalg.norm(b)
    )

    if denominator == 0:

        return 0.0

    return float(
        np.dot(a, b)
        /
        denominator
    )


# ============================================================
# LOCATION SIMILARITY
# ============================================================

def location_similarity(
    location1: str,
    location2: str
) -> float:

    location1 = clean_text(
        location1
    )

    location2 = clean_text(
        location2
    )

    if not location1 or not location2:

        return 0.0

    # Exact same location
    if location1 == location2:

        return 1.0

    words1 = set(
        location1.split()
    )

    words2 = set(
        location2.split()
    )

    # Some common location words
    if words1.intersection(words2):

        return 0.5

    return 0.0


# ============================================================
# HOME / HEALTH CHECK
# ============================================================

@app.get("/")
def home():

    return {

        "message":
            "Ekikrit AI Duplicate Detection API is running"

    }


# ============================================================
# DUPLICATE DETECTION
# ============================================================

@app.post("/check-duplicate")
def check_duplicate(
    request: DuplicateRequest
):

    new_project = request.new_project


    # --------------------------------------------------------
    # NO EXISTING PROJECTS
    # --------------------------------------------------------

    if not request.existing_projects:

        return {

            "is_duplicate": False,

            "score": 0,

            "percentage": 0,

            "message":
                "No existing projects to compare.",

            "best_match": None,

            "all_matches": []
        }


    # --------------------------------------------------------
    # CREATE EMBEDDING FOR NEW PROJECT
    # --------------------------------------------------------

    new_text = project_text(
        new_project
    )

    new_embedding = model.encode(

        new_text,

        normalize_embeddings=True
    )


    results = []


    # ========================================================
    # COMPARE WITH EVERY EXISTING PROJECT
    # ========================================================

    for project in request.existing_projects:


        existing_text = project_text(
            project
        )


        existing_embedding = model.encode(

            existing_text,

            normalize_embeddings=True
        )


        # ----------------------------------------------------
        # SEMANTIC SIMILARITY
        # ----------------------------------------------------

        semantic_score = cosine_similarity(

            new_embedding,

            existing_embedding
        )


        # ----------------------------------------------------
        # LOCATION SIMILARITY
        # ----------------------------------------------------

        location_score = location_similarity(

            new_project.location,

            project.location
        )


        # ----------------------------------------------------
        # CATEGORY SIMILARITY
        # ----------------------------------------------------

        category_score = (

            1.0

            if clean_text(
                new_project.category
            )
            ==
            clean_text(
                project.category
            )

            else 0.0
        )


        # ----------------------------------------------------
        # FINAL SCORE
        #
        # Semantic similarity = 70%
        # Location similarity = 20%
        # Category similarity = 10%
        # ----------------------------------------------------

        final_score = (

            semantic_score * 0.70

            +

            location_score * 0.20

            +

            category_score * 0.10
        )


        results.append({

            "title":
                project.title,

            "department":
                project.department,

            "location":
                project.location,

            "semantic_score":
                round(
                    semantic_score,
                    4
                ),

            "location_score":
                round(
                    location_score,
                    4
                ),

            "category_score":
                round(
                    category_score,
                    4
                ),

            "final_score":
                round(
                    final_score,
                    4
                )
        })


    # ========================================================
    # SORT BY HIGHEST SIMILARITY
    # ========================================================

    results.sort(

        key=lambda x:
            x["final_score"],

        reverse=True
    )


    # ========================================================
    # BEST MATCH
    # ========================================================

    best_match = results[0]

    score = best_match[
        "final_score"
    ]


    # ========================================================
    # DUPLICATE THRESHOLD
    # ========================================================

    is_duplicate = (
        score >= 0.70
    )


    # ========================================================
    # MESSAGE
    # ========================================================

    if is_duplicate:

        message = (
            "Possible duplicate project detected."
        )

    elif score >= 0.50:

        message = (
            "Project has some similarity "
            "with an existing project."
        )

    else:

        message = (
            "No significant duplicate detected."
        )


    # ========================================================
    # RESPONSE
    # ========================================================

    return {

        "is_duplicate":
            is_duplicate,

        "score":
            round(
                score,
                4
            ),

        "percentage":
            round(
                score * 100,
                2
            ),

        "message":
            message,

        "best_match":
            best_match,

        "all_matches":
            results[:5]
    }