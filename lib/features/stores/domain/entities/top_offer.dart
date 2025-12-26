import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_offer.freezed.dart';

/// Lightweight entity representing the best offer for a store.
///
/// Contains only the fields needed for display in store cards,
/// keeping the domain layer clean and reducing memory footprint.
@freezed
abstract class TopOffer with _$TopOffer {
  const factory TopOffer({
    required String id,
    required String title,
    String? titleAr,
    num? discountMaxPercent,
  }) = _TopOffer;

  const TopOffer._();

  /// Returns the localized title based on the current language.
  ///
  /// Falls back to English title if Arabic is empty or not available.
  String localizedTitle({required bool isArabic}) {
    if (!isArabic) return title;
    final arabicTitle = (titleAr ?? '').trim();
    return arabicTitle.isEmpty ? title : arabicTitle;
  }
}
