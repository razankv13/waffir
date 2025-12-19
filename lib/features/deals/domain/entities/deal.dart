import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal.freezed.dart';

/// Domain entity for a deal/product
@freezed
abstract class Deal with _$Deal {
  const factory Deal({
    required String id,
    required String title,
    required String description,
    required double price,
    double? originalPrice,
    int? discountPercentage,
    required String imageUrl,
    String? brand,
    @Default(0) int likesCount,
    @Default(0) int viewsCount,
    @Default(false) bool isLiked,
    double? rating,
    int? reviewCount,
    String? category,
    bool? isNew,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) = _Deal;

  const Deal._();

  /// Check if deal has a discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Calculate discount percentage if not provided
  int get calculatedDiscountPercentage {
    if (discountPercentage != null) return discountPercentage!;
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return 0;
  }

  /// Check if deal is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if deal is hot (discount > 20%)
  bool get isHot => calculatedDiscountPercentage >= 20;
}
