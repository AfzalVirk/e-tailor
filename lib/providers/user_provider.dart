import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Real per-account profile data, backed by Firestore. Automatically loads
/// the signed-in user's document when they log in, and clears on logout.
class UserProvider extends ChangeNotifier {
  static const String _defaultAvatar =
      'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/user_avatar_mgizef.jpg';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authSub;

  String _name = '';
  String _email = '';
  String _phone = '';
  String _avatarAsset = _defaultAvatar;
  bool _isLoading = false;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get avatarAsset => _avatarAsset;
  bool get isLoading => _isLoading;

  UserProvider() {
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      _name = '';
      _email = '';
      _phone = '';
      _avatarAsset = _defaultAvatar;
      notifyListeners();
      return;
    }
    await _loadFromFirestore(user.uid);
  }

  Future<void> _loadFromFirestore(String uid) async {
    _isLoading = true;
    notifyListeners();

    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data()!;
      _name = data['name'] ?? '';
      _email = data['email'] ?? _auth.currentUser?.email ?? '';
      _phone = data['phone'] ?? '';
      _avatarAsset = data['avatarUrl'] ?? _defaultAvatar;
    } else {
      // First time we've seen this account — create a starter document.
      _name = _auth.currentUser?.displayName ?? '';
      _email = _auth.currentUser?.email ?? '';
      _phone = '';
      _avatarAsset = _defaultAvatar;
      await docRef.set({
        'name': _name,
        'email': _email,
        'phone': _phone,
        'avatarUrl': _avatarAsset,
      });
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (avatarUrl != null) _avatarAsset = avatarUrl;
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'name': _name,
      'email': _email,
      'phone': _phone,
      'avatarUrl': _avatarAsset,
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}