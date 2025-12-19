import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';

abstract interface class CatalogCategoriesRepository {
  AsyncResult<List<CatalogCategory>> fetchActiveCategories({
    required String languageCode,
  });
}
