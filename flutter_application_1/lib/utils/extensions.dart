import 'package:flutter/material.dart';

/// Bu dosya, tüm uygulama genelinde kullanılan string, liste, tarih gibi
/// sınıflar için genişletme yöntemlerini içerir.

// String sınıfı için genişletme metodları
extension StringExtension on String {
  /// E-posta adresinin geçerli olup olmadığını kontrol eder
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Telefon numarasının geçerli olup olmadığını kontrol eder
  bool isValidPhone() {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(this);
  }

  /// Metnin sadece sayılardan oluşup oluşmadığını kontrol eder
  bool isNumeric() {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }

  /// Metnin sadece harflerden oluşup oluşmadığını kontrol eder
  bool isAlpha() {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Metnin sadece harf ve sayılardan oluşup oluşmadığını kontrol eder
  bool isAlphanumeric() {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// TC Kimlik numarasının geçerli olup olmadığını kontrol eder
  bool isValidTCKN() {
    if (length != 11) return false;
    if (!isNumeric()) return false;
    if (this[0] == '0') return false;
    
    int oddSum = 0;
    int evenSum = 0;
    int tenthDigit = int.parse(this[9]);
    int eleventhDigit = int.parse(this[10]);
    
    for (int i = 0; i < 9; i += 2) {
      oddSum += int.parse(this[i]);
    }
    
    for (int i = 1; i < 9; i += 2) {
      evenSum += int.parse(this[i]);
    }
    
    int tenth = ((oddSum * 7) - evenSum) % 10;
    int eleventh = (oddSum + evenSum + tenthDigit) % 10;
    
    return tenth == tenthDigit && eleventh == eleventhDigit;
  }

  /// String'in ilk harfini büyük, diğer harflerini küçük yapar
  String toCapitalized() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Her kelimenin ilk harfini büyük yapar
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.toCapitalized()).join(' ');
  }

  /// String'i belirli bir uzunlukta keser ve üç nokta ekler
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}

// DateTime sınıfı için genişletme metodları
extension DateTimeExtension on DateTime {
  /// Tarih formatını "gg.aa.yyyy" şeklinde döndürür
  String toFormattedDate() {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }

  /// Tarih ve saat formatını "gg.aa.yyyy ss:dd" şeklinde döndürür
  String toFormattedDateTime() {
    return '${toFormattedDate()} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// İki tarih arasındaki farkı hesaplar
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}

// List sınıfı için genişletme metodları
extension ListExtension<T> on List<T> {
  /// Listeden rastgele bir eleman döndürür
  T get random {
    final random = DateTime.now().millisecondsSinceEpoch % length;
    return this[random];
  }
}

// Renk işlemleri için Color sınıfına genişletme
extension ColorExtension on Color {
  /// Rengin daha koyu tonunu döndürür
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return hslDark.toColor();
  }
  
  /// Rengin daha açık tonunu döndürür
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return hslLight.toColor();
  }
} 