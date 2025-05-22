import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_app_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String verificationMethod;
  final String email;
  final String? phone;
  
  const VerifyScreen({
    Key? key,
    required this.verificationMethod,
    required this.email,
    this.phone,
  }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6, 
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6, 
    (index) => FocusNode(),
  );
  bool _isLoading = false;
  int _timerValue = 60; // Saniye cinsinden sayaç
  bool _isTimerActive = true;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  // Sayaç başlat
  void _startTimer() {
    setState(() {
      _timerValue = 60;
      _isTimerActive = true;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isTimerActive) {
        setState(() {
          _timerValue -= 1;
        });
        
        if (_timerValue > 0) {
          _startTimer();
        } else {
          setState(() {
            _isTimerActive = false;
          });
        }
      }
    });
  }
  
  // Doğrulama kodunu gönder
  void _resendCode() {
    setState(() {
      // Kodları temizle
      for (final controller in _codeControllers) {
        controller.clear();
      }
      // İlk input alanına odaklan
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
    
    // Yeni kod gönderildi mesajı
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yeni doğrulama kodu gönderildi'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Sayacı yeniden başlat
    _startTimer();
  }
  
  // Doğrulama işlemini gerçekleştir
  Future<void> _verifyCode() async {
    String code = '';
    for (final controller in _codeControllers) {
      code += controller.text;
    }
    
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen 6 haneli doğrulama kodunu girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Burada gerçek doğrulama işlemi yapılacak
      // Simülasyon için kısa bir gecikme ekleyelim
      await Future.delayed(const Duration(seconds: 2));
      
      // Başarılı doğrulama
      if (mounted) {
        // Başarılı mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hesabınız başarıyla doğrulandı'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Ana ekrana yönlendir
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainAppScreen()),
          (route) => false, // Tüm sayfaları temizle
        );
      }
    } catch (e) {
      // Hata durumunda
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doğrulama hatası: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String contactInfo = widget.verificationMethod == 'email' 
        ? widget.email 
        : widget.phone ?? '';
    
    final String verificationTitle = widget.verificationMethod == 'email'
        ? 'E-posta Doğrulama'
        : 'Telefon Doğrulama';
    
    final String verificationDescription = widget.verificationMethod == 'email'
        ? 'E-postanıza gönderdirdiğimiz 6 haneli doğrulama kodunu girin'
        : 'Telefonunuza gönderdirdiğimiz 6 haneli doğrulama kodunu girin';
        
    final IconData verificationIcon = widget.verificationMethod == 'email'
        ? Icons.email_outlined
        : Icons.phone_android;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          verificationTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            
            // İkon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  verificationIcon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Başlık
            const Text(
              'Doğrulama Kodu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Açıklama
            Text(
              verificationDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // İletişim bilgisi
            Text(
              'Gönderildiği adres: $contactInfo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Doğrulama kodu giriş alanı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  height: 50,
                  child: TextField(
                    controller: _codeControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      // Bir sonraki alana otomatik geç
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      }
                      // Son alana gelindiğinde klavyeyi kapat
                      if (value.isNotEmpty && index == 5) {
                        FocusScope.of(context).unfocus();
                      }
                      // Bir önceki alana otomatik dön
                      if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Doğrula butonu
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'DOĞRULA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            
            const SizedBox(height: 24),
            
            // Yeniden gönder
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kod almadınız mı?',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                _isTimerActive
                    ? Text(
                        '$_timerValue sn sonra tekrar gönder',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : TextButton(
                        onPressed: _resendCode,
                        child: Text(
                          'Tekrar Gönder',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 