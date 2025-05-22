import 'package:flutter/material.dart';
import 'user_model.dart';

enum ListingStatus {
  active,
  traded,
  closed
}

class Listing {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final List<String> images;
  final User owner;
  final DateTime createdAt;
  ListingStatus status;
  final double estimatedValue;
  final List<String> tags;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.images,
    required this.owner,
    required this.createdAt,
    this.status = ListingStatus.active,
    required this.estimatedValue,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'images': images,
      'ownerId': owner.id,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'estimatedValue': estimatedValue,
      'tags': tags,
    };
  }
} 