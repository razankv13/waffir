import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Product entity representing a product in the e-commerce system
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String title,
    required String description,
    required double price,
    required List<String> imageUrls,
    required String categoryId,
    String? brand,
    double? originalPrice,
    int? discountPercentage,
    double? rating,
    int? reviewCount,
    @Default([]) List<String> availableSizes,
    @Default([]) List<String> availableColors,
    String? badge,
    String? badgeType,
    @Default(0) int stockQuantity,
    @Default(true) bool isAvailable,
    @Default(false) bool isFeatured,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

/// Extension methods for Product
extension ProductX on Product {
  /// Check if product is on sale
  bool get isOnSale =>
      originalPrice != null && originalPrice! > price;

  /// Calculate discount amount
  double get discountAmount =>
      isOnSale ? originalPrice! - price : 0.0;

  /// Get primary image URL
  String get primaryImageUrl =>
      imageUrls.isNotEmpty ? imageUrls.first : '';

  /// Check if product is in stock
  bool get inStock => isAvailable && stockQuantity > 0;

  /// Check if product is low stock (less than 5 items)
  bool get isLowStock => stockQuantity > 0 && stockQuantity < 5;

  /// Get stock status message
  String get stockStatus {
    if (!isAvailable) return 'Out of Stock';
    if (stockQuantity == 0) return 'Out of Stock';
    if (isLowStock) return 'Only $stockQuantity left';
    return 'In Stock';
  }
}
