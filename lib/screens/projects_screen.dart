import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final Color primaryColor = const Color(0xFF087F78);

  String selectedFilter = "All";

  final List<Project> projects = [
    Project(
      title: "Ward 4 Road Resurfacing",
      department: "PUBLIC WORKS DEPARTMENT",
      status: "Ongoing",
      progress: 65,
      budget: "₹72.5L",
      location: "Ward 4",
      startDate: "4 Aug 2023",
    ),
    Project(
      title: "Main Sewer Line Extension",
      department: "WATER & SANITATION",
      status: "Completed",
      progress: 100,
      budget: "₹58.2L",
      location: "Ward 6",
      startDate: "04 Jun 2023",
    ),
    Project(
      title: "Smart Street Lighting Phase II",
      department: "ELECTRICITY DEPT.",
      status: "Delayed",
      progress: 72,
      budget: "₹36.8L",
      location: "Ward 7",
      startDate: "20 Sep 2023",
    ),
    Project(
      title: "New Primary Healthcare Center",
      department: "HEALTH & FAMILY",
      status: "Ongoing",
      progress: 42,
      budget: "₹92.4L",
      location: "Ward 2",
      startDate: "14 Jun 2023",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProjects = selectedFilter == "All"
        ? projects
        : projects
            .where((project) => project.status == selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      body: SafeArea(
        child: Column(
          children: [

            // ======================================================
            // HEADER
            // ======================================================

            _buildHeader(),

            // ======================================================
            // SEARCH
            // ======================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                8,
                10,
                7,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      height: 34,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD9E0E4),
                        ),
                      ),

                      child: const TextField(
                        style: TextStyle(
                          fontSize: 10,
                        ),

                        decoration: InputDecoration(
                          hintText: "Search projects...",
                          hintStyle: TextStyle(
                            fontSize: 9,
                            color: Color(0xFF89939A),
                          ),

                          prefixIcon: Icon(
                            Icons.search,
                            size: 15,
                            color: Color(0xFF89939A),
                          ),

                          border: InputBorder.none,

                          contentPadding: EdgeInsets.symmetric(
                            vertical: 9,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFD9E0E4),
                      ),
                    ),

                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.tune,
                        size: 16,
                        color: Color(0xFF087F78),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // FILTERS
            // ======================================================

            _buildFilters(),

            // ======================================================
            // TITLE
            // ======================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                10,
                10,
                7,
              ),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Active Projects",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172B3A),
                  ),
                ),
              ),
            ),

            // ======================================================
            // PROJECT LIST
            // ======================================================

            Expanded(
              child: filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        70,
                      ),

                      physics: const BouncingScrollPhysics(),

                      itemCount: filteredProjects.length,

                      itemBuilder: (context, index) {
                        return _buildProjectCard(
                          filteredProjects[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ============================================================
      // ADD PROJECT BUTTON
      // ============================================================

      floatingActionButton: FloatingActionButton(
        mini: true,

        backgroundColor: primaryColor,

        elevation: 4,

        onPressed: () {
          _showAddProjectMessage();
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==============================================================
  // HEADER
  // ==============================================================

  Widget _buildHeader() {
    return Container(
      height: 47,

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E7EA),
          ),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 25,
            height: 25,

            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),

            child: const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 14,
            ),
          ),

          const SizedBox(width: 7),

          const Expanded(
            child: Text(
              "Ekikrit",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17303D),
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,

            constraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 30,
            ),

            onPressed: () {},

            icon: const Icon(
              Icons.notifications_none,
              size: 17,
              color: Color(0xFF5E6B73),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // FILTERS
  // ==============================================================

  Widget _buildFilters() {
    final filters = [
      "All",
      "Ongoing",
      "Completed",
      "Delayed",
    ];

    return SizedBox(
      height: 28,

      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),

        scrollDirection: Axis.horizontal,

        itemCount: filters.length,

        separatorBuilder: (_, __) =>
            const SizedBox(width: 6),

        itemBuilder: (context, index) {
          final filter = filters[index];

          final bool selected =
              selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: selected
                    ? primaryColor
                    : Colors.white,

                borderRadius: BorderRadius.circular(14),

                border: Border.all(
                  color: selected
                      ? primaryColor
                      : const Color(0xFFD6DEE2),
                ),
              ),

              child: Text(
                filter,

                style: TextStyle(
                  fontSize: 8.5,

                  fontWeight: FontWeight.w500,

                  color: selected
                      ? Colors.white
                      : const Color(0xFF56636B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // PROJECT CARD
  // ==============================================================

  Widget _buildProjectCard(Project project) {
    Color statusColor;

    if (project.status == "Completed") {
      statusColor = const Color(0xFF3DA66A);
    } else if (project.status == "Delayed") {
      statusColor = const Color(0xFFD9534F);
    } else {
      statusColor = const Color(0xFF2688D1);
    }

    return GestureDetector(
      onTap: () {
        _showProjectDetails(project);
      },

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 9,
        ),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: const Color(0xFFDDE3E6),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.025),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ------------------------------------------------------
            // TITLE + STATUS
            // ------------------------------------------------------

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

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D303C),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        project.department,

                        style: const TextStyle(
                          fontSize: 6.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .15,
                          color: Color(0xFF7A858C),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.10),

                    borderRadius:
                        BorderRadius.circular(8),
                  ),

                  child: Text(
                    project.status,

                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            // ------------------------------------------------------
            // LOCATION + BUDGET
            // ------------------------------------------------------

            Row(
              children: [

                const Icon(
                  Icons.location_on_outlined,
                  size: 11,
                  color: Color(0xFF7B858B),
                ),

                const SizedBox(width: 3),

                Text(
                  project.location,

                  style: const TextStyle(
                    fontSize: 7,
                    color: Color(0xFF69757C),
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 11,
                  color: Color(0xFF7B858B),
                ),

                const SizedBox(width: 3),

                Text(
                  project.budget,

                  style: const TextStyle(
                    fontSize: 7,
                    color: Color(0xFF69757C),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ------------------------------------------------------
            // COMPLETION
            // ------------------------------------------------------

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Completion",

                  style: TextStyle(
                    fontSize: 6.5,
                    color: Color(0xFF737E85),
                  ),
                ),

                Text(
                  "${project.progress}%",

                  style: TextStyle(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Progress bar
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child: LinearProgressIndicator(
                value: project.progress / 100,

                minHeight: 3,

                backgroundColor:
                    const Color(0xFFE5EAEC),

                valueColor:
                    AlwaysStoppedAnimation<Color>(
                  statusColor,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ------------------------------------------------------
            // START DATE + ARROW
            // ------------------------------------------------------

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  "Started: ${project.startDate}",

                  style: const TextStyle(
                    fontSize: 6.5,
                    color: Color(0xFF8A949A),
                  ),
                ),

                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // EMPTY STATE
  // ==============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            Icons.folder_open_outlined,
            size: 45,
            color: primaryColor,
          ),

          const SizedBox(height: 10),

          const Text(
            "No projects found",

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF263746),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Try another filter.",

            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF7A858C),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // BOTTOM NAVIGATION
  // ==============================================================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: 1,

      selectedItemColor: primaryColor,

      unselectedItemColor:
          const Color(0xFF8A949A),

      selectedFontSize: 7,

      unselectedFontSize: 7,

      elevation: 10,

      backgroundColor: Colors.white,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 17,
          ),
          activeIcon: Icon(
            Icons.home,
            size: 17,
          ),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.folder_outlined,
            size: 17,
          ),
          activeIcon: Icon(
            Icons.folder,
            size: 17,
          ),
          label: "Projects",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
            size: 17,
          ),
          activeIcon: Icon(
            Icons.map,
            size: 17,
          ),
          label: "Map",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: 17,
          ),
          activeIcon: Icon(
            Icons.person,
            size: 17,
          ),
          label: "Profile",
        ),
      ],

     onTap: (index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }
},
    );
  }

  // ==============================================================
  // PROJECT DETAILS
  // ==============================================================

  void _showProjectDetails(Project project) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            18,
            15,
            18,
            25,
          ),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Center(
                child: Container(
                  width: 35,
                  height: 4,

                  decoration: BoxDecoration(
                    color: const Color(0xFFD5DBDE),
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                project.title,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B3A),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                project.department,

                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF78848B),
                ),
              ),

              const SizedBox(height: 18),

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
                "Started",
                project.startDate,
              ),

              _detailRow(
                Icons.trending_up,
                "Progress",
                "${project.progress}%",
              ),

              _detailRow(
                Icons.info_outline,
                "Status",
                project.status,
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 45,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    "View Full Project",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
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

  Widget _detailRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 13,
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 18,
            color: primaryColor,
          ),

          const SizedBox(width: 10),

          Text(
            "$label: ",

            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF7B858C),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263746),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // ADD PROJECT
  // ==============================================================

  void _showAddProjectMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Add Project functionality will be connected next.",
        ),
      ),
    );
  }
}

// =================================================================
// PROJECT MODEL
// =================================================================

class Project {
  final String title;
  final String department;
  final String status;
  final int progress;
  final String budget;
  final String location;
  final String startDate;

  Project({
    required this.title,
    required this.department,
    required this.status,
    required this.progress,
    required this.budget,
    required this.location,
    required this.startDate,
  });
}