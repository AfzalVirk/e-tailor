import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'otp_screen_args.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final codeSent = await authProvider.forgotPassword(
      _phoneController.text.trim(),
    );

    if (!mounted || !codeSent) return;

    Navigator.pushNamed(
      context,
      AppRoutes.otpVerification,
      arguments: OtpScreenArgs(
        context: OtpContext.forgotPassword,
        identifier: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
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
                        SizedBox(height: 8.h),
                        const Spacer(flex: 2),
                        Center(
                          child: SvgPicture.network(
                            'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976162/forgot_password_gvu4kz.svg',
                            height: 180.h,
                          ),
                        ),
                        const Spacer(flex: 2),
                        Text(
                          'Forgot\nPassword?',
                          style: AppTextStyles.heading1(context),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Don't worry! It happens. Please enter the phone number we'll send the OTP to.",
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        SizedBox(height: 24.h),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'Enter the Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          label: 'Continue',
                          //backgroundColor: AppColors.primary,
                          isLoading: isLoading,
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
