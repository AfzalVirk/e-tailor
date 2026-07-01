import 'package:flutter/material.dart';

/// Central color palette for E-Tailor.
/// Change colors here once — never hardcode a Color() value inside a screen.
class AppColors {
  AppColors._(); // prevents instantiation

  // Brand colors
  static const Color primary = Color(0xFF3F3D9C); // Indigo — replaces mint green
  static const Color accent = Color(0xFFE0703C); // Terracotta — replaces navy buttons
  static const Color gold = Color(0xFFF0B429); // Ratings, highlights, OTP accents

  // Light theme neutrals
  static const Color backgroundLight = Color(0xFFF7F7FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6E6E82);

  // Dark theme neutrals
  static const Color backgroundDark = Color(0xFF121223);
  static const Color surfaceDark = Color(0xFF1E1E33);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFFA4A4B8);

  // Status colors
  static const Color success = Color(0xFF2E9B5F);
  static const Color error = Color(0xFFD64545);
  static const Color warning = gold;

  // Borders / dividers
  static const Color borderLight = Color(0xFFE2E2EE);
  static const Color borderDark = Color(0xFF31314A);
}
