import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider with ChangeNotifier {
  static const _key = 'theme_mode';

  // Default to dark mode instead of system
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  ThemeModeProvider() {
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_key);

    // Only allow light or dark modes, default to dark if no preference saved
    if (themeIndex != null) {
      if (themeIndex == ThemeMode.light.index) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    } else {
      // If no preference is saved, default to dark and save it
      _themeMode = ThemeMode.dark;
      await prefs.setInt(_key, ThemeMode.dark.index);
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, _themeMode.index);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    // Only allow light or dark modes
    if (mode == ThemeMode.light || mode == ThemeMode.dark) {
      _themeMode = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, mode.index);
      notifyListeners();
    }
  }
}