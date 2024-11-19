import 'package:flutter/material.dart';

class ThemeService with ChangeNotifier {
  final String _boxName = 'settings';
  final String _key = 'isDarkMode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
