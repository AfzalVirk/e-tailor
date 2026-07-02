import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../models/order_confirmation.dart';
import 'order_confirmed_screen.dart';

class OrderProcessingScreen extends StatefulWidget {
  final OrderConfirmation order;

  const OrderProcessingScreen({super.key, required this.order});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) =>
              OrderConfirmedScreen(order: widget.order),
          transitionsBuilder: (_, animation, __, child) {
            final tween = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.primary.withOpacity(0.06),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(width: 3),
          ),
          child: Icon(Icons.check_rounded, color: Colors.white, size: 48.sp),
        ),
      ),
    );
  }
}
