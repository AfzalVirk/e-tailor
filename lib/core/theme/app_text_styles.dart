import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Text styles for E-Tailor.
/// Poppins is used for headings/titles (more character, good for branding).
/// Inter is used for body text (highly readable at small sizes).
class AppTextStyles {
  AppTextStyles._();

  // Headings — Poppins
  static TextStyle heading1(BuildContext context, {Color? color}) =>
      GoogleFonts.poppins(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: color ?? _textColor(context),
      );

  static TextStyle heading2(BuildContext context, {Color? color}) =>
      GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: color ?? _textColor(context),
      );

  static TextStyle heading3(BuildContext context, {Color? color}) =>
      GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? _textColor(context),
      );

  // Body — Inter
  static TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: color ?? _textColor(context),
      );

  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? _textColor(context),
      );

  static TextStyle bodySmall(BuildContext context, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color ?? _secondaryColor(context),
      );

  // Buttons — Poppins, slightly bolder
  static TextStyle button(BuildContext context, {Color? color}) =>
      GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  static Color _textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  }

  static Color _secondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  }
}
