import 'dart:math';

import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/repositories/store_catalog_repository.dart';
import 'package:waffir/features/stores/domain/repositories/stores_repository.dart';

class StoreCatalogRepositoryImpl implements StoreCatalogRepository {
  StoreCatalogRepositoryImpl(this._remote);

  final StoreCatalogRemoteDataSource _remote;

  @override
  AsyncResult<StoresFeed> fetchStoresFeed({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
  }) {
    return Result.guard(() async {
      final storeModels = await _remote.fetchStores(
        languageCode: languageCode,
        categorySlug: categorySlug,
        searchQuery: searchQuery,
      );

      // Convert models to domain entities
      final stores = storeModels.map((m) => m.toDomain()).toList();

      // Split stores randomly: ~30% Near You, ~70% Mall
      final (nearYou, mall) = _splitStoresRandomly(stores);

      return StoresFeed(nearYou: nearYou, mall: mall);
    });
  }

  /// Splits stores randomly into Near You (~30%) and Mall (~70%) sections.
  ///
  /// The algorithm shuffles stores and splits at ~30%, ensuring at least 1 store
  /// in each section when there are 2+ stores.
  (List<Store>, List<Store>) _splitStoresRandomly(List<Store> stores) {
    if (stores.isEmpty) return (const [], const []);
    if (stores.length == 1) return (stores, const []);

    final random = Random();
    final shuffled = List<Store>.from(stores)..shuffle(random);

    // Calculate split point: ~30% for Near You, minimum 1, maximum length-1
    final nearYouCount = (stores.length * 0.3).ceil().clamp(1, stores.length - 1);

    return (
      shuffled.sublist(0, nearYouCount),
      shuffled.sublist(nearYouCount),
    );
  }

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
