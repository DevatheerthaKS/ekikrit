import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/duplicate_detection_service.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {

  final TextEditingController projectNameController =
      TextEditingController();

  final TextEditingController wardController =
      TextEditingController();

  final TextEditingController contractorController =
      TextEditingController();

  final TextEditingController budgetController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController startDateController =
      TextEditingController();

  final TextEditingController endDateController =
      TextEditingController();

  String? selectedDepartment;
  String? selectedCategory;

  @override
  void dispose() {
    projectNameController.dispose();
    wardController.dispose();
    contractorController.dispose();
    budgetController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      TextEditingController controller) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  final List<String> departments = [
    "PWD",
    "KWA",
    "LSGD",
  ];

  final List<String> categories = [
    "Roads",
    "Water Supply",
    "Drainage",
    "Buildings",
    "Street Lighting",
  ];

  // ============================================================
  // AI DUPLICATE CHECK
  // ============================================================

  Future<void> _createProject() async {

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (projectNameController.text.trim().isEmpty ||
        selectedDepartment == null ||
        selectedCategory == null ||
        wardController.text.trim().isEmpty ||
        budgetController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields",
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // SHOW LOADING
    // ----------------------------------------------------------

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return const AlertDialog(
          content: Row(
            children: [

              CircularProgressIndicator(),

              SizedBox(width: 20),

              Expanded(
                child: Text(
                  "Checking for duplicate projects...",
                ),
              ),
            ],
          ),
        );
      },
    );

    try {

      // --------------------------------------------------------
      // GET EXISTING PROJECTS FROM FIRESTORE
      // --------------------------------------------------------

      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("projects")
              .get();

      final List<Map<String, dynamic>>
          existingProjects = [];

      for (final doc in snapshot.docs) {

        final data =
            doc.data() as Map<String, dynamic>;

        existingProjects.add({

          "title":
              data["title"] ?? "",

          "description":
              data["description"] ?? "",

          "category":
              data["category"] ?? "",

          "department":
              data["department"] ?? "",

          "location":
              data["location"] ?? "",
        });
      }

      // --------------------------------------------------------
      // NEW PROJECT DETAILS
      // --------------------------------------------------------

      final String projectTitle =
          projectNameController.text.trim();

      final String description =
          descriptionController.text.trim();

      final String department =
          selectedDepartment!;

      final String category =
          selectedCategory!;

      final String location =
          "Ward ${wardController.text.trim()}";

      // --------------------------------------------------------
      // CALL AI
      // --------------------------------------------------------

      final result =
          await DuplicateDetectionService.checkDuplicate(

        title: projectTitle,

        description: description,

        category: category,

        department: department,

        location: location,

        existingProjects:
            existingProjects,
      );

      // --------------------------------------------------------
      // CLOSE LOADING
      // --------------------------------------------------------

      if (!mounted) return;

      Navigator.pop(context);

      // --------------------------------------------------------
      // READ AI RESULT
      // --------------------------------------------------------

      final bool isDuplicate =
          result["is_duplicate"] ?? false;

      final double percentage =
          (result["percentage"] ?? 0).toDouble();

      final String message =
          result["message"] ?? "";

      final dynamic bestMatch =
          result["best_match"];

      // --------------------------------------------------------
      // DUPLICATE FOUND
      // --------------------------------------------------------

      if (isDuplicate) {

        final String matchingProject =
            bestMatch != null
                ? bestMatch["title"] ?? "Unknown project"
                : "Unknown project";

        final bool? createAnyway =
            await showDialog<bool>(
          context: context,

          builder: (context) {

            return AlertDialog(

              title: const Row(
                children: [

                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Possible Duplicate",
                    ),
                  ),
                ],
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Similarity: "
                    "${percentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Similar existing project:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    matchingProject,
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {

                    Navigator.pop(
                      context,
                      false,
                    );
                  },

                  child: const Text(
                    "Cancel",
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    Navigator.pop(
                      context,
                      true,
                    );
                  },

                  child: const Text(
                    "Create Anyway",
                  ),
                ),
              ],
            );
          },
        );

        // ------------------------------------------------------
        // USER CANCELLED
        // ------------------------------------------------------

        if (createAnyway != true) {
          return;
        }
      }

      // --------------------------------------------------------
      // SAVE PROJECT
      // --------------------------------------------------------

      await FirebaseFirestore.instance
          .collection("projects")
          .add({

        "title":
            projectTitle,

        "department":
            department,

        "category":
            category,

        "status":
            "Ongoing",

        "budget":
            "₹${budgetController.text.trim()}",

        "location":
            location,

        "ward":
            wardController.text.trim(),

        "contractor":
            contractorController.text.trim(),

        "description":
            description,

        "startDate":
            startDateController.text.trim(),

        "endDate":
            endDateController.text.trim(),

        // AI information
        "duplicateChecked":
            true,

        "duplicateScore":
            percentage,

        "createdAt":
            FieldValue.serverTimestamp(),
      });

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Project Created Successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "AI duplicate check failed: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff0F7C73),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ==================================================
            // BASIC INFORMATION
            // ==================================================

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color:
                                Colors.teal.withOpacity(.1),

                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.info_outline,
                            color:
                                Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Basic Information",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Project Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          projectNameController,

                      decoration: InputDecoration(
                        hintText:
                            "Enter formal project title",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Department",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedDepartment,

                      decoration:
                          InputDecoration(
                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),

                      hint:
                          const Text(
                        "Select Department",
                      ),

                      items:
                          departments.map((e) {

                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setState(() {
                          selectedDepartment =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Category",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,

                      decoration:
                          InputDecoration(
                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),

                      hint:
                          const Text(
                        "Select Category",
                      ),

                      items:
                          categories.map((e) {

                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setState(() {
                          selectedCategory =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Ward Number",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          wardController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(
                        hintText: "e.g. 12",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Contractor Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          contractorController,

                      decoration:
                          InputDecoration(
                        hintText:
                            "Assigned contractor firm",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // LOCATION & DETAILS
            // ==================================================

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color:
                                Colors.teal.withOpacity(.1),

                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.location_on_outlined,
                            color:
                                Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Location & Details",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      height: 220,
                      width: double.infinity,

                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),

                        color:
                            Colors.grey.shade300,

                        image:
                            const DecorationImage(
                          image: NetworkImage(
                            "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png",
                          ),

                          fit: BoxFit.cover,
                          opacity: .25,
                        ),
                      ),

                      child: Container(
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),

                          color:
                              Colors.black
                                  .withOpacity(.18),
                        ),

                        child: const Center(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [

                              CircleAvatar(
                                radius: 28,

                                backgroundColor:
                                    Colors.white,

                                child: Icon(
                                  Icons.location_on,
                                  color:
                                      Color(0xff0F7C73),
                                  size: 34,
                                ),
                              ),

                              SizedBox(height: 15),

                              Text(
                                "Select Location on Map",
                                style: TextStyle(
                                  color:
                                      Colors.white,

                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Project Description",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          descriptionController,

                      maxLines: 5,

                      decoration:
                          InputDecoration(
                        hintText:
                            "Briefly describe project scope,\ngoals, and target outcomes...",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.all(18),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // TIMELINE & BUDGET
            // ==================================================

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(22),
              ),

              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color:
                                Colors.teal.withOpacity(.1),

                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons
                                .account_balance_wallet_outlined,
                            color:
                                Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Timeline & Budget",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Total Budget (₹)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          budgetController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(
                        prefixIcon:
                            const Icon(
                          Icons.currency_rupee,
                        ),

                        hintText: "0.00",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "Start Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                controller:
                                    startDateController,

                                readOnly: true,

                                onTap: () =>
                                    _selectDate(
                                  startDateController,
                                ),

                                decoration:
                                    InputDecoration(
                                  hintText:
                                      "mm/dd/yyyy",

                                  suffixIcon:
                                      const Icon(
                                    Icons.calendar_today,
                                  ),

                                  filled: true,

                                  fillColor:
                                      const Color(
                                    0xffF7F8FC,
                                  ),

                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "End Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                controller:
                                    endDateController,

                                readOnly: true,

                                onTap: () =>
                                    _selectDate(
                                  endDateController,
                                ),

                                decoration:
                                    InputDecoration(
                                  hintText:
                                      "mm/dd/yyyy",

                                  suffixIcon:
                                      const Icon(
                                    Icons.calendar_today,
                                  ),

                                  filled: true,

                                  fillColor:
                                      const Color(
                                    0xffF7F8FC,
                                  ),

                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // CREATE PROJECT BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton.icon(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff0F7C73),

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                onPressed: _createProject,

                icon: const Icon(
                  Icons.check_circle,
                ),

                label: const Text(
                  "Create Project",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}