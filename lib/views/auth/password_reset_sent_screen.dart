import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class PasswordResetSentScreen extends StatefulWidget {
  final String email;
  const PasswordResetSentScreen({super.key, required this.email});

  @override
  State<PasswordResetSentScreen> createState() =>
      _PasswordResetSentScreenState();
}

class _PasswordResetSentScreenState extends State<PasswordResetSentScreen> {
  int _resendCooldown = 60;
  bool _isResending = false;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _resendCooldown = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown == 0) {
        timer.cancel();
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  Future<void> _handleResend() async {
    setState(() => _isResending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      _startCooldown();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reset email resent!')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 64.sp,
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                'Check Your Inbox',
                style: AppTextStyles.heading2(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                "We've sent a password reset link to",
                style: AppTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                widget.email,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.primary,
                ).copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Click the link in the email to set a new password. Check your spam folder if you don\'t see it.',
                style: AppTextStyles.bodySmall(context),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              CustomButton(
                label: 'Back to Login',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: (_resendCooldown > 0 || _isResending)
                      ? null
                      : _handleResend,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _resendCooldown > 0
                          ? AppColors.borderLight
                          : AppColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: _isResending
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _resendCooldown > 0
                              ? 'Resend in ${_resendCooldown}s'
                              : 'Resend Email',
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: _resendCooldown > 0
                                ? AppColors.textSecondaryLight
                                : AppColors.primary,
                          ),
                        ),
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
