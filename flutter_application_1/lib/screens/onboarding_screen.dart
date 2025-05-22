import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/storage_helper.dart';
import 'main_app_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  // Onboarding data for each page
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'TAKAS ZAMANI!',
      'description': 'Kullanmadığınız eşyaları takas edin, yeni şeyler keşfedin. Artık ihtiyacınız olmayan ürünlere başkalarının ihtiyacı olabilir.',
      'image': 'assets/images/onboarding_swap.png',
      'color': const Color(0xFFFFA726),
    },
    {
      'title': 'MESAJLAŞIN & ANLAŞIN',
      'description': 'Satıcılar ile doğrudan mesajlaşarak takas koşullarını konuşun ve anlaşmaya varın.',
      'image': 'assets/images/onboarding_chat.png', 
      'color': const Color(0xFF66BB6A),
    },
    {
      'title': 'GÜVENLİ BULUŞMA',
      'description': 'Güvenli buluşma noktaları belirleyin ve takasınızı tamamlayın. Derecelendirme yaparak topluluk güvenliğine katkıda bulunun.',
      'image': 'assets/images/onboarding_secure.png',
      'color': const Color(0xFF42A5F5),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Check if it's the last page
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _isLastPage = index == _onboardingData.length - 1;
    });
  }

  // Mark onboarding as completed using StorageHelper
  Future<void> _completeOnboarding() async {
    await StorageHelper.setBool('onboarding_completed', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'ATLA',
                      style: TextStyle(
                        color: _onboardingData[_currentPage]['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              // PageView for onboarding content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return _buildOnboardingPage(
                      title: data['title'],
                      description: data['description'],
                      image: data['image'],
                      color: data['color'],
                    );
                  },
                ),
              ),
              
              // Bottom navigation and indicators
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _onboardingData.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: _onboardingData[_currentPage]['color'],
                        dotColor: Colors.grey.shade300,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button (hidden on first page)
                        _currentPage == 0
                            ? const SizedBox(width: 80) // Empty space on first page
                            : TextButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  'GERİ',
                                  style: TextStyle(
                                    color: _onboardingData[_currentPage]['color'],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        
                        // Next/Start button
                        ElevatedButton(
                          onPressed: () {
                            if (_isLastPage) {
                              _completeOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _onboardingData[_currentPage]['color'],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isLastPage ? 'BAŞLA' : 'İLERİ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build individual onboarding page
  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String image,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image container - takes up upper half of the screen
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Image.asset(
                  image,
                  height: 280,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForPage(title),
                        size: 100,
                        color: color,
                      ),
                    ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Text content - takes up lower half
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage(String title) {
    switch (title) {
      case 'TAKAS ZAMANI!':
        return Icons.swap_horiz;
      case 'MESAJLAŞIN & ANLAŞIN':
        return Icons.chat;
      case 'GÜVENLİ BULUŞMA':
        return Icons.security;
      default:
        return Icons.help;
    }
  }
} 