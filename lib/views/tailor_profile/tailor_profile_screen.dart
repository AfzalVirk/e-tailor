import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/tailor_model.dart';
import '../../services/chat_service.dart';
import '../chat/chat_thread_args.dart';
import '../chat/chat_thread_screen.dart';

class TailorProfileScreen extends StatelessWidget {
  final TailorModel tailor;
  const TailorProfileScreen({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(context),
                  _buildInfoSection(context),
                  _buildReviewsSection(context),
                ],
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  // ── Header: shop image gallery + shop name + owner name + rating + address
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(0.06),
      child: Column(
        children: [
          // App bar row
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimaryLight,
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Tailor Profile',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.ios_share_rounded),
                  color: AppColors.textPrimaryLight,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Cover gallery + overlapping avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              if (tailor.shopImages.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: tailor.shopImages.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: tailor.shopImages[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.backgroundLight,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.backgroundLight,
                            child: Icon(
                              Icons.store_rounded,
                              color: AppColors.textSecondaryLight,
                              size: 48.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Avatar, overlapping the bottom edge of the gallery
              Positioned(
                bottom: -40.h,
                child: Container(
                  width: 84.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2.5),
                    color: AppColors.backgroundLight,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: tailor.imagePath,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        color: AppColors.textSecondaryLight,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Space to make room for the overlapping avatar below the gallery
          SizedBox(height: 48.h),

          // Shop name
          Text(tailor.shopName, style: AppTextStyles.heading2(context)),
          SizedBox(height: 4.h),

          // Owner name
          Text(
            'Owner: ${tailor.ownerName}',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 6.h),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: AppColors.gold, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                tailor.rating.toString(),
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Address
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  tailor.address,
                  style: AppTextStyles.bodySmall(
                    context,
                    color: AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ── Info section: experience, working hours, contact
  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shop Info', style: AppTextStyles.heading3(context)),
          SizedBox(height: 14.h),
          _infoRow(
            context,
            icon: Icons.workspace_premium_rounded,
            label: 'Experience',
            value: tailor.experience,
          ),
          SizedBox(height: 12.h),
          _infoRow(
            context,
            icon: Icons.access_time_rounded,
            label: 'Working Hours',
            value: tailor.workingHours,
          ),
          SizedBox(height: 12.h),
          _infoRow(
            context,
            icon: Icons.phone_outlined,
            label: 'Contact',
            value: tailor.phone,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall(
                context,
                color: AppColors.textSecondaryLight,
              ),
            ),
            Text(
              value.isNotEmpty ? value : 'Not specified',
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ],
    );
  }

  // ── Reviews section
  Widget _buildReviewsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ratings & Reviews', style: AppTextStyles.heading3(context)),
              Text(
                '${tailor.rating} ★',
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.gold,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (tailor.reviews.isEmpty)
            Text(
              'No reviews yet.',
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.textSecondaryLight,
              ),
            )
          else
            ...tailor.reviews.map(
              (r) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: _buildReviewItem(context, r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, Map<String, dynamic> review) {
    final stars = (review['stars'] as num?)?.toInt() ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review['name'] as String? ?? '',
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 2.h),
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              Icons.star_rounded,
              size: 13.sp,
              color: i < stars ? AppColors.gold : AppColors.borderLight,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          review['comment'] as String? ?? '',
          style: AppTextStyles.bodySmall(
            context,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  // ── Bottom bar: Order Now | Chat | Call
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Chat button
          _iconButton(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;
              final conversationId = await ChatService.ensureConversation(
                customerUid: uid,
                tailorId: tailor.id,
                tailorName: tailor.shopName,
                tailorImage: tailor.imagePath,
              );
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatThreadScreen(
                    args: ChatThreadArgs(
                      conversationId: conversationId,
                      tailorName: tailor.shopName,
                      tailorImage: tailor.imagePath,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 10.w),

          // Call button
          _iconButton(
            context,
            icon: Icons.call_rounded,
            onTap: () async {
              final uri = Uri(scheme: 'tel', path: tailor.phone);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          SizedBox(width: 10.w),

          // Order Now button
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.measurement,
                  arguments: tailor,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Order Now',
                  style: AppTextStyles.button(context, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20.sp),
      ),
    );
  }
}
