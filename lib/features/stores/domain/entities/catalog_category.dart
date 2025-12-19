import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_category.freezed.dart';

@freezed
abstract class CatalogCategory with _$CatalogCategory {
  const factory CatalogCategory({
    required String id,
    required String slug,
    required String nameEn,
    String? nameAr,
    required bool isActive,
  }) = _CatalogCategory;
}

extension CatalogCategoryX on CatalogCategory {
  String localizedName({required bool isArabic}) {
    if (!isArabic) return nameEn;
    final value = nameAr?.trim();
    if (value == null || value.isEmpty) return nameEn;
    return value;
  }
}
