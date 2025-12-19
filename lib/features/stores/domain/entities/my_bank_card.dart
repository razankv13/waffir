import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_bank_card.freezed.dart';

@freezed
abstract class MyBankCard with _$MyBankCard {
  const factory MyBankCard({
    required String bankCardId,
    required String bankId,
    required String bankName,
    required String cardName,
  }) = _MyBankCard;
}
