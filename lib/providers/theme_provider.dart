import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls light/dark mode app-wide and remembers the user's choice
/// between app launches using SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const String _prefsKey = 'is_dark_mode';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, _isDarkMode);
  }
}
