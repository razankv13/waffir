import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_offer.freezed.dart';

@freezed
abstract class StoreOffer with _$StoreOffer {
  const StoreOffer._();

  const factory StoreOffer({
    required String id,
    required String storeId,
    required String title,
    String? titleAr,
    String? description,
    String? descriptionAr,
    String? termsText,
    String? termsTextAr,
    num? discountMinPercent,
    num? discountMaxPercent,
    String? promoCode,
    String? onlineOrInstore,
    DateTime? startDate,
    DateTime? endDate,
    String? imageUrl,
    String? refUrl,
    int? popularityScore,
    DateTime? createdAt,
  }) = _StoreOffer;

  String localizedTitle({required bool isArabic}) {
    if (!isArabic) return title;
    final value = (titleAr ?? '').trim();
    return value.isEmpty ? title : value;
  }

  String? localizedDescription({required bool isArabic}) {
    final primary = isArabic ? descriptionAr : description;
    final fallback = isArabic ? description : descriptionAr;
    final primaryValue = (primary ?? '').trim();
    if (primaryValue.isNotEmpty) return primaryValue;
    final fallbackValue = (fallback ?? '').trim();
    return fallbackValue.isNotEmpty ? fallbackValue : null;
  }

  String? localizedTerms({required bool isArabic}) {
    final primary = isArabic ? termsTextAr : termsText;
    final fallback = isArabic ? termsText : termsTextAr;
    final primaryValue = (primary ?? '').trim();
    if (primaryValue.isNotEmpty) return primaryValue;
    final fallbackValue = (fallback ?? '').trim();
    return fallbackValue.isNotEmpty ? fallbackValue : null;
  }
}
