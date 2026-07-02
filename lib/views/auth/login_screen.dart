import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'otp_screen_args.dart';

enum _LoginMode { email, phone }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  _LoginMode _mode = _LoginMode.email;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    if (_mode == _LoginMode.email) {
      final success = await authProvider.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted || !success) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      final codeSent = await authProvider.loginWithPhone(
        _phoneController.text.trim(),
      );
      if (!mounted) return;

      if (!codeSent) {
        if (authProvider.status == AuthStatus.error)
          return; // error shown inline already
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
        return;
      }

      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,
        arguments: OtpScreenArgs(
          context: OtpContext.loginPhone,
          identifier: _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Text('Login Account', style: AppTextStyles.heading1(context)),
                SizedBox(height: 6.h),
                Text(
                  'Hello, welcome back to your account!',
                  style: AppTextStyles.bodyMedium(context),
                ),
                SizedBox(height: 32.h),
                Center(child: const AppLogo(iconSize: 44, fontSize: 26)),
                SizedBox(height: 32.h),

                // Email / Phone toggle
                _buildModeToggle(),
                SizedBox(height: 20.h),

                if (_mode == _LoginMode.email) ...[
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  CustomTextField(
                    controller: _phoneController,
                    hintText: 'Enter Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  SizedBox(height: 28.h),
                ],

                SizedBox(height: 12.h),
                CustomButton(
                  label: _mode == _LoginMode.email ? 'Login' : 'Send OTP',
                  isLoading: isLoading,
                  onPressed: _handleLogin,
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

                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderLight)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        'Or sign up with',
                        style: AppTextStyles.bodySmall(context),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderLight)),
                  ],
                ),
                SizedBox(height: 18.h),
                Center(
                  child: CustomButton(
                    label: 'Google',
                    isOutlined: true,
                    backgroundColor: AppColors.textPrimaryLight,
                    onPressed: () {
                      // Styled placeholder only — wired up when real auth
                      // (Firebase) is added later.
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: RichText(
                      text: TextSpan(
                        text: 'Not registered yet? ',
                        style: AppTextStyles.bodyMedium(context),
                        children: [
                          TextSpan(
                            text: 'Create Account',
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

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _toggleButton('Email', _LoginMode.email),
          _toggleButton('Phone Number', _LoginMode.phone),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, _LoginMode mode) {
    final isSelected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(11.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium(
              context,
              color: isSelected ? Colors.white : AppColors.textPrimaryLight,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
