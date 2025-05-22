import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../models/trade_offer_model.dart';
import '../models/user_model.dart';

class ListingService extends ChangeNotifier {
  List<Listing> _listings = [];
  List<TradeOffer> _tradeOffers = [];
  
  // Filtreleme parametreleri
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedLocation;
  RangeValues? _priceRange;
  List<String> _selectedTags = [];
  bool _onlyAvailable = true;
  
  // Getter'lar
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedLocation => _selectedLocation;
  RangeValues? get priceRange => _priceRange;
  List<String> get selectedTags => _selectedTags;
  bool get onlyAvailable => _onlyAvailable;
  
  // Tüm kategorileri getir
  List<String> get allCategories => [
    'Elektronik',
    'Giyim',
    'Kitap',
    'Spor',
    'Oyuncak',
    'Diğer',
  ];
  
  // Tüm konumları getir
  List<String> get allLocations => [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Diğer',
  ];
  
  // Tüm etiketleri getir
  List<String> get allTags {
    Set<String> tags = {};
    for (var listing in _listings) {
      tags.addAll(listing.tags);
    }
    return tags.toList()..sort();
  }
  
  List<Listing> get listings => _filterListings();
  List<TradeOffer> get tradeOffers => _tradeOffers;
  
  // Filtreleme metodları
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }
  
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  void setLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }
  
  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
  }

  void setOnlyAvailable(bool value) {
    _onlyAvailable = value;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedLocation = null;
    _priceRange = null;
    _selectedTags = [];
    _onlyAvailable = true;
    notifyListeners();
  }
  
  List<Listing> _filterListings() {
    return _listings.where((listing) {
      // Sadece aktif ilanları göster
      if (_onlyAvailable && listing.status != ListingStatus.active) {
        return false;
      }

      // Arama sorgusu kontrolü
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        bool matchesSearch = false;
        
        // Başlıkta ara
        if (listing.title.toLowerCase().contains(query)) {
          matchesSearch = true;
        }
        
        // Açıklamada ara
        if (listing.description.toLowerCase().contains(query)) {
          matchesSearch = true;
        }
        
        // Etiketlerde ara
        if (listing.tags.any((tag) => tag.toLowerCase().contains(query))) {
          matchesSearch = true;
        }

        // Kategoride ara
        if (listing.category.toLowerCase().contains(query)) {
          matchesSearch = true;
        }

        if (!matchesSearch) return false;
      }
      
      // Kategori kontrolü
      if (_selectedCategory != null && listing.category != _selectedCategory) {
        return false;
      }
      
      // Konum kontrolü
      if (_selectedLocation != null && listing.location != _selectedLocation) {
        return false;
      }
      
      // Fiyat aralığı kontrolü
      if (_priceRange != null) {
        if (listing.estimatedValue < _priceRange!.start ||
            listing.estimatedValue > _priceRange!.end) {
          return false;
        }
      }

      // Etiket kontrolü
      if (_selectedTags.isNotEmpty) {
        if (!_selectedTags.any((tag) => listing.tags.contains(tag))) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
  
  // İlan yönetimi
  Future<void> createListing(Listing listing) async {
    // TODO: Backend entegrasyonu
    _listings.add(listing);
    notifyListeners();
  }
  
  // Takas teklifi yönetimi
  Future<void> sendTradeOffer(TradeOffer offer) async {
    // TODO: Backend entegrasyonu
    _tradeOffers.add(offer);
    notifyListeners();
  }
  
  Future<void> respondToTradeOffer(String offerId, bool accept) async {
    final offerIndex = _tradeOffers.indexWhere((offer) => offer.id == offerId);
    if (offerIndex != -1) {
      _tradeOffers[offerIndex].status = 
          accept ? TradeOfferStatus.accepted : TradeOfferStatus.rejected;
      
      if (accept) {
        // İlanların durumunu güncelle
        final targetListing = _tradeOffers[offerIndex].targetListing;
        final offeredListing = _tradeOffers[offerIndex].offeredListing;
        
        targetListing.status = ListingStatus.traded;
        offeredListing.status = ListingStatus.traded;
      }
      
      notifyListeners();
    }
  }
  
  // Test verileri
  void loadTestData() {
    final testUser = User(
      id: '1',
      username: 'test_user',
      email: 'test@example.com',
      phoneNumber: '+90 555 555 5555',
    );

    final testUser2 = User(
      id: '2',
      username: 'ahmet_yilmaz',
      email: 'ahmet@example.com',
      phoneNumber: '+90 555 444 3333',
      profileImage: 'https://picsum.photos/200?random=2',
    );
    
    _listings = [
      Listing(
        id: '1',
        title: 'iPhone 12',
        description: 'Çok temiz, kutulu iPhone 12. 128GB depolama. Batarya sağlığı %89.',
        category: 'Elektronik',
        location: 'İstanbul',
        images: ['https://picsum.photos/200?random=1'],
        owner: testUser,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        estimatedValue: 15000,
        tags: ['telefon', 'apple', 'iphone'],
      ),
      Listing(
        id: '2',
        title: 'Nike Air Max',
        description: '1 kez giyildi, 42 numara Nike Air Max spor ayakkabı.',
        category: 'Giyim',
        location: 'Ankara',
        images: ['https://picsum.photos/200?random=2'],
        owner: testUser2,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        estimatedValue: 2500,
        tags: ['ayakkabı', 'nike', 'spor'],
      ),
      Listing(
        id: '3',
        title: 'PlayStation 5',
        description: 'Kutulu, 2 kol ile birlikte PS5. Garanti devam ediyor.',
        category: 'Elektronik',
        location: 'İzmir',
        images: ['https://picsum.photos/200?random=3'],
        owner: testUser,
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
        estimatedValue: 18000,
        tags: ['konsol', 'playstation', 'oyun'],
      ),
      Listing(
        id: '4',
        title: 'Harry Potter Set',
        description: '7 kitaplık Harry Potter seti, çok temiz.',
        category: 'Kitap',
        location: 'İstanbul',
        images: ['https://picsum.photos/200?random=4'],
        owner: testUser2,
        createdAt: DateTime.now().subtract(Duration(hours: 6)),
        estimatedValue: 800,
        tags: ['kitap', 'harry potter', 'set'],
      ),
      Listing(
        id: '5',
        title: 'Elektro Gitar',
        description: 'Fender Stratocaster, çok az kullanıldı.',
        category: 'Diğer',
        location: 'Bursa',
        images: ['https://picsum.photos/200?random=5'],
        owner: testUser,
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
        estimatedValue: 12000,
        tags: ['müzik', 'gitar', 'fender'],
      ),
    ];

    // Test takas teklifleri
    _tradeOffers = [
      TradeOffer(
        id: '1',
        targetListing: _listings[1], // Nike Air Max
        offeredListing: _listings[0], // iPhone 12
        sender: testUser,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        status: TradeOfferStatus.pending,
        message: 'Ayakkabınız çok hoşuma gitti, takas yapmak ister misiniz?',
      ),
      TradeOffer(
        id: '2',
        targetListing: _listings[2], // PlayStation 5
        offeredListing: _listings[4], // Elektro Gitar
        sender: testUser2,
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
        status: TradeOfferStatus.accepted,
        message: 'Gitarım ile PS5\'inizi takas etmek istiyorum.',
      ),
    ];
    
    notifyListeners();
  }
} 