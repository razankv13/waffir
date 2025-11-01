/// Mock user data for profile screens
///
/// This file contains mock data for demonstrating the profile UI/UX.
/// In production, this data would come from a backend API or local storage.

class MockUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? birthday;
  final String? avatarUrl;
  final String city;
  final String gender;
  final bool isPremium;
  final String subscriptionPlan;
  final DateTime? subscriptionExpiryDate;

  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthday,
    this.avatarUrl,
    required this.city,
    this.gender = 'Not specified',
    this.isPremium = false,
    this.subscriptionPlan = 'Free',
    this.subscriptionExpiryDate,
  });

  MockUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? birthday,
    String? avatarUrl,
    String? city,
    String? gender,
    bool? isPremium,
    String? subscriptionPlan,
    DateTime? subscriptionExpiryDate,
  }) {
    return MockUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      isPremium: isPremium ?? this.isPremium,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
    );
  }
}

/// Mock user instances for testing

// Default free user (English)
final mockUserFree = MockUser(
  id: '1',
  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '+1 234 567 8900',
  birthday: '1990-05-15',
  city: 'Riyadh',
  gender: 'Male',
  isPremium: false,
  subscriptionPlan: 'Free',
);

// Premium user (English)
final mockUserPremium = MockUser(
  id: '2',
  name: 'Sarah Johnson',
  email: 'sarah.johnson@example.com',
  phone: '+1 555 123 4567',
  birthday: '1985-08-22',
  avatarUrl: 'https://i.pravatar.cc/150?img=1',
  city: 'Jeddah',
  gender: 'Female',
  isPremium: true,
  subscriptionPlan: 'Premium Monthly',
  subscriptionExpiryDate: DateTime.now().add(const Duration(days: 25)),
);

// Arabic user (from Figma)
final mockUserArabic = MockUser(
  id: '3',
  name: 'محمد مو',
  email: 'Mohd.moe@example.com',
  phone: '+966 50 123 4567',
  birthday: '1992-03-10',
  avatarUrl: 'https://i.pravatar.cc/150?img=12',
  city: 'الرياض', // Riyadh in Arabic
  gender: 'ذكر', // Male in Arabic
  isPremium: true,
  subscriptionPlan: 'Premium Yearly',
  subscriptionExpiryDate: DateTime.now().add(const Duration(days: 340)),
);

// User with no avatar
final mockUserNoAvatar = MockUser(
  id: '4',
  name: 'Alex Smith',
  email: 'alex.smith@example.com',
  city: 'Dammam',
  isPremium: false,
  subscriptionPlan: 'Free',
);

/// Default mock user for the app (can be changed based on testing needs)
MockUser get currentMockUser => mockUserPremium;

/// Cities available in the app
final List<String> mockCities = [
  'Riyadh',
  'Jeddah',
  'Mecca',
  'Medina',
  'Dammam',
  'Khobar',
  'Dhahran',
  'Abha',
  'Tabuk',
  'Buraidah',
  'Khamis Mushait',
  'Hofuf',
  'Taif',
  'Najran',
  'Jubail',
  'Al Qatif',
  'Yanbu',
  'Al Hasa',
  'Al Kharj',
  'Arar',
];

/// Cities in Arabic
final List<String> mockCitiesArabic = [
  'الرياض',
  'جدة',
  'مكة المكرمة',
  'المدينة المنورة',
  'الدمام',
  'الخبر',
  'الظهران',
  'أبها',
  'تبوك',
  'بريدة',
  'خميس مشيط',
  'الهفوف',
  'الطائف',
  'نجران',
  'الجبيل',
  'القطيف',
  'ينبع',
  'الأحساء',
  'الخرج',
  'عرعر',
];

/// Gender options
final List<String> mockGenderOptions = [
  'Male',
  'Female',
  'Other',
  'Prefer not to say',
];

/// Gender options in Arabic
final List<String> mockGenderOptionsArabic = [
  'ذكر',
  'أنثى',
  'آخر',
  'أفضل عدم الإفصاح',
];
