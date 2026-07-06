import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

/// Temporary placeholder landing screen for tailor accounts, standing in
/// until the real Tailor Dashboard gets built. RoleRouterScreen sends
/// tailor-role accounts here based on their saved Firestore role.
class TailorHomeScreen extends StatelessWidget {
  const TailorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text('Tailor Dashboard', style: AppTextStyles.heading3(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.error,
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.dashboard_customize_outlined,
                size: 56.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 16.h),
              Text(
                'Welcome, ${user.name.isNotEmpty ? user.name : "Tailor"}',
                style: AppTextStyles.heading3(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Dashboard, Orders, and shop tools go here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
