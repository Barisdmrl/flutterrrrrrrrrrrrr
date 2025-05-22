import 'package:flutter/material.dart';
import 'verify_screen.dart';

class VerificationMethodScreen extends StatefulWidget {
  final String email;
  
  const VerificationMethodScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerificationMethodScreen> createState() => _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  String _selectedMethod = 'email'; // Varsayılan doğrulama yöntemi: e-posta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Doğrulama Yöntemi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Başlık
            const Text(
              'Doğrulama Yöntemi Seçin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hesabınızı doğrulamak için bir yöntem seçin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            
            // E-posta ile doğrulama seçeneği
            _buildVerificationOption(
              title: 'E-posta ile Doğrulama',
              description: 'Kayıt olurken girdiğiniz e-posta adresinize doğrulama kodu göndereceğiz.',
              icon: Icons.email_outlined,
              value: 'email',
            ),
            
            const SizedBox(height: 20),
            
            // Telefon ile doğrulama seçeneği
            _buildVerificationOption(
              title: 'Telefon ile Doğrulama',
              description: 'Telefon numaranıza SMS ile doğrulama kodu göndereceğiz.',
              icon: Icons.phone_android,
              value: 'phone',
            ),
            
            const Spacer(),
            
            // Devam et butonu
            ElevatedButton(
              onPressed: () {
                // Doğrulama ekranına git
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyScreen(
                      verificationMethod: _selectedMethod,
                      email: widget.email,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'DEVAM ET',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Doğrulama yöntemi seçim kartı
  Widget _buildVerificationOption({
    required String title,
    required String description,
    required IconData icon,
    required String value,
  }) {
    final bool isSelected = _selectedMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2) 
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedMethod,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMethod = newValue;
                  });
                }
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
} 