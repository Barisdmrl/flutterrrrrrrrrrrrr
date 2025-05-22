import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/social_auth_service.dart';
import '../services/localization_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizationService = context.watch<LocalizationService>();
    final socialAuthService = context.read<SocialAuthService>();
    final authService = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.getString('login')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen e-posta adresinizi girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şifrenizi girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        final success = await authService.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        setState(() => _isLoading = false);
                        
                        if (success) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Giriş başarısız')),
                          );
                        }
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(localizationService.getString('login')),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              localizationService.getString('social_login'),
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Google ile giriş
                ElevatedButton.icon(
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                    height: 24,
                  ),
                  label: Text('Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    final user = await socialAuthService.signInWithGoogle();
                    if (user != null) {
                      Navigator.pop(context);
                    }
                  },
                ),
                // Facebook ile giriş
                ElevatedButton.icon(
                  icon: Icon(Icons.facebook, color: Colors.white),
                  label: Text('Facebook'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1877F2),
                  ),
                  onPressed: () async {
                    final user = await socialAuthService.signInWithFacebook();
                    if (user != null) {
                      Navigator.pop(context);
                    }
                  },
                ),
                // Apple ile giriş (sadece iOS'ta göster)
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  ElevatedButton.icon(
                    icon: Icon(Icons.apple),
                    label: Text('Apple'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      final user = await socialAuthService.signInWithApple();
                      if (user != null) {
                        Navigator.pop(context);
                      }
                    },
                  ),
              ],
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Hesabınız yok mu? Üye Olun'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 