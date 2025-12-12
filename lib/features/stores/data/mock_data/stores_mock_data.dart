import 'package:waffir/features/stores/data/models/store_model.dart';

/// Mock data for stores
class StoresMockData {
  static List<StoreModel> get stores => [
        // Near You - Stores
    const StoreModel(
      id: '1',
      name: 'Nike Store',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400',
      description: 'Athletic footwear and apparel',
      address: 'Riyadh Park Mall, Riyadh',
      distance: '1.2 km',
      rating: 4.8,
      reviewCount: 256,
      phoneNumber: '+966 11 234 5678',
      location: 'Riyadh Park Mall, Riyadh',
      discountText: '20% off',
    ),

    const StoreModel(
      id: '2',
      name: 'Zara',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
      description: 'Contemporary fashion',
      address: 'Granada Mall, Riyadh',
      distance: '2.5 km',
      rating: 4.6,
      reviewCount: 189,
      location: 'Granada Mall, Riyadh',
      discountText: '30% - 70% off',
    ),

        const StoreModel(
          id: '3',
          name: 'Apple Store',
          category: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1611078489935-0cb964de46d6?w=400',
          description: 'Premium electronics and accessories',
          address: 'Kingdom Centre, Riyadh',
          distance: '3.1 km',
          rating: 4.9,
          reviewCount: 445,
          location: 'Kingdom Centre, Riyadh',
        ),

        const StoreModel(
          id: '4',
          name: 'Sephora',
          category: 'Beauty',
          imageUrl: 'https://images.unsplash.com/photo-1583241800698-b4422936c7d2?w=400',
          description: 'Beauty and cosmetics',
          address: 'Panorama Mall, Riyadh',
          distance: '1.8 km',
          rating: 4.7,
          reviewCount: 234,
          location: 'Panorama Mall, Riyadh',
        ),

        const StoreModel(
          id: '5',
          name: 'Starbucks',
          category: 'Dining',
          imageUrl: 'https://images.unsplash.com/photo-1453614512568-c4024d13c247?w=400',
          description: 'Coffee and beverages',
          address: 'Tahlia Street, Riyadh',
          distance: '0.8 km',
          rating: 4.5,
          reviewCount: 567,
          location: 'Tahlia Street, Riyadh',
        ),

        // Mall Stores
    const StoreModel(
      id: '6',
      name: 'H&M',
      category: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=400',
      description: 'Fashion and quality at the best price',
      address: 'Al Nakheel Mall',
      distance: '4.2 km',
      rating: 4.6,
      reviewCount: 178,
      location: 'Al Nakheel Mall',
      discountText: 'Buy 1 Get 1',
    ),

        const StoreModel(
          id: '7',
          name: 'Samsung Store',
          category: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400',
          description: 'Latest Samsung devices',
          address: 'Riyadh Gallery',
          distance: '5.1 km',
          rating: 4.7,
          reviewCount: 289,
          location: 'Riyadh Gallery',
        ),

        const StoreModel(
          id: '8',
          name: 'MAC Cosmetics',
          category: 'Beauty',
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
          description: 'Professional makeup',
          address: 'Kingdom Centre',
          distance: '3.2 km',
          rating: 4.8,
          reviewCount: 156,
          location: 'Kingdom Centre',
        ),

        const StoreModel(
          id: '9',
          name: 'Jarir Bookstore',
          category: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          description: 'Books, electronics, and office supplies',
          address: 'Granada Mall',
          distance: '2.7 km',
          rating: 4.6,
          reviewCount: 234,
          location: 'Granada Mall',
        ),

        const StoreModel(
          id: '10',
          name: 'The Cheesecake Factory',
          category: 'Dining',
          imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
          description: 'American restaurant',
          address: 'Kingdom Centre',
          distance: '3.3 km',
          rating: 4.7,
          reviewCount: 678,
          location: 'Kingdom Centre',
        ),

        const StoreModel(
          id: '11',
          name: 'IKEA',
          category: 'Lifestyle',
          imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
          description: 'Furniture and home accessories',
          address: 'Exit 10, Riyadh',
          distance: '8.5 km',
          rating: 4.8,
          reviewCount: 567,
          location: 'Exit 10, Riyadh',
        ),

        const StoreModel(
          id: '12',
          name: 'Pandora',
          category: 'Jewelry',
          imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
          description: 'Hand-finished jewelry',
          address: 'Panorama Mall',
          distance: '2.0 km',
          rating: 4.7,
          reviewCount: 123,
          location: 'Panorama Mall',
        ),

        const StoreModel(
          id: '13',
          name: 'VOX Cinemas',
          category: 'Entertainment',
          imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400',
          description: 'Movie theater',
          address: 'Riyadh Park',
          distance: '1.5 km',
          rating: 4.6,
          reviewCount: 891,
          location: 'Riyadh Park',
        ),

        const StoreModel(
          id: '14',
          name: 'Adidas',
          category: 'Fashion',
          imageUrl: 'https://images.unsplash.com/photo-1542219550-37153d387c27?w=400',
          description: 'Sports apparel and shoes',
          address: 'Al Nakheel Mall',
          distance: '4.3 km',
          rating: 4.7,
          reviewCount: 234,
          location: 'Al Nakheel Mall',
        ),

        const StoreModel(
          id: '15',
          name: 'Carrefour',
          category: 'Lifestyle',
          imageUrl: 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=400',
          description: 'Hypermarket',
          address: 'Granada Mall',
          distance: '2.6 km',
          rating: 4.5,
          reviewCount: 456,
          location: 'Granada Mall',
        ),
      ];

  /// Get stores near you
  static List<StoreModel> get nearYouStores => stores.take(5).toList();

  /// Get mall stores
  static List<StoreModel> get mallStores => stores.skip(5).toList();

  /// Get stores by category
  static List<StoreModel> getStoresByCategory(String category) {
    if (category == 'All' || category == 'الكل') return stores;
    return stores.where((store) => store.category == category).toList();
  }

  /// Get stores by location/mall name
  static List<StoreModel> getStoresByMall(String mallName) {
    return stores.where((store) =>
      store.location?.contains(mallName) ?? false).toList();
  }
}
