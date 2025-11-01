import 'package:waffir/features/products/domain/entities/review.dart';

/// Mock review service for testing and development
class MockReviewService {
  static final MockReviewService _instance = MockReviewService._internal();
  factory MockReviewService() => _instance;
  MockReviewService._internal();

  /// Sample reviews data (bilingual: English & Arabic)
  final Map<String, List<Review>> _reviewsByProduct = {
    'prod_001': [
      Review(
        id: 'rev_001',
        productId: 'prod_001',
        userId: 'user_001',
        rating: 5.0,
        comment: 'Amazing shoes! Super comfortable and stylish. I wear them every day and get compliments all the time. Worth every riyal!',
        userName: 'Ahmed Al-Farsi',
        helpfulCount: 24,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        id: 'rev_002',
        productId: 'prod_001',
        userId: 'user_002',
        rating: 4.0,
        comment: 'جودة ممتازة ومريحة جداً. الحجم مناسب والتوصيل سريع. أنصح بالشراء!',
        userName: 'فاطمة السعيد',
        helpfulCount: 18,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Review(
        id: 'rev_003',
        productId: 'prod_001',
        userId: 'user_003',
        rating: 5.0,
        comment: 'Perfect fit! The Air Max cushioning is incredibly comfortable. These are my new favorite shoes.',
        userName: 'Sarah Johnson',
        helpfulCount: 31,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Review(
        id: 'rev_004',
        productId: 'prod_001',
        userId: 'user_004',
        rating: 4.5,
        comment: 'منتج رائع وسعر جيد مع الخصم. الجودة عالية والمقاس صحيح. شكراً لكم!',
        userName: 'محمد خالد',
        helpfulCount: 12,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ],
    'prod_002': [
      Review(
        id: 'rev_005',
        productId: 'prod_002',
        userId: 'user_005',
        rating: 4.0,
        comment: 'Good quality t-shirt. The fabric is soft and breathable. Great for workouts.',
        userName: 'Omar Hassan',
        helpfulCount: 8,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Review(
        id: 'rev_006',
        productId: 'prod_002',
        userId: 'user_006',
        rating: 4.5,
        comment: 'قماش ممتاز ومريح. مناسب للرياضة وخفيف جداً. أعجبني كثيراً!',
        userName: 'ليلى أحمد',
        helpfulCount: 5,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ],
    'prod_003': [
      Review(
        id: 'rev_007',
        productId: 'prod_003',
        userId: 'user_007',
        rating: 5.0,
        comment: 'Best phone I\'ve ever owned! The camera is absolutely incredible, battery lasts all day, and the S Pen is so useful. Worth the investment!',
        userName: 'Abdullah Rahman',
        helpfulCount: 45,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'rev_008',
        productId: 'prod_003',
        userId: 'user_008',
        rating: 4.5,
        comment: 'هاتف ممتاز! الكاميرا خيالية والأداء سريع جداً. القلم يضيف ميزات رائعة للإنتاجية.',
        userName: 'نورة العتيبي',
        helpfulCount: 38,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Review(
        id: 'rev_009',
        productId: 'prod_003',
        userId: 'user_009',
        rating: 5.0,
        comment: 'Absolutely love this phone! The display is stunning, performance is blazing fast, and the build quality is premium. Highly recommended!',
        userName: 'David Miller',
        helpfulCount: 52,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
    ],
    'prod_004': [
      Review(
        id: 'rev_010',
        productId: 'prod_004',
        userId: 'user_010',
        rating: 4.5,
        comment: 'Great smartwatch! Seamlessly integrates with my iPhone. Love the health tracking features.',
        userName: 'Khaled Ibrahim',
        helpfulCount: 15,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Review(
        id: 'rev_011',
        productId: 'prod_004',
        userId: 'user_011',
        rating: 5.0,
        comment: 'ساعة رائعة! تتبع صحتي بدقة والبطارية تدوم طويلاً. أفضل استثمار صحي!',
        userName: 'مريم السالم',
        helpfulCount: 22,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ],
    'prod_005': [
      Review(
        id: 'rev_012',
        productId: 'prod_005',
        userId: 'user_012',
        rating: 4.0,
        comment: 'Bold and comfortable! The colors are vibrant and the fit is perfect. Great value for money.',
        userName: 'Yousef Mansour',
        helpfulCount: 9,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Review(
        id: 'rev_013',
        productId: 'prod_005',
        userId: 'user_013',
        rating: 4.5,
        comment: 'حذاء جميل وألوانه جذابة. مريح للمشي ويناسب الاستخدام اليومي.',
        userName: 'سارة محمود',
        helpfulCount: 6,
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
      ),
    ],
  };

  /// Get reviews for a product
  Future<List<Review>> getProductReviews(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _reviewsByProduct[productId] ?? [];
  }

  /// Get average rating for a product
  Future<double?> getAverageRating(String productId) async {
    final reviews = await getProductReviews(productId);
    if (reviews.isEmpty) return null;

    final sum = reviews.fold<double>(0, (prev, review) => prev + review.rating);
    return sum / reviews.length;
  }

  /// Mark review as helpful
  Future<bool> markReviewHelpful(String reviewId, String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final reviews = _reviewsByProduct[productId];
    if (reviews == null) return false;

    final index = reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _reviewsByProduct[productId]![index] = reviews[index].copyWith(
        helpfulCount: reviews[index].helpfulCount + 1,
      );
      return true;
    }
    return false;
  }
}
