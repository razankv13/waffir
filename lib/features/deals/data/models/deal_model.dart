import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';

part 'deal_model.freezed.dart';
part 'deal_model.g.dart';

/// Data model for Deal with JSON serialization
@freezed
abstract class DealModel with _$DealModel {

  /// Create from domain entity
  factory DealModel.fromDomain(Deal deal) {
    return DealModel(
      id: deal.id,
      title: deal.title,
      description: deal.description,
      price: deal.price,
      originalPrice: deal.originalPrice,
      discountPercentage: deal.discountPercentage,
      imageUrl: deal.imageUrl,
      brand: deal.brand,
      rating: deal.rating,
      reviewCount: deal.reviewCount,
      category: deal.category,
      isNew: deal.isNew,
      isFeatured: deal.isFeatured,
      createdAt: deal.createdAt,
      expiresAt: deal.expiresAt,
    );
  }
  const factory DealModel({
    required String id,
    required String title,
    required String description,
    required double price,
    double? originalPrice,
    int? discountPercentage,
    required String imageUrl,
    String? brand,
    double? rating,
    int? reviewCount,
    String? category,
    bool? isNew,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) = _DealModel;

  /// Create from JSON
  factory DealModel.fromJson(Map<String, dynamic> json) => _$DealModelFromJson(json);

  const DealModel._();

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

  /// Check if deal is hot (discount >= 20%)
  bool get isHot => calculatedDiscountPercentage >= 20;

  /// Convert to domain entity
  Deal toDomain() {
    return Deal(
      id: id,
      title: title,
      description: description,
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      imageUrl: imageUrl,
      brand: brand,
      rating: rating,
      reviewCount: reviewCount,
      category: category,
      isNew: isNew,
      isFeatured: isFeatured,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }
}
