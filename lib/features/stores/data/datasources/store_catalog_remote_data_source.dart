import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

abstract class StoreCatalogRemoteDataSource {
  /// Fetches all active stores with optional filtering.
  ///
  /// - [languageCode]: 'en' or 'ar' for localized names
  /// - [categorySlug]: Optional category slug (e.g., 'fashion', 'dining')
  /// - [searchQuery]: Optional search term for store name
  Future<List<StoreModel>> fetchStores({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
  });

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
