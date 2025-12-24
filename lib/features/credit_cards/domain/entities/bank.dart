import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank.freezed.dart';

/// Domain entity for a bank (matches Supabase `banks` table)
@freezed
abstract class Bank with _$Bank {
  const factory Bank({
    required String id,
    required String name,
    String? nameAr,
    String? logoUrl,
    @Default(true) bool isActive,
  }) = _Bank;

  const Bank._();

  /// Get localized name based on language code
  String localizedName(String languageCode) {
    if (languageCode.toLowerCase() == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }
}
