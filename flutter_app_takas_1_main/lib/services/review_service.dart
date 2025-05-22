import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/trade_offer_model.dart';
import '../models/listing_model.dart';

class ReviewService extends ChangeNotifier {
  List<Review> _reviews = [];
  
  List<Review> get reviews => _reviews;
  
  // Kullanıcının aldığı değerlendirmeleri getir
  List<Review> getReviewsForUser(String userId) {
    return _reviews.where((review) => review.reviewedUser.id == userId).toList();
  }
  
  // Kullanıcının ortalama puanını hesapla
  double getAverageRating(String userId) {
    final userReviews = getReviewsForUser(userId);
    if (userReviews.isEmpty) return 0;
    
    final totalRating = userReviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / userReviews.length;
  }
  
  // Yeni değerlendirme ekle
  Future<void> addReview({
    required User reviewer,
    required User reviewedUser,
    required TradeOffer tradeOffer,
    required double rating,
    required String comment,
  }) async {
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reviewer: reviewer,
      reviewedUser: reviewedUser,
      tradeOffer: tradeOffer,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    
    _reviews.add(review);
    notifyListeners();
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

    final testOffer = TradeOffer(
      id: '2',
      targetListing: Listing(
        id: '3',
        title: 'PlayStation 5',
        description: 'Kutulu PS5',
        category: 'Elektronik',
        location: 'İzmir',
        images: ['https://picsum.photos/200?random=3'],
        owner: testUser,
        createdAt: DateTime.now(),
        estimatedValue: 18000,
        tags: ['konsol', 'playstation'],
      ),
      offeredListing: Listing(
        id: '5',
        title: 'Elektro Gitar',
        description: 'Fender Stratocaster',
        category: 'Diğer',
        location: 'Bursa',
        images: ['https://picsum.photos/200?random=5'],
        owner: testUser2,
        createdAt: DateTime.now(),
        estimatedValue: 12000,
        tags: ['müzik', 'gitar'],
      ),
      sender: testUser2,
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      status: TradeOfferStatus.accepted,
      message: 'Gitarım ile PS5\'inizi takas etmek istiyorum.',
    );

    _reviews = [
      Review(
        id: '1',
        reviewer: testUser,
        reviewedUser: testUser2,
        tradeOffer: testOffer,
        rating: 4.5,
        comment: 'Çok güzel bir takas deneyimiydi. Ürün anlatıldığı gibiydi.',
        createdAt: DateTime.now().subtract(Duration(hours: 6)),
      ),
      Review(
        id: '2',
        reviewer: testUser2,
        reviewedUser: testUser,
        tradeOffer: testOffer,
        rating: 5.0,
        comment: 'Harika bir alışveriş, çok memnun kaldım. Teşekkürler!',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
      ),
    ];
    
    notifyListeners();
  }
} 