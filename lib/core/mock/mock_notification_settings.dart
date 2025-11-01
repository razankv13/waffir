/// Mock notification settings data for notification settings screen
///
/// This file contains mock data for demonstrating the notification settings UI.
/// In production, this data would come from a backend API or local storage.

class MockNotificationSettings {
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool newDealsEnabled;
  final bool newStoresEnabled;
  final bool favoriteStoresEnabled;
  final bool priceDropsEnabled;
  final bool expiringDealsEnabled;
  final bool weeklyDigestEnabled;
  final bool promotionalEmailsEnabled;
  final bool marketingEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const MockNotificationSettings({
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.newDealsEnabled = true,
    this.newStoresEnabled = true,
    this.favoriteStoresEnabled = true,
    this.priceDropsEnabled = true,
    this.expiringDealsEnabled = true,
    this.weeklyDigestEnabled = false,
    this.promotionalEmailsEnabled = false,
    this.marketingEnabled = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  MockNotificationSettings copyWith({
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? newDealsEnabled,
    bool? newStoresEnabled,
    bool? favoriteStoresEnabled,
    bool? priceDropsEnabled,
    bool? expiringDealsEnabled,
    bool? weeklyDigestEnabled,
    bool? promotionalEmailsEnabled,
    bool? marketingEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return MockNotificationSettings(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      newDealsEnabled: newDealsEnabled ?? this.newDealsEnabled,
      newStoresEnabled: newStoresEnabled ?? this.newStoresEnabled,
      favoriteStoresEnabled: favoriteStoresEnabled ?? this.favoriteStoresEnabled,
      priceDropsEnabled: priceDropsEnabled ?? this.priceDropsEnabled,
      expiringDealsEnabled: expiringDealsEnabled ?? this.expiringDealsEnabled,
      weeklyDigestEnabled: weeklyDigestEnabled ?? this.weeklyDigestEnabled,
      promotionalEmailsEnabled: promotionalEmailsEnabled ?? this.promotionalEmailsEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

/// Notification categories for grouping
class NotificationCategory {
  final String id;
  final String title;
  final String description;
  final bool isEnabled;

  const NotificationCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.isEnabled,
  });
}

/// Mock notification categories
final List<NotificationCategory> mockNotificationCategories = [
  const NotificationCategory(
    id: 'new_deals',
    title: 'New Deals',
    description: 'Get notified when new deals are available',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'new_stores',
    title: 'New Stores',
    description: 'Be the first to know when new stores join',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'favorite_stores',
    title: 'Favorite Stores',
    description: 'Updates from your favorite stores',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'price_drops',
    title: 'Price Drops',
    description: 'Get alerted when prices drop on saved deals',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'expiring_deals',
    title: 'Expiring Deals',
    description: 'Reminders for deals about to expire',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'weekly_digest',
    title: 'Weekly Digest',
    description: 'Weekly summary of best deals',
    isEnabled: false,
  ),
];

/// Mock notification categories in Arabic
final List<NotificationCategory> mockNotificationCategoriesArabic = [
  const NotificationCategory(
    id: 'new_deals',
    title: 'عروض جديدة',
    description: 'احصل على إشعار عند توفر عروض جديدة',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'new_stores',
    title: 'متاجر جديدة',
    description: 'كن أول من يعرف عند انضمام متاجر جديدة',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'favorite_stores',
    title: 'المتاجر المفضلة',
    description: 'تحديثات من متاجرك المفضلة',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'price_drops',
    title: 'انخفاض الأسعار',
    description: 'احصل على تنبيه عند انخفاض الأسعار على العروض المحفوظة',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'expiring_deals',
    title: 'العروض المنتهية',
    description: 'تذكيرات للعروض التي على وشك الانتهاء',
    isEnabled: true,
  ),
  const NotificationCategory(
    id: 'weekly_digest',
    title: 'الملخص الأسبوعي',
    description: 'ملخص أسبوعي لأفضل العروض',
    isEnabled: false,
  ),
];

/// Default mock notification settings
const MockNotificationSettings defaultMockNotificationSettings = MockNotificationSettings();

/// All notifications disabled (for testing)
const MockNotificationSettings allDisabledNotificationSettings = MockNotificationSettings(
  pushNotificationsEnabled: false,
  emailNotificationsEnabled: false,
  newDealsEnabled: false,
  newStoresEnabled: false,
  favoriteStoresEnabled: false,
  priceDropsEnabled: false,
  expiringDealsEnabled: false,
  weeklyDigestEnabled: false,
  promotionalEmailsEnabled: false,
  marketingEnabled: false,
  soundEnabled: false,
  vibrationEnabled: false,
);

/// All notifications enabled (for testing)
const MockNotificationSettings allEnabledNotificationSettings = MockNotificationSettings(
  pushNotificationsEnabled: true,
  emailNotificationsEnabled: true,
  newDealsEnabled: true,
  newStoresEnabled: true,
  favoriteStoresEnabled: true,
  priceDropsEnabled: true,
  expiringDealsEnabled: true,
  weeklyDigestEnabled: true,
  promotionalEmailsEnabled: true,
  marketingEnabled: true,
  soundEnabled: true,
  vibrationEnabled: true,
);
