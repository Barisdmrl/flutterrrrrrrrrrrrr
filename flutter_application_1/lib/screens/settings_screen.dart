import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import 'followers_screen.dart';
import 'following_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Ayar durumları
  bool _darkMode = false;
  bool _notifications = true;
  bool _locationServices = true;
  double _fontSize = 16.0;
  String _language = 'Türkçe';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Profilim ve Hesap Ayarları Başlığı
          _buildSectionHeader('Profil ve Hesap'),
          
          // Sosyal Etkileşimler
          _buildSocialInteractionSection(),
          
          // Hesap Bilgilerini Düzenle
          _buildListTile(
            icon: Icons.person,
            title: 'Hesap Bilgilerini Düzenle',
            subtitle: 'İsim, e-posta, şifre ve diğer hesap detayları',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hesap düzenleme sayfası açılıyor')),
              );
            },
          ),
          
          // Ödeme Yöntemleri
          _buildListTile(
            icon: Icons.credit_card,
            title: 'Ödeme Yöntemleri',
            subtitle: 'Kayıtlı kartlar ve diğer ödeme yöntemleri',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ödeme yöntemleri sayfası açılıyor')),
              );
            },
          ),
          
          // Adreslerim
          _buildListTile(
            icon: Icons.location_on,
            title: 'Adreslerim',
            subtitle: 'Kayıtlı adresler ve konum bilgileri',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adresler sayfası açılıyor')),
              );
            },
          ),
          
          // Uygulama Ayarları Başlığı
          _buildSectionHeader('Uygulama Ayarları'),
          
          // Karanlık Mod
          SwitchListTile(
            secondary: Icon(
              _darkMode ? Icons.dark_mode : Icons.light_mode, 
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Karanlık Mod',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _darkMode ? 'Açık' : 'Kapalı',
              style: TextStyle(color: Colors.grey[600]),
            ),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              
              // Tema değişikliğini ThemeProvider'a bildir
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.setDarkMode(value);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Karanlık mod ${value ? 'açıldı' : 'kapatıldı'}')),
              );
            },
          ),
          
          // Dil Seçimi
          _buildListTile(
            icon: Icons.language,
            title: 'Dil',
            subtitle: _language,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageSelectionDialog();
            },
          ),
          
          // Yazı Boyutu
          ListTile(
            leading: Icon(
              Icons.format_size, 
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Yazı Boyutu',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${_fontSize.toInt()}px',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: _fontSize,
                min: 12,
                max: 24,
                divisions: 6,
                label: '${_fontSize.toInt()}',
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
          ),
          
          // Bildirimler Başlığı
          _buildSectionHeader('Bildirimler'),
          
          // Bildirim Ayarları
          SwitchListTile(
            secondary: Icon(
              Icons.notifications, 
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Bildirimler',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _notifications ? 'Açık' : 'Kapalı',
              style: TextStyle(color: Colors.grey[600]),
            ),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
          
          // Konum Hizmetleri
          SwitchListTile(
            secondary: Icon(
              Icons.location_on, 
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Konum Hizmetleri',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _locationServices ? 'Açık' : 'Kapalı',
              style: TextStyle(color: Colors.grey[600]),
            ),
            value: _locationServices,
            onChanged: (value) {
              setState(() {
                _locationServices = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Konum hizmetleri ${value ? 'açıldı' : 'kapatıldı'}')),
              );
            },
          ),
          
          // Gizlilik ve Güvenlik Başlığı
          _buildSectionHeader('Gizlilik ve Güvenlik'),
          
          // Gizlilik Ayarları
          _buildListTile(
            icon: Icons.privacy_tip,
            title: 'Gizlilik Ayarları',
            subtitle: 'Veri paylaşımı ve gizlilik tercihleri',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gizlilik ayarları sayfası açılıyor')),
              );
            },
          ),
          
          // Güvenlik
          _buildListTile(
            icon: Icons.security,
            title: 'Güvenlik',
            subtitle: 'Şifre değiştirme ve iki faktörlü doğrulama',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Güvenlik ayarları sayfası açılıyor')),
              );
            },
          ),
          
          // Verileri Temizle
          _buildListTile(
            icon: Icons.delete_sweep,
            title: 'Verileri Temizle',
            subtitle: 'Önbelleği ve yerel verileri temizle',
            onTap: () {
              _showClearDataConfirmation();
            },
          ),
          
          // Hakkında Başlığı
          _buildSectionHeader('Hakkında'),
          
          // Uygulama Hakkında
          _buildListTile(
            icon: Icons.info,
            title: 'Uygulama Hakkında',
            subtitle: 'Sürüm bilgisi, lisanslar ve geliştiriciler',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uygulama hakkında sayfası açılıyor')),
              );
            },
          ),
          
          // Yardım ve Destek
          _buildListTile(
            icon: Icons.help,
            title: 'Yardım ve Destek',
            subtitle: 'Sık sorulan sorular ve müşteri desteği',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yardım ve destek sayfası açılıyor')),
              );
            },
          ),
          
          // Hesabımı Sil
          _buildListTile(
            icon: Icons.no_accounts,
            title: 'Hesabımı Sil',
            subtitle: 'Hesabınızı kalıcı olarak silin',
            iconColor: Colors.red,
            onTap: () {
              _showDeleteAccountConfirmation();
            },
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  // Bölüm başlığı
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // Özelleştirilmiş ListTile
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon, 
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      ) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  
  // Dil seçimi dialogu
  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dil Seçimi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('Türkçe'),
              _buildLanguageOption('English'),
              _buildLanguageOption('Deutsch'),
              _buildLanguageOption('Español'),
              _buildLanguageOption('Français'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İPTAL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('TAMAM'),
            ),
          ],
        );
      },
    );
  }
  
  // Dil seçim opsiyonu
  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _language,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _language = value;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dil $value olarak değiştirildi')),
          );
        }
      },
    );
  }
  
  // Sosyal etkileşimler bölümü
  Widget _buildSocialInteractionSection() {
    return Column(
      children: [
        // Takipçilerim
        _buildListTile(
          icon: Icons.people,
          title: 'Takipçilerim',
          subtitle: '128 takipçi',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FollowersScreen(
                  userId: 'current_user',
                  userName: 'Hesabım',
                ),
              ),
            );
          },
        ),
        
        // Takip Ettiklerim
        _buildListTile(
          icon: Icons.person_add,
          title: 'Takip Ettiklerim',
          subtitle: '75 kullanıcı',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FollowingScreen(
                  userId: 'current_user',
                  userName: 'Hesabım',
                ),
              ),
            );
          },
        ),
        
        // Engellenen Kullanıcılar
        _buildListTile(
          icon: Icons.block,
          title: 'Engellenen Kullanıcılar',
          subtitle: 'Engellediğiniz kullanıcıları yönetin',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Engellenen kullanıcılar listesi açılıyor')),
            );
          },
        ),
      ],
    );
  }
  
  // Veri temizleme onay dialogu
  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verileri Temizle'),
        content: const Text(
          'Bu işlem, uygulamanın önbelleğini ve yerel verilerini temizleyecektir. Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İPTAL'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veriler temizlendi')),
              );
            },
            child: const Text('TEMİZLE'),
          ),
        ],
      ),
    );
  }
  
  // Hesap silme onay dialogu
  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabımı Sil'),
        content: const Text(
          'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İPTAL'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hesap silme işlemi başlatıldı')),
              );
            },
            child: const Text('HESABIMI SİL'),
          ),
        ],
      ),
    );
  }
} 