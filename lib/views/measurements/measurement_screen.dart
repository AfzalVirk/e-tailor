import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../models/tailor_model.dart';

class MeasurementScreen extends StatefulWidget {
  final TailorModel? tailor;
  const MeasurementScreen({super.key, this.tailor});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final String _clothUniqueNumber;

  final List<File> _clothPhotos = [];

  String _unit = 'inc'; // 'inc' or 'cm'
  bool _sendingStitchedGarment = false;
  String _armLengthType = 'Half';
  bool _isUrgent = false;
  DateTime? _deliveryDate;

  final Map<String, TextEditingController> _kurta = {
    'Length': TextEditingController(),
    'Shoulder': TextEditingController(),
    'Chest': TextEditingController(),
    'Waist': TextEditingController(),
    'Hip': TextEditingController(),
    'Gher': TextEditingController(),
    'Arm Length': TextEditingController(),
    'Around Arm': TextEditingController(),
    'Wrist': TextEditingController(),
    'Collar Front': TextEditingController(),
    'Collar Back': TextEditingController(),
  };

  final Map<String, TextEditingController> _salwar = {
    'Length': TextEditingController(),
    'Waist': TextEditingController(),
    'Hip': TextEditingController(),
    'Around Leg': TextEditingController(),
    'Mori': TextEditingController(),
  };

  final _instructionsController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clothUniqueNumber = _generateClothNumber();
  }

  String _generateClothNumber() {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ET-${ts.substring(ts.length - 6)}';
  }

  @override
  void dispose() {
    for (final c in _kurta.values) {
      c.dispose();
    }
    for (final c in _salwar.values) {
      c.dispose();
    }
    _instructionsController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  Future<void> _addClothPhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _clothPhotos.add(File(picked.path)));
    }
  }

  void _removeClothPhoto(int index) {
    setState(() => _clothPhotos.removeAt(index));
  }

  Future<void> _pickDeliveryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deliveryDate = picked;
        _deliveryDateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery date')),
      );
      return;
    }

    // TODO: once a backend exists, save cloth photo, pattern images,
    // measurement maps, unit, delivery date, urgency, and instructions
    // as a MeasurementProfile tied to widget.tailor?.id (or left
    // unassigned if opened from the tab), then send it to the tailor.

    final message = widget.tailor != null
        ? 'Sent to ${widget.tailor!.name}. They\'ll confirm your order shortly.'
        : 'Measurement details saved.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Measurement details',
          style: AppTextStyles.heading3(context),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
          children: [
            _garmentTypeBadge(context),
            if (widget.tailor != null) ...[
              SizedBox(height: 12.h),
              _assignedTailorCard(context, widget.tailor!),
            ],
            SizedBox(height: 16.h),
            _sectionCard(
              context,
              title: 'Cloth and pattern',
              child: _clothSection(context),
            ),
            SizedBox(height: 16.h),
            _sectionCard(
              context,
              title: 'Measurements',
              trailing: _unitToggle(context),
              child: _measurementsSection(context),
            ),
            SizedBox(height: 16.h),
            _sectionCard(
              context,
              title: 'Delivery',
              child: _deliverySection(context),
            ),
            SizedBox(height: 16.h),
            _sectionCard(
              context,
              title: 'Special instructions',
              child: CustomTextField(
                controller: _instructionsController,
                hintText:
                    'Anything the tailor should know (fit, style, fabric care)...',
                maxLines: 4,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              label: 'Save measurement details',
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _garmentTypeBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.checkroom_rounded, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'Shalwar Kameez / Kurta',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.primary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _assignedTailorCard(BuildContext context, TailorModel tailor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: tailor.imagePath,
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 44.w,
                height: 44.w,
                color: AppColors.backgroundLight,
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                color: AppColors.textSecondaryLight,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tailor.name,
                      style: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (tailor.isVerified) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                    ],
                  ],
                ),
                Text(
                  'These details will be sent to this tailor',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.heading3(context)),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _clothSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cloth photos', style: AppTextStyles.bodySmall(context)),
        SizedBox(height: 8.h),
        SizedBox(
          height: 90.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _addClothPhoto,
                child: Container(
                  height: 90.h,
                  width: 90.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderLight),
                    color: AppColors.backgroundLight,
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.textSecondaryLight,
                    size: 26.sp,
                  ),
                ),
              ),
              for (int i = 0; i < _clothPhotos.length; i++)
                Stack(
                  children: [
                    Container(
                      height: 90.h,
                      width: 90.w,
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(_clothPhotos[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 12.w,
                      child: GestureDetector(
                        onTap: () => _removeClothPhoto(i),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(
              Icons.tag_rounded,
              color: AppColors.textSecondaryLight,
              size: 18.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              'Cloth ID: $_clothUniqueNumber',
              style: AppTextStyles.bodySmall(context),
            ),
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Cloth ID'),
                  content: const Text(
                    'This number identifies your fabric if you send it '
                    'physically to a tailor, so it doesn\'t get mixed up '
                    'with other orders.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: AppColors.textSecondaryLight,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _unitToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          _unitOption(context, 'inc', 'in'),
          _unitOption(context, 'cm', 'cm'),
        ],
      ),
    );
  }

  Widget _unitOption(BuildContext context, String value, String label) {
    final isSelected = _unit == value;
    return GestureDetector(
      onTap: () => setState(() => _unit = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall(
            context,
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _measurementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _sendingStitchedGarment,
          onChanged: (v) => setState(() => _sendingStitchedGarment = v),
          activeColor: AppColors.primary,
          title: Text(
            'I\'ll send a stitched garment for reference sizing instead',
            style: AppTextStyles.bodySmall(context),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Kurta',
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        for (final entry in _kurta.entries) ...[
          if (entry.key == 'Arm Length')
            _armLengthRow(context, entry.value)
          else
            _measurementField(context, entry.key, entry.value),
          SizedBox(height: 10.h),
        ],
        SizedBox(height: 6.h),
        Text(
          'Salwar',
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        for (final entry in _salwar.entries) ...[
          _measurementField(context, entry.key, entry.value),
          SizedBox(height: 10.h),
        ],
      ],
    );
  }

  Widget _measurementField(
    BuildContext context,
    String label,
    TextEditingController c,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(label, style: AppTextStyles.bodySmall(context)),
        ),
        Expanded(
          child: CustomTextField(
            controller: c,
            hintText: '0.0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Center(
                widthFactor: 1,
                child: Text(_unit, style: AppTextStyles.bodySmall(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _armLengthRow(BuildContext context, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _measurementField(context, 'Arm Length', c),
        SizedBox(height: 6.h),
        Row(
          children: [
            SizedBox(width: 100.w),
            _armTypeChip(context, 'Half'),
            SizedBox(width: 8.w),
            _armTypeChip(context, 'Full'),
          ],
        ),
      ],
    );
  }

  Widget _armTypeChip(BuildContext context, String value) {
    final isSelected = _armLengthType == value;
    return GestureDetector(
      onTap: () => setState(() => _armLengthType = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          value,
          style: AppTextStyles.bodySmall(
            context,
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  Widget _deliverySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery date', style: AppTextStyles.bodySmall(context)),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: _deliveryDateController,
          hintText: 'Select a date',
          readOnly: true,
          onTap: _pickDeliveryDate,
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            color: AppColors.textSecondaryLight,
            size: 18.sp,
          ),
          validator: (_) =>
              _deliveryDate == null ? 'Please select a date' : null,
        ),
        SizedBox(height: 4.h),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _isUrgent,
          onChanged: (v) => setState(() => _isUrgent = v),
          activeColor: AppColors.accent,
          title: Text(
            'Mark as urgent',
            style: AppTextStyles.bodySmall(context),
          ),
        ),
      ],
    );
  }
}
