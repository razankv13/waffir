import 'package:waffir/features/products/domain/entities/product.dart';

/// Mock product service for testing and development
class MockProductService {
  static final MockProductService _instance = MockProductService._internal();
  factory MockProductService() => _instance;
  MockProductService._internal();

  /// Sample product data
  final List<Product> _products = [
    // Product 1 - Nike Shoes
    Product(
      id: 'prod_001',
      title: 'Nike Air Max 270',
      description: 'Experience ultimate comfort with the Nike Air Max 270. Featuring large Max Air unit for all-day cushioning and a sleek, modern design perfect for everyday wear.',
      price: 459.99,
      originalPrice: 599.99,
      discountPercentage: 23,
      imageUrls: [
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/7c5ba6ce-93de-42f0-af87-f21b47254eb8/air-max-270-shoes-2V5C4p.png',
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/awjogtdnqxniqqk0wpgf/air-max-270-shoes-2V5C4p.png',
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/i1-4434ae90-7c44-4c27-8e8c-424cbc2d47ba/air-max-270-shoes-2V5C4p.png',
      ],
      brand: 'Nike',
      categoryId: 'cat_shoes',
      rating: 4.5,
      reviewCount: 128,
      availableSizes: ['40', '41', '42', '43', '44', '45'],
      availableColors: ['Black', 'White', 'Red', 'Blue'],
      badge: 'SALE',
      badgeType: 'sale',
      stockQuantity: 25,
      isAvailable: true,
      isFeatured: true,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Product 2 - Adidas T-Shirt
    Product(
      id: 'prod_002',
      title: 'Adidas Performance T-Shirt',
      description: 'Stay cool and comfortable during workouts with this Adidas Performance T-Shirt. Made with breathable fabric and moisture-wicking technology.',
      price: 129.99,
      imageUrls: [
        'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8a2fc1c0d1094f12811fad5800ad7bb0_9366/Training_Essentials_Feelready_Logo_Tee_Black_HS6359_21_model.jpg',
        'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c6058cfcf7234f018b73ad5800ad7c21_9366/Training_Essentials_Feelready_Logo_Tee_Black_HS6359_25_model.jpg',
      ],
      brand: 'Adidas',
      categoryId: 'cat_clothing',
      rating: 4.2,
      reviewCount: 64,
      availableSizes: ['S', 'M', 'L', 'XL', 'XXL'],
      availableColors: ['Black', 'White', 'Navy', 'Gray'],
      badge: 'NEW',
      badgeType: 'newBadge',
      stockQuantity: 50,
      isAvailable: true,
      isFeatured: false,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // Product 3 - Samsung Phone
    Product(
      id: 'prod_003',
      title: 'Samsung Galaxy S24 Ultra',
      description: 'The ultimate smartphone experience. Featuring a stunning 6.8" AMOLED display, powerful Snapdragon 8 Gen 3 processor, 200MP camera, and S Pen for productivity.',
      price: 3999.99,
      originalPrice: 4499.99,
      discountPercentage: 11,
      imageUrls: [
        'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bzkcmea-thumb-539573129',
        'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bzkcmea-thumb-539573131',
        'https://images.samsung.com/is/image/samsung/p6pim/levant/2401/gallery/levant-galaxy-s24-ultra-s928-sm-s928bzkcmea-thumb-539573133',
      ],
      brand: 'Samsung',
      categoryId: 'cat_electronics',
      rating: 4.8,
      reviewCount: 256,
      availableSizes: [],
      availableColors: ['Titanium Black', 'Titanium Gray', 'Titanium Violet'],
      stockQuantity: 15,
      isAvailable: true,
      isFeatured: true,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // Product 4 - Apple Watch
    Product(
      id: 'prod_004',
      title: 'Apple Watch Series 9',
      description: 'Your essential companion. Stay connected, active, and healthy. Features advanced health sensors, crash detection, and seamless Apple ecosystem integration.',
      price: 1599.99,
      imageUrls: [
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MRX43ref_VW_34FR+watch-45-alum-midnight-nc-s9_VW_34FR_WF_CO?wid=1400&hei=1400&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1694507270678%2C1694895924116',
      ],
      brand: 'Apple',
      categoryId: 'cat_electronics',
      rating: 4.7,
      reviewCount: 189,
      availableSizes: ['41mm', '45mm'],
      availableColors: ['Midnight', 'Starlight', 'Silver'],
      badge: 'FEATURED',
      badgeType: 'featured',
      stockQuantity: 8,
      isAvailable: true,
      isFeatured: true,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
    ),

    // Product 5 - Puma Sneakers
    Product(
      id: 'prod_005',
      title: 'Puma RS-X Reinvention',
      description: 'Bold design meets comfort. The RS-X Reinvention features a chunky silhouette with modern materials and vibrant colorways for a standout look.',
      price: 349.99,
      originalPrice: 449.99,
      discountPercentage: 22,
      imageUrls: [
        'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/371008/75/sv01/fnd/PNA/fmt/png/RS-X-Reinvention-Sneakers',
      ],
      brand: 'Puma',
      categoryId: 'cat_shoes',
      rating: 4.3,
      reviewCount: 92,
      availableSizes: ['38', '39', '40', '41', '42', '43'],
      availableColors: ['White/Red', 'Black/Yellow', 'Blue/Green'],
      badge: 'SALE',
      badgeType: 'sale',
      stockQuantity: 3,
      isAvailable: true,
      isFeatured: false,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  /// Get all products
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API delay
    return _products;
  }

  /// Get product by ID
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  /// Search products
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowerQuery = query.toLowerCase();
    return _products.where((p) =>
      p.title.toLowerCase().contains(lowerQuery) ||
      (p.brand?.toLowerCase().contains(lowerQuery) ?? false) ||
      p.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  /// Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((p) => p.isFeatured).toList();
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        isFavorite: !_products[index].isFavorite,
      );
      return _products[index].isFavorite;
    }
    return false;
  }
}
