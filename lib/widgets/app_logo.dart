import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

/// E-Tailor's logo, built from a styled icon + wordmark instead of an
/// image file. Keeps it crisp at any size and themeable (it can react to
/// dark mode) without needing separate logo image exports.
class AppLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.iconSize = 48,
    this.fontSize = 26,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.content_cut_rounded,
                color: Colors.white,
                size: iconSize.sp,
              ),
            ),
            SizedBox(width: 10.w),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'E-',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Tailor',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: 6.h),
          Text(
            'Tailoring, made simple',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondaryLight,
              letterSpacing: 3.1,
            ),
          ),
        ],
      ],
    );
  }
}
