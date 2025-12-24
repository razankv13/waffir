import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:waffir/features/credit_cards/domain/entities/bank.dart';

part 'bank_model.freezed.dart';
part 'bank_model.g.dart';

/// Data model for Bank with JSON serialization (matches Supabase `banks` table)
@freezed
abstract class BankModel with _$BankModel {
  const factory BankModel({
    required String id,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _BankModel;

  const BankModel._();

  /// Create from JSON (Supabase row)
  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);

  /// Create from domain entity
  factory BankModel.fromDomain(Bank bank) {
    return BankModel(
      id: bank.id,
      name: bank.name,
      nameAr: bank.nameAr,
      logoUrl: bank.logoUrl,
      isActive: bank.isActive,
    );
  }

  /// Convert to domain entity
  Bank toDomain() {
    return Bank(
      id: id,
      name: name,
      nameAr: nameAr,
      logoUrl: logoUrl,
      isActive: isActive,
    );
  }
}
