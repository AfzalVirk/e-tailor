import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) return;

    context.read<UserProvider>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  Widget _fieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: AppTextStyles.bodySmall(
        context,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Edit Profile', style: AppTextStyles.heading3(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            color: AppColors.textPrimaryLight,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44.r,
                        backgroundImage: AssetImage(user.avatarAsset),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    'Change Picture',
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                _fieldLabel(context, 'Username'),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your username',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                SizedBox(height: 16.h),
                _fieldLabel(context, 'Email I\'d'),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                SizedBox(height: 16.h),
                _fieldLabel(context, 'Phone Number'),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                SizedBox(height: 16.h),
                _fieldLabel(context, 'Password'),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: true,
                ),
                SizedBox(height: 32.h),
                CustomButton(label: 'Update', onPressed: _handleUpdate),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
