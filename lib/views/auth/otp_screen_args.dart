import '../../providers/auth_provider.dart';

/// Arguments passed via Navigator when pushing the OTP screen — tells it
/// why it was opened (signup / login / forgot password) and who the code
/// was "sent" to, so it can show the right message and branch correctly
/// after a successful verification.
class OtpScreenArgs {
  final OtpContext context;
  final String identifier;

  const OtpScreenArgs({required this.context, required this.identifier});
}
