import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences için yardımcı sınıf
/// Hata durumunda bellek içi depolama ile yedekleme yapar
class StorageHelper {
  // Bellek içi yedekleme için
  static final Map<String, dynamic> _memoryStorage = {};
  static bool _sharedPrefsWorking = true;

  /// SharedPreferences başlatma ve test
  static Future<bool> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Test amaçlı küçük bir veri yaz/oku
      await prefs.setString('_test_key', 'test_value');
      final testValue = prefs.getString('_test_key');
      _sharedPrefsWorking = testValue == 'test_value';
      print('SharedPreferences initialization status: $_sharedPrefsWorking');
      return _sharedPrefsWorking;
    } catch (e) {
      print('SharedPreferences initialization error: $e');
      _sharedPrefsWorking = false;
      return false;
    }
  }

  /// Boolean değer okuma
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getBool(key) ?? _memoryStorage[key] ?? defaultValue;
      }
    } catch (e) {
      print('Error reading bool from SharedPreferences: $e');
    }
    return _memoryStorage[key] ?? defaultValue;
  }

  /// Boolean değer yazma
  static Future<bool> setBool(String key, bool value) async {
    // Bellek içi depolamaya her durumda kaydet
    _memoryStorage[key] = value;
    
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return await prefs.setBool(key, value);
      }
    } catch (e) {
      print('Error writing bool to SharedPreferences: $e');
    }
    return false;
  }

  /// String değer okuma
  static Future<String> getString(String key, {String defaultValue = ''}) async {
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(key) ?? _memoryStorage[key] ?? defaultValue;
      }
    } catch (e) {
      print('Error reading string from SharedPreferences: $e');
    }
    return _memoryStorage[key] ?? defaultValue;
  }

  /// String değer yazma
  static Future<bool> setString(String key, String value) async {
    // Bellek içi depolamaya her durumda kaydet
    _memoryStorage[key] = value;
    
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return await prefs.setString(key, value);
      }
    } catch (e) {
      print('Error writing string to SharedPreferences: $e');
    }
    return false;
  }

  /// Int değer okuma
  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getInt(key) ?? _memoryStorage[key] ?? defaultValue;
      }
    } catch (e) {
      print('Error reading int from SharedPreferences: $e');
    }
    return _memoryStorage[key] ?? defaultValue;
  }

  /// Int değer yazma
  static Future<bool> setInt(String key, int value) async {
    // Bellek içi depolamaya her durumda kaydet
    _memoryStorage[key] = value;
    
    try {
      if (_sharedPrefsWorking) {
        final prefs = await SharedPreferences.getInstance();
        return await prefs.setInt(key, value);
      }
    } catch (e) {
      print('Error writing int to SharedPreferences: $e');
    }
    return false;
  }
} 