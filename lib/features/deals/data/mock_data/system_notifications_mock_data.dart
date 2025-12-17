/// System notification types for activity feed
enum SystemNotificationType {
  subscription,
  priceDrop,
  newDeal,
  storeUpdate,
  paymentSuccess,
  deliveryUpdate,
  general,
}

/// System notification model for activity feed
class SystemNotification {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isRead;
  final SystemNotificationType type;
  final String iconAssetPath;

  const SystemNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isRead,
    required this.type,
    required this.iconAssetPath,
  });

  /// Get formatted time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Mock data for system notifications
class SystemNotificationsMockData {
  static List<SystemNotification> get notifications => [
        SystemNotification(
          id: 'sn1',
          title: 'Premium subscription renewed',
          subtitle: 'Your monthly subscription has been renewed successfully',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
          type: SystemNotificationType.subscription,
          iconAssetPath: 'assets/icons/bolt.svg',
        ),
        SystemNotification(
          id: 'sn2',
          title: 'Price drop alert',
          subtitle: 'Samsung Galaxy Buds Pro 2 dropped to SAR 599',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
          type: SystemNotificationType.priceDrop,
          iconAssetPath: 'assets/icons/tag.svg',
        ),
        SystemNotification(
          id: 'sn3',
          title: 'New deal available',
          subtitle: 'Nike Air Max 2025 - Limited time offer at 33% off',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
          type: SystemNotificationType.newDeal,
          iconAssetPath: 'assets/icons/bolt.svg',
        ),
        SystemNotification(
          id: 'sn4',
          title: 'Payment successful',
          subtitle: 'Your payment of SAR 249.99 was processed successfully',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          isRead: true,
          type: SystemNotificationType.paymentSuccess,
          iconAssetPath: 'assets/icons/riyal.svg',
        ),
        SystemNotification(
          id: 'sn5',
          title: 'Zara store updates',
          subtitle: 'New summer collection now available with exclusive deals',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          type: SystemNotificationType.storeUpdate,
          iconAssetPath: 'assets/icons/store_detail/store_icon.svg',
        ),
        SystemNotification(
          id: 'sn6',
          title: 'Deal alert subscribed',
          subtitle: 'You are now subscribed to Electronics Sale Alerts',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          isRead: true,
          type: SystemNotificationType.subscription,
          iconAssetPath: 'assets/icons/notification_bell.svg',
        ),
        SystemNotification(
          id: 'sn7',
          title: 'Price drop on your wishlist',
          subtitle: 'Apple iPhone 16 Pro is now 13% off',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          type: SystemNotificationType.priceDrop,
          iconAssetPath: 'assets/icons/tag.svg',
        ),
        SystemNotification(
          id: 'sn8',
          title: 'Welcome to Waffir',
          subtitle: 'Start exploring amazing deals and save on your purchases',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          type: SystemNotificationType.general,
          iconAssetPath: 'assets/icons/notification_bell.svg',
        ),
        SystemNotification(
          id: 'sn9',
          title: 'Beauty Week started',
          subtitle: 'L\'Oréal premium skincare at 40% off - Limited time',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
          isRead: true,
          type: SystemNotificationType.newDeal,
          iconAssetPath: 'assets/icons/bolt.svg',
        ),
        SystemNotification(
          id: 'sn10',
          title: 'Flash sale ending soon',
          subtitle: 'Weekend flash sales end in 2 hours - Don\'t miss out',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          isRead: true,
          type: SystemNotificationType.newDeal,
          iconAssetPath: 'assets/icons/bolt.svg',
        ),
        SystemNotification(
          id: 'sn11',
          title: 'Nike store updates',
          subtitle: 'New arrivals and exclusive member offers now available',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          isRead: true,
          type: SystemNotificationType.storeUpdate,
          iconAssetPath: 'assets/icons/store_detail/store_icon.svg',
        ),
        SystemNotification(
          id: 'sn12',
          title: 'Payment reminder',
          subtitle: 'Your subscription payment is due in 3 days',
          timestamp: DateTime.now().subtract(const Duration(days: 6)),
          isRead: true,
          type: SystemNotificationType.subscription,
          iconAssetPath: 'assets/icons/riyal.svg',
        ),
      ];

  /// Get unread notifications
  static List<SystemNotification> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  /// Get read notifications
  static List<SystemNotification> get readNotifications =>
      notifications.where((n) => n.isRead).toList();
}



