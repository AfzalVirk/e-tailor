import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Primary call-to-action button used app-wide (Login, Send OTP, Order,
/// Pay Now, Submit...). Handles its own loading spinner state so screens
/// don't each reinvent "show a spinner while this future runs."
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? AppColors.accent);
    final fgColor = isOutlined
        ? (backgroundColor ?? AppColors.accent)
        : (textColor ?? Colors.white);

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: isOutlined ? 0 : 1,
          side: isOutlined
              ? BorderSide(color: backgroundColor ?? AppColors.accent)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Text(label, style: AppTextStyles.button(context, color: fgColor)),
      ),
    );
  }
}
