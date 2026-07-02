import '../../providers/auth_provider.dart';

class OtpScreenArgs {
  final OtpContext context;
  final String identifier;
  final String? signupName;
  final String? signupEmail;

  const OtpScreenArgs({
    required this.context,
    required this.identifier,
    this.signupName,
    this.signupEmail,
  });
}
