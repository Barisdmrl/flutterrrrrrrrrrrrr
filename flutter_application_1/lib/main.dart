import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_app_screen.dart';
import 'utils/theme_provider.dart';
import 'utils/storage_helper.dart';

void main() async {
  // Önce Flutter engine'i başlat (plugins kullanmadan önce)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Storage Helper'ı başlat
  await StorageHelper.initialize();
  
  // Firebase'i başlatma kısmını geçici olarak yorum satırına al (test için)
  // Gerçek uygulamada bu kısım açılacak
  /*
  try {
    await Firebase.initializeApp(
      // Firebase yapılandırma dosyanız yoksa, options parametresini kaldırın
      // options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Firebase başlatılamaması uygulamanın çalışmasını engellemeyecek
  }
  */
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// Gradient tema için özel bir widget
class GradientTheme extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  
  const GradientTheme({super.key, required this.child, required this.isDarkMode});
  
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: isDarkMode
        //       ? [
        //           const Color(0xFF1A1A1A),  // Koyu gri
        //           const Color(0xFF303030),  // Daha koyu gri
        //         ]
        //       : [
        //           const Color.fromARGB(255, 202, 255, 9),  // Orange
        //           const Color.fromARGB(255, 253, 0, 0),  // Blue
        //         ],
        // ),
      ),
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema sağlayıcısından karanlık mod durumunu al
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return GradientTheme(
      isDarkMode: themeProvider.isDarkMode,
      child: MaterialApp(
        title: 'SWAP',
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        home: const OnboardingChecker(),
        // Türkçe dil desteği için gerekli delegeler
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'), // Türkçe
          Locale('en', 'US'), // İngilizce
        ],
        locale: const Locale('tr', 'TR'), // Varsayılan olarak Türkçe
      ),
    );
  }
  
  // Açık tema tanımı
  ThemeData _buildLightTheme() {
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
      textTheme: GoogleFonts.poppinsTextTheme(),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,  
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,  
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
  
  // Karanlık tema tanımı
  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF81C784),      // Açık yeşil - koyu tema için
        primaryContainer: const Color(0xFF2E7D32), // Koyu yeşil container
        secondary: const Color(0xFFA5D6A7),    // Açık yeşil
        secondaryContainer: const Color(0xFF1B5E20), // Daha koyu yeşil container  
        tertiary: const Color(0xFF4CAF50),     // Orta yeşil
        tertiaryContainer: const Color(0xFF388E3C), // Koyu açık yeşil container
        surface: Colors.white,      // Koyu gri yüzey
        background: Colors.white,        // Arka plan white
        error: const Color(0xFFEF9A9A),        // Daha açık kırmızı
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF388E3C),
          foregroundColor: Colors.white,
        ),
      ),
      cardColor: const Color(0xFF424242),      // Kart rengi
      dialogBackgroundColor: const Color(0xFF303030), // Dialog arka plan rengi
    );
  }
}

// Onboarding'in tamamlanıp tamamlanmadığını kontrol eden widget
class OnboardingChecker extends StatefulWidget {
  const OnboardingChecker({super.key});

  @override
  State<OnboardingChecker> createState() => _OnboardingCheckerState();
}

class _OnboardingCheckerState extends State<OnboardingChecker> {
  bool _isLoading = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  // Onboarding durumunu kontrol et
  Future<void> _checkOnboardingStatus() async {
    try {
      // StorageHelper kullanarak onboarding durumunu kontrol et
      final bool onboardingCompleted = await StorageHelper.getBool('onboarding_completed', defaultValue: false);
      
      if (mounted) {
        setState(() {
          _showOnboarding = !onboardingCompleted;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Onboarding status check error: $e');
      // Hata durumunda varsayılan olarak onboarding'i göster
      if (mounted) {
        setState(() {
          _showOnboarding = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showOnboarding) {
      return const OnboardingScreen();
    } else {
      return const MainAppScreen();
    }
  }
}

// Plugin hatası durumunda gösterilecek ekran
class PluginErrorScreen extends StatelessWidget {
  const PluginErrorScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Uygulama başlatılamadı',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gerekli bileşenler yüklenemedi. Lütfen uygulamayı yeniden başlatın veya güncelleyin.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Uygulamayı yeniden başlatma girişimi
                  WidgetsFlutterBinding.ensureInitialized();
                  main();
                },
                child: const Text('Yeniden Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
