import 'package:flutter/material.dart';

class LocalizationService extends ChangeNotifier {
  Locale _currentLocale = const Locale('tr');

  final Map<String, Map<String, String>> _localizedStrings = {
    'tr': {
      'app_name': 'SWAP',
      'login': 'Giriş Yap',
      'register': 'Üye Ol',
      'profile': 'Profil',
      'my_offers': 'Tekliflerim',
      'logout': 'Çıkış Yap',
      'search': 'Ne aramıştınız?',
      'category': 'Kategori',
      'location': 'Konum',
      'price_range': 'Fiyat Aralığı',
      'latest_listings': 'Son İlanlar',
      'follow': 'Takip Et',
      'settings': 'Ayarlar',
      'dark_mode': 'Karanlık Mod',
      'theme': 'Tema',
      'language': 'Dil',
      'turkish': 'Türkçe',
      'english': 'English',
      'social_login': 'Sosyal Medya ile Giriş',
    },
    'en': {
      'app_name': 'SWAP',
      'login': 'Login',
      'register': 'Register',
      'profile': 'Profile',
      'my_offers': 'My Offers',
      'logout': 'Logout',
      'search': 'What are you looking for?',
      'category': 'Category',
      'location': 'Location',
      'price_range': 'Price Range',
      'latest_listings': 'Latest Listings',
      'follow': 'Follow',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'theme': 'Theme',
      'language': 'Language',
      'turkish': 'Turkish',
      'english': 'English',
      'social_login': 'Social Login',
    },
  };

  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => const [
    Locale('tr'),
    Locale('en'),
  ];

  String getString(String key) {
    return _localizedStrings[_currentLocale.languageCode]?[key] ?? key;
  }

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _currentLocale = locale;
    notifyListeners();
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
} 