import 'package:waffir/features/products/domain/entities/product.dart';
import 'package:waffir/features/products/domain/entities/store.dart';

/// Repository interface for Store operations
abstract class StoreRepository {
  /// Get store by ID
  Future<Store?> getStoreById(String id);

  /// Get all stores
  Future<List<Store>> getAllStores();

  /// Get stores by category
  Future<List<Store>> getStoresByCategory(String category);

  /// Get products by store ID
  Future<List<Product>> getStoreProducts(String storeId);

  /// Search stores by name
  Future<List<Store>> searchStores(String query);

  /// Toggle follow status for a store
  Future<bool> toggleFollow(String storeId, bool isFollowing);

  /// Get followed stores
  Future<List<Store>> getFollowedStores();

  /// Get popular stores
  Future<List<Store>> getPopularStores({int limit = 10});
}
