import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/products/domain/entities/category.dart';
import 'package:waffir/features/products/domain/entities/product.dart';
import 'package:waffir/features/products/domain/entities/review.dart';

/// Repository interface for product operations
abstract class ProductRepository {
  /// Get all products with optional filtering
  AsyncResult<List<Product>> getProducts({
    String? categoryId,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Get a single product by ID
  AsyncResult<Product> getProductById(String productId);

  /// Get featured products
  AsyncResult<List<Product>> getFeaturedProducts({int? limit});

  /// Get products on sale
  AsyncResult<List<Product>> getSaleProducts({int? limit});

  /// Search products by query
  AsyncResult<List<Product>> searchProducts(String query);

  /// Get all categories
  AsyncResult<List<Category>> getCategories();

  /// Get products by category
  AsyncResult<List<Product>> getProductsByCategory(
    String categoryId, {
    int? limit,
    int? offset,
  });

  /// Get product reviews
  AsyncResult<List<Review>> getProductReviews(
    String productId, {
    int? limit,
    int? offset,
  });

  /// Add product review
  AsyncResult<Review> addProductReview({
    required String productId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
  });

  /// Toggle product favorite status
  AsyncResult<bool> toggleFavorite(String productId);

  /// Get user's favorite products
  AsyncResult<List<Product>> getFavoriteProducts();
}
