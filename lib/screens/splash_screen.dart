import 'dart:async';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // After 3 seconds, move to the next screen.
 Timer(const Duration(seconds: 3), () {
  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF5F8FC),
              Color(0xFFEAF2F7),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Image.asset(
              'lib/assets/ekikrit_logo.png',

              // Bigger logo
              width: 320,
              height: 320,

              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}