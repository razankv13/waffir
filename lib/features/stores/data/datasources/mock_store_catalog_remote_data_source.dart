import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/mock_data/stores_mock_data.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class MockStoreCatalogRemoteDataSource implements StoreCatalogRemoteDataSource {
  @override
  Future<StoreModel> fetchStoreById({
    required String storeId,
    required String languageCode,
  }) async {
    try {
      return StoresMockData.stores.firstWhere((store) => store.id == storeId);
    } catch (_) {
      throw Failure.notFound(
        message: 'Store not found',
        code: 'STORE_NOT_FOUND',
      );
    }
  }

  @override
  Future<List<StoreOffer>> fetchStoreOffers({
    required String storeId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    return const <StoreOffer>[];
  }

  @override
  Future<bool> toggleFavoriteStore({required String storeId}) async {
    return true;
  }
}
