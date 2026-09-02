/*
=========================================
Screen : Splash Screen

Purpose:
- First screen of the app.
- Shows app logo and name.
- Waits for 3 seconds.
- Navigates to Login Screen.

Widgets Used:
1. StatefulWidget
2. Scaffold
3. Center
4. Column
5. Icon
6. Text
7. SizedBox

Viva:
Q. Why StatefulWidget?
Ans: Because after 3 seconds the screen changes automatically.

Q. Why initState()?
Ans: It runs automatically when the screen opens.

=========================================
*/

import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Runs automatically when screen starts
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.primary,

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // App Icon
            const Icon(
              Icons.search,
              size: 90,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              "UniFind",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Smart Lost & Found System",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
            ),

          ],
        ),
      ),
    );
  }
}