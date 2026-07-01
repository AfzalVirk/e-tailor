import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/auth/forgot_password_screen.dart';
import '../../views/auth/otp_verification_screen.dart';
import '../../views/auth/otp_screen_args.dart';

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

      // Remaining screens (home, etc.) get added here one at a time as
      // we build them — each is a single case + import.

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
