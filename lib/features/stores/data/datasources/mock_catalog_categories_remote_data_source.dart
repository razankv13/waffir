import 'package:waffir/features/stores/data/datasources/catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';

class MockCatalogCategoriesRemoteDataSource
    implements CatalogCategoriesRemoteDataSource {
  @override
  Future<List<CatalogCategory>> fetchActiveCategories({
    required String languageCode,
  }) async {
    return const <CatalogCategory>[];
  }
}
