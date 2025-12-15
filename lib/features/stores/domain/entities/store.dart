import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _Store;

  const Store._();

  bool get hasHighRating => rating != null && rating! >= 4.5;
}
