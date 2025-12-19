import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_bank_card.freezed.dart';

@freezed
abstract class CatalogBankCard with _$CatalogBankCard {
  const factory CatalogBankCard({
    required String id,
    required String bankId,
    required String name,
    String? nameAr,
    String? imageUrl,
    required bool isActive,
  }) = _CatalogBankCard;
}

extension CatalogBankCardX on CatalogBankCard {
  String localizedName({required bool isArabic}) {
    if (!isArabic) return name;
    final value = (nameAr ?? '').trim();
    return value.isEmpty ? name : value;
  }
}
