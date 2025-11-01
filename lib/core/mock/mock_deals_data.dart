/// Mock deals data for saved deals screen
///
/// This file contains mock data for demonstrating the saved deals UI.
/// In production, this data would come from a backend API or local storage.

class MockDeal {
  final String id;
  final String title;
  final String store;
  final String discount;
  final String? imageUrl;
  final bool isSaved;
  final DateTime expiryDate;
  final String? category;
  final String? description;
  final List<String> eligibleBanks;

  const MockDeal({
    required this.id,
    required this.title,
    required this.store,
    required this.discount,
    this.imageUrl,
    this.isSaved = false,
    required this.expiryDate,
    this.category,
    this.description,
    this.eligibleBanks = const [],
  });

  MockDeal copyWith({
    String? id,
    String? title,
    String? store,
    String? discount,
    String? imageUrl,
    bool? isSaved,
    DateTime? expiryDate,
    String? category,
    String? description,
    List<String>? eligibleBanks,
  }) {
    return MockDeal(
      id: id ?? this.id,
      title: title ?? this.title,
      store: store ?? this.store,
      discount: discount ?? this.discount,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaved: isSaved ?? this.isSaved,
      expiryDate: expiryDate ?? this.expiryDate,
      category: category ?? this.category,
      description: description ?? this.description,
      eligibleBanks: eligibleBanks ?? this.eligibleBanks,
    );
  }
}

/// Mock saved deals for the user
final List<MockDeal> mockSavedDeals = [
  MockDeal(
    id: '1',
    title: '50% Off on Electronics',
    store: 'Extra',
    discount: '50%',
    imageUrl: 'https://picsum.photos/400/300?random=1',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 7)),
    category: 'Electronics',
    description: 'Get 50% off on selected electronics items',
    eligibleBanks: ['Al Rajhi Bank', 'SNB', 'Riyad Bank'],
  ),
  MockDeal(
    id: '2',
    title: 'Buy 1 Get 1 Free - Fashion',
    store: 'Zara',
    discount: 'BOGO',
    imageUrl: 'https://picsum.photos/400/300?random=2',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 14)),
    category: 'Fashion',
    description: 'Buy one item and get another free on selected fashion items',
    eligibleBanks: ['Alinma Bank', 'Al Rajhi Bank'],
  ),
  MockDeal(
    id: '3',
    title: '30% Off on Dining',
    store: 'The Cheesecake Factory',
    discount: '30%',
    imageUrl: 'https://picsum.photos/400/300?random=3',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 3)),
    category: 'Dining',
    description: 'Enjoy 30% discount on your total bill',
    eligibleBanks: ['Riyad Bank', 'SNB'],
  ),
  MockDeal(
    id: '4',
    title: 'Free Delivery on Orders Above SAR 200',
    store: 'Noon',
    discount: 'Free Delivery',
    imageUrl: 'https://picsum.photos/400/300?random=4',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 30)),
    category: 'Online Shopping',
    description: 'Free delivery on all orders above SAR 200',
    eligibleBanks: ['All Banks'],
  ),
  MockDeal(
    id: '5',
    title: '40% Off on Home Appliances',
    store: 'Jarir Bookstore',
    discount: '40%',
    imageUrl: 'https://picsum.photos/400/300?random=5',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 10)),
    category: 'Home & Garden',
    description: 'Get 40% discount on home appliances',
    eligibleBanks: ['Al Rajhi Bank', 'Alinma Bank', 'SNB'],
  ),
  MockDeal(
    id: '6',
    title: '20% Cash Back on Grocery',
    store: 'Carrefour',
    discount: '20% Cashback',
    imageUrl: 'https://picsum.photos/400/300?random=6',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 5)),
    category: 'Grocery',
    description: 'Get 20% cash back on grocery shopping',
    eligibleBanks: ['Riyad Bank'],
  ),
];

/// Mock deals in Arabic (for RTL testing)
final List<MockDeal> mockSavedDealsArabic = [
  MockDeal(
    id: '1',
    title: 'خصم 50٪ على الإلكترونيات',
    store: 'إكسترا',
    discount: '50%',
    imageUrl: 'https://picsum.photos/400/300?random=1',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 7)),
    category: 'إلكترونيات',
    description: 'احصل على خصم 50٪ على العناصر الإلكترونية المختارة',
    eligibleBanks: ['مصرف الراجحي', 'البنك الأهلي', 'بنك الرياض'],
  ),
  MockDeal(
    id: '2',
    title: 'اشترِ واحدة واحصل على الثانية مجانًا - أزياء',
    store: 'زارا',
    discount: 'BOGO',
    imageUrl: 'https://picsum.photos/400/300?random=2',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 14)),
    category: 'أزياء',
    description: 'اشترِ عنصرًا واحصل على آخر مجانًا على عناصر الأزياء المختارة',
    eligibleBanks: ['مصرف الإنماء', 'مصرف الراجحي'],
  ),
  MockDeal(
    id: '3',
    title: 'خصم 30٪ على المطاعم',
    store: 'ذا تشيز كيك فاكتوري',
    discount: '30%',
    imageUrl: 'https://picsum.photos/400/300?random=3',
    isSaved: true,
    expiryDate: DateTime.now().add(const Duration(days: 3)),
    category: 'مطاعم',
    description: 'استمتع بخصم 30٪ على إجمالي فاتورتك',
    eligibleBanks: ['بنك الرياض', 'البنك الأهلي'],
  ),
];

/// Categories for filtering
final List<String> mockDealCategories = [
  'All',
  'Electronics',
  'Fashion',
  'Dining',
  'Grocery',
  'Home & Garden',
  'Online Shopping',
  'Travel',
  'Entertainment',
  'Health & Beauty',
];

/// Categories in Arabic
final List<String> mockDealCategoriesArabic = [
  'الكل',
  'إلكترونيات',
  'أزياء',
  'مطاعم',
  'بقالة',
  'منزل وحديقة',
  'تسوق عبر الإنترنت',
  'سفر',
  'ترفيه',
  'صحة وجمال',
];
