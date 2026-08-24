import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'dashboard_screen.dart';
import 'projects_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Default location if GPS is unavailable.
  // Kochi
  static const LatLng _defaultLocation = LatLng(9.9312, 76.2673);

  LatLng? _currentLocation;

  bool _isLoadingLocation = true;

  int _selectedIndex = 2;

  // ============================================================
  // SAMPLE PROJECT LOCATIONS
  // ============================================================

  final List<ProjectLocation> _projects = [
    ProjectLocation(
      id: "project1",
      name: "Ward 4 Road Resurfacing",
      location: LatLng(9.9670, 76.2673),
      status: "Ongoing",
    ),
    ProjectLocation(
      id: "project2",
      name: "Main Sewer Line Extension",
      location: LatLng(9.9450, 76.2800),
      status: "Completed",
    ),
    ProjectLocation(
      id: "project3",
      name: "Smart Street Lighting Phase II",
      location: LatLng(9.9200, 76.2500),
      status: "Delayed",
    ),
    ProjectLocation(
      id: "project4",
      name: "New Primary Healthcare Center",
      location: LatLng(9.9000, 76.2900),
      status: "Proposed",
    ),
    ProjectLocation(
      id: "project5",
      name: "Road Governance Project",
      location: LatLng(9.9800, 76.3000),
      status: "Ongoing",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ============================================================
  // GET REAL PHONE GPS
  // ============================================================

  Future<void> _getCurrentLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _currentLocation = _defaultLocation;
        });

        _showMessage(
          "Please turn on your phone's location.",
        );

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _currentLocation = _defaultLocation;
        });

        _showMessage(
          "Location permission was denied.",
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isLoadingLocation = false;
          _currentLocation = _defaultLocation;
        });

        _showMessage(
          "Location permission is permanently denied. "
          "Please enable it from Settings.",
        );

        return;
      }

      // ========================================================
      // REAL GPS LOCATION
      // ========================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng location = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = location;
        _isLoadingLocation = false;
      });

      // Move map to user's actual location
      _mapController.move(
        location,
        14.0,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
        _currentLocation = _defaultLocation;
      });

      _showMessage(
        "Unable to get your current location.",
      );
    }
  }

  // ============================================================
  // GO TO USER LOCATION
  // ============================================================

  void _goToMyLocation() {
    if (_currentLocation == null) {
      _getCurrentLocation();
      return;
    }

    _mapController.move(
      _currentLocation!,
      15.0,
    );
  }

  // ============================================================
  // ZOOM IN
  // ============================================================

  void _zoomIn() {
    final double currentZoom =
        _mapController.camera.zoom;

    _mapController.move(
      _mapController.camera.center,
      currentZoom + 1,
    );
  }

  // ============================================================
  // ZOOM OUT
  // ============================================================

  void _zoomOut() {
    final double currentZoom =
        _mapController.camera.zoom;

    _mapController.move(
      _mapController.camera.center,
      currentZoom - 1,
    );
  }

  // ============================================================
  // PROJECT MARKERS
  // ============================================================

  List<Marker> _buildProjectMarkers() {
    return _projects.map((project) {
      return Marker(
        point: project.location,
        width: 40,
        height: 50,
        child: GestureDetector(
          onTap: () {
            _showProjectDetails(project);
          },
          child: Column(
            children: [
              // Marker
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _getMarkerColor(project.status),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 16,
                ),
              ),

              // Small pointer
              Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.transparent,
                      width: 5,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                      width: 5,
                    ),
                    top: BorderSide(
                      color: Colors.white,
                      width: 7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // ============================================================
  // USER GPS MARKER
  // ============================================================

  Marker? _buildCurrentLocationMarker() {
    if (_currentLocation == null) {
      return null;
    }

    return Marker(
      point: _currentLocation!,
      width: 55,
      height: 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Accuracy-like circle
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF087F78).withOpacity(.15),
              shape: BoxShape.circle,
            ),
          ),

          // Actual location dot
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF087F78),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MARKER COLORS
  // ============================================================

  Color _getMarkerColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;

      case "Ongoing":
        return Colors.blue;

      case "Delayed":
        return Colors.red;

      case "Proposed":
        return Colors.orange;

      default:
        return Colors.purple;
    }
  }

  // ============================================================
  // PROJECT DETAILS
  // ============================================================

  void _showProjectDetails(
    ProjectLocation project,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 35,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Project name
              Text(
                project.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B3A),
                ),
              ),

              const SizedBox(height: 15),

              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Color(0xFF087F78),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Lat: ${project.location.latitude.toStringAsFixed(5)}, "
                      "Lng: ${project.location.longitude.toStringAsFixed(5)}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Color(0xFF087F78),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "Status: ${project.status}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF087F78),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "View Project",
                    style: TextStyle(
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

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(
          fontSize: 10,
        ),
        decoration: InputDecoration(
          hintText:
              "Search project, location...",
          hintStyle: const TextStyle(
            fontSize: 9,
            color: Color(0xFF89939A),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 17,
            color: Color(0xFF6E7B83),
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              size: 16,
              color: Color(0xFF087F78),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 11,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS LEGEND
  // ============================================================

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _legendItem(
            "Completed",
            Colors.green,
          ),

          const SizedBox(height: 5),

          _legendItem(
            "Ongoing",
            Colors.blue,
          ),

          const SizedBox(height: 5),

          _legendItem(
            "Delayed",
            Colors.red,
          ),

          const SizedBox(height: 5),

          _legendItem(
            "Proposed",
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _legendItem(
    String title,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 5),

        Text(
          title,
          style: const TextStyle(
            fontSize: 7.5,
            color: Color(0xFF55636B),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MAP BUTTON
  // ============================================================

  Widget _mapButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(7),
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(7),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 17,
            color: const Color(0xFF52616A),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor:
          const Color(0xFF087F78),
      unselectedItemColor:
          const Color(0xFF8A949A),
      selectedFontSize: 7,
      unselectedFontSize: 7,
      backgroundColor: Colors.white,
      elevation: 10,
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
        // Home
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const DashboardScreen(),
            ),
          );
        }

        // Projects
        else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ProjectsScreen(),
            ),
          );
        }

        // Map - already here
        else if (index == 2) {
          return;
        }

        // Profile
        else if (index == 3) {
          _showMessage(
            "Profile will be connected soon.",
          );
        }
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final LatLng mapCenter =
        _currentLocation ?? _defaultLocation;

    final Marker? currentLocationMarker =
        _buildCurrentLocationMarker();

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F8FC),

      body: SafeArea(
        child: Stack(
          children: [
            // ==================================================
            // OPENSTREETMAP
            // ==================================================

            FlutterMap(
              mapController: _mapController,

              options: MapOptions(
                initialCenter: mapCenter,
                initialZoom: 12.5,
                minZoom: 3,
                maxZoom: 19,
              ),

              children: [
                // =================================================
                // MAP TILES
                // =================================================

                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.ekikrit',
                ),

                // =================================================
                // PROJECT MARKERS
                // =================================================

                MarkerLayer(
                  markers:
                      _buildProjectMarkers(),
                ),

                // =================================================
                // CURRENT GPS LOCATION
                // =================================================

                if (currentLocationMarker != null)
                  MarkerLayer(
                    markers: [
                      currentLocationMarker,
                    ],
                  ),
              ],
            ),

            // ==================================================
            // SEARCH BAR
            // ==================================================

            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: _buildSearchBar(),
            ),

            // ==================================================
            // LEGEND
            // ==================================================

            Positioned(
              top: 63,
              right: 10,
              child: _buildLegend(),
            ),

            // ==================================================
            // GPS LOADING
            // ==================================================

            if (_isLoadingLocation)
              Positioned(
                top: 115,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(.12),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 13,
                          height: 13,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),

                        SizedBox(width: 7),

                        Text(
                          "Getting your location...",
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ==================================================
            // MAP CONTROLS
            // ==================================================

            Positioned(
              right: 10,
              bottom: 70,
              child: Column(
                children: [
                  // My location
                  _mapButton(
                    icon: Icons.my_location,
                    onPressed:
                        _goToMyLocation,
                  ),

                  const SizedBox(height: 6),

                  // Zoom in
                  _mapButton(
                    icon: Icons.add,
                    onPressed: _zoomIn,
                  ),

                  const SizedBox(height: 6),

                  // Zoom out
                  _mapButton(
                    icon: Icons.remove,
                    onPressed: _zoomOut,
                  ),
                ],
              ),
            ),

            // ==================================================
            // OPENSTREETMAP ATTRIBUTION
            // ==================================================

            Positioned(
              left: 5,
              bottom: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                color: Colors.white.withOpacity(.75),
                child: const Text(
                  "© OpenStreetMap contributors",
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
          _buildBottomNavigationBar(),
    );
  }
}

// =================================================================
// PROJECT LOCATION MODEL
// =================================================================

class ProjectLocation {
  final String id;
  final String name;
  final LatLng location;
  final String status;

  ProjectLocation({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
  });
}