import 'package:waffir/features/stores/domain/entities/catalog_category.dart';

/// Helpers to map legacy/hardcoded category labels to backend categories.
///
/// Backend slugs use lower-case values (e.g. `others`) while legacy UI uses
/// title-case labels (e.g. `Other`). This keeps the mapping deterministic.
class CatalogCategoryMatching {
  static String normalizeSlug(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'other') return 'others';
    return normalized;
  }

  static CatalogCategory? findBySlugOrEnglishName({
    required List<CatalogCategory> categories,
    required String value,
  }) {
    final normalized = normalizeSlug(value);

    for (final category in categories) {
      if (normalizeSlug(category.slug) == normalized) return category;
    }

    for (final category in categories) {
      if (category.nameEn.trim().toLowerCase() == normalized) return category;
    }

    return null;
  }
}

