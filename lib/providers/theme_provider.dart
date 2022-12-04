import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class Themes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Raleway',
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white, opacity: 1),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Raleway',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    primaryColor: Colors.deepPurple,
    iconTheme: const IconThemeData(color: Colors.deepPurple, opacity: 1),
  );
}
