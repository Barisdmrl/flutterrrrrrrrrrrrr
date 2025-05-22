import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../data/mock_data.dart';
import 'reviews_screen.dart';
import 'chat_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key, 
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imagePageController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _isDescriptionExpanded = false;
  bool _isFavorite = false;
  double _imageParallaxOffset = 0.0;

  // İlgili ürünler listesi
  late final List<Map<String, dynamic>> _relatedProducts;

  @override
  void initState() {
    super.initState();
    
    // Parallax efekti için scroll listener
    _scrollController.addListener(() {
      if (_scrollController.offset < 300) {
        setState(() {
          _imageParallaxOffset = _scrollController.offset * 0.4;
        });
      }
    });
    
    // İlgili ürünleri hazırla (normalde API'den gelecektir)
    _relatedProducts = List.generate(
      5, 
      (index) => {
        'id': 100 + index,
        'title': 'Benzer Ürün ${index + 1}',
        'description': 'Bu ürün ${widget.product['title']} ile takas edilebilir.',
        'imageUrl': 'https://picsum.photos/id/${80 + index}/300/300',
        'price': '${(index + 1) * 50} TL değerinde',
        'category': widget.product['category'],
      }
    );
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Örnek ürün resimleri (normalde API'den gelecektir)
    final List<String> productImages = [
      'https://picsum.photos/id/26/600/400',
      'https://picsum.photos/id/65/600/400',
      'https://picsum.photos/id/96/600/400',
      'https://picsum.photos/id/63/600/400',
    ];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              widget.product['title'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            titleSpacing: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Görsel Galerisi
                  PageView.builder(
                    controller: _imagePageController,
                    itemCount: productImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          // Parallax efektli resim
                          Transform.translate(
                            offset: Offset(0, -_imageParallaxOffset),
                            child: CachedNetworkImage(
                              imageUrl: productImages[index],
                              height: 350, // Parallax için biraz daha yüksek
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          // Yarı-saydam gradientin altındaki göstergeler
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: _imagePageController,
                                  count: productImages.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: Colors.white,
                                    dotColor: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Favorilere ekle butonu
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isFavorite
                                ? 'Favorilere eklendi'
                                : 'Favorilerden çıkarıldı'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // İçerik
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ürün Başlığı ve Değeri
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          widget.product['price'] ?? 'Sadece takas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Kategori ve Durum
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.product['category'] ?? 'Kategori',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.product['condition'] ?? 'Kullanılmış',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Kullanıcı Profili
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Kullanıcı avatarı
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).cardColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: 'https://i.pravatar.cc/150?img=${widget.product['id']}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Kullanıcı bilgileri
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ahmet Yılmaz',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  // Değerlendirmeler sayfasına git
                                  final String userId = widget.product['userId'] ?? 'user1';
                                  final String productId = widget.product['id'];
                                  
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReviewsScreen(
                                        productId: productId,
                                        sellerId: userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '4.8 (24 değerlendirme)',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'İstanbul, Kadıköy',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        
                        // Profil görüntüleme
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profil görüntüleniyor')),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Açıklama
                  const Text(
                    'Açıklama',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildExpandableDescription(
                    widget.product['description'] ?? 
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Sed euismod, '
                    'nisl vel ultricies lacinia, nisl nisl aliquam nisl, vel ultricies nisl nisl vel nisl. '
                    'Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, vel ultricies nisl nisl vel nisl. '
                    'Sed euismod, nisl vel ultricies lacinia, nisl nisl aliquam nisl, vel ultricies nisl nisl vel nisl.',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Değerlendirme Butonu
                  InkWell(
                    onTap: () {
                      final String userId = widget.product['userId'] ?? 'user1';
                      final String productId = widget.product['id'];
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(
                            productId: productId,
                            sellerId: userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Değerlendirme ikonu
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Değerlendirme bilgisi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Değerlendirmeleri Gör',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bu ürün ve satıcı hakkında yapılan yorumları görün',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          
                          // İleri oku
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Takas Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _showSwapConfirmationDialog(),
                      icon: const Icon(Icons.swap_horiz, size: 24),
                      label: const Text(
                        'TAKAS TEKLİF ET',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rapor Et Butonu
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ürün rapor edildi')),
                        );
                      },
                      icon: const Icon(Icons.flag_outlined, size: 20),
                      label: const Text('ÜRÜNÜ RAPOR ET'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // İlgili Ürünler Bölümü
                  const Text(
                    'Benzer Ürünler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _relatedProducts.length,
                      itemBuilder: (context, index) {
                        final relatedProduct = _relatedProducts[index];
                        return _buildRelatedProductCard(relatedProduct);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Genişletilebilir açıklama widgeti
  Widget _buildExpandableDescription(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: _isDescriptionExpanded ? null : 3,
          overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isDescriptionExpanded = !_isDescriptionExpanded;
            });
          },
          child: Text(
            _isDescriptionExpanded ? 'Daha az göster' : 'Devamını göster',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  // İlgili ürün kartı
  Widget _buildRelatedProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.85),
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
              child: CachedNetworkImage(
                imageUrl: product['imageUrl'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            
            // Ürün bilgileri
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product['description'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Takas onay dialogu
  Future<void> _showSwapConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: const Text('Takas Teklifi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.product['title']} ürünü için takas teklifi göndermek istediğinizden emin misiniz?',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Teklifiniz kabul edilirse, satıcı sizinle iletişime geçecektir.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Takas teklifinde bulunacağınız ürünü seçin:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Kullanıcının ürünleri (örnek)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage('https://picsum.photos/id/11/100/100'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'iPhone 11 Pro Max',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '3500 TL değerinde',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Radio(
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İPTAL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('TEKLİF GÖNDER'),
              onPressed: () {
                Navigator.of(context).pop();
                
                // Kullanıcının ID'sini al (mevcut kullanıcı varsayalım)
                final currentUserId = MockData.currentUser['id'];
                final productId = widget.product['id'];
                
                // Sohbet odası oluştur veya varsa mevcut odayı al
                final chatId = MockData.createChatRoom(productId, currentUserId);
                
                // Takas teklifi mesajı gönder
                MockData.addMessage(
                  chatId, 
                  currentUserId, 
                  'Merhaba, ${widget.product['title']} ürünü için takas teklifi göndermek istiyorum. İlgilenirseniz detayları konuşabiliriz.'
                );
                
                // Bildirim göster ve kullanıcıyı sohbet ekranına yönlendir
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Takas teklifi gönderildi')),
                );
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatId: chatId,
                      productId: productId,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
} 