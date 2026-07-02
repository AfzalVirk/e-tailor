import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/home_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/product_card.dart';
import '../../widgets/tailor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar with logo + dark mode toggle ──
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLogo(iconSize: 28, fontSize: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded),
                          color: AppColors.primary,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Welcome text ──
                    Text(
                      'Welcome back,',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    Text(
                      userProvider.name,
                      style: AppTextStyles.heading2(context),
                    ),
                    SizedBox(height: 20.h),

                    // ── Wallet / points card ──
                    _WalletCard(),
                    SizedBox(height: 28.h),

                    // ── Search bar ──
                    _SearchBar(
                      controller: _searchController,
                      onChanged: homeProvider.search,
                      onClear: () {
                        _searchController.clear();
                        homeProvider.clearSearch();
                      },
                    ),
                    SizedBox(height: 28.h),

                    // ── Recommended tailors ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended Tailors',
                          style: AppTextStyles.heading3(context),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),

            // ── Tailor carousel ──
            SliverToBoxAdapter(
              child: homeProvider.tailors.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Center(
                        child: Text(
                          'No tailors found for "${homeProvider.searchQuery}"',
                          style: AppTextStyles.bodyMedium(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 190.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 20.w),
                        itemCount: homeProvider.tailors.length,
                        itemBuilder: (context, index) {
                          final tailor = homeProvider.tailors[index];
                          return TailorCard(
                            tailor: tailor,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.tailorProfile,
                              arguments: tailor,
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // ── Featured collection heading ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 28.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Collection',
                          style: AppTextStyles.heading3(context),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),

            // ── Products carousel ──
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.w, bottom: 4.h),
                  itemCount: homeProvider.featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = homeProvider.featuredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: product,
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _WalletCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Balance',
                  style: AppTextStyles.bodySmall(
                    context,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Rs. 10,000',
                  style: AppTextStyles.heading2(context, color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.gold,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '100 Points',
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _WalletAction(icon: Icons.add_card_rounded, label: 'Add\nFunds'),
              SizedBox(width: 16.w),
              _WalletAction(
                icon: Icons.emoji_events_rounded,
                label: 'Get\nPoints',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WalletAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: Colors.white, size: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.bodySmall(
            context,
            color: Colors.white70,
          ).copyWith(fontSize: 9.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search tailors by name or city...',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondaryLight,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 18.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }
}
