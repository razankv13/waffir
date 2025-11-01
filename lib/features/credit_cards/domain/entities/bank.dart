import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank.freezed.dart';

/// Domain entity for a bank
@freezed
abstract class Bank with _$Bank {
  const factory Bank({
    required String id,
    required String name,
    required String nameAr,
    required String logoUrl,
    String? description,
    String? website,
    String? phoneNumber,
    List<String>? cardTypes,
    bool? isPopular,
  }) = _Bank;

  const Bank._();

  /// Check if bank offers credit cards
  bool get hasCreditCards => cardTypes != null && cardTypes!.isNotEmpty;
}
