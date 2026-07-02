import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/auth/forgot_password_screen.dart';
import '../../views/auth/otp_verification_screen.dart';
import '../../views/auth/otp_screen_args.dart';
import '../../views/home/main_shell.dart';
import '../../views/profile/edit_profile_screen.dart';
import '../../views/tailor_profile/tailor_profile_screen.dart';
import '../../models/tailor_model.dart';
import '../../models/product_model.dart';
import '../../views/product_details/product_details_screen.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/checkout/checkout_summary_screen.dart';
import '../../views/checkout/payment_screen.dart';

/// Maps every route name to its screen.
/// Keeping this separate from main.dart means main.dart stays tiny, and
/// adding a new screen later is a two-line change here instead of touching
/// MaterialApp's routes table directly.
///
/// Usage: Navigator.pushNamed(context, AppRoutes.home);
/// With arguments: Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product);
class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _build(const SplashScreen(), settings);

      case AppRoutes.login:
        return _build(const LoginScreen(), settings);

      case AppRoutes.signup:
        return _build(const SignupScreen(), settings);

      case AppRoutes.forgotPassword:
        return _build(const ForgotPasswordScreen(), settings);

      case AppRoutes.otpVerification:
        final args = settings.arguments as OtpScreenArgs?;
        if (args == null) {
          return _build(
            const Scaffold(
              body: Center(child: Text('Missing OTP screen arguments')),
            ),
            settings,
          );
        }
        return _build(OtpVerificationScreen(args: args), settings);

      case AppRoutes.home:
        final initialIndex = settings.arguments is int
            ? settings.arguments as int
            : 0;
        return _build(MainShell(initialIndex: initialIndex), settings);

      case AppRoutes.tailorProfile:
        final tailor = settings.arguments as TailorModel?;
        if (tailor == null) {
          return _build(
            const Scaffold(
              body: Center(child: Text('Missing tailor argument')),
            ),
            settings,
          );
        }
        return _build(TailorProfileScreen(tailor: tailor), settings);

      // Remaining screens (tailor profile, product details etc.) added below.

      case AppRoutes.editProfile:
        return _build(const EditProfileScreen(), settings);

      case AppRoutes.productDetails:
        final product = settings.arguments as ProductModel?;
        if (product == null) {
          return _build(
            const Scaffold(
              body: Center(child: Text('Missing product argument')),
            ),
            settings,
          );
        }
        return _build(ProductDetailsScreen(product: product), settings);

      case AppRoutes.cart:
        return _build(const CartScreen(), settings);

      case AppRoutes.checkoutSummary:
        return _build(const CheckoutSummaryScreen(), settings);

      case AppRoutes.payment:
        return _build(const PaymentScreen(), settings);

      default:
        return _build(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _build(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
