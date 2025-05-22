import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

class SocialAuthService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Google ile giriş
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // TODO: Backend entegrasyonu için token'ları kullan
      // googleAuth.accessToken
      // googleAuth.idToken

      return User(
        id: googleUser.id,
        username: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        phoneNumber: '',
        profileImage: googleUser.photoUrl,
      );
    } catch (e) {
      print('Google sign in error: $e');
      return null;
    }
  }

  // Facebook ile giriş
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return null;

      final userData = await FacebookAuth.instance.getUserData();
      
      return User(
        id: userData['id'],
        username: userData['name'] ?? 'Facebook User',
        email: userData['email'] ?? '',
        phoneNumber: '',
        profileImage: userData['picture']?['data']?['url'],
      );
    } catch (e) {
      print('Facebook sign in error: $e');
      return null;
    }
  }

  // Apple ile giriş
  Future<User?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      // Apple'dan gelen bilgiler sınırlı olabilir
      return User(
        id: credential.userIdentifier ?? DateTime.now().toString(),
        username: '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim(),
        email: credential.email ?? '',
        phoneNumber: '',
        profileImage: null,
      );
    } catch (e) {
      print('Apple sign in error: $e');
      return null;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
    } catch (e) {
      print('Sign out error: $e');
    }
  }
} 