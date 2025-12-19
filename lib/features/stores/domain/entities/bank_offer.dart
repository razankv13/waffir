import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_offer.freezed.dart';

@freezed
abstract class BankOffer with _$BankOffer {
  const factory BankOffer({
    required String id,
    required String bankId,
    String? bankCardId,
    String? merchantStoreId,
    String? merchantNameText,
    required String title,
    String? titleAr,
    String? description,
    String? descriptionAr,
    String? termsText,
    String? termsTextAr,
    String? bankName,
    String? bankNameAr,
    String? bankCardName,
    String? bankCardNameAr,
    String? merchantNameAr,
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
  }) = _BankOffer;

  const BankOffer._();

  String localizedTitle({required bool isArabic}) {
    if (!isArabic) return title;
    final value = (titleAr ?? '').trim();
    return value.isEmpty ? title : value;
  }

  String? localizedBankName({required bool isArabic}) {
    final primary = isArabic ? bankNameAr : bankName;
    final fallback = isArabic ? bankName : bankNameAr;
    final primaryValue = (primary ?? '').trim();
    if (primaryValue.isNotEmpty) return primaryValue;
    final fallbackValue = (fallback ?? '').trim();
    return fallbackValue.isNotEmpty ? fallbackValue : null;
  }
}
