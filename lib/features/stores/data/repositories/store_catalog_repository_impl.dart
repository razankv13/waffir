import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';

class StoreCatalogRepositoryImpl implements StoreCatalogRepository {
  StoreCatalogRepositoryImpl(this._remote);

  final StoreCatalogRemoteDataSource _remote;

  @override
  AsyncResult<StoreModel> fetchStoreById({
    required String storeId,
    required String languageCode,
  }) {
    return Result.guard(
      () =>
          _remote.fetchStoreById(storeId: storeId, languageCode: languageCode),
    );
  }

  @override
  AsyncResult<List<StoreOffer>> fetchStoreOffers({
    required String storeId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) {
    return Result.guard(
      () => _remote.fetchStoreOffers(
        storeId: storeId,
        languageCode: languageCode,
        searchQuery: searchQuery,
        categoryId: categoryId,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AsyncResult<bool> toggleFavoriteStore({required String storeId}) {
    return Result.guard(() => _remote.toggleFavoriteStore(storeId: storeId));
  }
}
