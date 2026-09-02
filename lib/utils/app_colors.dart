/*
===========================================
File : app_colors.dart

Purpose:
Stores all colors used in the application.

Why?
Instead of writing Color codes repeatedly,
we create one class and reuse it.

Viva Question:
Why create a separate colors file?

Answer:
To improve code reusability and maintainability.
===========================================
*/

import 'package:flutter/material.dart';

class AppColors {

  // Main theme color
  static const Color primary = Color(0xff312C51);

  // Secondary color
  static const Color secondary = Color(0xff48426D);

  // Accent color
  static const Color accent = Color(0xffF0C38E);

  // Alert / Error color
  static const Color alert = Color(0xffF1AA9B);

  // Background color
  static const Color background = Color(0xffF8F8F8);

  // White
  static const Color white = Colors.white;

  // Black
  static const Color black = Colors.black;

  // Grey
  static const Color grey = Colors.grey;
}