import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'settings_screen.dart';
import 'auth_screen.dart';
import '../data/mock_data.dart';
import 'followers_screen.dart';
import 'following_screen.dart';
import 'reviews_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // Opsiyonel kullanıcı ID parametresi
  const ProfileScreen({super.key, this.userId}); // Constructor parametresini ekledim

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = true;
  bool _isVerified = true;
  late TabController _tabController;
  final ValueNotifier<bool> _isAvatarLoading = ValueNotifier<bool>(false);
  bool _isOwnProfile = true; // Kendi profili mi kontrol etmek için

  // Örnek kullanıcı verileri (normalde API'den veya Firebase'den gelir)
  final Map<String, dynamic> _userData = {
    'name': 'Ahmet Yılmaz',
    'username': '@ahmetyilmaz',
    'avatar': 'https://i.pravatar.cc/300?img=7',
    'rating': 4.8,
    'reviewCount': 24,
    'completedSwaps': 15,
    'location': 'İstanbul, Kadıköy',
    'about': 'Elektronik ve kitap meraklısıyım. Koleksiyonumdaki fazla eşyaları takas etmeyi seviyorum.',
    'memberSince': '2023',
    'isVerified': true,
    'followers': 128,
    'following': 75,
  };

  // Örnek aktif ilanlar (normalde API'den gelir)
  final List<Map<String, dynamic>> _activeListings = List.generate(
    8,
    (index) => {
      'id': index + 1,
      'title': 'Ürün ${index + 1}',
      'imageUrl': 'https://picsum.photos/id/${60 + index}/300/300',
      'price': '${(index + 1) * 100} TL değerinde',
      'likeCount': (index * 3) + 5,
      'viewCount': (index * 10) + 20,
    },
  );

  // Örnek tamamlanmış takaslar (normalde API'den gelir)
  final List<Map<String, dynamic>> _completedSwaps = List.generate(
    5,
    (index) => {
      'id': index + 1,
      'title': 'Takas ${index + 1}',
      'imageUrl': 'https://picsum.photos/id/${70 + index}/300/300',
      'otherUser': 'Kullanıcı ${index + 1}',
      'date': '${index + 1} Mayıs 2023',
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Veri yükleme simülasyonu
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isAvatarLoading.dispose();
    super.dispose();
  }

  // Belirtilen ID'ye sahip kullanıcının verilerini yükle
  void _loadUserData(String userId) {
    // Gerçek uygulamada burada API çağrısı yapılır
    // Bu örnek için demo veriler kullanıyoruz
    setState(() {
      _userData['name'] = 'Zeynep Kaya'; // Örnek bir isim
      _userData['username'] = '@zeynepkaya';
      _userData['avatar'] = 'https://i.pravatar.cc/300?img=5'; // Farklı bir avatar
      _userData['rating'] = 4.9;
      _userData['reviewCount'] = 32;
      _userData['completedSwaps'] = 18;
      _userData['location'] = 'İzmir, Bornova';
      _userData['about'] = 'Kitap ve müzik tutkunu. Koleksiyonumda fazlalık olan eşyaları takas etmeyi seviyorum.';
      _userData['memberSince'] = '2022';
      _userData['isVerified'] = true;
      _userData['followers'] = 145;
      _userData['following'] = 82;
    });
  }

  // Resim seçme işlevi
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      
      // Firebase'e yükleme simülasyonu
      _uploadImageToFirebase(File(image.path));
    }
  }

  // Firebase'e resim yükleme işlevi (örnek)
  Future<void> _uploadImageToFirebase(File imageFile) async {
    _isAvatarLoading.value = true;
    
    try {
      // Not: Firebase henüz tam olarak kurulmadığından, bu bir simülasyondur
      // Gerçek uygulamada bu bölüm şu şekilde olacaktır:
      /*
      final storageRef = FirebaseStorage.instance.ref();
      final profilePicRef = storageRef.child('profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await profilePicRef.putFile(imageFile);
      final downloadUrl = await profilePicRef.getDownloadURL();
      
      // Kullanıcı veritabanında avatar URL'sini güncelleme
      // örn: await FirebaseFirestore.instance.collection('users').doc(userId).update({'avatar': downloadUrl});
      */
      
      // Simülasyon için 2 saniye bekleme
      await Future.delayed(const Duration(seconds: 2));
      
      // Başarı mesajı
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil fotoğrafı başarıyla güncellendi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yükleme hatası: $e')),
        );
      }
    } finally {
      _isAvatarLoading.value = false;
    }
  }

  // Çıkış onay dialogu
  Future<void> _showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text(
            'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İPTAL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('ÇIKIŞ YAP'),
              onPressed: () {
                Navigator.of(context).pop();
                // Çıkış işlemi ve auth ekranına yönlendirme
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Çıkış yapıldı')),
                );
                // Giriş/Kayıt ekranına yönlendir
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profilim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          // Ayarlar butonu
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          // Çıkış butonu
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildProfileContent(),
    );
  }

  // Yükleniyor durumu için shimmer efekti
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar ve isim shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // İstatistikler shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // TabBar shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 40,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Grid shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Profil içeriği
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil üst kısmı - Avatar, isim, derecelendirme vb.
          _buildProfileHeader(),
          
          // Takip ve Takipçi Bar'ı
          _buildFollowStatsBar(),
          
          // İstatistikler kartı
          _buildStatisticsCard(),
          
          // Hakkında metni
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Hakkında',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _userData['about'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tab Bar - Aktif İlanlar ve Tamamlanmış Takaslar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Aktif İlanlarım'),
                Tab(text: 'Tamamlanmış Takaslar'),
              ],
            ),
          ),
          
          // Tab Bar View
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // Ekran yüksekliğine göre ayarla
            child: TabBarView(
              controller: _tabController,
              children: [
                // Aktif İlanlar Grid
                _buildActiveListingsGrid(),
                
                // Tamamlanmış Takaslar Listesi
                _buildCompletedSwapsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profil üst kısmı
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar bölümü
          Stack(
            children: [
              // Avatar resmi
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isAvatarLoading,
                      builder: (context, isLoading, child) {
                        if (isLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          );
                        } else if (_selectedImage != null) {
                          return Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return CachedNetworkImage(
                            imageUrl: _userData['avatar'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              
              // Avatar yükleme butonu
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 20),
          
          // İsim, kullanıcı adı, konum ve derecelendirme
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // İsim
                    Text(
                      _userData['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Doğrulanmış rozeti
                    if (_userData['isVerified'])
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Tooltip(
                          message: 'Doğrulanmış Profil',
                          child: Icon(
                            Icons.verified,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Kullanıcı adı
                Text(
                  _userData['username'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Konum
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _userData['location'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Derecelendirme yıldızları ve sayısı
                GestureDetector(
                  onTap: () {
                    // Değerlendirmeler ekranını göster
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsScreen(
                          productId: 'profile', // Önemli değil, sadece profil için
                          sellerId: _userData['id'] ?? 'user1', // Mock id olarak kullanıcı1'i kullan
                          isUserProfile: true, // Profil sayfasından açıldı
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < _userData['rating'].floor()
                              ? Icons.star
                              : (index < _userData['rating'] ? Icons.star_half : Icons.star_border),
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${_userData['rating']} (${_userData['reviewCount']} değerlendirme)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Üyelik tarihi
                Text(
                  '${_userData['memberSince']} yılından beri üye',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Takip ve Takipçi Bar'ı
  Widget _buildFollowStatsBar() {
    // Null değerleri önlemek için kontroller
    int followersCount = 0;
    int followingCount = 0;
    
    if (_userData != null) {
      if (_userData.containsKey('followers') && _userData['followers'] != null) {
        followersCount = _userData['followers'] is int 
            ? _userData['followers'] 
            : int.tryParse(_userData['followers'].toString()) ?? 0;
      }
      
      if (_userData.containsKey('following') && _userData['following'] != null) {
        followingCount = _userData['following'] is int 
            ? _userData['following'] 
            : int.tryParse(_userData['following'].toString()) ?? 0;
      }
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Takipçi sayısı
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Takipçiler listesi gösterme modalı
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowersScreen(
                        userId: 'current_user', // Sabit bir değer kullanıyoruz
                        userName: _userData?['name'] ?? 'Hesabım',
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildStatisticItem(
                    icon: Icons.people,
                    value: followersCount.toString(),
                    label: 'Takipçi',
                    iconColor: Colors.purple[400],
                  ),
                ),
              ),
            ),
          ),
          
          // Dikey ayırıcı
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          
          // Takip sayısı
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Takip edilen kişiler listesi gösterme modalı
                  if (_userData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowingScreen(
                          userId: 'current_user', // Sabit bir değer kullanıyoruz
                          userName: _userData['name'] ?? 'Hesabım',
                        ),
                      ),
                    );
                  } else {
                    // Veri yoksa kullanıcıya bilgi ver
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kullanıcı bilgileri yüklenemedi'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildStatisticItem(
                    icon: Icons.person_add_outlined,
                    value: followingCount.toString(),
                    label: 'Takip',
                    iconColor: Colors.blue[400],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // İstatistikler kartı
  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Aktif İlanlar
          _buildStatisticItem(
            icon: Icons.list_alt,
            value: _activeListings.length.toString(),
            label: 'Aktif İlan',
          ),
          
          // Dikey ayırıcı
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          
          // Tamamlanmış Takaslar
          _buildStatisticItem(
            icon: Icons.swap_horiz,
            value: _userData['completedSwaps'].toString(),
            label: 'Takas',
          ),
          
          // Dikey ayırıcı
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          
          // Derecelendirme
          _buildStatisticItem(
            icon: Icons.star,
            value: _userData['rating'].toString(),
            label: 'Derece',
            iconColor: Colors.amber,
          ),
        ],
      ),
    );
  }

  // İstatistik öğesi
  Widget _buildStatisticItem({
    required IconData icon,
    required String value,
    required String label,
    Color? iconColor,
  }) {
    // Değer null veya "null" ise varsayılan değerler göster
    String displayValue = value;
    if (value == "null" || value.toLowerCase() == "null") {
      if (label == "Takipçi") {
        displayValue = "128";
      } else if (label == "Takip") {
        displayValue = "75";
      } else {
        displayValue = "0";
      }
    }
    
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          displayValue,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Ürün grid öğesi
  Widget _buildProductGridItem(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün resmi
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: product['imageUrl'],
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
                
                // Düzenleme butonu
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Ürün bilgileri
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Text(
                    product['price'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // İstatistikler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product['viewCount'].toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product['likeCount'].toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Aktif İlanlar Grid
  Widget _buildActiveListingsGrid() {
    if (_activeListings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Henüz aktif ilanınız bulunmamaktadır.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _activeListings.length,
      itemBuilder: (context, index) {
        final listing = _activeListings[index];
        return _buildProductGridItem(listing);
      },
    );
  }

  // Tamamlanmış Takaslar Listesi
  Widget _buildCompletedSwapsList() {
    if (_completedSwaps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Henüz tamamlanmış takas işleminiz bulunmamaktadır.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _completedSwaps.length,
      itemBuilder: (context, index) {
        final swap = _completedSwaps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Swap resmi
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: swap['imageUrl'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Swap bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        swap['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            swap['otherUser'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            swap['date'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Başarılı işaret
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 