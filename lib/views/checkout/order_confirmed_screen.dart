import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_confirmation.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final OrderConfirmation order;

  const OrderConfirmedScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd.MM.yyyy – HH:mm:ss',
    ).format(order.dateTime);

    return Scaffold(
      //backgroundColor: AppColors.primary.withOpacity(0.06),
      body: SafeArea(
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
                    'Confirmed',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3(context),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: Colors.pink.shade100,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          Text(
                            'Payment Detail',
                            style: AppTextStyles.heading3(context),
                          ),
                          SizedBox(height: 14.h),
                          _detailRow(context, 'Order No.', order.orderNo),
                          _detailRow(
                            context,
                            'Total',
                            'Rs. ${order.total.toStringAsFixed(0)}',
                          ),
                          _detailRow(context, 'Date & Time', formattedDate),
                          _detailRow(
                            context,
                            'Payment Method',
                            order.paymentMethod,
                          ),
                          _detailRow(context, 'Name', order.name),
                          _detailRow(context, 'Email', order.email),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (order.email != '—')
                      Text(
                        'A receipt will be sent directly to the email',
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.textSecondaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: CustomButton(
                label: 'Done',
                onPressed: () {
                  context.read<CartProvider>().clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall(
              context,
              color: AppColors.textSecondaryLight,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
