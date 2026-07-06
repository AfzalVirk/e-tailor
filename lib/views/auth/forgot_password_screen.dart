import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      // Navigate to confirmation screen, passing the email so it can display it
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.passwordResetSent,
        arguments: _emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'user-not-found'
            ? 'No account found with this email address.'
            : e.message ?? 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(flex: 2),
                        Center(
                          child: SvgPicture.network(
                            'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976162/forgot_password_gvu4kz.svg',
                            height: 220.h,
                            placeholderBuilder: (context) => SizedBox(
                              height: 220.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        Text(
                          'Forgot\nPassword?',
                          style: AppTextStyles.heading1(context),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Enter your email and we'll send you a link to reset your password.",
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        SizedBox(height: 28.h),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: 10.h),
                          Text(
                            _errorMessage!,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        SizedBox(height: 24.h),
                        CustomButton(
                          label: 'Continue',
                          isLoading: _isLoading,
                          onPressed: _handleContinue,
                        ),
                        const Spacer(flex: 3),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
