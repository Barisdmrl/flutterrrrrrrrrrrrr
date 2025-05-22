import 'package:flutter/material.dart';
import 'user_model.dart';
import 'trade_offer_model.dart';

class Review {
  final String id;
  final User reviewer;
  final User reviewedUser;
  final TradeOffer tradeOffer;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.reviewer,
    required this.reviewedUser,
    required this.tradeOffer,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerId': reviewer.id,
      'reviewedUserId': reviewedUser.id,
      'tradeOfferId': tradeOffer.id,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 