
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_screen.dart';
import 'projects_screen.dart';
import 'map_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
 State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final Color primaryColor = const Color(0xFF087F78);

  Uint8List? profileImage;

  int currentIndex = 3;

  Future<void> pickImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image != null) {
    final bytes = await image.readAsBytes();

    setState(() {
      profileImage = bytes;
    });
  }
}

  Future<DocumentSnapshot> getUser() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: getUser(),

      builder: (context,snapshot){

        if(snapshot.connectionState==ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data =
            snapshot.data!.data() as Map<String,dynamic>;

        return Scaffold(

          backgroundColor: const Color(0xffF5F8FC),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SingleChildScrollView(

            padding: const EdgeInsets.all(20),

            child: Column(

              children: [

                Stack(

                  children: [

                    CircleAvatar(
  radius: 70,
  backgroundColor: Colors.grey.shade300,
  backgroundImage: profileImage != null
      ? MemoryImage(profileImage!)
      : null,
  child: profileImage == null
      ? const Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        )
      : null,
),

                    Positioned(

                      bottom: 0,
                      right: 5,

                      child: InkWell(

                        onTap: pickImage,

                        child: Container(

                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),

                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height:20),

                Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),

                const SizedBox(height:8),

                Text(
                  data["role"] ?? "",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height:5),

                Text(
                  data["department"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height:35),

                infoTile(
                  Icons.email_outlined,
                  "Email",
                  data["email"],
                ),

                const SizedBox(height:15),

                infoTile(
                  Icons.account_balance,
                  "Department",
                  data["department"],
                ),

                const SizedBox(height:15),

                infoTile(
                  Icons.badge_outlined,
                  "Role",
                  data["role"],
                ),

                const SizedBox(height:40),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.red,

                      padding: const EdgeInsets.symmetric(
                        vertical:16,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () async {

                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                        (route)=>false,
                      );
                    },

                    icon: const Icon(Icons.logout),

                    label: const Text(
                      "Logout",
                    ),
                  ),
                )
              ],
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(

            currentIndex: currentIndex,

            selectedItemColor: primaryColor,

            onTap: (index){

              if(index==0){

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const DashboardScreen(),
                  ),
                );
              }

              if(index==1){

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const ProjectsScreen(),
                  ),
                );
              }

              if(index==2){

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const MapScreen(),
                  ),
                );
              }

            },

            items: const [

              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.folder_outlined),
                label: "Projects",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: "Map",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget infoTile(
      IconData icon,
      String title,
      String value){

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 10,
          )
        ],
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 25,

            backgroundColor:
                const Color(0xffEAF2FF),

            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),

          const SizedBox(width:15),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height:5),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}