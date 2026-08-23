import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EkikritApp());
}

class EkikritApp extends StatelessWidget {
  const EkikritApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Ekikrit',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      home: const SplashScreen(),
    );
  }
}