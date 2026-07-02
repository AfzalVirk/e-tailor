import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text('Log Out?', style: AppTextStyles.heading3(context)),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'No',
                      isOutlined: true,
                      backgroundColor: AppColors.textSecondaryLight,
                      onPressed: () => Navigator.pop(dialogContext, false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      label: 'Yes',
                      backgroundColor: AppColors.error,
                      onPressed: () => Navigator.pop(dialogContext, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('Profile', style: AppTextStyles.heading3(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            color: AppColors.textPrimaryLight,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            SizedBox(height: 8.h),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44.r,
                    backgroundImage: NetworkImage(user.avatarAsset),
                  ),
                  SizedBox(height: 12.h),
                  Text(user.name, style: AppTextStyles.heading3(context)),
                  SizedBox(height: 2.h),
                  Text(
                    user.phone,
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.button(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            _sectionLabel(context, 'Account'),
            _tile(context, Icons.person_outline_rounded, 'Account'),
            _tile(context, Icons.lock_outline_rounded, 'Privacy'),
            _tile(context, Icons.receipt_long_outlined, 'Orders'),
            SizedBox(height: 20.h),
            _sectionLabel(context, 'Display'),
            _tile(context, Icons.language_rounded, 'Language'),
            _tile(context, Icons.notifications_none_rounded, 'Notifications'),
            SizedBox(height: 20.h),
            _sectionLabel(context, 'Support'),
            _tile(context, Icons.help_outline_rounded, 'Help Center'),
            _tile(
              context,
              Icons.logout_rounded,
              'Log Out',
              color: AppColors.error,
              onTap: () => _confirmLogout(context),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(
          context,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.textPrimaryLight),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium(context, color: color),
      ),
      trailing: color == null
          ? const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondaryLight,
            )
          : null,
      onTap: onTap ?? () {},
    );
  }
}
