import 'package:flutter/material.dart';
import 'projects_screen.dart';
import 'create_project_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final Color primaryColor = const Color(0xFF087F78);
  final Color backgroundColor = const Color(0xFFF5F8FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboard(),
            _buildPlaceholderPage(
              Icons.folder_outlined,
              "Projects",
              "Your projects will appear here.",
            ),
            _buildPlaceholderPage(
              Icons.notifications_none,
              "Notifications",
              "No new notifications.",
            ),
            _buildPlaceholderPage(
              Icons.person_outline,
              "Profile",
              "Your profile information.",
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        20,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // ======================================================
          // HEADER
          // ======================================================

          Row(
            children: [

              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Ekikrit",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF102033),
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "Panchayath Engineer",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF69747D),
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.notifications_none,
                  size: 22,
                ),
              ),

              CircleAvatar(
                radius: 17,

                backgroundColor:
                    const Color(0xFFE1F1EF),

                child: Icon(
                  Icons.person,
                  size: 19,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ======================================================
          // STATISTICS
          // ======================================================

          _buildStatistics(),

          const SizedBox(height: 18),

          // ======================================================
          // RECENT ACTIVITIES
          // ======================================================

          _buildSectionHeader(
            "Recent Activities",
            "View log",
          ),

          const SizedBox(height: 9),

          _buildRecentActivities(),

          const SizedBox(height: 18),

          // ======================================================
          // UPCOMING DEADLINES
          // ======================================================

          _buildSectionHeader(
            "Upcoming Deadlines",
            "View all",
          ),

          const SizedBox(height: 9),

          _buildUpcomingDeadlines(),

          const SizedBox(height: 18),

          // ======================================================
          // QUICK ACTIONS
          // ======================================================

          _buildSectionTitle("Quick Actions"),

          const SizedBox(height: 9),

          _buildQuickActions(),

          const SizedBox(height: 18),

          // ======================================================
          // LIVE PROJECT MAP
          // ======================================================

          _buildLiveProjectMap(),

          const SizedBox(height: 18),

          // ======================================================
          // PROJECT CARD
          // ======================================================

          _buildProjectCard(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Column(
      children: [

        Row(
          children: [

            Expanded(
              child: _buildStatCard(
                title: "Total Projects",
                value: "124",
                icon: Icons.folder_copy_outlined,
                iconColor: primaryColor,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildStatCard(
                title: "Ongoing",
                value: "42",
                icon: Icons.autorenew,
                iconColor: Colors.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        Row(
          children: [

            Expanded(
              child: _buildStatCard(
                title: "Completed",
                value: "68",
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildStatCard(
                title: "Delayed",
                value: "14",
                icon: Icons.warning_amber_outlined,
                iconColor: Colors.red,
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        Row(
          children: [

            Expanded(
              child: _buildStatCard(
                title: "Pending Approval",
                value: "08",
                icon: Icons.pending_actions,
                iconColor: Colors.orange,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildStatCard(
                title: "Budget Utilization",
                value: "72%",
                icon: Icons.account_balance_wallet_outlined,
                iconColor: primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 76,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE0E5E9),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 17,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF68747C),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF182B3A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(
    String title,
    String action,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF182B3A),
          ),
        ),

        Text(
          action,

          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF182B3A),
      ),
    );
  }

  // ============================================================
  // RECENT ACTIVITIES
  // ============================================================

  Widget _buildRecentActivities() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE0E5E9),
        ),
      ),

      child: Column(
        children: [

          _buildActivityItem(
            icon: Icons.description_outlined,
            title: "Project Proposal Submitted",
            subtitle: "Road development project submitted",
            time: "2 hours ago",
          ),

          _buildDivider(),

          _buildActivityItem(
            icon: Icons.check_circle_outline,
            title: "Budget Approved",
            subtitle: "Municipal road improvement project",
            time: "Yesterday",
          ),

          _buildDivider(),

          _buildActivityItem(
            icon: Icons.assignment_outlined,
            title: "Tender Process Initiated",
            subtitle: "Tender documents are being processed",
            time: "2 days ago",
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 10,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 31,
            height: 31,

            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F3),
              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(
              icon,
              color: primaryColor,
              size: 16,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263746),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF77818A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          Text(
            time,

            style: const TextStyle(
              fontSize: 7.5,
              color: Color(0xFF9299A0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 51,
      endIndent: 10,
      color: Color(0xFFECEFF1),
    );
  }

  // ============================================================
  // UPCOMING DEADLINES
  // ============================================================

  Widget _buildUpcomingDeadlines() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE0E5E9),
        ),
      ),

      child: Column(
        children: [

          _buildDeadlineItem(
            icon: Icons.event_note_outlined,
            title: "Utility Survey Work",
            subtitle: "Kizhakkambalam Road",
            date: "24 Aug",
            urgent: true,
          ),

          _buildDivider(),

          _buildDeadlineItem(
            icon: Icons.description_outlined,
            title: "GIS Material Audit",
            subtitle: "Municipal Project",
            date: "26 Aug",
            urgent: false,
          ),

          _buildDivider(),

          _buildDeadlineItem(
            icon: Icons.assignment_outlined,
            title: "Tender Document Submission",
            subtitle: "District Infrastructure Project",
            date: "28 Aug",
            urgent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required bool urgent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 10,
      ),

      child: Row(
        children: [

          Container(
            width: 31,
            height: 31,

            decoration: BoxDecoration(
              color: urgent
                  ? const Color(0xFFFFF1E8)
                  : const Color(0xFFEAF3F7),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(
              icon,

              color: urgent
                  ? Colors.orange
                  : Colors.blue,

              size: 16,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263746),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF77818A),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [

              Text(
                date,

                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: urgent
                      ? Colors.red
                      : const Color(0xFF68747C),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                urgent ? "Due soon" : "Upcoming",

                style: TextStyle(
                  fontSize: 7,

                  color: urgent
                      ? Colors.red
                      : const Color(0xFF9299A0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: primaryColor,

        borderRadius: BorderRadius.circular(13),
      ),

      child: Row(
        children: [

          Expanded(
  child: InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const CreateProjectScreen(),
        ),
      );
    },
    child: _buildQuickAction(
      Icons.add_circle_outline,
      "Add Project",
    ),
  ),
),

          Expanded(
            child: _buildQuickAction(
              Icons.map_outlined,
              "View Map",
            ),
          ),

          Expanded(
            child: _buildQuickAction(
              Icons.analytics_outlined,
              "Analytics",
            ),
          ),

          Expanded(
            child: _buildQuickAction(
              Icons.description_outlined,
              "Reports",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
  IconData icon,
  String title,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 7,
    ),
    child: Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        const SizedBox(height: 5),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 7.5,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

  // ============================================================
  // LIVE PROJECT MAP
  // ============================================================

  Widget _buildLiveProjectMap() {
    return Container(
      height: 155,

      clipBehavior: Clip.antiAlias,

      decoration: BoxDecoration(
        color: const Color(0xFFDCE7E1),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFD2DADD),
        ),
      ),

      child: Stack(
        children: [

          // Simulated map background
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPainter(),
            ),
          ),

          Positioned(
            left: 12,
            top: 11,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 5,
                  ),
                ],
              ),

              child: Row(
                children: [

                  Icon(
                    Icons.location_on,
                    color: primaryColor,
                    size: 13,
                  ),

                  const SizedBox(width: 4),

                  const Text(
                    "Live Project Map",
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map markers
          _buildMapMarker(
            left: 90,
            top: 58,
          ),

          _buildMapMarker(
            left: 170,
            top: 90,
          ),

          _buildMapMarker(
            left: 250,
            top: 52,
          ),

          Positioned(
            right: 10,
            bottom: 10,

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),

              child: const Text(
                "124 Projects",
                style: TextStyle(
                  fontSize: 7.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker({
    required double left,
    required double top,
  }) {
    return Positioned(
      left: left,
      top: top,

      child: Container(
        width: 23,
        height: 23,

        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 5,
            ),
          ],
        ),

        child: const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 11,
        ),
      ),
    );
  }

  // ============================================================
  // PROJECT CARD
  // ============================================================

  Widget _buildProjectCard() {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE0E5E9),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F2),
              borderRadius: BorderRadius.circular(9),
            ),

            child: Icon(
              Icons.construction_outlined,
              color: primaryColor,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  "Road Governance",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263746),
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Panchayath infrastructure project",
                  style: TextStyle(
                    fontSize: 7.5,
                    color: Color(0xFF77818A),
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Fort Kochi • 72% completed",
                  style: TextStyle(
                    fontSize: 7.5,
                    color: Color(0xFF68747C),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            size: 18,
            color: Color(0xFF9AA1A7),
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
      currentIndex: _selectedIndex,

     onTap: (index) {
  if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ProjectsScreen(),
      ),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
},
      type: BottomNavigationBarType.fixed,

      backgroundColor: Colors.white,

      selectedItemColor: primaryColor,

      unselectedItemColor:
          const Color(0xFF8A9298),

      selectedFontSize: 9,

      unselectedFontSize: 8,

      elevation: 10,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 20,
          ),
          activeIcon: Icon(
            Icons.home,
            size: 20,
          ),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.folder_outlined,
            size: 20,
          ),
          activeIcon: Icon(
            Icons.folder,
            size: 20,
          ),
          label: "Projects",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications_none,
            size: 20,
          ),
          activeIcon: Icon(
            Icons.notifications,
            size: 20,
          ),
          label: "Alerts",
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: 20,
          ),
          activeIcon: Icon(
            Icons.person,
            size: 20,
          ),
          label: "Profile",
        ),
      ],
    );
  }

  // ============================================================
  // PLACEHOLDER PAGES
  // ============================================================

  Widget _buildPlaceholderPage(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 55,
            color: primaryColor,
          ),

          const SizedBox(height: 15),

          Text(
            title,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF182B3A),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            subtitle,

            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF77818A),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SIMPLE MAP PAINTER
// ============================================================

class _MapPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint roadPaint = Paint()
      ..color = const Color(0xFFB7C5BB)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final Paint smallRoadPaint = Paint()
      ..color = const Color(0xFFD0D8D1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint areaPaint = Paint()
      ..color = const Color(0xFFE5EDE4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      areaPaint,
    );

    final Path road1 = Path();

    road1.moveTo(0, size.height * .72);

    road1.cubicTo(
      size.width * .25,
      size.height * .35,
      size.width * .50,
      size.height * .82,
      size.width,
      size.height * .25,
    );

    canvas.drawPath(
      road1,
      roadPaint,
    );

    final Path road2 = Path();

    road2.moveTo(
      size.width * .15,
      0,
    );

    road2.cubicTo(
      size.width * .30,
      size.height * .35,
      size.width * .60,
      size.height * .50,
      size.width * .85,
      size.height,
    );

    canvas.drawPath(
      road2,
      smallRoadPaint,
    );

    final Path road3 = Path();

    road3.moveTo(
      size.width * .65,
      0,
    );

    road3.cubicTo(
      size.width * .55,
      size.height * .30,
      size.width * .80,
      size.height * .55,
      size.width,
      size.height * .70,
    );

    canvas.drawPath(
      road3,
      smallRoadPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}