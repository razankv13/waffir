import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

/// Data model for BankCard with JSON serialization (matches Supabase `bank_cards` joined with `banks`)
@freezed
abstract class BankCardModel with _$BankCardModel {
  const factory BankCardModel({
    required String id,
    @JsonKey(name: 'bank_id') required String bankId,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'name_ar') String? nameAr,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'account_type_id') int? accountTypeId,
    @JsonKey(name: 'card_type_id') int? cardTypeId,
    // Bank info from join
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'bank_name_ar') String? bankNameAr,
    @JsonKey(name: 'bank_logo_url') String? bankLogoUrl,
  }) = _BankCardModel;

  const BankCardModel._();

  /// Create from JSON (Supabase row with bank join)
  factory BankCardModel.fromJson(Map<String, dynamic> json) => _$BankCardModelFromJson(json);

  /// Create from domain entity
  factory BankCardModel.fromDomain(BankCard card) {
    return BankCardModel(
      id: card.id,
      bankId: card.bankId,
      nameEn: card.nameEn,
      nameAr: card.nameAr,
      imageUrl: card.imageUrl,
      isActive: card.isActive,
      accountTypeId: card.accountTypeId,
      cardTypeId: card.cardTypeId,
      bankName: card.bankName,
      bankNameAr: card.bankNameAr,
      bankLogoUrl: card.bankLogoUrl,
    );
  }

  /// Convert to domain entity
  BankCard toDomain() {
    return BankCard(
      id: id,
      bankId: bankId,
      nameEn: nameEn,
      nameAr: nameAr,
      imageUrl: imageUrl,
      isActive: isActive,
      accountTypeId: accountTypeId,
      cardTypeId: cardTypeId,
      bankName: bankName,
      bankNameAr: bankNameAr,
      bankLogoUrl: bankLogoUrl,
    );
  }
}

/// Legacy alias for backwards compatibility
typedef CreditCardModel = BankCardModel;
