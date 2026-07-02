import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'otp_screen_args.dart';

/// Signup form. Note: the original Figma included a "PAN number" field
/// (an India-specific tax ID) — dropped here since it doesn't fit a
/// general-audience tailor app. Add it back easily if your sir specifically
/// wants the form to match the Figma 1:1.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final codeSent = await authProvider.signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      address: _addressController.text.trim(),
    );

    if (!mounted || !codeSent) return;

    Navigator.pushNamed(
      context,
      AppRoutes.otpVerification,
      arguments: OtpScreenArgs(
        context: OtpContext.signup,
        identifier: _phoneController.text.trim(),
        signupName: _nameController.text.trim(),
        signupEmail: _emailController.text.trim(),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text('Sign up!', style: AppTextStyles.heading1(context)),
                SizedBox(height: 6.h),
                Text(
                  'Create account by filling the form below.',
                  style: AppTextStyles.bodyMedium(context),
                ),
                SizedBox(height: 28.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter name',
                  validator: (v) => Validators.required(v, fieldName: 'Name'),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _addressController,
                  hintText: 'Residential Address',
                  validator: (v) =>
                      Validators.required(v, fieldName: 'Address'),
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  label: 'Create Account',
                  //backgroundColor: AppColors.primary,
                  isLoading: isLoading,
                  onPressed: _handleSignup,
                ),
                if (authProvider.errorMessage != null) ...[
                  SizedBox(height: 10.h),
                  Text(
                    authProvider.errorMessage!,
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.error,
                    ),
                  ),
                ],
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: 'Do you already have an account? ',
                        style: AppTextStyles.bodyMedium(context),
                        children: [
                          TextSpan(
                            text: 'LOGIN',
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.primary,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
