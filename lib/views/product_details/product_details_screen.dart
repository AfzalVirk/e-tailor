import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';
import '../../core/routes/app_routes.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  void _addToCartAndOrder() {
    context.read<CartProvider>().setProductQuantity(widget.product, _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} added to cart')),
    );

    Navigator.pushNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        product.imagePath,
                        width: double.infinity,
                        height: 320.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: _circleIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: _circleIconButton(
                          icon: Icons.favorite_border_rounded,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: AppTextStyles.heading2(context),
                              ),
                            ),
                            Text(
                              'Rs. ${product.price.toStringAsFixed(0)}',
                              style: AppTextStyles.heading3(
                                context,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.gold,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${product.rating}  •  ${product.totalOrders} orders',
                              style: AppTextStyles.bodySmall(
                                context,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            _tag(
                              context,
                              Icons.texture_rounded,
                              product.material,
                            ),
                            SizedBox(width: 10.w),
                            _tag(
                              context,
                              Icons.straighten_rounded,
                              product.size,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Description',
                          style: AppTextStyles.heading3(context),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          product.description,
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity',
                              style: AppTextStyles.heading3(context),
                            ),
                            _quantitySelector(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomBar(context, product),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimaryLight, size: 20.sp),
      ),
    );
  }

  Widget _tag(BuildContext context, IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.bodySmall(context, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector(BuildContext context) {
    return Row(
      children: [
        _qtyButton(
          icon: Icons.remove_rounded,
          onTap: () {
            if (_quantity > 1) setState(() => _quantity--);
          },
        ),
        SizedBox(width: 14.w),
        Text('$_quantity', style: AppTextStyles.heading3(context)),
        SizedBox(width: 14.w),
        _qtyButton(
          icon: Icons.add_rounded,
          onTap: () => setState(() => _quantity++),
        ),
      ],
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductModel product) {
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
        child: CustomButton(
          label:
              'Order  •  Rs. ${(product.price * _quantity).toStringAsFixed(0)}',
          onPressed: _addToCartAndOrder,
        ),
      ),
    );
  }
}
