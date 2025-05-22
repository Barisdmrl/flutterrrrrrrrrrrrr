import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;
  static const String _darkModeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Tercih edilen temayı yerel depolamadan yükle
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('is_dark_mode') ?? false;
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Tema modunu değiştir
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // Tema tercihini kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    
    notifyListeners();
  }

  // Temayı doğrudan ayarla
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return; // Değişiklik yoksa işlem yapma
    
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    // Tema tercihini kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    
    notifyListeners();
  }

  // Açık tema
  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF4CAF50),      // Orta yeşil
        primaryContainer: const Color(0xFFC8E6C9), // Açık yeşil container
        secondary: const Color(0xFF66BB6A),    // Açık yeşil
        secondaryContainer: const Color(0xFFDCEDC8), // Daha açık yeşil container
        tertiary: const Color(0xFF2E7D32),     // Koyu yeşil
        tertiaryContainer: const Color(0xFFA5D6A7), // Orta açık yeşil container
        surface: Colors.white,
        background: Colors.white,
        error: const Color(0xFFE57373),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
      brightness: Brightness.light,
      cardColor: Colors.white,
      useMaterial3: true,
    );
  }

  // Koyu tema
  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF81C784),      // Daha açık yeşil (koyu temada daha görünür)
        primaryContainer: const Color(0xFF2E7D32), // Koyu yeşil container
        secondary: const Color(0xFFA5D6A7),    // Açık yeşil
        secondaryContainer: const Color(0xFF1B5E20), // Çok koyu yeşil container
        tertiary: const Color(0xFF66BB6A),     // Orta yeşil
        tertiaryContainer: const Color(0xFF1B5E20), // Koyu yeşil container
        surface: const Color(0xFF121212),
        background: const Color(0xFF121212),
        error: const Color(0xFFE57373),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF81C784),
          foregroundColor: Colors.black,
        ),
      ),
      brightness: Brightness.dark,
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: Colors.white24,
      useMaterial3: true,
    );
  }
} 