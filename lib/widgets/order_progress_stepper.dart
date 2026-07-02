import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_colors.dart';

/// 3-step progress indicator shared by Cart, Summary, and Payment screens.
/// currentStep is 0-indexed (0 = Cart, 1 = Summary, 2 = Payment).
class OrderProgressStepper extends StatelessWidget {
  final int currentStep;

  const OrderProgressStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        if (i.isOdd) {
          // connecting line between dots
          final dotIndex = i ~/ 2;
          final isActive = dotIndex < currentStep;
          return Container(
            width: 60.w,
            height: 2.h,
            color: isActive ? AppColors.primary : AppColors.borderLight,
          );
        }
        final dotIndex = i ~/ 2;
        final isCompleted = dotIndex < currentStep;
        final isCurrent = dotIndex == currentStep;
        return Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isCurrent)
                ? AppColors.primary
                : Colors.white,
            border: Border.all(
              color: (isCompleted || isCurrent)
                  ? AppColors.primary
                  : AppColors.borderLight,
              width: 2,
            ),
          ),
          child: isCompleted
              ? Icon(Icons.check_rounded, color: Colors.white, size: 14.sp)
              : null,
        );
      }),
    );
  }
}
