import '../models/deal_model.dart';

/// Mock data for deals/products
class DealsMockData {
  static List<DealModel> get deals => [
        // Nike Air Max - Featured Product from Figma
        const DealModel(
          id: '1',
          title: 'نايك إير ماكس 2025 أحذية للرجال (3 ألوان)',
          description: 'Nike Men\'s Air Max 2025 Shoes (3 Colors)',
          price: 399.99,
          originalPrice: 599.99,
          discountPercentage: 33,
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
          brand: 'Nike',
          rating: 4.8,
          reviewCount: 256,
          category: 'Fashion',
          isNew: false,
          isFeatured: true,
        ),

        // iPhone 16 Pro - From Figma
        const DealModel(
          id: '2',
          title: 'أعضاء برايم: 1 تيرابايت ابل ايفون 16 برو الذكي',
          description: 'Prime Members: 1TB Apple iPhone 16 Pro',
          price: 5499.99,
          originalPrice: 6299.99,
          discountPercentage: 13,
          imageUrl: 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=400',
          brand: 'Apple',
          rating: 4.9,
          reviewCount: 1024,
          category: 'Electronics',
          isNew: true,
          isFeatured: true,
        ),

        // Fashion Item
        const DealModel(
          id: '3',
          title: 'زارا فستان صيفي - مجموعة جديدة',
          description: 'Zara Summer Dress - New Collection',
          price: 249.99,
          originalPrice: 399.99,
          discountPercentage: 38,
          imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
          brand: 'Zara',
          rating: 4.6,
          reviewCount: 128,
          category: 'Fashion',
          isNew: true,
          isFeatured: false,
        ),

        // Electronics
        const DealModel(
          id: '4',
          title: 'سامسونج جالاكسي بودز برو 2',
          description: 'Samsung Galaxy Buds Pro 2 - Wireless Earbuds',
          price: 599.99,
          originalPrice: 899.99,
          discountPercentage: 33,
          imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
          brand: 'Samsung',
          rating: 4.7,
          reviewCount: 445,
          category: 'Electronics',
          isNew: false,
          isFeatured: true,
        ),

        // Beauty Product
        const DealModel(
          id: '5',
          title: 'لوريال باريس سيروم للوجه',
          description: 'L\'Oréal Paris Face Serum - Anti-Aging',
          price: 149.99,
          originalPrice: 249.99,
          discountPercentage: 40,
          imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
          brand: 'L\'Oréal',
          rating: 4.5,
          reviewCount: 89,
          category: 'Beauty',
          isNew: false,
          isFeatured: false,
        ),

        // Home & Lifestyle
        const DealModel(
          id: '6',
          title: 'ايكيا طاولة قهوة عصرية',
          description: 'IKEA Modern Coffee Table - Minimalist Design',
          price: 899.99,
          originalPrice: 1299.99,
          discountPercentage: 31,
          imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=400',
          brand: 'IKEA',
          rating: 4.4,
          reviewCount: 67,
          category: 'Lifestyle',
          isNew: false,
          isFeatured: false,
        ),

        // Jewelry
        const DealModel(
          id: '7',
          title: 'سواروفسكي عقد كريستال',
          description: 'Swarovski Crystal Necklace - Elegant Design',
          price: 799.99,
          originalPrice: 1299.99,
          discountPercentage: 38,
          imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400',
          brand: 'Swarovski',
          rating: 4.9,
          reviewCount: 234,
          category: 'Jewelry',
          isNew: true,
          isFeatured: true,
        ),

        // Sports & Outdoors
        const DealModel(
          id: '8',
          title: 'أديداس حذاء رياضي للجري',
          description: 'Adidas Running Shoes - Ultraboost 2025',
          price: 499.99,
          originalPrice: 699.99,
          discountPercentage: 29,
          imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
          brand: 'Adidas',
          rating: 4.7,
          reviewCount: 567,
          category: 'Fashion',
          isNew: false,
          isFeatured: true,
        ),

        // Tech Gadget
        const DealModel(
          id: '9',
          title: 'سوني سماعات لاسلكية WH-1000XM5',
          description: 'Sony Wireless Headphones WH-1000XM5 - Noise Cancelling',
          price: 1299.99,
          originalPrice: 1599.99,
          discountPercentage: 19,
          imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=400',
          brand: 'Sony',
          rating: 4.9,
          reviewCount: 892,
          category: 'Electronics',
          isNew: true,
          isFeatured: true,
        ),

        // Fashion Accessory
        const DealModel(
          id: '10',
          title: 'مايكل كورس حقيبة يد جلدية',
          description: 'Michael Kors Leather Handbag - Designer Collection',
          price: 1499.99,
          originalPrice: 2299.99,
          discountPercentage: 35,
          imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
          brand: 'Michael Kors',
          rating: 4.8,
          reviewCount: 156,
          category: 'Fashion',
          isNew: false,
          isFeatured: false,
        ),

        // Smart Watch
        const DealModel(
          id: '11',
          title: 'أبل واتش سيريز 9',
          description: 'Apple Watch Series 9 - GPS + Cellular',
          price: 1899.99,
          originalPrice: 2399.99,
          discountPercentage: 21,
          imageUrl: 'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=400',
          brand: 'Apple',
          rating: 4.8,
          reviewCount: 723,
          category: 'Electronics',
          isNew: true,
          isFeatured: true,
        ),

        // Gaming Console
        const DealModel(
          id: '12',
          title: 'بلايستيشن 5 - نسخة ديجيتال',
          description: 'PlayStation 5 Digital Edition + 2 Games',
          price: 1999.99,
          originalPrice: 2499.99,
          discountPercentage: 20,
          imageUrl: 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400',
          brand: 'Sony',
          rating: 4.9,
          reviewCount: 1567,
          category: 'Entertainment',
          isNew: false,
          isFeatured: true,
        ),

        // Perfume
        const DealModel(
          id: '13',
          title: 'ديور سوفاج عطر رجالي',
          description: 'Dior Sauvage Men\'s Fragrance - 100ml',
          price: 449.99,
          originalPrice: 599.99,
          discountPercentage: 25,
          imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400',
          brand: 'Dior',
          rating: 4.7,
          reviewCount: 345,
          category: 'Beauty',
          isNew: false,
          isFeatured: false,
        ),

        // Laptop
        const DealModel(
          id: '14',
          title: 'ماك بوك برو M3 - 14 انش',
          description: 'MacBook Pro M3 14" - 16GB RAM, 512GB SSD',
          price: 7999.99,
          originalPrice: 9499.99,
          discountPercentage: 16,
          imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
          brand: 'Apple',
          rating: 4.9,
          reviewCount: 456,
          category: 'Electronics',
          isNew: true,
          isFeatured: true,
        ),

        // Sunglasses
        const DealModel(
          id: '15',
          title: 'راي بان نظارات شمسية كلاسيك',
          description: 'Ray-Ban Classic Sunglasses - Polarized',
          price: 599.99,
          originalPrice: 899.99,
          discountPercentage: 33,
          imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
          brand: 'Ray-Ban',
          rating: 4.6,
          reviewCount: 234,
          category: 'Fashion',
          isNew: false,
          isFeatured: false,
        ),

        // Kitchen Appliance
        const DealModel(
          id: '16',
          title: 'كيتشن ايد خلاط كهربائي',
          description: 'KitchenAid Stand Mixer - Professional 600',
          price: 1299.99,
          originalPrice: 1799.99,
          discountPercentage: 28,
          imageUrl: 'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=400',
          brand: 'KitchenAid',
          rating: 4.8,
          reviewCount: 189,
          category: 'Lifestyle',
          isNew: false,
          isFeatured: false,
        ),

        // Camera
        const DealModel(
          id: '17',
          title: 'كانون EOS R6 كاميرا احترافية',
          description: 'Canon EOS R6 Full Frame Mirrorless Camera',
          price: 8999.99,
          originalPrice: 10999.99,
          discountPercentage: 18,
          imageUrl: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400',
          brand: 'Canon',
          rating: 4.9,
          reviewCount: 278,
          category: 'Electronics',
          isNew: true,
          isFeatured: true,
        ),

        // Backpack
        const DealModel(
          id: '18',
          title: 'نورث فيس حقيبة ظهر رياضية',
          description: 'The North Face Hiking Backpack - 40L',
          price: 449.99,
          originalPrice: 699.99,
          discountPercentage: 36,
          imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
          brand: 'The North Face',
          rating: 4.7,
          reviewCount: 456,
          category: 'Travel',
          isNew: false,
          isFeatured: false,
        ),

        // Smart Speaker
        const DealModel(
          id: '19',
          title: 'امازون ايكو دوت جيل 5',
          description: 'Amazon Echo Dot 5th Gen - Smart Speaker with Alexa',
          price: 199.99,
          originalPrice: 299.99,
          discountPercentage: 33,
          imageUrl: 'https://images.unsplash.com/photo-1589003077984-894e133dabab?w=400',
          brand: 'Amazon',
          rating: 4.5,
          reviewCount: 1234,
          category: 'Electronics',
          isNew: true,
          isFeatured: false,
        ),

        // Sneakers
        const DealModel(
          id: '20',
          title: 'بوما حذاء رياضي كاجوال',
          description: 'Puma Casual Sneakers - RS-X Collection',
          price: 349.99,
          originalPrice: 549.99,
          discountPercentage: 36,
          imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400',
          brand: 'Puma',
          rating: 4.6,
          reviewCount: 345,
          category: 'Fashion',
          isNew: false,
          isFeatured: false,
        ),
      ];

  /// Get featured deals
  static List<DealModel> get featuredDeals => deals.where((deal) => deal.isFeatured == true).toList();

  /// Get new deals
  static List<DealModel> get newDeals => deals.where((deal) => deal.isNew == true).toList();

  /// Get deals by category
  static List<DealModel> getDealsByCategory(String category) {
    if (category == 'All' || category == 'الكل') return deals;
    return deals.where((deal) => deal.category == category).toList();
  }

  /// Get hot deals (discount >= 30%)
  static List<DealModel> get hotDeals => deals.where((deal) => (deal.discountPercentage ?? 0) >= 30).toList();
}
