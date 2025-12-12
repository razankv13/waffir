import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

/// Store/Vendor entity representing a seller in the e-commerce system
@freezed
abstract class Store with _$Store {
  const factory Store({
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
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}

/// Extension methods for Store
extension StoreX on Store {
  /// Check if store has high rating (>=4.5)
  bool get hasHighRating => rating != null && rating! >= 4.5;

  /// Check if store is popular (>1000 followers)
  bool get isPopular => followerCount > 1000;

  /// Get formatted follower count (e.g., "1.2K", "5.3K")
  String get formattedFollowerCount {
    if (followerCount >= 1000) {
      return '${(followerCount / 1000).toStringAsFixed(1)}K';
    }
    return followerCount.toString();
  }

  /// Get rating text
  String get ratingText {
    if (rating == null) return 'No rating';
    return '${rating!.toStringAsFixed(1)} (${reviewCount ?? 0} reviews)';
  }
}
