import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/repositories/stores_repository.dart';

abstract class StoreCatalogRepository {
  /// Fetches the stores feed with "Near You" and "Mall" sections.
  ///
  /// - [languageCode]: 'en' or 'ar' for localized names
  /// - [categorySlug]: Optional category slug (e.g., 'fashion', 'dining')
  /// - [searchQuery]: Optional search term for store name
  ///
  /// The split between sections is randomized (~30% Near You, ~70% Mall).
  AsyncResult<StoresFeed> fetchStoresFeed({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
  });

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
