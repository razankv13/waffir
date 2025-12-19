import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

abstract class StoreCatalogRepository {
  AsyncResult<StoreModel> fetchStoreById({
    required String storeId,
    required String languageCode,
  });

  AsyncResult<List<StoreOffer>> fetchStoreOffers({
    required String storeId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  });

  AsyncResult<bool> toggleFavoriteStore({required String storeId});
}
