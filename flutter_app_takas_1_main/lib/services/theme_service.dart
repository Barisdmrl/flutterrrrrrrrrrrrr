import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final String name;

  AppTheme({
    required this.lightTheme,
    required this.darkTheme,
    required this.name,
  });
}

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  int _selectedThemeIndex = 0;

  final List<AppTheme> _themes = [
    // Varsayılan tema
    AppTheme(
      name: 'Mor',
      lightTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade200,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
    ),
    // Mavi tema
    AppTheme(
      name: 'Mavi',
      lightTheme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade200,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
    ),
    // Yeşil tema
    AppTheme(
      name: 'Yeşil',
      lightTheme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade200,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.greenAccent,
        ),
      ),
    ),
  ];

  bool get isDarkMode => _isDarkMode;
  int get selectedThemeIndex => _selectedThemeIndex;
  List<AppTheme> get themes => _themes;
  ThemeData get currentTheme => _isDarkMode 
      ? _themes[_selectedThemeIndex].darkTheme 
      : _themes[_selectedThemeIndex].lightTheme;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(int index) {
    if (index >= 0 && index < _themes.length) {
      _selectedThemeIndex = index;
      notifyListeners();
    }
  }
} 