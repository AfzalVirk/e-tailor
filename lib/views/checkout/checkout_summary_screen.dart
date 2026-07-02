import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/order_progress_stepper.dart';

class CheckoutSummaryScreen extends StatelessWidget {
  const CheckoutSummaryScreen({super.key});

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
                          'Summary',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3(context),
                        ),
                      ),
                      SizedBox(width: 48.w),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const OrderProgressStepper(currentStep: 1),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Summary', style: AppTextStyles.heading3(context)),
                        SizedBox(height: 14.h),
                        ...cart.items.map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.quantity > 1
                                        ? '${item.product.name} x${item.quantity}'
                                        : item.product.name,
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                ),
                                Text(
                                  'Rs. ${item.subtotal.toStringAsFixed(0)}',
                                  style: AppTextStyles.bodyMedium(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: AppColors.borderLight, height: 24.h),
                        _summaryRow(
                          context,
                          'Subtotal',
                          'Rs. ${cart.subtotal.toStringAsFixed(0)}',
                        ),
                        SizedBox(height: 6.h),
                        _summaryRow(
                          context,
                          'Services Fee',
                          'Rs. ${CartProvider.serviceFee.toStringAsFixed(0)}',
                        ),
                        SizedBox(height: 10.h),
                        _summaryRow(
                          context,
                          'Total',
                          'Rs. ${cart.total.toStringAsFixed(0)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomBar(context, cart),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
  }) {
    final style = bold
        ? AppTextStyles.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w700)
        : AppTextStyles.bodyMedium(
            context,
            color: AppColors.textSecondaryLight,
          );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
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
                  'Rs. ${cart.total.toStringAsFixed(0)}',
                  style: AppTextStyles.heading3(
                    context,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            CustomButton(
              label: 'Pay Now',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.payment),
            ),
          ],
        ),
      ),
    );
  }
}
