import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_bank.freezed.dart';

@freezed
abstract class CatalogBank with _$CatalogBank {
  const factory CatalogBank({
    required String id,
    required String name,
    String? nameAr,
    String? logoUrl,
    required bool isActive,
  }) = _CatalogBank;

  const CatalogBank._();

  String localizedName({required bool isArabic}) {
    if (!isArabic) return name;
    final value = (nameAr ?? '').trim();
    return value.isEmpty ? name : value;
  }
}
