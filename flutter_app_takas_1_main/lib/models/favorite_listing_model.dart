import 'package:hive/hive.dart';

part 'favorite_listing_model.g.dart';

@HiveType(typeId: 0)
class FavoriteListing {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final double estimatedValue;

  @HiveField(7)
  final DateTime savedAt;

  FavoriteListing({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.images,
    required this.estimatedValue,
    required this.savedAt,
  });
} 