import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundEnabled = true;
  bool _darkMode = false;

  bool get soundEnabled => _soundEnabled;
  bool get darkMode => _darkMode;

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}