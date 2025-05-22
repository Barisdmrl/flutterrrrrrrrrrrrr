import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;

  // Test kullanıcısı
  final User _testUser = User(
    id: '1',
    username: 'test_user',
    email: 'test@example.com',
    phoneNumber: '+90 555 555 5555',
    profileImage: 'https://picsum.photos/200',
  );

  // Otomatik giriş yapma
  void autoLogin() {
    _currentUser = _testUser;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      // Test kullanıcısı kontrolü
      if (email == _testUser.email && password == 'test123') {
        _currentUser = _testUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String phoneNumber) async {
    try {
      // Gerçek uygulamada burada API çağrısı yapılacak
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        email: email,
        phoneNumber: phoneNumber,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
} 