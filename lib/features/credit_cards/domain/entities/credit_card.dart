import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';

/// Domain entity for a bank card (matches Supabase `bank_cards` table with bank join)
///
/// This entity represents a bank card with its associated bank information,
/// used for display in the credit cards selection screen.
@freezed
abstract class BankCard with _$BankCard {
  const factory BankCard({
    required String id,
    required String bankId,
    required String nameEn,
    String? nameAr,
    String? imageUrl,
    @Default(true) bool isActive,
    int? accountTypeId,
    int? cardTypeId,
    // Bank info from join
    String? bankName,
    String? bankNameAr,
    String? bankLogoUrl,
  }) = _BankCard;

  const BankCard._();

  /// Get localized card name based on language code
  String localizedName(String languageCode) {
    if (languageCode.toLowerCase() == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return nameEn;
  }

  /// Get localized bank name based on language code
  String localizedBankName(String languageCode) {
    if (languageCode.toLowerCase() == 'ar' && bankNameAr != null && bankNameAr!.isNotEmpty) {
      return bankNameAr!;
    }
    return bankName ?? '';
  }

  /// Get the display image URL (card image or bank logo fallback)
  String? get displayImageUrl => imageUrl ?? bankLogoUrl;

  /// Check if this card has an image to display
  bool get hasImage => displayImageUrl != null && displayImageUrl!.isNotEmpty;
}

/// Legacy alias for backwards compatibility
typedef CreditCard = BankCard;
