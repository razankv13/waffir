import 'package:waffir/features/products/domain/entities/store.dart';

/// Mock store service for testing and development
class MockStoreService {
  MockStoreService._internal();
  factory MockStoreService() => _instance;
  static final MockStoreService _instance = MockStoreService._internal();

  /// Sample stores data (bilingual)
  final List<Store> _stores = [
    Store(
      id: 'store_001',
      name: 'Nike Official Store',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400',
      description:
          'Official Nike store offering the latest shoes, apparel, and accessories. Authorized retailer with authentic products and warranty.',
      rating: 4.7,
      reviewCount: 1542,
      followerCount: 25340,
      productIds: ['prod_001'],
      categories: ['Shoes', 'Apparel', 'Accessories'],
      location: 'Riyadh, Saudi Arabia',
      phoneNumber: '+966 11 234 5678',
      email: 'nike.sa@nike.com',
      website: 'https://www.nike.com/sa',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Store(
      id: 'store_002',
      name: 'Adidas Saudi Arabia',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1542219550-37153d387c27?w=400',
      description:
          'متجر أديداس الرسمي في السعودية. أفضل المنتجات الرياضية والأزياء العصرية. جودة عالمية وضمان معتمد.',
      rating: 4.6,
      reviewCount: 1289,
      followerCount: 18920,
      productIds: ['prod_002'],
      categories: ['Clothing', 'Shoes', 'Sports'],
      location: 'Jeddah, Saudi Arabia',
      phoneNumber: '+966 12 345 6789',
      email: 'info@adidas.sa',
      website: 'https://www.adidas.sa',
      isVerified: true,
      isFollowing: true,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
    Store(
      id: 'store_003',
      name: 'Tech Galaxy',
      category: 'Electronics',
      imageUrl: 'https://images.unsplash.com/photo-1611078489935-0cb964de46d6?w=400',
      description:
          'Your destination for the latest smartphones, tablets, and electronics. Authorized distributor for Samsung, Apple, and more.',
      rating: 4.8,
      reviewCount: 2156,
      followerCount: 42500,
      productIds: ['prod_003', 'prod_004'],
      categories: ['Electronics', 'Smartphones', 'Wearables'],
      location: 'Dammam, Saudi Arabia',
      phoneNumber: '+966 13 456 7890',
      email: 'support@techgalaxy.sa',
      website: 'https://www.techgalaxy.sa',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Store(
      id: 'store_004',
      name: 'Puma Arabia',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1542219550-37153d387c27?w=400',
      description:
          'متجر بوما الرسمي. أحذية رياضية وملابس عصرية للرجال والنساء. تصاميم عالمية وجودة مضمونة.',
      rating: 4.5,
      reviewCount: 892,
      followerCount: 12450,
      productIds: ['prod_005'],
      categories: ['Shoes', 'Sportswear'],
      location: 'Mecca, Saudi Arabia',
      phoneNumber: '+966 12 567 8901',
      email: 'hello@puma.sa',
      website: 'https://www.puma-saudi.com',
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Store(
      id: 'store_005',
      name: 'Fashion Hub',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
      description:
          'Multi-brand fashion store. Shop from top international and local brands all in one place. Fast delivery across KSA.',
      rating: 4.4,
      reviewCount: 1745,
      followerCount: 30120,
      productIds: [],
      categories: ['Fashion', 'Accessories', 'Shoes'],
      location: 'Riyadh, Saudi Arabia',
      phoneNumber: '+966 11 678 9012',
      email: 'contact@fashionhub.sa',
      website: 'https://www.fashionhub.sa',
      isVerified: true,
      isFollowing: true,
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  /// Get all stores
  Future<List<Store>> getAllStores() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _stores;
  }

  /// Get store by ID
  Future<Store?> getStoreById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _stores.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get stores by category
  Future<List<Store>> getStoresByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _stores.where((s) => s.categories.contains(category)).toList();
  }

  /// Search stores
  Future<List<Store>> searchStores(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowerQuery = query.toLowerCase();
    return _stores
        .where(
          (s) =>
              s.name.toLowerCase().contains(lowerQuery) ||
              (s.description?.toLowerCase().contains(lowerQuery) ?? false) ||
              s.categories.any((c) => c.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  /// Get popular stores
  Future<List<Store>> getPopularStores({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = List<Store>.from(_stores)
      ..sort((a, b) => b.followerCount.compareTo(a.followerCount));
    return sorted.take(limit).toList();
  }

  /// Toggle follow status
  Future<bool> toggleFollow(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _stores.indexWhere((s) => s.id == storeId);
    if (index != -1) {
      _stores[index] = _stores[index].copyWith(
        isFollowing: !_stores[index].isFollowing,
        followerCount: _stores[index].isFollowing
            ? _stores[index].followerCount - 1
            : _stores[index].followerCount + 1,
      );
      return _stores[index].isFollowing;
    }
    return false;
  }

  /// Get followed stores
  Future<List<Store>> getFollowedStores() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _stores.where((s) => s.isFollowing).toList();
  }
}
