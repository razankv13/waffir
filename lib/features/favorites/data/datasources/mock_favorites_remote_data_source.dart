import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';
import 'package:waffir/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Mock implementation of favorites data source for testing.
///
/// Simulates Supabase behavior with hardcoded data and artificial delays.
/// Maintains in-memory state for toggled favorites.
class MockFavoritesRemoteDataSource implements FavoritesRemoteDataSource {
  MockFavoritesRemoteDataSource();

  // In-memory storage for mocked favorites
  final Set<String> _likedProductIds = {'product_001', 'product_003'};
  final Set<String> _favoritedStoreIds = {'store_002', 'store_005'};

  @override
  Future<List<DealModel>> fetchFavoritedProducts({String languageCode = 'en'}) async {
    AppLogger.debug('🎭 [MOCK] Fetching favorited products');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock product deals
    final mockDeals = <DealModel>[];

    for (final productId in _likedProductIds) {
      mockDeals.add(DealModel.fromJson({
        'id': productId,
        'title': languageCode == 'ar' ? 'منتج مفضل' : 'Favorite Product',
        'title_ar': 'منتج مفضل',
        'description': languageCode == 'ar' ? 'هذا منتج مفضل تجريبي' : 'This is a mock favorite product',
        'description_ar': 'هذا منتج مفضل تجريبي',
        'image_url': 'https://via.placeholder.com/300x300',
        'brand': 'Mock Brand',
        'category': 'Electronics',
        'price': 99.99,
        'original_price': 149.99,
        'discount_percentage': 33,
        'is_liked': true,
        'likes_count': 42,
        'views_count': 150,
        'is_featured': false,
        'created_at': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      }));
    }

    AppLogger.debug('✅ [MOCK] Returned ${mockDeals.length} favorited products');
    return mockDeals;
  }

  @override
  Future<List<StoreModel>> fetchFavoritedStores({String languageCode = 'en'}) async {
    AppLogger.debug('🎭 [MOCK] Fetching favorited stores');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock stores
    final mockStores = <StoreModel>[];

    for (final storeId in _favoritedStoreIds) {
      mockStores.add(StoreModel.fromJson({
        'id': storeId,
        'name': languageCode == 'ar' ? 'متجر مفضل' : 'Favorite Store',
        'name_ar': 'متجر مفضل',
        'image_url': 'https://via.placeholder.com/200x200',
        'discount_text': languageCode == 'ar' ? 'خصم 20%' : '20% Off',
        'distance': '1.5 km',
        'is_favorited': true,
        'category': 'Fashion',
      }));
    }

    AppLogger.debug('✅ [MOCK] Returned ${mockStores.length} favorited stores');
    return mockStores;
  }

  @override
  Future<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  }) async {
    AppLogger.debug('🎭 [MOCK] Toggling deal like (id: $dealId, type: $dealType)');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Toggle in-memory state
    final nowLiked = _likedProductIds.contains(dealId);
    if (nowLiked) {
      _likedProductIds.remove(dealId);
    } else {
      _likedProductIds.add(dealId);
    }

    final newState = !nowLiked;
    AppLogger.debug('✅ [MOCK] Deal like toggled: $newState');
    return newState;
  }

  @override
  Future<bool> toggleStoreFavorite({required String storeId}) async {
    AppLogger.debug('🎭 [MOCK] Toggling store favorite (id: $storeId)');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Toggle in-memory state
    final nowFavorited = _favoritedStoreIds.contains(storeId);
    if (nowFavorited) {
      _favoritedStoreIds.remove(storeId);
    } else {
      _favoritedStoreIds.add(storeId);
    }

    final newState = !nowFavorited;
    AppLogger.debug('✅ [MOCK] Store favorite toggled: $newState');
    return newState;
  }

  @override
  Future<void> migrateFavorites({
    required List<String> productIds,
    required List<String> storeIds,
  }) async {
    AppLogger.info('🎭 [MOCK] Starting favorites migration (products: ${productIds.length}, stores: ${storeIds.length})');

    // Simulate network delay for migration
    await Future.delayed(const Duration(milliseconds: 800));

    // Add all IDs to in-memory storage
    _likedProductIds.addAll(productIds);
    _favoritedStoreIds.addAll(storeIds);

    AppLogger.info('✅ [MOCK] Favorites migration completed');
  }

  // Test helper methods (for integration tests)

  /// Reset mock data to initial state
  void reset() {
    _likedProductIds.clear();
    _likedProductIds.addAll({'product_001', 'product_003'});
    _favoritedStoreIds.clear();
    _favoritedStoreIds.addAll({'store_002', 'store_005'});
  }

  /// Get current liked product IDs (for testing)
  Set<String> get likedProductIds => Set.from(_likedProductIds);

  /// Get current favorited store IDs (for testing)
  Set<String> get favoritedStoreIds => Set.from(_favoritedStoreIds);
}
