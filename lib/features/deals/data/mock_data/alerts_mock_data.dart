import 'package:waffir/features/deals/domain/entities/alert.dart';

/// Mock data for alerts
class AlertsMockData {
  static List<Alert> get alerts => [
        // Popular Alerts
        Alert(
          id: '1',
          title: 'Electronics Sale Alerts',
          description: 'Get notified when electronics go on sale',
          type: AlertType.categoryAlert,
          category: 'Electronics',
          isSubscribed: false,
          subscriberCount: 2567,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),

        Alert(
          id: '2',
          title: 'Fashion Deals',
          description: 'Exclusive fashion deals and discounts',
          type: AlertType.categoryAlert,
          category: 'Fashion',
          isSubscribed: true,
          subscriberCount: 3456,
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),

        Alert(
          id: '3',
          title: 'Nike Store Updates',
          description: 'New arrivals and offers from Nike',
          type: AlertType.storeAlert,
          category: 'Fashion',
          isSubscribed: false,
          subscriberCount: 1890,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),

        Alert(
          id: '4',
          title: 'Apple Product Launches',
          description: 'Be the first to know about new Apple products',
          type: AlertType.newProduct,
          category: 'Electronics',
          isSubscribed: true,
          subscriberCount: 5678,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),

        Alert(
          id: '5',
          title: 'Beauty & Cosmetics Deals',
          description: 'Sephora, MAC, and more beauty deals',
          type: AlertType.categoryAlert,
          category: 'Beauty',
          isSubscribed: false,
          subscriberCount: 1234,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),

        Alert(
          id: '6',
          title: 'Price Drop Alerts',
          description: 'Track price drops on your wishlist items',
          type: AlertType.priceDrop,
          isSubscribed: true,
          subscriberCount: 4567,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),

        Alert(
          id: '7',
          title: 'Weekend Flash Sales',
          description: 'Special weekend deals and flash sales',
          type: AlertType.deal,
          isSubscribed: false,
          subscriberCount: 3890,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),

        Alert(
          id: '8',
          title: 'Zara New Collection',
          description: 'Latest fashion collections from Zara',
          type: AlertType.storeAlert,
          category: 'Fashion',
          isSubscribed: false,
          subscriberCount: 2345,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),

        Alert(
          id: '9',
          title: 'Dining Offers',
          description: 'Restaurant deals and dining discounts',
          type: AlertType.categoryAlert,
          category: 'Dining',
          isSubscribed: true,
          subscriberCount: 1567,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        Alert(
          id: '10',
          title: 'Jewelry Sale Alerts',
          description: 'Pandora, Swarovski, and luxury jewelry deals',
          type: AlertType.categoryAlert,
          category: 'Jewelry',
          isSubscribed: false,
          subscriberCount: 890,
          createdAt: DateTime.now(),
        ),
      ];

  /// Get subscribed alerts
  static List<Alert> get subscribedAlerts => alerts.where((alert) => alert.isSubscribed == true).toList();

  /// Get popular alerts (> 100 subscribers)
  static List<Alert> get popularAlerts => alerts.where((alert) => alert.isPopular).toList();

  /// Get alerts by category
  static List<Alert> getAlertsByCategory(String category) {
    return alerts.where((alert) => alert.category == category).toList();
  }

  /// Get alerts by type
  static List<Alert> getAlertsByType(AlertType type) {
    return alerts.where((alert) => alert.type == type).toList();
  }
}

/// Mock notification data for deal alerts
class DealNotificationsMockData {
  static List<DealNotification> get notifications => [
        DealNotification(
          id: 'n1',
          title: 'Nike Air Max 2025 - 33% OFF!',
          description: 'Your favorite Nike shoes are now on sale. Limited time offer!',
          dealId: '1',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
        ),

        DealNotification(
          id: 'n2',
          title: 'iPhone 16 Pro Available Now',
          description: 'Prime Members: Get the latest iPhone with exclusive discount',
          dealId: '2',
          imageUrl: 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=400',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
        ),

        DealNotification(
          id: 'n3',
          title: 'Zara Summer Collection - 38% OFF',
          description: 'New summer dresses are here with amazing discounts',
          dealId: '3',
          imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),

        DealNotification(
          id: 'n4',
          title: 'Samsung Galaxy Buds Pro 2 Deal',
          description: 'Save 33% on premium wireless earbuds',
          dealId: '4',
          imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
        ),

        DealNotification(
          id: 'n5',
          title: 'Beauty Week - L\'Oréal 40% OFF',
          description: 'Premium skincare at unbeatable prices',
          dealId: '5',
          imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
        ),
      ];

  /// Get unread notifications
  static List<DealNotification> get unreadNotifications => notifications.where((n) => !n.isRead).toList();

  /// Get read notifications
  static List<DealNotification> get readNotifications => notifications.where((n) => n.isRead).toList();
}

/// Deal notification model
class DealNotification {
  final String id;
  final String title;
  final String description;
  final String dealId;
  final String imageUrl;
  final DateTime timestamp;
  final bool isRead;

  DealNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.dealId,
    required this.imageUrl,
    required this.timestamp,
    required this.isRead,
  });

  /// Get formatted time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
