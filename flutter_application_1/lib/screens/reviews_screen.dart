import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/mock_data.dart';

class ReviewsScreen extends StatefulWidget {
  final String productId;
  final String sellerId;
  final bool isUserProfile;  // Profil sayfasından açılıp açılmadığını kontrol etmek için
  
  const ReviewsScreen({
    Key? key, 
    required this.productId, 
    required this.sellerId,
    this.isUserProfile = false,  // Varsayılan olarak ürün detay sayfasından açılacak
  }) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _productReviewsCount = 0;
  int _sellerReviewsCount = 0;
  double _productRating = 0.0;
  double _sellerRating = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    // Profil sayfasından açıldıysa sadece satıcı değerlendirmeleri gösterilecek
    _tabController = TabController(
      length: widget.isUserProfile ? 1 : 2, 
      vsync: this,
      initialIndex: widget.isUserProfile ? 0 : 0,
    );
    
    // Değerlendirme sayılarını ve ortalamalarını hesapla
    if (!widget.isUserProfile) {
      final productReviews = MockData.getProductReviews(widget.productId);
      _productReviewsCount = productReviews.length;
      _productRating = MockData.getProductAverageRating(widget.productId);
    }
    
    final sellerReviews = MockData.getSellerReviews(widget.sellerId);
    _sellerReviewsCount = sellerReviews.length;
    _sellerRating = MockData.getSellerAverageRating(widget.sellerId);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.isUserProfile ? 'Kullanıcı Değerlendirmeleri' : 'Değerlendirmeler',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        bottom: widget.isUserProfile
            ? null  // Profil sayfasından açıldıysa tab bar gösterme
            : TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text('Ürün (${_productReviewsCount})'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text('Satıcı (${_sellerReviewsCount})'),
                    ),
                  ),
                ],
              ),
      ),
      body: widget.isUserProfile
          ? _buildSellerReviewsList()  // Profil sayfasından açıldıysa sadece satıcı değerlendirmeleri
          : TabBarView(
              controller: _tabController,
              children: [
                // Ürün Değerlendirmeleri
                _buildProductReviewsList(),
                
                // Satıcı Değerlendirmeleri
                _buildSellerReviewsList(),
              ],
            ),
    );
  }
  
  // Ürün değerlendirmeleri listesi
  Widget _buildProductReviewsList() {
    final reviews = MockData.getProductReviews(widget.productId);
    
    if (reviews.isEmpty) {
      return _buildEmptyReviewsMessage('Bu ürün için henüz değerlendirme yapılmamış.');
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Ortalama puan göstergesi
        _buildRatingSummary(_productRating, _productReviewsCount, 'ürün'),
        
        const SizedBox(height: 24),
        
        // Değerlendirme listesi
        ...reviews.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }
  
  // Satıcı değerlendirmeleri listesi
  Widget _buildSellerReviewsList() {
    final reviews = MockData.getSellerReviews(widget.sellerId);
    
    if (reviews.isEmpty) {
      return _buildEmptyReviewsMessage(
        widget.isUserProfile
            ? 'Bu kullanıcı için henüz değerlendirme yapılmamış.'
            : 'Bu satıcı için henüz değerlendirme yapılmamış.'
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Ortalama puan göstergesi
        _buildRatingSummary(
          _sellerRating, 
          _sellerReviewsCount, 
          widget.isUserProfile ? 'kullanıcı' : 'satıcı'
        ),
        
        const SizedBox(height: 24),
        
        // Değerlendirme listesi
        ...reviews.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }
  
  // Değerlendirme özeti ve ortalama puan göstergesi
  Widget _buildRatingSummary(double rating, int count, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Text(
            'Değerlendirme Özeti',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ortalama puan
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Yıldızlar ve değerlendirme sayısı
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final double starValue = index + 1.0;
                      return Icon(
                        starValue <= rating 
                            ? Icons.star 
                            : (starValue - 0.5 <= rating 
                                ? Icons.star_half 
                                : Icons.star_border),
                        color: Colors.amber,
                        size: 24,
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    '$count değerlendirme',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Bu $type için ortalama puan: ${rating.toStringAsFixed(1)}/5.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Değerlendirme kartı
  Widget _buildReviewItem(Map<String, dynamic> review) {
    // Tarih formatını düzenle (örn: "25 Ocak 2024")
    final dateStr = review['date'];
    final dateParts = dateStr.split('-');
    
    final aylar = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    
    String formattedDate = '';
    try {
      final ay = int.parse(dateParts[1]);
      formattedDate = '${dateParts[2]} ${aylar[ay]} ${dateParts[0]}';
    } catch (e) {
      formattedDate = dateStr;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          // Kullanıcı bilgisi ve tarih
          Row(
            children: [
              // Kullanıcı avatarı
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: review['userAvatar'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 20),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Kullanıcı adı ve değerlendirme tarihi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Puan yıldızları
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review['rating'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Yıldızlar
          Row(
            children: List.generate(5, (index) {
              final double starValue = index + 1.0;
              final double rating = review['rating'];
              
              return Icon(
                starValue <= rating 
                    ? Icons.star 
                    : (starValue - 0.5 <= rating 
                        ? Icons.star_half 
                        : Icons.star_border),
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Değerlendirme metni
          Text(
            review['comment'],
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
  
  // Boş değerlendirme mesajı
  Widget _buildEmptyReviewsMessage(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Geri Dön'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
} 