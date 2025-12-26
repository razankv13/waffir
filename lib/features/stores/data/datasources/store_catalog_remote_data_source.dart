import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

/// Result container for stores fetch with embedded offers.
class StoresWithOffersResult {
  const StoresWithOffersResult({
    required this.stores,
    this.totalCount = 0,
  });

  /// List of stores with their topOffer populated.
  final List<StoreModel> stores;

  /// Total count of stores matching the filter (for pagination).
  final int totalCount;

  /// Whether there are more stores to load.
  bool get hasMore => stores.length < totalCount;
}

abstract class StoreCatalogRemoteDataSource {
  /// Fetches all active stores with optional filtering.
  ///
  /// - [languageCode]: 'en' or 'ar' for localized names
  /// - [categorySlug]: Optional category slug (e.g., 'fashion', 'dining')
  /// - [searchQuery]: Optional search term for store name
  /// - [selectedBankCardIds]: Optional set of bank card IDs to filter stores
  Future<List<StoreModel>> fetchStores({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
    Set<String>? selectedBankCardIds,
  });

  /// Fetches active stores with their top offers (optimized single-query).
  ///
  /// Returns stores with embedded [TopOffer] (highest discount) and pagination
  /// metadata. Detail screens should fetch full offers via [fetchStoreOffers].
  ///
  /// - [selectedBankCardIds]: Optional set of bank card IDs to filter stores
  ///   that have offers from these cards.
  /// - [limit]: Number of stores to fetch (default 20).
  /// - [offset]: Pagination offset (default 0).
  Future<StoresWithOffersResult> fetchStoresWithOffers({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
    Set<String>? selectedBankCardIds,
    int limit = 20,
    int offset = 0,
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
