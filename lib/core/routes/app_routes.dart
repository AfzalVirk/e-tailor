/// All route names live here as constants — never hardcode a route string
/// like '/home' inside a screen. This is the single source of truth, and it
/// means a typo becomes a compile-time error instead of a silent navigation bug.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';

  static const String home = '/home';
  static const String tailorProfile = '/tailor-profile';
  static const String productDetails = '/product-details';

  static const String cart = '/cart';
  static const String checkoutSummary = '/checkout-summary';
  static const String payment = '/payment';
  static const String orderConfirmed = '/order-confirmed';

  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
}
