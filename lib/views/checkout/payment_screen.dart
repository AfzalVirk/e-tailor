import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order_confirmation.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/order_progress_stepper.dart';
import 'order_processing_screen.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _rememberCard = true;
  bool _sendReceipt = false;

  Future<void> _pickExpiryDate() async {
    final selected = await SimpleMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      disableFuture: false, // cards expire in the future, so don't disable it
    );

    if (selected != null) {
      final mm = selected.month.toString().padLeft(2, '0');
      final yy = (selected.year % 100).toString().padLeft(2, '0');
      setState(() => _expiryController.text = '$mm/$yy');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePayNow() {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final user = context.read<UserProvider>();

    final order = OrderConfirmation(
      orderNo: DateTime.now().millisecondsSinceEpoch.toString(),
      total: cart.total,
      dateTime: DateTime.now(),
      paymentMethod: 'Credit / Debit Card',
      name: user.name,
      email: _sendReceipt ? user.email : '—',
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderProcessingScreen(order: order)),
    );
  }

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
                          'Payment',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3(context),
                        ),
                      ),
                      SizedBox(width: 48.w),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const OrderProgressStepper(currentStep: 2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel(context, 'Payment Method'),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderLight),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.credit_card_rounded,
                              size: 18.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Credit / Debit Card',
                              style: AppTextStyles.bodyMedium(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _fieldLabel(context, 'Cardholder Name'),
                      SizedBox(height: 6.h),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Name on card',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          size: 18.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Cardholder name is required'
                            : null,
                      ),
                      SizedBox(height: 16.h),
                      _fieldLabel(context, 'Card Number'),
                      SizedBox(height: 6.h),
                      CustomTextField(
                        controller: _cardNumberController,
                        hintText: '1234 5678 9012 3456',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(
                          Icons.credit_card_rounded,
                          size: 18.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(
                            RegExp(r'\D'),
                            '',
                          );
                          if (digits.length != 16) {
                            return 'Enter a valid 16-digit card number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(context, 'Expiry'),
                                SizedBox(height: 6.h),
                                GestureDetector(
                                  onTap: _pickExpiryDate,
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      controller: _expiryController,
                                      hintText: 'MM/YY',
                                      prefixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16.sp,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                      validator: (v) {
                                        final ok = RegExp(
                                          r'^\d{2}/\d{2}$',
                                        ).hasMatch(v ?? '');
                                        return ok ? null : 'Select expiry date';
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(context, 'CVV'),
                                SizedBox(height: 6.h),
                                CustomTextField(
                                  controller: _cvvController,
                                  hintText: '***',
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => (v == null || v.length != 3)
                                      ? '3 digits'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _rememberCard,
                        onChanged: (v) => setState(() => _rememberCard = v),
                        activeColor: AppColors.primary,
                        title: Text(
                          'Remember this card',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _sendReceipt,
                        onChanged: (v) => setState(() => _sendReceipt = v),
                        activeColor: AppColors.primary,
                        title: Text(
                          'Send receipt to my email',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(context, cart),
          ],
        ),
      ),
    );
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
            CustomButton(label: 'Pay Now', onPressed: _handlePayNow),
          ],
        ),
      ),
    );
  }
}
