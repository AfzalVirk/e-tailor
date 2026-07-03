import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/tailor_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/chat_service.dart';
import '../chat/chat_thread_args.dart';
import '../chat/chat_thread_screen.dart';

class TailorProfileScreen extends StatefulWidget {
  final TailorModel tailor;

  const TailorProfileScreen({super.key, required this.tailor});

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> {
  int _selectedCategory =
      2; // "Fabric" highlighted, matches Figma's default state

  static const _categories = ['Clothing', 'Accessories', 'Fabric', 'Wearable'];

  static const _services = [
    ('Tops', 7),
    ('Bottoms', 4),
    ('Full Outfits', 8),
    ('Alterations', 4),
  ];

  @override
  Widget build(BuildContext context) {
    final tailor = widget.tailor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(context, tailor),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _sectionHeader(context, 'Description'),
                        SizedBox(height: 6.h),
                        Text(
                          tailor.description,
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _sectionHeader(context, 'Ratings & Reviews'),
                        SizedBox(height: 10.h),
                        _buildReview(
                          context,
                          name: 'Arista',
                          stars: 5,
                          comment:
                              'Great work and very professional. Delivered right on time and the stitching quality was excellent.',
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Tailoring & Alteration Services',
                          style: AppTextStyles.heading3(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 14.h),
                      ],
                    ),
                  ),
                  ..._services.map(
                    (s) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 6.h,
                      ),
                      child: _serviceTile(context, s.$1, s.$2),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "${tailor.name}'s Collection",
                      style: AppTextStyles.heading3(context),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Wrap(
                      spacing: 8.w,
                      children: List.generate(_categories.length, (i) {
                        final selected = i == _selectedCategory;
                        return ChoiceChip(
                          label: Text(_categories[i]),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = i),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textPrimaryLight,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: AppColors.backgroundLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide.none,
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TailorModel tailor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      color: AppColors.primary.withOpacity(0.06),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.textPrimaryLight,
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Profile',
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
          SizedBox(height: 8.h),
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2.5),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: tailor.imagePath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: AppColors.textSecondaryLight,
                  size: 32.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tailor.name, style: AppTextStyles.heading3(context)),
              if (tailor.isVerified) ...[
                SizedBox(width: 6.w),
                Icon(Icons.verified, color: AppColors.primary, size: 16.sp),
              ],
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: AppColors.gold, size: 15.sp),
              SizedBox(width: 3.w),
              Text(
                '${tailor.rating}  •  ${tailor.totalOrders} orders',
                style: AppTextStyles.bodySmall(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: 3.w),
              Text(
                tailor.location,
                style: AppTextStyles.bodySmall(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(title, style: AppTextStyles.heading3(context));
  }

  Widget _buildReview(
    BuildContext context, {
    required String name,
    required int stars,
    required String comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
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
              size: 14.sp,
              color: i < stars ? AppColors.gold : AppColors.borderLight,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          comment,
          style: AppTextStyles.bodySmall(
            context,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _serviceTile(BuildContext context, String label, int orders) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                'Order $orders • work time ~2 days',
                style: AppTextStyles.bodySmall(
                  context,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondaryLight,
          ),
        ],
      ),
    );
  }

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
          GestureDetector(
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              final conversationId = await ChatService.ensureConversation(
                customerUid: uid,
                tailorId: widget.tailor.id,
                tailorName: widget.tailor.name,
                tailorImage: widget.tailor.imagePath,
              );

              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatThreadScreen(
                    args: ChatThreadArgs(
                      conversationId: conversationId,
                      tailorName: widget.tailor.name,
                      tailorImage: widget.tailor.imagePath,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.measurement,
                    arguments: widget.tailor,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Order',
                  style: AppTextStyles.button(context, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
