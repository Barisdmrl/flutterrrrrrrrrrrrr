import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Geçici olarak Firebase Authentication olmadan test yapabilmek için
// mock kullanıcı sınıfı
class MockUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;

  MockUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
  });
}

class AuthService {
  // Test için: Firebase bağlantısı olmadığında mock kullanıcı kullan
  bool _useMock = true;  // Test modunda true olarak ayarlı
  
  // Mock kullanıcı verileri
  MockUser? _mockCurrentUser;
  final List<MockUser> _mockUsers = [
    MockUser(
      uid: 'test123',
      email: 'test@example.com',
      displayName: 'Test Kullanıcı',
      emailVerified: true,
    ),
  ];
  
  // Firebase bağlantısı olduğunda kullanılacak
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Kullanıcı giriş durumunu izleyen akış
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Mevcut kullanıcı bilgisini döndür
  User? get currentUser => _useMock ? null : _auth.currentUser;
  
  // Mock kullanıcı bilgisini döndür
  MockUser? get mockCurrentUser => _mockCurrentUser;
  
  // Gerçek kullanıcı mı yoksa mock kullanıcı mı var kontrol et
  bool get isLoggedIn => _useMock ? (_mockCurrentUser != null) : (_auth.currentUser != null);
  
  // E-posta ve şifre ile kayıt ol
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password) async {
    if (_useMock) {
      // Test için mock kullanıcı oluştur
      await Future.delayed(const Duration(seconds: 1)); // Network gecikmesi simülasyonu
      
      // Email kontrolü
      if (_mockUsers.any((user) => user.email == email)) {
        throw Exception('email-already-in-use');
      }
      
      // Yeni mock kullanıcı oluştur
      final newUser = MockUser(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: 'Yeni Kullanıcı',
      );
      
      _mockUsers.add(newUser);
      _mockCurrentUser = newUser;
      
      return null; // Gerçek UserCredential'a benzetmek için
    } else {
      try {
        return await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        rethrow;
      }
    }
  }
  
  // E-posta ve şifre ile giriş yap
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    if (_useMock) {
      // Test için mock giriş
      await Future.delayed(const Duration(seconds: 1)); // Network gecikmesi simülasyonu
      
      // Kullanıcıyı bul
      final user = _mockUsers.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('user-not-found'),
      );
      
      // Test için şifre doğrulama (gerçekte her zaman 'password' ile giriş yapılabilir)
      if (password != 'password') {
        throw Exception('wrong-password');
      }
      
      _mockCurrentUser = user;
      return null; // Gerçek UserCredential'a benzetmek için
    } else {
      try {
        return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        rethrow;
      }
    }
  }
  
  // Çıkış yap
  Future<void> signOut() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 300)); // Gecikme simülasyonu
      _mockCurrentUser = null;
    } else {
      await _auth.signOut();
    }
  }
  
  // Şifre sıfırlama e-postası gönder
  Future<void> sendPasswordResetEmail(String email) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1)); // Gecikme simülasyonu
      // Test için kullanıcı kontrolü
      final userExists = _mockUsers.any((user) => user.email == email);
      if (!userExists) {
        throw Exception('user-not-found');
      }
      // Gerçekte e-posta gönderimi simüle edilir
    } else {
      await _auth.sendPasswordResetEmail(email: email);
    }
  }
  
  // Kullanıcı profilini güncelle
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1)); // Gecikme simülasyonu
      if (_mockCurrentUser != null) {
        _mockCurrentUser = MockUser(
          uid: _mockCurrentUser!.uid,
          email: _mockCurrentUser!.email,
          displayName: displayName ?? _mockCurrentUser!.displayName,
          photoURL: photoURL ?? _mockCurrentUser!.photoURL,
          emailVerified: _mockCurrentUser!.emailVerified,
        );
      }
    } else {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
      }
    }
  }
  
  // E-posta doğrulama gönder
  Future<void> sendEmailVerification() async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1)); // Gecikme simülasyonu
      // Test için e-posta doğrulama simülasyonu
    } else {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    }
  }
  
  // E-posta doğrulama durumunu kontrol et
  Future<bool> isEmailVerified() async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1)); // Gecikme simülasyonu
      return _mockCurrentUser?.emailVerified ?? false;
    } else {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    }
  }
  
  // Şifre değiştir
  Future<void> changePassword(String newPassword) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1)); // Gecikme simülasyonu
      // Test için şifre değiştirme simülasyonu
    } else {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    }
  }
} 