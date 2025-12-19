import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waffir/features/products/data/services/mock_product_service.dart';
import 'package:waffir/features/products/data/services/mock_review_service.dart';
import 'package:waffir/features/products/data/services/mock_store_service.dart';
import 'package:waffir/features/products/domain/entities/product.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
import 'package:waffir/features/products/domain/entities/store.dart';

// ============================================================================
// SERVICE PROVIDERS
// ============================================================================

/// Mock product service provider
final mockProductServiceProvider = Provider<MockProductService>((ref) {
  return MockProductService();
});

/// Mock review service provider
final mockReviewServiceProvider = Provider<MockReviewService>((ref) {
  return MockReviewService();
});

/// Mock store service provider
final mockStoreServiceProvider = Provider<MockStoreService>((ref) {
  return MockStoreService();
});

// ============================================================================
// PRODUCT PROVIDERS
// ============================================================================

/// Get all products
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(mockProductServiceProvider);
  return await service.getAllProducts();
});

/// Get product by ID (Family provider)
final productByIdProvider = FutureProvider.family<Product?, String>((ref, productId) async {
  final service = ref.watch(mockProductServiceProvider);
  return await service.getProductById(productId);
});

/// Get featured products
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(mockProductServiceProvider);
  return await service.getFeaturedProducts();
});

/// Get products by category (Family provider)
final productsByCategoryProvider = FutureProvider.family<List<Product>, String>((ref, categoryId) async {
  final service = ref.watch(mockProductServiceProvider);
  return await service.getProductsByCategory(categoryId);
});

/// Search products (Family provider)
final searchProductsProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  final service = ref.watch(mockProductServiceProvider);
  return await service.searchProducts(query);
});

// ============================================================================
// REVIEW PROVIDERS
// ============================================================================

/// Get reviews for a product (Family provider)
final productReviewsProvider = FutureProvider.family<List<Review>, String>((ref, productId) async {
  final service = ref.watch(mockReviewServiceProvider);
  return await service.getProductReviews(productId);
});

/// Get average rating for a product (Family provider)
final productAverageRatingProvider = FutureProvider.family<double?, String>((ref, productId) async {
  final service = ref.watch(mockReviewServiceProvider);
  return await service.getAverageRating(productId);
});

// ============================================================================
// STORE PROVIDERS
// ============================================================================

/// Get all stores
final allStoresProvider = FutureProvider<List<Store>>((ref) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.getAllStores();
});

/// Get store by ID (Family provider)
final storeByIdProvider = FutureProvider.family<Store?, String>((ref, storeId) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.getStoreById(storeId);
});

/// Get popular stores
final popularStoresProvider = FutureProvider<List<Store>>((ref) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.getPopularStores();
});

/// Get stores by category (Family provider)
final storesByCategoryProvider = FutureProvider.family<List<Store>, String>((ref, category) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.getStoresByCategory(category);
});

/// Search stores (Family provider)
final searchStoresProvider = FutureProvider.family<List<Store>, String>((ref, query) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.searchStores(query);
});

/// Get followed stores
final followedStoresProvider = FutureProvider<List<Store>>((ref) async {
  final service = ref.watch(mockStoreServiceProvider);
  return await service.getFollowedStores();
});

// ============================================================================
// STATE NOTIFIER PROVIDERS (for mutable state)
// ============================================================================

