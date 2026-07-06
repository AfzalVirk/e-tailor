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
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted || !success) return;

    // Reload to get latest email verification status from Firebase
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null && !user.emailVerified) {
      // Account exists but email not verified — send a fresh link and gate them
      await user.sendEmailVerification();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.emailVerification,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.roleRouter,
        (route) => false,
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
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  label: 'Login',
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
                    onPressed: () {},
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
}
