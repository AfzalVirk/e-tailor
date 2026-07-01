import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { idle, loading, success, error }

/// Why an OTP screen was opened — decides what happens after a correct
/// code is entered, since signup/login/forgot-password each need a
/// different outcome (see OtpVerificationScreen for the branching).
enum OtpContext { signup, loginPhone, forgotPassword }

/// Mocked authentication state for this frontend-only assignment.
///
/// IMPORTANT: this app is static frontend UI per spec — there is no real
/// backend, no real SMS sent, no real password check. Every method here
/// simulates a network delay and fakes a result locally. The public method
/// names and signatures are written so that if real auth is ever wired in
/// later, only the *inside* of these methods changes — nothing that calls
/// this provider needs to change.
class AuthProvider extends ChangeNotifier {
  static const String _loggedInKey = 'is_logged_in';

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Mock OTP state
  String? _generatedOtp;
  String? _pendingIdentifier; // phone/email the OTP was "sent" to
  OtpContext? _otpContext;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String? get pendingIdentifier => _pendingIdentifier;

  /// Exposed ONLY because this is a static/mock frontend build with no real
  /// SMS provider — the demo OTP screen shows this so it can be typed in
  /// and tested. A real implementation would never expose the code itself.
  String? get debugOtp => _generatedOtp;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    notifyListeners();
  }

  /// Email+password login — no OTP step, matches the Figma's email login flow.
  Future<bool> loginWithEmail(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _status = AuthStatus.success;
    _isLoggedIn = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    return true;
  }

  /// Phone login — sends a mock OTP, caller should navigate to the OTP screen.
  Future<String> loginWithPhone(String phone) async {
    return _sendMockOtp(phone, OtpContext.loginPhone);
  }

  /// Signup — sends a mock OTP to verify the phone before the account
  /// is considered "created."
  Future<String> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    // In a real app this is where the new user record would be created.
    // Here we just hold the phone number for the OTP step.
    return _sendMockOtp(phone, OtpContext.signup);
  }

  /// Forgot password — sends a mock OTP to confirm identity before
  /// the (mocked) reset.
  Future<String> forgotPassword(String phone) async {
    return _sendMockOtp(phone, OtpContext.forgotPassword);
  }

  /// Generates a random 4-digit code and "sends" it — since this is a
  /// static frontend, no real SMS goes out. The code is returned so the
  /// UI can show it directly (e.g. in a SnackBar) for demo purposes.
  Future<String> _sendMockOtp(String identifier, OtpContext context) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    _generatedOtp = (1000 + Random().nextInt(9000)).toString(); // 4 digits
    _pendingIdentifier = identifier;
    _otpContext = context;
    _status = AuthStatus.success;
    notifyListeners();

    return _generatedOtp!;
  }

  /// Re-sends (regenerates) the OTP for whatever context is currently pending.
  Future<String> resendOtp() async {
    if (_pendingIdentifier == null || _otpContext == null) {
      throw StateError('No pending OTP request to resend.');
    }
    return _sendMockOtp(_pendingIdentifier!, _otpContext!);
  }

  /// Verifies the entered code against the mock-generated one, then
  /// performs the correct outcome for the context the OTP was sent for.
  /// Returns true if verified successfully.
  Future<bool> verifyOtp(String enteredCode) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (enteredCode != _generatedOtp) {
      _status = AuthStatus.error;
      _errorMessage = 'Incorrect code. Please try again.';
      notifyListeners();
      return false;
    }

    _status = AuthStatus.success;

    if (_otpContext == OtpContext.signup || _otpContext == OtpContext.loginPhone) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
    }
    // forgotPassword: intentionally does NOT log the user in — verifying
    // identity isn't the same as being logged in. Screen sends them back
    // to Login afterward.

    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _status = AuthStatus.idle;
    _generatedOtp = null;
    _pendingIdentifier = null;
    _otpContext = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }
}
