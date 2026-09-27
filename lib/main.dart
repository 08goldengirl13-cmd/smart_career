import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const SmartCareerApp());
}

class SmartCareerApp extends StatelessWidget {
  const SmartCareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yo'nalish - Smart Career",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
