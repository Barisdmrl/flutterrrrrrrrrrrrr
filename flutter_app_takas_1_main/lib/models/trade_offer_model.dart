import 'package:flutter/material.dart';
import 'user_model.dart';
import 'listing_model.dart';

enum TradeOfferStatus {
  pending,
  accepted,
  rejected,
  cancelled
}

class TradeOffer {
  final String id;
  final Listing targetListing;
  final Listing offeredListing;
  final User sender;
  final DateTime createdAt;
  TradeOfferStatus status;
  String? message;

  TradeOffer({
    required this.id,
    required this.targetListing,
    required this.offeredListing,
    required this.sender,
    required this.createdAt,
    this.status = TradeOfferStatus.pending,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetListingId': targetListing.id,
      'offeredListingId': offeredListing.id,
      'senderId': sender.id,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'message': message,
    };
  }
} 