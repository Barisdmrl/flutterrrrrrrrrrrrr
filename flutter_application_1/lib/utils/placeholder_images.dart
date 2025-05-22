import 'package:flutter/material.dart';

class PlaceholderImages {
  /// Generates a placeholder widget for the first onboarding screen
  /// showing two people exchanging items
  static Widget onboarding1(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          
          // Two people exchanging items
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First person with item
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Person icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Item being offered
                  Transform.translate(
                    offset: const Offset(15, 0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Exchange arrows in the middle
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              
              // Second person with item
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Person icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Item being offered
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purple,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.headphones,
                        color: Colors.purple,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Generates a placeholder widget for the second onboarding screen
  /// showing app features
  static Widget onboarding2(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.security,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Generates a placeholder widget for the third onboarding screen
  /// showing community and swap experience
  static Widget onboarding3(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // People icons in a circle
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  _positionedAvatar(
                    context, 
                    Icons.person, 
                    Colors.blue, 
                    0, 
                    40
                  ),
                  _positionedAvatar(
                    context, 
                    Icons.person, 
                    Colors.green, 
                    60, 
                    0
                  ),
                  _positionedAvatar(
                    context, 
                    Icons.person, 
                    Colors.orange, 
                    120, 
                    40
                  ),
                  _positionedAvatar(
                    context, 
                    Icons.person, 
                    Colors.purple, 
                    90, 
                    90
                  ),
                  _positionedAvatar(
                    context, 
                    Icons.person, 
                    Colors.teal, 
                    30, 
                    90
                  ),
                  // Center swap icon
                  Positioned(
                    left: 50,
                    top: 50,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to position avatar icons
  static Widget _positionedAvatar(
    BuildContext context, 
    IconData icon, 
    Color color, 
    double left, 
    double top
  ) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 14,
        ),
      ),
    );
  }
}

/// Custom painter to draw circle patterns for background
class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw various sized circles
    for (int i = 0; i < 20; i++) {
      final radius = 10.0 + (i * 5.0);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 