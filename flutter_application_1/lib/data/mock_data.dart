import 'package:flutter/material.dart';

/// Bu sınıf, Firebase bağlantısı kurulana kadar
/// test amacıyla kullanılacak örnek verileri içerir.
class MockData {
  /// Kullanıcı verileri
  static final Map<String, dynamic> currentUser = {
    'id': 'user1',
    'name': 'Ahmet Yılmaz',
    'username': '@ahmetyilmaz',
    'email': 'ahmet.yilmaz@example.com',
    'phone': '+90 555 123 4567',
    'location': 'İstanbul, Türkiye',
    'bio': 'Teknoloji ve kitap tutkunuyum. Kullanmadığım eşyaları değerlendirmeyi seviyorum.',
    'avatarUrl': 'https://randomuser.me/api/portraits/men/75.jpg',
    'isVerified': true,
    'rating': 4.7,
    'reviewCount': 36,
    'memberSince': '2022-03-15',
    'completedSwaps': 24,
    'activeListings': 5,
    'favoriteCount': 12,
  };

  // Favori ürünlerin ID'lerini tutan liste
  static final List<String> _favoriteProductIds = [];
  
  /// Favori ürünleri döndürür
  static List<Map<String, dynamic>> get favoriteProducts {
    return products
        .where((product) => _favoriteProductIds.contains(product['id']))
        .toList();
  }
  
  /// Ürünün favori durumunu kontrol eder
  static bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }
  
  /// Ürünü favorilere ekler veya favorilerden çıkarır
  static void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
  }
  
  /// Tüm favorileri temizler
  static void clearFavorites() {
    _favoriteProductIds.clear();
  }

  /// Kullanıcı listesi
  static final List<Map<String, dynamic>> users = [
    currentUser,
    {
      'id': 'user2',
      'name': 'Zeynep Kaya',
      'username': '@zeynepkaya',
      'email': 'zeynep.kaya@example.com',
      'phone': '+90 555 987 6543',
      'location': 'Ankara, Türkiye',
      'bio': 'Sanat ve dekorasyon meraklısıyım. Evimi sürekli yenilemeyi seviyorum.',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/65.jpg',
      'isVerified': true,
      'rating': 4.9,
      'reviewCount': 42,
      'memberSince': '2021-11-20',
      'completedSwaps': 31,
      'activeListings': 3,
      'favoriteCount': 18,
    },
    {
      'id': 'user3',
      'name': 'Mehmet Demir',
      'username': '@mehmetdemir',
      'email': 'mehmet.demir@example.com',
      'phone': '+90 555 456 7890',
      'location': 'İzmir, Türkiye',
      'bio': 'Elektronik cihazlar ve gadgetler ile ilgileniyorum. Yeni teknolojileri keşfetmeyi seviyorum.',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
      'isVerified': false,
      'rating': 4.2,
      'reviewCount': 15,
      'memberSince': '2023-01-10',
      'completedSwaps': 7,
      'activeListings': 8,
      'favoriteCount': 5,
    },
    {
      'id': 'user4',
      'name': 'Ayşe Yıldız',
      'username': '@ayseyildiz',
      'email': 'ayse.yildiz@example.com',
      'phone': '+90 555 234 5678',
      'location': 'Bursa, Türkiye',
      'bio': 'Kitap kurdu ve koleksiyoner. Nadir bulunan kitapları takas etmeyi seviyorum.',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/42.jpg',
      'isVerified': true,
      'rating': 4.8,
      'reviewCount': 27,
      'memberSince': '2022-07-05',
      'completedSwaps': 19,
      'activeListings': 4,
      'favoriteCount': 15,
    },
  ];

  /// Ürün kategorileri
  static final List<Map<String, dynamic>> categories = [
    {
      'id': 'cat1',
      'name': 'Elektronik',
      'icon': Icons.devices,
      'color': Colors.blue,
    },
    {
      'id': 'cat2',
      'name': 'Giyim',
      'icon': Icons.shopping_bag,
      'color': Colors.orange,
    },
    {
      'id': 'cat3',
      'name': 'Kitaplar',
      'icon': Icons.book,
      'color': Colors.green,
    },
    {
      'id': 'cat4',
      'name': 'Ev Eşyaları',
      'icon': Icons.chair,
      'color': Colors.brown,
    },
    {
      'id': 'cat5',
      'name': 'Spor',
      'icon': Icons.sports_basketball,
      'color': Colors.red,
    },
    {
      'id': 'cat6',
      'name': 'Oyuncak',
      'icon': Icons.toys,
      'color': Colors.purple,
    },
    {
      'id': 'cat7',
      'name': 'Diğer',
      'icon': Icons.more_horiz,
      'color': Colors.grey,
    },
  ];

  /// Ürün listesi (Ana sayfada ve profil sayfasında kullanılır)
  static final List<Map<String, dynamic>> products = [
    {
      'id': 'prod1',
      'userId': 'user1',
      'title': 'Apple iPad Pro 2022',
      'description': 'Çok az kullanılmış iPad Pro. Kutusunda, tüm aksesuarları ile birlikte. Takas değeri 15.000 TL civarında başka bir elektronik ürün veya koleksiyon saati ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/96/500/500',
        'https://picsum.photos/id/7/500/500',
        'https://picsum.photos/id/20/500/500',
      ],
      'condition': 'Az Kullanılmış',
      'category': 'Elektronik',
      'categoryId': 'cat1',
      'swapValue': '15.000 TL',
      'location': 'İstanbul, Kadıköy',
      'postedDate': '2023-09-15',
      'viewCount': 248,
      'favoriteCount': 32,
      'isActive': true,
    },
    {
      'id': 'prod2',
      'userId': 'user1',
      'title': 'Vintage Deri Ceket',
      'description': 'Hakiki deri, vintage tarzı erkek ceketi. M beden, mükemmel durumda. Benzer kalitede bir kışlık mont veya deri çanta ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/846/500/500',
        'https://picsum.photos/id/513/500/500',
      ],
      'condition': 'İyi',
      'category': 'Giyim',
      'categoryId': 'cat2',
      'swapValue': '5.000 TL',
      'location': 'İstanbul, Kadıköy',
      'postedDate': '2023-10-05',
      'viewCount': 187,
      'favoriteCount': 24,
      'isActive': true,
    },
    {
      'id': 'prod3',
      'userId': 'user2',
      'title': 'Harry Potter Kitap Seti (7 Kitap)',
      'description': 'Tüm Harry Potter serisi, Türkçe çeviri, sert kapak, çok iyi durumda. Başka bir kitap serisi veya manga koleksiyonu ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/24/500/500',
        'https://picsum.photos/id/21/500/500',
      ],
      'condition': 'Çok İyi',
      'category': 'Kitaplar',
      'categoryId': 'cat3',
      'swapValue': '2.000 TL',
      'location': 'Ankara, Çankaya',
      'postedDate': '2023-10-20',
      'viewCount': 156,
      'favoriteCount': 42,
      'isActive': true,
    },
    {
      'id': 'prod4',
      'userId': 'user2',
      'title': 'Nintendo Switch Lite',
      'description': 'Nintendo Switch Lite, turkuaz renk. 2 oyun ile birlikte (Mario Kart 8 ve Animal Crossing). Farklı bir konsol veya tablet ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/96/500/500',
        'https://picsum.photos/id/111/500/500',
      ],
      'condition': 'Az Kullanılmış',
      'category': 'Elektronik',
      'categoryId': 'cat1',
      'swapValue': '8.000 TL',
      'location': 'Ankara, Çankaya',
      'postedDate': '2023-11-01',
      'viewCount': 134,
      'favoriteCount': 19,
      'isActive': true,
    },
    {
      'id': 'prod5',
      'userId': 'user3',
      'title': 'Profesyonel Kahve Makinesi',
      'description': 'Ev tipi profesyonel espresso makinesi. 2 yıllık, düzenli bakımı yapılmış. Kamera ekipmanı veya DJ ekipmanı ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/225/500/500',
        'https://picsum.photos/id/187/500/500',
      ],
      'condition': 'İyi',
      'category': 'Ev Eşyaları',
      'categoryId': 'cat4',
      'swapValue': '12.000 TL',
      'location': 'İzmir, Karşıyaka',
      'postedDate': '2023-11-15',
      'viewCount': 98,
      'favoriteCount': 15,
      'isActive': true,
    },
    {
      'id': 'prod6',
      'userId': 'user3',
      'title': 'Vintage Polaroid Fotoğraf Makinesi',
      'description': 'Çalışır durumda vintage Polaroid kamera. Koleksiyonerlık değeri var. Benzer değerde eski fotoğraf makineleri veya plak koleksiyonu ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/250/500/500',
      ],
      'condition': 'Vintage',
      'category': 'Elektronik',
      'categoryId': 'cat1',
      'swapValue': '3.500 TL',
      'location': 'İzmir, Karşıyaka',
      'postedDate': '2023-12-01',
      'viewCount': 87,
      'favoriteCount': 23,
      'isActive': true,
    },
    {
      'id': 'prod7',
      'userId': 'user4',
      'title': 'Nadir Basım Klasik Eserler (5 Kitap)',
      'description': 'Nadir basım klasik Türk ve Dünya edebiyatı eserleri. Özel ciltli, limitli seri. Diğer nadir kitaplar veya değerli plaklar ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/24/500/500',
        'https://picsum.photos/id/21/500/500',
      ],
      'condition': 'Çok İyi',
      'category': 'Kitaplar',
      'categoryId': 'cat3',
      'swapValue': '4.000 TL',
      'location': 'Bursa, Nilüfer',
      'postedDate': '2023-12-10',
      'viewCount': 65,
      'favoriteCount': 17,
      'isActive': true,
    },
    {
      'id': 'prod8',
      'userId': 'user4',
      'title': 'El Yapımı Seramik Seti',
      'description': 'El yapımı, sanatsal seramik kahve fincanları ve tabaklar seti. 6 kişilik. El yapımı diğer dekoratif ürünler ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/30/500/500',
      ],
      'condition': 'Yeni',
      'category': 'Ev Eşyaları',
      'categoryId': 'cat4',
      'swapValue': '2.500 TL',
      'location': 'Bursa, Nilüfer',
      'postedDate': '2023-12-15',
      'viewCount': 42,
      'favoriteCount': 8,
      'isActive': true,
    },
    {
      'id': 'prod9',
      'userId': 'user1',
      'title': 'Akustik Gitar (Fender)',
      'description': 'Fender CD-60 akustik gitar, çok iyi durumda. Kılıfı ve aksesuarları ile birlikte. Dijital piyano veya başka bir müzik aleti ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/145/500/500',
      ],
      'condition': 'İyi',
      'category': 'Diğer',
      'categoryId': 'cat7',
      'swapValue': '7.000 TL',
      'location': 'İstanbul, Beşiktaş',
      'postedDate': '2023-12-20',
      'viewCount': 54,
      'favoriteCount': 11,
      'isActive': true,
    },
    {
      'id': 'prod10',
      'userId': 'user1',
      'title': 'Profesyonel Drone (DJI Mini 2)',
      'description': 'DJI Mini 2 drone, eksiksiz set. Az kullanılmış, kutusu ve tüm aksesuarları mevcut. Fotoğraf makinesi veya kamera ekipmanı ile takas edilebilir.',
      'images': [
        'https://picsum.photos/id/29/500/500',
        'https://picsum.photos/id/96/500/500',
      ],
      'condition': 'Az Kullanılmış',
      'category': 'Elektronik',
      'categoryId': 'cat1',
      'swapValue': '11.000 TL',
      'location': 'İstanbul, Beşiktaş',
      'postedDate': '2023-12-25',
      'viewCount': 76,
      'favoriteCount': 14,
      'isActive': true,
    },
  ];

  /// Kullanıcı yorumları
  static final List<Map<String, dynamic>> reviews = [
    {
      'id': 'rev1',
      'userId': 'user2', // Yorumu yapan
      'targetUserId': 'user1', // Yorum yapılan
      'rating': 5,
      'comment': 'Çok güvenilir bir satıcı. Ürün tam açıklandığı gibiydi ve takas sürecinde hiçbir sorun yaşamadık.',
      'date': '2023-11-10',
      'productId': 'prod1',
    },
    {
      'id': 'rev2',
      'userId': 'user3',
      'targetUserId': 'user1',
      'rating': 4,
      'comment': 'İyi bir takas deneyimiydi. Ürün biraz geç gönderildi ama kalitesi iyiydi.',
      'date': '2023-10-20',
      'productId': 'prod2',
    },
    {
      'id': 'rev3',
      'userId': 'user4',
      'targetUserId': 'user1',
      'rating': 5,
      'comment': 'Muhteşem bir alışveriş deneyimi. Çok hızlı ve dürüst bir satıcı.',
      'date': '2023-12-05',
      'productId': 'prod9',
    },
    {
      'id': 'rev4',
      'userId': 'user1',
      'targetUserId': 'user2',
      'rating': 5,
      'comment': 'Kitaplar mükemmel durumdaydı. Çok nazik ve anlayışlı bir satıcı.',
      'date': '2023-10-25',
      'productId': 'prod3',
    },
    {
      'id': 'rev5',
      'userId': 'user1',
      'targetUserId': 'user3',
      'rating': 4,
      'comment': 'Fotoğraf makinesi açıklandığı gibiydi. Takas süreci sorunsuz geçti.',
      'date': '2023-12-10',
      'productId': 'prod6',
    },
  ];

  /// Tamamlanan takaslar
  static final List<Map<String, dynamic>> completedSwaps = [
    {
      'id': 'swap1',
      'date': '2023-11-15',
      'offeredProductId': 'prod1', // Sunulan ürün
      'offeredProductUserId': 'user1',
      'offeredProductTitle': 'Apple iPad Pro 2022',
      'offeredProductImage': 'https://picsum.photos/id/96/500/500',
      'receivedProductId': 'exch1', // Alınan ürün
      'receivedProductUserId': 'user2',
      'receivedProductTitle': 'Samsung Galaxy Tab S7',
      'receivedProductImage': 'https://picsum.photos/id/1/500/500',
      'swapType': 'Direkt Takas', // Direkt Takas veya Takas + Para
      'additionalAmount': 0, // Takas + Para durumunda ek miktar
      'status': 'Tamamlandı',
    },
    {
      'id': 'swap2',
      'date': '2023-10-25',
      'offeredProductId': 'prod2',
      'offeredProductUserId': 'user1',
      'offeredProductTitle': 'Vintage Deri Ceket',
      'offeredProductImage': 'https://picsum.photos/id/846/500/500',
      'receivedProductId': 'exch2',
      'receivedProductUserId': 'user3',
      'receivedProductTitle': 'Kış Montu Columbia',
      'receivedProductImage': 'https://picsum.photos/id/335/500/500',
      'swapType': 'Takas + Para',
      'additionalAmount': 1000,
      'status': 'Tamamlandı',
    },
    {
      'id': 'swap3',
      'date': '2023-12-10',
      'offeredProductId': 'prod9',
      'offeredProductUserId': 'user1',
      'offeredProductTitle': 'Akustik Gitar (Fender)',
      'offeredProductImage': 'https://picsum.photos/id/145/500/500',
      'receivedProductId': 'exch3',
      'receivedProductUserId': 'user4',
      'receivedProductTitle': 'Dijital Piyano Yamaha',
      'receivedProductImage': 'https://picsum.photos/id/89/500/500',
      'swapType': 'Direkt Takas',
      'additionalAmount': 0,
      'status': 'Tamamlandı',
    },
  ];

  /// Profil sayfası ayarlar menüsü
  static final List<Map<String, dynamic>> settingsMenu = [
    {
      'id': 'setting1',
      'title': 'Profil Bilgilerimi Düzenle',
      'icon': Icons.person,
      'route': '/edit-profile',
    },
    {
      'id': 'setting2',
      'title': 'Adres Bilgilerim',
      'icon': Icons.location_on,
      'route': '/addresses',
    },
    {
      'id': 'setting3',
      'title': 'Bildirim Ayarları',
      'icon': Icons.notifications,
      'route': '/notification-settings',
    },
    {
      'id': 'setting4',
      'title': 'Güvenlik',
      'icon': Icons.security,
      'route': '/security',
    },
    {
      'id': 'setting5',
      'title': 'Gizlilik Politikası',
      'icon': Icons.privacy_tip,
      'route': '/privacy-policy',
    },
    {
      'id': 'setting6',
      'title': 'Kullanım Koşulları',
      'icon': Icons.description,
      'route': '/terms',
    },
    {
      'id': 'setting7',
      'title': 'Yardım & Destek',
      'icon': Icons.help,
      'route': '/help',
    },
    {
      'id': 'setting8',
      'title': 'Çıkış Yap',
      'icon': Icons.logout,
      'route': '/logout',
      'isLogout': true,
    },
  ];

  /// Kullanıcı başarıları/rozetleri
  static final List<Map<String, dynamic>> achievements = [
    {
      'id': 'achievement1',
      'title': 'Hızlı Takas',
      'description': '24 saat içinde takas tamamlandı',
      'icon': Icons.speed,
      'isUnlocked': true,
    },
    {
      'id': 'achievement2',
      'title': '10+ Takas',
      'description': '10\'dan fazla takas tamamladınız',
      'icon': Icons.workspace_premium,
      'isUnlocked': true,
    },
    {
      'id': 'achievement3',
      'title': 'Süper Satıcı',
      'description': '5 yıldızlı 20+ değerlendirme',
      'icon': Icons.star,
      'isUnlocked': true,
    },
    {
      'id': 'achievement4',
      'title': 'Koleksiyoner',
      'description': 'Her kategoriden en az bir ürün takası',
      'icon': Icons.collections,
      'isUnlocked': false,
    },
  ];

  /// Mevcut kullanıcının aktif ürünlerini döndürür
  static List<Map<String, dynamic>> getCurrentUserActiveProducts() {
    return products.where((product) => 
      product['userId'] == currentUser['id'] && 
      product['isActive'] == true
    ).toList();
  }

  /// Mevcut kullanıcının tamamlanan takaslarını döndürür
  static List<Map<String, dynamic>> getCurrentUserCompletedSwaps() {
    return completedSwaps.where((swap) => 
      swap['offeredProductUserId'] == currentUser['id']
    ).toList();
  }

  /// Belirli bir kullanıcının yorumlarını döndürür
  static List<Map<String, dynamic>> getUserReviews(String userId) {
    return reviews.where((review) => 
      review['targetUserId'] == userId
    ).toList();
  }

  /// Belirli bir kategorideki ürünleri döndürür
  static List<Map<String, dynamic>> getProductsByCategory(String categoryId) {
    return products.where((product) => 
      product['categoryId'] == categoryId &&
      product['isActive'] == true
    ).toList();
  }

  /// Benzer ürünleri döndürür (aynı kategorideki diğer ürünler)
  static List<Map<String, dynamic>> getSimilarProducts(String productId) {
    final product = products.firstWhere((p) => p['id'] == productId);
    final categoryId = product['categoryId'];
    
    return products.where((p) => 
      p['id'] != productId && 
      p['categoryId'] == categoryId &&
      p['isActive'] == true
    ).toList();
  }

  /// Ürün değerlendirmeleri
  static final List<Map<String, dynamic>> productReviews = [
    {
      'id': 'prev1',
      'productId': 'prod1',
      'userId': 'user2',
      'userName': 'Zeynep Kaya',
      'userAvatar': 'https://randomuser.me/api/portraits/women/65.jpg',
      'rating': 4.5,
      'comment': 'Ürün gerçekten iyi durumda ve açıklandığı gibi geldi. Çok memnun kaldım.',
      'date': '2023-12-15',
    },
    {
      'id': 'prev2',
      'productId': 'prod1',
      'userId': 'user3',
      'userName': 'Mehmet Demir',
      'userAvatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      'rating': 5.0,
      'comment': 'Harika bir ürün! Takası çok sorunsuz gerçekleşti. Satıcı çok ilgiliydi.',
      'date': '2023-11-30',
    },
    {
      'id': 'prev3',
      'productId': 'prod2',
      'userId': 'user1',
      'userName': 'Ahmet Yılmaz',
      'userAvatar': 'https://randomuser.me/api/portraits/men/75.jpg',
      'rating': 4.0,
      'comment': 'Ürün iyi durumda, ama bekletildiğim için bir yıldız kırdım.',
      'date': '2024-01-05',
    },
    {
      'id': 'prev4',
      'productId': 'prod3',
      'userId': 'user4',
      'userName': 'Ayşe Yıldız',
      'userAvatar': 'https://randomuser.me/api/portraits/women/42.jpg',
      'rating': 3.5,
      'comment': 'Ürün açıklamadaki gibi değildi, biraz hayal kırıklığı yaşadım.',
      'date': '2023-12-20',
    },
    {
      'id': 'prev5',
      'productId': 'prod4',
      'userId': 'user5',
      'userName': 'Emre Can',
      'userAvatar': 'https://randomuser.me/api/portraits/men/22.jpg',
      'rating': 5.0,
      'comment': 'Mükemmel bir ürün ve çok hızlı teslimat. Satıcı çok ilgiliydi.',
      'date': '2024-01-10',
    },
  ];

  /// Satıcı değerlendirmeleri
  static final List<Map<String, dynamic>> sellerReviews = [
    {
      'id': 'srev1',
      'sellerId': 'user1',
      'userId': 'user2',
      'userName': 'Zeynep Kaya',
      'userAvatar': 'https://randomuser.me/api/portraits/women/65.jpg',
      'rating': 5.0,
      'comment': 'Ahmet Bey ile takas süreci çok sorunsuz geçti. İletişimi çok iyi ve ürünleri tam anlatıldığı gibi. Kesinlikle tekrar takas yaparım.',
      'date': '2023-11-22',
    },
    {
      'id': 'srev2',
      'sellerId': 'user1',
      'userId': 'user3',
      'userName': 'Mehmet Demir',
      'userAvatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      'rating': 4.0,
      'comment': 'İyi bir takas deneyimi, ürün tanımlandığı gibiydi. Sadece biraz geç cevap verdi mesajlara, onun dışında sorun yok.',
      'date': '2023-12-08',
    },
    {
      'id': 'srev3',
      'sellerId': 'user2',
      'userId': 'user1',
      'userName': 'Ahmet Yılmaz',
      'userAvatar': 'https://randomuser.me/api/portraits/men/75.jpg',
      'rating': 5.0,
      'comment': 'Zeynep Hanım harika bir satıcı. İletişimi çok açık ve dürüst. Ürünler tam anlatıldığı gibiydi.',
      'date': '2023-12-20',
    },
    {
      'id': 'srev4',
      'sellerId': 'user3',
      'userId': 'user4',
      'userName': 'Ayşe Yıldız',
      'userAvatar': 'https://randomuser.me/api/portraits/women/42.jpg',
      'rating': 3.5,
      'comment': 'Ürün iyi durumdaydı ama Mehmet Bey randevu saatine geç geldi. İletişim konusunda biraz daha dikkatli olabilir.',
      'date': '2024-01-10',
    },
    {
      'id': 'srev5',
      'sellerId': 'user4',
      'userId': 'user2',
      'userName': 'Zeynep Kaya',
      'userAvatar': 'https://randomuser.me/api/portraits/women/65.jpg',
      'rating': 5.0,
      'comment': 'Ayşe Hanım ile takas süreci mükemmeldi. Çok dürüst ve güvenilir bir satıcı. Kesinlikle tavsiye ederim.',
      'date': '2023-11-15',
    },
  ];

  /// Belirli bir ürüne ait değerlendirmeleri getirir
  static List<Map<String, dynamic>> getProductReviews(String productId) {
    return productReviews.where((review) => review['productId'] == productId).toList();
  }

  /// Belirli bir satıcıya ait değerlendirmeleri getirir
  static List<Map<String, dynamic>> getSellerReviews(String sellerId) {
    return sellerReviews.where((review) => review['sellerId'] == sellerId).toList();
  }

  /// Ürün için ortalama puanı hesaplar
  static double getProductAverageRating(String productId) {
    final reviews = getProductReviews(productId);
    if (reviews.isEmpty) return 0.0;
    
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review['rating'];
    }
    return totalRating / reviews.length;
  }

  /// Satıcı için ortalama puanı hesaplar
  static double getSellerAverageRating(String sellerId) {
    final reviews = getSellerReviews(sellerId);
    if (reviews.isEmpty) return 0.0;
    
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review['rating'];
    }
    return totalRating / reviews.length;
  }

  /// Mesajlaşma için sohbet odaları
  static List<Map<String, dynamic>> chatRooms = [
    {
      'id': 'chat1',
      'productId': 'prod1',
      'productTitle': 'iPhone 13 Pro Max',
      'productImage': 'https://picsum.photos/id/1/200/200',
      'sellerId': 'user1',
      'buyerId': 'user2',
      'lastMessage': 'Ürün hala mevcut mu?',
      'lastMessageTime': '2024-06-02T15:30:00',
      'unreadCount': 2,
      'isActive': true,
      'offerStatus': 'pending', // pending, accepted, rejected
    },
    {
      'id': 'chat2',
      'productId': 'prod2',
      'productTitle': 'Samsung Galaxy S21 Ultra',
      'productImage': 'https://picsum.photos/id/2/200/200',
      'sellerId': 'user2',
      'buyerId': 'user1',
      'lastMessage': 'Yarın saat 15:00\'da buluşalım mı?',
      'lastMessageTime': '2024-06-01T18:45:00',
      'unreadCount': 0,
      'isActive': true,
      'offerStatus': 'accepted',
    },
    {
      'id': 'chat3',
      'productId': 'prod3',
      'productTitle': 'MacBook Pro M1',
      'productImage': 'https://picsum.photos/id/3/200/200',
      'sellerId': 'user3',
      'buyerId': 'user1',
      'lastMessage': 'Teşekkürler, takas teklifinizi düşüneceğim.',
      'lastMessageTime': '2024-05-30T09:15:00',
      'unreadCount': 1,
      'isActive': true,
      'offerStatus': 'pending',
    },
    {
      'id': 'chat4',
      'productId': 'prod4',
      'productTitle': 'PlayStation 5',
      'productImage': 'https://picsum.photos/id/4/200/200',
      'sellerId': 'user1',
      'buyerId': 'user4',
      'lastMessage': 'Takas teklifinizi kabul ediyorum.',
      'lastMessageTime': '2024-05-25T14:20:00',
      'unreadCount': 0,
      'isActive': false,
      'offerStatus': 'rejected',
    },
  ];
  
  /// Sohbet mesajları
  static List<Map<String, dynamic>> messages = [
    // chat1 mesajları
    {
      'id': 'msg1',
      'chatId': 'chat1',
      'senderId': 'user2',
      'text': 'Merhaba, iPhone 13 Pro Max ürününüz hala mevcut mu?',
      'timestamp': '2024-06-02T15:25:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg2',
      'chatId': 'chat1',
      'senderId': 'user1',
      'text': 'Evet, ürün hala satışta. İlgilendiğiniz için teşekkürler.',
      'timestamp': '2024-06-02T15:27:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg3',
      'chatId': 'chat1',
      'senderId': 'user2',
      'text': 'Ürünün durumu nasıl? Herhangi bir çizik veya hasar var mı?',
      'timestamp': '2024-06-02T15:29:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg4',
      'chatId': 'chat1',
      'senderId': 'user2',
      'text': 'Ürün hala mevcut mu?',
      'timestamp': '2024-06-02T15:30:00',
      'isRead': false,
      'status': 'sent',
    },
    
    // chat2 mesajları
    {
      'id': 'msg5',
      'chatId': 'chat2',
      'senderId': 'user1',
      'text': 'Merhaba, Samsung Galaxy S21 Ultra için takas teklifinde bulunmak istiyorum. Elimde iPhone 12 var, ilgilenir misiniz?',
      'timestamp': '2024-06-01T10:15:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg6',
      'chatId': 'chat2',
      'senderId': 'user2',
      'text': 'Merhaba, evet ilgilenebilirim. iPhone 12\'nin durumu nasıl?',
      'timestamp': '2024-06-01T10:30:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg7',
      'chatId': 'chat2',
      'senderId': 'user1',
      'text': 'Gayet iyi durumda, 1 yıldır kullanıyorum. Kutusunda olan her şey mevcut. Size birkaç fotoğraf gönderebilirim.',
      'timestamp': '2024-06-01T10:45:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg8',
      'chatId': 'chat2',
      'senderId': 'user2',
      'text': 'Evet, fotoğrafları görürsem iyi olur. Eğer uygunsa ürünleri değerlendirebiliriz.',
      'timestamp': '2024-06-01T11:00:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg9',
      'chatId': 'chat2',
      'senderId': 'user1',
      'text': 'Fotoğrafları gönderdim. Ne düşünüyorsunuz?',
      'timestamp': '2024-06-01T11:15:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg10',
      'chatId': 'chat2',
      'senderId': 'user2',
      'text': 'Fotoğraflar iyi görünüyor. Takası kabul ediyorum. Ne zaman ve nerede buluşabiliriz?',
      'timestamp': '2024-06-01T11:30:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg11',
      'chatId': 'chat2',
      'senderId': 'user1',
      'text': 'Harika! Yarın müsait misiniz?',
      'timestamp': '2024-06-01T18:30:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg12',
      'chatId': 'chat2',
      'senderId': 'user2',
      'text': 'Yarın saat 15:00\'da buluşalım mı?',
      'timestamp': '2024-06-01T18:45:00',
      'isRead': true,
      'status': 'read',
    },
    
    // chat3 mesajları
    {
      'id': 'msg13',
      'chatId': 'chat3',
      'senderId': 'user1',
      'text': 'Merhaba, MacBook Pro M1 için bir takas teklifim var. iPad Pro 2021 ile takas etmeyi düşünür müsünüz?',
      'timestamp': '2024-05-30T09:00:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg14',
      'chatId': 'chat3',
      'senderId': 'user3',
      'text': 'Merhaba, teşekkürler takas teklifiniz için. iPad Pro\'nun özellikleri neler?',
      'timestamp': '2024-05-30T09:10:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg15',
      'chatId': 'chat3',
      'senderId': 'user1',
      'text': '12.9 inç, 256GB, WiFi+Cellular, Apple Pencil 2 ve Magic Keyboard ile birlikte.',
      'timestamp': '2024-05-30T09:12:00',
      'isRead': true,
      'status': 'read',
    },
    {
      'id': 'msg16',
      'chatId': 'chat3',
      'senderId': 'user3',
      'text': 'Teşekkürler, takas teklifinizi düşüneceğim.',
      'timestamp': '2024-05-30T09:15:00',
      'isRead': false,
      'status': 'sent',
    },
  ];
  
  /// Belirli bir sohbet odasının mesajlarını getirir
  static List<Map<String, dynamic>> getChatMessages(String chatId) {
    return messages
        .where((message) => message['chatId'] == chatId)
        .toList();
  }
  
  /// Belirli bir kullanıcının sohbet odalarını getirir
  static List<Map<String, dynamic>> getUserChatRooms(String userId) {
    return chatRooms
        .where((chatRoom) => chatRoom['sellerId'] == userId || chatRoom['buyerId'] == userId)
        .toList();
  }
  
  /// Okunmamış mesaj sayısını günceller
  static void markChatAsRead(String chatId, String userId) {
    final chatMessages = getChatMessages(chatId);
    for (var message in chatMessages) {
      if (message['senderId'] != userId && message['isRead'] == false) {
        message['isRead'] = true;
      }
    }
    
    // Sohbet odasının okunmamış mesaj sayısını güncelle
    final chatRoom = chatRooms.firstWhere((room) => room['id'] == chatId);
    if (chatRoom['sellerId'] == userId || chatRoom['buyerId'] == userId) {
      chatRoom['unreadCount'] = 0;
    }
  }
  
  /// Yeni mesaj ekler
  static String addMessage(String chatId, String senderId, String text) {
    final messageId = 'msg${messages.length + 1}';
    final newMessage = {
      'id': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
      'status': 'sent',
    };
    
    messages.add(newMessage);
    
    // Sohbet odasının son mesajını güncelle
    final chatRoom = chatRooms.firstWhere((room) => room['id'] == chatId);
    chatRoom['lastMessage'] = text;
    chatRoom['lastMessageTime'] = newMessage['timestamp'];
    
    // Karşı taraf için okunmamış mesaj sayısını artır
    final receiverId = senderId == chatRoom['sellerId'] 
        ? chatRoom['buyerId'] 
        : chatRoom['sellerId'];
    chatRoom['unreadCount'] = (chatRoom['unreadCount'] as int) + 1;
    
    return messageId;
  }
  
  /// Mesaj durumunu günceller
  static void updateMessageStatus(String messageId, String status) {
    final message = messages.firstWhere((msg) => msg['id'] == messageId);
    message['status'] = status;
  }
  
  /// Takas teklifinin durumunu günceller
  static void updateOfferStatus(String chatId, String status) {
    final chatRoom = chatRooms.firstWhere((room) => room['id'] == chatId);
    chatRoom['offerStatus'] = status;
  }
  
  /// Yeni sohbet odası oluşturur
  static String createChatRoom(String productId, String buyerId) {
    final product = products.firstWhere((p) => p['id'] == productId);
    final sellerId = product['userId'];
    
    // Aynı alıcı-satıcı-ürün kombinasyonu için önceden oluşturulmuş sohbet var mı kontrol et
    final existingChat = chatRooms.firstWhere(
      (chat) => 
          chat['productId'] == productId && 
          chat['sellerId'] == sellerId && 
          chat['buyerId'] == buyerId,
      orElse: () => {},
    );
    
    if (existingChat.isNotEmpty) {
      return existingChat['id'];
    }
    
    // Yeni sohbet odası oluştur
    final chatId = 'chat${chatRooms.length + 1}';
    final newChatRoom = {
      'id': chatId,
      'productId': productId,
      'productTitle': product['title'],
      'productImage': product['images'][0],
      'sellerId': sellerId,
      'buyerId': buyerId,
      'lastMessage': 'Henüz mesaj yok',
      'lastMessageTime': DateTime.now().toIso8601String(),
      'unreadCount': 0,
      'isActive': true,
      'offerStatus': 'pending',
    };
    
    chatRooms.add(newChatRoom);
    return chatId;
  }
} 