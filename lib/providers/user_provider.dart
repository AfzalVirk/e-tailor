import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name;
  String _email;
  String _phone;
  final String _avatarAsset;

  UserProvider({
    String name = 'Afzal Virk',
    String email = 'afzal.virk@example.com',
    String phone = '03001234567',
    String avatarAsset =
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/user_avatar_mgizef.jpg',
  }) : _name = name,
       _email = email,
       _phone = phone,
       _avatarAsset = avatarAsset;

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get avatarAsset => _avatarAsset;

  void updateProfile({String? name, String? email, String? phone}) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    notifyListeners();
  }
}
