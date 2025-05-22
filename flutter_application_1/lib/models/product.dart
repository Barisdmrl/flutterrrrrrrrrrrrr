// models/product.dart
class Product {
  final String id;
  final String name;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    this.isFavorite = false,
  });
}