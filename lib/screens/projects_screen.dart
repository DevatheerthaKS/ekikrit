import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_project_screen.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final Color primaryColor = const Color(0xFF087F78);

  String selectedFilter = "All";
  String searchText = "";

  final TextEditingController searchController =
      TextEditingController();

  // ============================================================
  // FILTERS
  // ============================================================

  final List<String> filters = [
    "All",
    "Roads",
    "Water Supply",
    "Drainage",
    "Buildings",
    "Street Lighting",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      body: SafeArea(
        child: Column(
          children: [

            // ====================================================
            // HEADER
            // ====================================================

            _buildHeader(),

            // ====================================================
            // SEARCH BAR
            // ====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                12,
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      height: 56,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),

                        border: Border.all(
                          color: const Color(0xFFD5DADC),
                        ),
                      ),

                      child: TextField(
                        controller: searchController,

                        onChanged: (value) {
                          setState(() {
                            searchText = value.toLowerCase();
                          });
                        },

                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF263746),
                        ),

                        decoration: const InputDecoration(
                          hintText:
                              "Search projects...",

                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF7C8790),
                          ),

                          prefixIcon: Icon(
                            Icons.search,
                            size: 28,
                            color: Color(0xFF68747A),
                          ),

                          border: InputBorder.none,

                          contentPadding:
                              EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Filter button

                  Container(
                    width: 56,
                    height: 56,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),

                      border: Border.all(
                        color:
                            const Color(0xFFD5DADC),
                      ),
                    ),

                    child: IconButton(
                      onPressed: () {
                        _showFilterDialog();
                      },

                      icon: Icon(
                        Icons.tune,
                        size: 27,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ====================================================
            // CATEGORY FILTERS
            // ====================================================

            _buildFilters(),

            // ====================================================
            // ACTIVE PROJECTS TITLE
            // ====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                30,
                24,
                20,
                14,
              ),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Active Projects",

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF172B3A),
                  ),
                ),
              ),
            ),

            // ====================================================
            // FIRESTORE PROJECT LIST
            // ====================================================

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("projects")
                    .snapshots(),

                builder: (context, snapshot) {

                  // Loading

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }

                  // Error

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading projects",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }

                  // Empty

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Convert Firestore documents

                  List<Project> projects =
                      snapshot.data!.docs.map((doc) {

                    final data =
                        doc.data()
                            as Map<String, dynamic>;

                    return Project(
                      id: doc.id,

                      title:
                          data["title"] ?? "",

                      department:
                          data["department"] ?? "",

                      category:
                          data["category"] ?? "",

                      status:
                          data["status"] ?? "Ongoing",

                      budget:
                          data["budget"] ?? "",

                      location:
                          data["location"] ?? "",

                      startDate:
                          data["startDate"] ?? "",
                    );
                  }).toList();

                  // ==================================================
                  // CATEGORY FILTER
                  // ==================================================

     if (selectedFilter != "All") {
  projects = projects.where((project) {
    return project.category.trim().toLowerCase() ==
        selectedFilter.trim().toLowerCase();
  }).toList();
}

                  // ==================================================
                  // SEARCH FILTER
                  // ==================================================

                  if (searchText.isNotEmpty) {

                    projects =
                        projects.where((project) {

                      return project.title
                              .toLowerCase()
                              .contains(searchText) ||

                          project.department
                              .toLowerCase()
                              .contains(searchText) ||

                          project.location
                              .toLowerCase()
                              .contains(searchText) ||

                          project.category
                              .toLowerCase()
                              .contains(searchText);

                    }).toList();
                  }

                  // No matching project

                  if (projects.isEmpty) {
                    return _buildNoResults();
                  }

                  // ==================================================
                  // LIST
                  // ==================================================

                  return ListView.builder(

                    padding:
                        const EdgeInsets.fromLTRB(
                      28,
                      0,
                      28,
                      100,
                    ),

                    itemCount: projects.length,

                    itemBuilder:
                        (context, index) {

                      return _buildProjectCard(
                        projects[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // FLOATING ADD BUTTON
      // ==========================================================

      floatingActionButton:
          FloatingActionButton(

        backgroundColor: primaryColor,

        elevation: 5,

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateProjectScreen(),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar:
          _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {

    return Container(
      height: 72,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 28,
      ),

      decoration: const BoxDecoration(
        color: Color(0xFFE9F0FF),

        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E5EA),
          ),
        ),
      ),

      child: Row(
        children: [

          // Menu

          IconButton(
            padding: EdgeInsets.zero,

            constraints:
                const BoxConstraints(),

            onPressed: () {
              Scaffold.of(context).openDrawer();
            },

            icon: Icon(
              Icons.menu,
              size: 30,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 18),

          // Logo / Name

          const Text(
            "Ekikrit",

            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695F),
            ),
          ),

          const Spacer(),

          // Notification

          IconButton(
            onPressed: () {

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content:
                      Text("No new notifications"),
                ),
              );
            },

            icon: Icon(
              Icons.notifications_none,
              size: 31,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {

    return SizedBox(
      height: 54,

      child: ListView.separated(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 28,
        ),

        scrollDirection:
            Axis.horizontal,

        itemCount: filters.length,

        separatorBuilder:
            (_, __) =>
                const SizedBox(width: 10),

        itemBuilder:
            (context, index) {

          final filter =
              filters[index];

          final bool selected =
              selectedFilter == filter;

          return GestureDetector(

            onTap: () {

              setState(() {
                selectedFilter = filter;
              });
            },

            child: Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 28,
              ),

              alignment:
                  Alignment.center,

              decoration:
                  BoxDecoration(

                color: selected
                    ? primaryColor
                    : const Color(0xFFF1F5FC),

                borderRadius:
                    BorderRadius.circular(30),

                border: Border.all(
                  color: selected
                      ? primaryColor
                      : const Color(
                          0xFFBEC8D0,
                        ),
                ),
              ),

              child: Text(

                filter,

                style: TextStyle(

                  fontSize: 16,

                  fontWeight:
                      FontWeight.w500,

                  color: selected
                      ? Colors.white
                      : const Color(
                          0xFF4F5A60,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PROJECT CARD
  // ============================================================

  Widget _buildProjectCard(
      Project project) {

    final statusColors =
        _getStatusColors(
      project.status,
    );

    return GestureDetector(

      onTap: () {
        _showProjectDetails(project);
      },

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
            const EdgeInsets.fromLTRB(
          22,
          22,
          22,
          18,
        ),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          border: Border.all(
            color:
                const Color(0xFFE5E8EA),
          ),

          boxShadow: [

            BoxShadow(
              color:
                  Colors.black.withOpacity(
                .035,
              ),

              blurRadius: 8,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // TITLE + STATUS
            // ==================================================

            Row(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Expanded(
                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        project.title,

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            const TextStyle(

                          fontSize: 25,

                          fontWeight:
                              FontWeight.w500,

                          color:
                              Color(0xFF172B3A),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(

                        project.department
                            .toUpperCase(),

                        style:
                            const TextStyle(

                          fontSize: 15,

                          fontWeight:
                              FontWeight.w500,

                          letterSpacing:
                              0.8,

                          color:
                              Color(0xFF4F5A60),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Status badge

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        statusColors.background,

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: Text(

                    project.status,

                    style: TextStyle(

                      fontSize: 15,

                      fontWeight:
                          FontWeight.w600,

                      color:
                          statusColors.text,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // ==================================================
            // LOCATION + BUDGET
            // ==================================================

            Row(
              children: [

                const Icon(
                  Icons.location_on_outlined,
                  size: 23,
                  color: Color(0xFF56636A),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(

                    project.location,

                    style:
                        const TextStyle(

                      fontSize: 17,

                      fontWeight:
                          FontWeight.w500,

                      color:
                          Color(0xFF4D575C),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 22,
                  color: Color(0xFF56636A),
                ),

                const SizedBox(width: 6),

                Text(

                  project.budget,

                  style:
                      const TextStyle(

                    fontSize: 17,

                    fontWeight:
                        FontWeight.w500,

                    color:
                        Color(0xFF4D575C),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CATEGORY
            // ==================================================

            if (project.category.isNotEmpty)
              Row(
                children: [

                  const Icon(
                    Icons.category_outlined,
                    size: 21,
                    color: Color(0xFF56636A),
                  ),

                  const SizedBox(width: 7),

                  Text(
                    project.category,

                    style:
                        const TextStyle(

                      fontSize: 16,

                      color:
                          Color(0xFF59646A),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // ==================================================
            // DIVIDER
            // ==================================================

            Container(
              height: 1,
              color:
                  const Color(0xFFD3D9DC),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // START DATE + ARROW
            // ==================================================

            Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(

                  "Started: ${project.startDate}",

                  style:
                      const TextStyle(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.w500,

                    color:
                        Color(0xFF59646A),
                  ),
                ),

                Icon(
                  Icons.arrow_forward,
                  size: 28,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATUS COLORS
  // ============================================================

  StatusColors _getStatusColors(
      String status) {

    if (status == "Completed") {

      return StatusColors(
        text: const Color(0xFF187A3D),
        background:
            const Color(0xFFD9F7E5),
      );
    }

    if (status == "Delayed") {

      return StatusColors(
        text: const Color(0xFFC51E1E),
        background:
            const Color(0xFFFFDAD7),
      );
    }

    if (status == "Critical") {

      return StatusColors(
        text: const Color(0xFFC51E1E),
        background:
            const Color(0xFFFFDAD7),
      );
    }

    // Ongoing

    return StatusColors(
      text: const Color(0xFFFFFFFF),
      background:
          const Color(0xFF326BF2),
    );
  }

  // ============================================================
  // PROJECT DETAILS
  // ============================================================

  void _showProjectDetails(
      Project project) {

    final statusColors =
        _getStatusColors(
      project.status,
    );

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (context) {

        return Container(

          padding:
              const EdgeInsets.fromLTRB(
            24,
            14,
            24,
            30,
          ),

          decoration:
              const BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // Handle

              Center(
                child: Container(
                  width: 45,
                  height: 5,

                  decoration:
                      BoxDecoration(

                    color:
                        const Color(
                      0xFFD5DBDE,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Title

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Expanded(
                    child: Text(

                      project.title,

                      style:
                          const TextStyle(

                        fontSize: 25,

                        fontWeight:
                            FontWeight.w600,

                        color:
                            Color(0xFF172B3A),
                      ),
                    ),
                  ),

                  Container(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 7,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          statusColors.background,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Text(

                      project.status,

                      style: TextStyle(
                        color:
                            statusColors.text,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(

                project.department,

                style:
                    const TextStyle(

                  fontSize: 15,

                  color:
                      Color(0xFF727D83),
                ),
              ),

              const SizedBox(height: 25),

              _detailRow(
                Icons.category_outlined,
                "Category",
                project.category,
              ),

              _detailRow(
                Icons.location_on_outlined,
                "Location",
                project.location,
              ),

              _detailRow(
                Icons.account_balance_wallet_outlined,
                "Budget",
                project.budget,
              ),

              _detailRow(
                Icons.calendar_today_outlined,
                "Start Date",
                project.startDate,
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        primaryColor,

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  child:
                      const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    IconData icon,
    String label,
    String value,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 17,
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 22,
            color: primaryColor,
          ),

          const SizedBox(width: 12),

          Text(

            "$label:",

            style:
                const TextStyle(

              fontSize: 15,

              color:
                  Color(0xFF7A858B),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(

              value,

              style:
                  const TextStyle(

                fontSize: 15,

                fontWeight:
                    FontWeight.w600,

                color:
                    Color(0xFF263746),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER DIALOG
  // ============================================================

  void _showFilterDialog() {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.white,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),

      builder: (context) {

        return Padding(

          padding:
              const EdgeInsets.all(25),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const Text(
                "Filter Projects",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ...filters.map((filter) {

                return RadioListTile<String>(

                  value: filter,

                  groupValue:
                      selectedFilter,

                  activeColor:
                      primaryColor,

                  title: Text(filter),

                  onChanged: (value) {

                    setState(() {
                      selectedFilter =
                          value!;
                    });

                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {

    return Center(

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            Icons.folder_open_outlined,
            size: 75,
            color:
                primaryColor.withOpacity(.5),
          ),

          const SizedBox(height: 18),

          const Text(

            "No Projects Yet",

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF263746),
            ),
          ),

          const SizedBox(height: 8),

          const Text(

            "Create a project to see it here.",

            style: TextStyle(
              fontSize: 15,
              color:
                  Color(0xFF7A858C),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CreateProjectScreen(),
                ),
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  primaryColor,
              foregroundColor:
                  Colors.white,
            ),

            icon: const Icon(Icons.add),

            label:
                const Text(
              "Create Project",
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NO SEARCH RESULTS
  // ============================================================

  Widget _buildNoResults() {

    return Center(

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            Icons.search_off,
            size: 60,
            color:
                Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          const Text(

            "No projects found",

            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Text(

            "Try another search or filter.",

            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {

    return BottomNavigationBar(

      type:
          BottomNavigationBarType.fixed,

      currentIndex: 1,

      backgroundColor:
          Colors.white,

      selectedItemColor:
          primaryColor,

      unselectedItemColor:
          const Color(0xFF59646A),

      selectedFontSize: 13,

      unselectedFontSize: 13,

      elevation: 15,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          activeIcon: Icon(
            Icons.home,
          ),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.folder_outlined,
          ),
          activeIcon: Icon(
            Icons.folder,
          ),
          label: "Projects",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
          ),
          activeIcon: Icon(
            Icons.map,
          ),
          label: "Map",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          activeIcon: Icon(
            Icons.person,
          ),
          label: "Profile",
        ),
      ],

      onTap: (index) {

        if (index == 0) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const DashboardScreen(),
            ),
          );
        }

        // Projects = current page
        else if (index == 1) {
          // Already on Projects
        }

        // Map
       // Map
else if (index == 2) {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const MapScreen(),
    ),
  );
}

        // Profile
        else if (index == 3) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const PlaceholderPage(
                title: "Profile",
                icon: Icons.person,
              ),
            ),
          );
        }
      },
    );
  }
}

// ================================================================
// PROJECT MODEL
// ================================================================

class Project {

  final String id;

  final String title;

  final String department;

  final String category;

  final String status;

  final String budget;

  final String location;

  final String startDate;

  Project({

    required this.id,

    required this.title,

    required this.department,

    required this.category,

    required this.status,

    required this.budget,

    required this.location,

    required this.startDate,
  });
}

// ================================================================
// STATUS COLORS
// ================================================================

class StatusColors {

  final Color text;

  final Color background;

  StatusColors({
    required this.text,
    required this.background,
  });
}

// ================================================================
// TEMPORARY MAP / PROFILE PAGE
// ================================================================

class PlaceholderPage extends StatelessWidget {

  final String title;

  final IconData icon;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF087F78),

        foregroundColor:
            Colors.white,

        title: Text(title),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 70,
              color:
                  const Color(0xFF087F78),
            ),

            const SizedBox(height: 15),

            Text(
              "$title Page",

              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}