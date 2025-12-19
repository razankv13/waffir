import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/datasources/catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';
import 'package:waffir/features/stores/domain/repositories/catalog_categories_repository.dart';

class CatalogCategoriesRepositoryImpl implements CatalogCategoriesRepository {
  CatalogCategoriesRepositoryImpl(this._remote);

  final CatalogCategoriesRemoteDataSource _remote;

  @override
  AsyncResult<List<CatalogCategory>> fetchActiveCategories({
    required String languageCode,
  }) {
    return Result.guard(
      () => _remote.fetchActiveCategories(languageCode: languageCode),
    );
  }
}
