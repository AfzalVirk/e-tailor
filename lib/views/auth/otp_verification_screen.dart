import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import 'otp_screen_args.dart';

/// One screen, reused for signup / phone login / forgot password — the
/// `OtpScreenArgs.context` passed in decides what happens after a correct
/// code, instead of building three near-identical screens.
///
/// NOTE: this is a STATIC mock per the assignment brief — no real SMS is
/// sent. The generated code is shown in a SnackBar so it can actually be
/// typed in and demoed end-to-end.
class OtpVerificationScreen extends StatefulWidget {
  final OtpScreenArgs args;

  const OtpVerificationScreen({super.key, required this.args});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  Timer? _countdownTimer;
  int _secondsRemaining = 60;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Show the mock code once when the screen opens, since it was already
    // "sent" by whichever screen pushed us here (signup/login/forgot).
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String get _screenTitle {
    switch (widget.args.context) {
      case OtpContext.signup:
        return 'Verify Your Phone';
      case OtpContext.loginPhone:
        return 'OTP Verification';
      case OtpContext.forgotPassword:
        return 'Confirm It\'s You';
    }
  }

  Future<void> _handleVerify() async {
    setState(() => _localError = null);
    if (_otpController.text.length != 6) {
      setState(() => _localError = 'Enter the full 6-digit code');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(_otpController.text);

    if (!mounted) return;

    if (!success) {
      setState(() => _localError = authProvider.errorMessage);
      return;
    }

    if (widget.args.context == OtpContext.signup) {
      context.read<UserProvider>().updateProfile(
        name: widget.args.signupName,
        email: widget.args.signupEmail,
        phone: widget.args.identifier,
      );
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  Future<void> _handleResend() async {
    final codeSent = await context.read<AuthProvider>().resendOtp();
    if (!mounted) return;
    if (codeSent) {
      _startCountdown();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Code re-sent.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.h),
                      SvgPicture.asset(
                        'assets/images/otp_verification.svg',
                        height: 160.h,
                      ),
                      SizedBox(height: 28.h),
                      Text(
                        _screenTitle,
                        style: AppTextStyles.heading2(context),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Enter the OTP sent to ${widget.args.identifier}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      SizedBox(height: 32.h),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 56.h,
                          fieldWidth: 56.w,
                          activeColor: AppColors.primary,
                          selectedColor: AppColors.primary,
                          inactiveColor: AppColors.borderLight,
                          activeFillColor: AppColors.surfaceLight,
                          selectedFillColor: AppColors.surfaceLight,
                          inactiveFillColor: AppColors.surfaceLight,
                        ),
                        enableActiveFill: true,
                        onChanged: (_) {},
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _secondsRemaining > 0
                            ? '00:${_secondsRemaining.toString().padLeft(2, '0')} Sec'
                            : 'Code expired',
                        style: AppTextStyles.bodySmall(context),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: _secondsRemaining == 0 ? _handleResend : null,
                        child: RichText(
                          text: TextSpan(
                            text: "Don't receive code? ",
                            style: AppTextStyles.bodyMedium(context),
                            children: [
                              TextSpan(
                                text: 'Re-send',
                                style: AppTextStyles.bodyMedium(
                                  context,
                                  color: _secondsRemaining == 0
                                      ? AppColors.primary
                                      : AppColors.textSecondaryLight,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_localError != null) ...[
                        SizedBox(height: 14.h),
                        Text(
                          _localError!,
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const Spacer(),
                      SizedBox(height: 20.h),
                      CustomButton(
                        label: 'Submit',
                        isLoading: isLoading,
                        onPressed: _handleVerify,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
