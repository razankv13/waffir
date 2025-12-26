import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/domain/entities/top_offer.dart';

part 'store_model.freezed.dart';
part 'store_model.g.dart';

/// Data model for Store with JSON serialization
@freezed
abstract class StoreModel with _$StoreModel {

  /// Create from domain entity
  factory StoreModel.fromDomain(Store store) {
    return StoreModel(
      id: store.id,
      name: store.name,
      category: store.category,
      imageUrl: store.imageUrl,
      description: store.description,
      address: store.address,
      distance: store.distance,
      logoUrl: store.logoUrl,
      bannerUrl: store.bannerUrl,
      rating: store.rating,
      reviewCount: store.reviewCount,
      followerCount: store.followerCount,
      productIds: store.productIds,
      categories: store.categories,
      location: store.location,
      phoneNumber: store.phoneNumber,
      email: store.email,
      website: store.website,
      discountText: store.discountText,
      isVerified: store.isVerified,
      isFollowing: store.isFollowing,
      isActive: store.isActive,
      createdAt: store.createdAt,
      updatedAt: store.updatedAt,
      topOffer: store.topOffer,
    );
  }
  const factory StoreModel({
    required String id,
    required String name,
    required String category,
    required String imageUrl,
    String? description,
    String? address,
    String? distance,
    String? logoUrl,
    String? bannerUrl,
    double? rating,
    int? reviewCount,
    @Default(0) int followerCount,
    @Default([]) List<String> productIds,
    @Default([]) List<String> categories,
    String? location,
    String? phoneNumber,
    String? email,
    String? website,
    String? discountText,
    @Default(false) bool isVerified,
    @Default(false) bool isFollowing,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) TopOffer? topOffer,
  }) = _StoreModel;

  const StoreModel._();

  /// Create from JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

  /// Convert to domain entity
  Store toDomain() {
    return Store(
      id: id,
      name: name,
      category: category,
      imageUrl: imageUrl,
      description: description,
      address: address,
      distance: distance,
      logoUrl: logoUrl,
      bannerUrl: bannerUrl,
      rating: rating,
      reviewCount: reviewCount,
      followerCount: followerCount,
      productIds: productIds,
      categories: categories,
      location: location,
      phoneNumber: phoneNumber,
      email: email,
      website: website,
      discountText: discountText,
      isVerified: isVerified,
      isFollowing: isFollowing,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      topOffer: topOffer,
    );
  }
}
