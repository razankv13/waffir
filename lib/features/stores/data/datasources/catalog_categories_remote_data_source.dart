import 'package:waffir/features/stores/domain/entities/catalog_category.dart';

abstract interface class CatalogCategoriesRemoteDataSource {
  Future<List<CatalogCategory>> fetchActiveCategories({
    required String languageCode,
  });
}
