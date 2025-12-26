import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/stores/domain/entities/top_offer.dart';

part 'store.freezed.dart';

/// Domain entity for a store.
///
/// This mirrors the fields needed by the Stores UI while keeping the domain
/// independent from any specific backend implementation (mock vs Supabase).
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
    TopOffer? topOffer,
  }) = _Store;

  const Store._();

  bool get hasHighRating => rating != null && rating! >= 4.5;

  /// Returns the formatted display name for store cards.
  ///
  /// Format: "storeName - offerTitle" if offer exists, otherwise just "storeName".
  String displayName({required bool isArabic}) {
    if (topOffer == null) return name;
    final offerTitle = topOffer!.localizedTitle(isArabic: isArabic);
    if (offerTitle.isEmpty) return name;
    return '$name - $offerTitle';
  }
}
