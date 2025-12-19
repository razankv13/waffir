import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

abstract class StoreCatalogRemoteDataSource {
  Future<StoreModel> fetchStoreById({
    required String storeId,
    required String languageCode,
  });

  Future<List<StoreOffer>> fetchStoreOffers({
    required String storeId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  });

  Future<bool> toggleFavoriteStore({required String storeId});
}
