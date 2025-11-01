import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';

/// Domain entity for a credit card offer
@freezed
abstract class CreditCard with _$CreditCard {
  const factory CreditCard({
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
  }) = _CreditCard;

  const CreditCard._();

  /// Check if card has cashback
  bool get hasCashback => cashbackPercentage != null && cashbackPercentage! > 0;

  /// Check if card has rewards
  bool get hasRewards => rewardPoints != null && rewardPoints! > 0;

  /// Check if card has no annual fee
  bool get isNoAnnualFee => annualFee == null || annualFee == 0;

  /// Get formatted annual fee
  String get formattedAnnualFee {
    if (annualFee == null || annualFee == 0) return 'No annual fee';
    return 'SAR ${annualFee!.toStringAsFixed(0)}/year';
  }
}
