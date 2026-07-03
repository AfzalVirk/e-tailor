import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/order_progress_stepper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
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
                          'My Order',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3(context),
                        ),
                      ),
                      SizedBox(width: 48.w),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const OrderProgressStepper(currentStep: 0),
                ],
              ),
            ),
            Expanded(
              child: cart.isEmpty
                  ? _emptyState(context)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CachedNetworkImage(
                                  imageUrl: item.product.imagePath,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 60.w,
                                    height: 60.w,
                                    color: AppColors.backgroundLight,
                                    child: Center(
                                      child: SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 60.w,
                                        height: 60.w,
                                        color: AppColors.backgroundLight,
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: AppColors.textSecondaryLight,
                                          size: 20.sp,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: AppTextStyles.bodyMedium(
                                        context,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Rs. ${item.product.price.toStringAsFixed(0)}',
                                      style: AppTextStyles.bodySmall(
                                        context,
                                        color: AppColors.accent,
                                      ).copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 2.h),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.productDetails,
                                        arguments: item.product,
                                      ),
                                      child: Text(
                                        'Edit',
                                        style:
                                            AppTextStyles.bodySmall(
                                              context,
                                              color:
                                                  AppColors.textSecondaryLight,
                                            ).copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _quantityStepper(context, item),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (!cart.isEmpty) _buildBottomBar(context, cart),
          ],
        ),
      ),
    );
  }

  Widget _quantityStepper(BuildContext context, CartItem item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () =>
                context.read<CartProvider>().decrementQuantity(item.product.id),
            child: Icon(
              Icons.remove_circle,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text('${item.quantity}', style: AppTextStyles.bodyMedium(context)),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () =>
                context.read<CartProvider>().incrementQuantity(item.product.id),
            child: Icon(
              Icons.add_circle,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 56.sp,
              color: AppColors.textSecondaryLight,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your cart is empty',
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
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
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total price', style: AppTextStyles.bodyMedium(context)),
                Text(
                  'Rs. ${cart.subtotal.toStringAsFixed(0)}',
                  style: AppTextStyles.heading3(
                    context,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            CustomButton(
              label: 'Order',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.checkoutSummary),
            ),
          ],
        ),
      ),
    );
  }
}
