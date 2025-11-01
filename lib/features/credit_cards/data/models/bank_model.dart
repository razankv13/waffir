import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/credit_cards/domain/entities/bank.dart';

part 'bank_model.freezed.dart';
part 'bank_model.g.dart';

/// Data model for Bank with JSON serialization
@freezed
abstract class BankModel with _$BankModel {

  /// Create from domain entity
  factory BankModel.fromDomain(Bank bank) {
    return BankModel(
      id: bank.id,
      name: bank.name,
      nameAr: bank.nameAr,
      logoUrl: bank.logoUrl,
      description: bank.description,
      website: bank.website,
      phoneNumber: bank.phoneNumber,
      cardTypes: bank.cardTypes,
      isPopular: bank.isPopular,
    );
  }
  const factory BankModel({
    required String id,
    required String name,
    required String nameAr,
    required String logoUrl,
    String? description,
    String? website,
    String? phoneNumber,
    List<String>? cardTypes,
    bool? isPopular,
  }) = _BankModel;

  const BankModel._();

  /// Create from JSON
  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);

  /// Convert to domain entity
  Bank toDomain() {
    return Bank(
      id: id,
      name: name,
      nameAr: nameAr,
      logoUrl: logoUrl,
      description: description,
      website: website,
      phoneNumber: phoneNumber,
      cardTypes: cardTypes,
      isPopular: isPopular,
    );
  }
}
