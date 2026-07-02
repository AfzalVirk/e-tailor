import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { idle, loading, success, error }

enum OtpContext { signup, loginPhone, forgotPassword }

class AuthProvider extends ChangeNotifier {
  static const String _loggedInKey = 'is_logged_in';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  bool _isLoggedIn = false;
  String? _pendingEmail;
  String? _pendingPassword;
  String? _pendingName;

  String? _verificationId;
  int? _resendToken;
  String? _pendingIdentifier;
  OtpContext? _otpContext;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String? get pendingIdentifier => _pendingIdentifier;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final mockLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    _isLoggedIn = mockLoggedIn || _firebaseAuth.currentUser != null;
    notifyListeners();
  }

  String _toE164(String localPhone) {
    final digits = localPhone.replaceAll(RegExp(r'\D'), '');
    final withoutLeadingZero = digits.startsWith('0')
        ? digits.substring(1)
        : digits;
    return '+92$withoutLeadingZero';
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoggedIn = true;
      _status = AuthStatus.success;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _mapAuthError(e);
      notifyListeners();
      return false;
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak (use at least 6 characters).';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect email or password.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  Future<bool> loginWithPhone(String phone) {
    return _sendFirebaseOtp(phone, OtpContext.loginPhone);
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) {
    _pendingName = name;
    _pendingEmail = email;
    _pendingPassword = password;
    return _sendFirebaseOtp(phone, OtpContext.signup);
  }

  Future<bool> forgotPassword(String phone) {
    return _sendFirebaseOtp(phone, OtpContext.forgotPassword);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _sendFirebaseOtp(
    String localPhone,
    OtpContext otpContext,
  ) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final e164Phone = _toE164(localPhone);
    _pendingIdentifier = localPhone;
    _otpContext = otpContext;

    final completer = Completer<bool>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: e164Phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _completeSignIn(credential, otpContext);
        if (!completer.isCompleted) completer.complete(false);
      },
      verificationFailed: (FirebaseAuthException e) {
        _status = AuthStatus.error;
        _errorMessage = e.message ?? 'Failed to send code. Try again.';
        notifyListeners();
        if (!completer.isCompleted) completer.complete(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        _status = AuthStatus.success;
        notifyListeners();
        if (!completer.isCompleted) completer.complete(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      forceResendingToken: _resendToken,
    );

    return completer.future;
  }

  Future<bool> resendOtp() async {
    if (_pendingIdentifier == null || _otpContext == null) {
      throw StateError('No pending OTP request to resend.');
    }
    return _sendFirebaseOtp(_pendingIdentifier!, _otpContext!);
  }

  /// Verifies the entered 6-digit code, then applies the correct
  /// account rule for the context it was sent for:
  /// - signup: must be a NEW phone. If it already has an account, reject.
  /// - loginPhone / forgotPassword: must be an EXISTING phone. If it's
  ///   brand new, reject (and clean up the ghost account Firebase made).
  Future<bool> verifyOtp(String enteredCode) async {
    if (_verificationId == null) {
      _status = AuthStatus.error;
      _errorMessage = 'Session expired. Please request a new code.';
      notifyListeners();
      return false;
    }

    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: enteredCode,
      );
      return await _completeSignIn(credential, _otpContext);
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.code == 'invalid-verification-code'
          ? 'Incorrect code. Please try again.'
          : (e.message ?? 'Verification failed.');
      notifyListeners();
      return false;
    }
  }

  Future<bool> _completeSignIn(
    PhoneAuthCredential credential,
    OtpContext? otpContext,
  ) async {
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

    if (otpContext == OtpContext.signup && !isNewUser) {
      _status = AuthStatus.error;
      _errorMessage =
          'This number is already registered. Please log in instead.';
      await _firebaseAuth.signOut();
      notifyListeners();
      return false;
    }

    if ((otpContext == OtpContext.loginPhone ||
            otpContext == OtpContext.forgotPassword) &&
        isNewUser) {
      _status = AuthStatus.error;
      _errorMessage = 'No account found for this number. Please sign up first.';
      await _firebaseAuth.currentUser?.delete();
      notifyListeners();
      return false;
    }

    if (otpContext == OtpContext.signup ||
        otpContext == OtpContext.loginPhone ||
        otpContext == OtpContext.forgotPassword) {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);

      if (otpContext == OtpContext.signup &&
          _pendingEmail != null &&
          _pendingPassword != null) {
        try {
          final emailCred = EmailAuthProvider.credential(
            email: _pendingEmail!,
            password: _pendingPassword!,
          );
          await _firebaseAuth.currentUser!.linkWithCredential(emailCred);
          if (_pendingName != null) {
            await _firebaseAuth.currentUser!.updateDisplayName(_pendingName);
          }
        } on FirebaseAuthException catch (_) {
          // Email might already be in use by another account — phone signup
          // still succeeds either way, just email-login won't work for them.
        }
        _pendingEmail = null;
        _pendingPassword = null;
        _pendingName = null;
      }
    }

    _status = AuthStatus.success;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _isLoggedIn = false;
    _status = AuthStatus.idle;
    _verificationId = null;
    _pendingIdentifier = null;
    _otpContext = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }
}
