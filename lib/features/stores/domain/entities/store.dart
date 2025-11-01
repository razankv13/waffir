import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';

/// Domain entity for a store
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
    double? rating,
    int? reviewCount,
    String? phoneNumber,
    String? website,
    bool? isOpen,
    String? openingHours,
    bool? isMall,
    String? mallName,
    List<String>? tags,
    double? latitude,
    double? longitude,
  }) = _Store;

  const Store._();

  /// Check if store has high rating
  bool get hasHighRating => rating != null && rating! >= 4.0;

  /// Get formatted distance
  String get formattedDistance {
    if (distance == null) return '';
    return distance!;
  }
}

/// Store category enum
enum StoreCategory {
  all,
  dining,
  fashion,
  electronics,
  beauty,
  travel,
  lifestyle,
  jewelry,
  entertainment,
  other;

  String get displayName {
    switch (this) {
      case StoreCategory.all:
        return 'الكل'; // All in Arabic
      case StoreCategory.dining:
        return 'المطاعم'; // Dining
      case StoreCategory.fashion:
        return 'ازياء'; // Fashion
      case StoreCategory.electronics:
        return 'إلكترونيات'; // Electronics
      case StoreCategory.beauty:
        return 'Beauty';
      case StoreCategory.travel:
        return 'Travel';
      case StoreCategory.lifestyle:
        return 'Lifestyle';
      case StoreCategory.jewelry:
        return 'Jewelry';
      case StoreCategory.entertainment:
        return 'Entertainment';
      case StoreCategory.other:
        return 'Others';
    }
  }
}
