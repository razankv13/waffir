import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/mock_data/stores_mock_data.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class MockStoreCatalogRemoteDataSource implements StoreCatalogRemoteDataSource {
  /// Maps category slugs to legacy category names used in mock data.
  static const Map<String, String> _slugToCategory = {
    'dining': 'Dining',
    'fashion': 'Fashion',
    'electronics': 'Electronics',
    'beauty': 'Beauty',
    'travel': 'Travel',
    'lifestyle': 'Lifestyle',
    'jewelry': 'Jewelry',
    'entertainment': 'Entertainment',
    'others': 'Other',
  };

  @override
  Future<List<StoreModel>> fetchStores({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    var stores = StoresMockData.stores;

    // Filter by category
    if (categorySlug != null && categorySlug.isNotEmpty) {
      final legacyCategory = _slugToCategory[categorySlug.toLowerCase()];
      if (legacyCategory != null) {
        stores = stores.where((s) => s.category == legacyCategory).toList();
      }
    }

    // Filter by search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      stores = stores.where((s) => s.name.toLowerCase().contains(query)).toList();
    }

    return stores;
  }

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
