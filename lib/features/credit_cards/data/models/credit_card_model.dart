import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/credit_cards/domain/entities/credit_card.dart';

part 'credit_card_model.freezed.dart';
part 'credit_card_model.g.dart';

/// Data model for CreditCard with JSON serialization
@freezed
abstract class CreditCardModel with _$CreditCardModel {

  /// Create from domain entity
  factory CreditCardModel.fromDomain(CreditCard card) {
    return CreditCardModel(
      id: card.id,
      bankId: card.bankId,
      bankName: card.bankName,
      cardName: card.cardName,
      cardType: card.cardType,
      imageUrl: card.imageUrl,
      description: card.description,
      benefits: card.benefits,
      cashbackPercentage: card.cashbackPercentage,
      rewardPoints: card.rewardPoints,
      annualFee: card.annualFee,
      isPopular: card.isPopular,
      isFeatured: card.isFeatured,
      applyUrl: card.applyUrl,
    );
  }
  const factory CreditCardModel({
    required String id,
    required String bankId,
    required String bankName,
    required String cardName,
    required String cardType,
    required String imageUrl,
    String? description,
    List<String>? benefits,
    double? cashbackPercentage,
    int? rewardPoints,
    double? annualFee,
    bool? isPopular,
    bool? isFeatured,
    String? applyUrl,
  }) = _CreditCardModel;

  const CreditCardModel._();

  /// Create from JSON
  factory CreditCardModel.fromJson(Map<String, dynamic> json) => _$CreditCardModelFromJson(json);

  /// Convert to domain entity
  CreditCard toDomain() {
    return CreditCard(
      id: id,
      bankId: bankId,
      bankName: bankName,
      cardName: cardName,
      cardType: cardType,
      imageUrl: imageUrl,
      description: description,
      benefits: benefits,
      cashbackPercentage: cashbackPercentage,
      rewardPoints: rewardPoints,
      annualFee: annualFee,
      isPopular: isPopular,
      isFeatured: isFeatured,
      applyUrl: applyUrl,
    );
  }
}
