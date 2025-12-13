import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/features/deals/data/mock_data/alerts_mock_data.dart';
import 'package:waffir/features/deals/data/mock_data/deals_mock_data.dart';
import 'package:waffir/features/deals/data/mock_data/system_notifications_mock_data.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';
import 'package:waffir/features/deals/domain/entities/alert.dart';

/// Provider for all deals
final dealsProvider = Provider<List<DealModel>>((ref) {
  return DealsMockData.deals;
});

/// Provider for featured deals
final featuredDealsProvider = Provider<List<DealModel>>((ref) {
  return DealsMockData.featuredDeals;
});

/// Provider for new deals
final newDealsProvider = Provider<List<DealModel>>((ref) {
  return DealsMockData.newDeals;
});

/// Provider for hot deals (discount >= 30%)
final hotDealsProvider = Provider<List<DealModel>>((ref) {
  return DealsMockData.hotDeals;
});

/// Provider for deals by category
final dealsByCategoryProvider = Provider.family<List<DealModel>, String>((ref, category) {
  return DealsMockData.getDealsByCategory(category);
});

/// State notifier for selected category filter
class SelectedCategoryNotifier extends StateNotifier<String> {
  SelectedCategoryNotifier() : super('All');

  void selectCategory(String category) {
    state = category;
  }
}

/// Provider for selected category
final selectedCategoryProvider = StateNotifierProvider<SelectedCategoryNotifier, String>((ref) {
  return SelectedCategoryNotifier();
});

/// Provider for filtered deals based on selected category
final filteredDealsProvider = Provider<List<DealModel>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  return DealsMockData.getDealsByCategory(selectedCategory);
});

/// Provider for all alerts
final alertsProvider = Provider<List<Alert>>((ref) {
  return AlertsMockData.alerts;
});

/// Provider for popular alerts
final popularAlertsProvider = Provider<List<Alert>>((ref) {
  return AlertsMockData.popularAlerts;
});

/// Provider for subscribed alerts
final subscribedAlertsProvider = Provider<List<Alert>>((ref) {
  return AlertsMockData.subscribedAlerts;
});

/// Provider for deal notifications
final dealNotificationsProvider = Provider<List<DealNotification>>((ref) {
  return DealNotificationsMockData.notifications;
});

/// Provider for unread notifications count
final unreadNotificationsCountProvider = Provider<int>((ref) {
  return DealNotificationsMockData.unreadNotifications.length;
});

/// Provider for system notifications
final systemNotificationsProvider = Provider<List<SystemNotification>>((ref) {
  return SystemNotificationsMockData.notifications;
});

/// Provider for unread system notifications count
final unreadSystemNotificationsCountProvider = Provider<int>((ref) {
  return SystemNotificationsMockData.unreadNotifications.length;
});

/// State notifier for notifications screen filter toggle
class NotificationsFilterNotifier extends StateNotifier<bool> {
  NotificationsFilterNotifier() : super(true); // true = Deal Alerts, false = Notifications

  void showDealAlerts() => state = true;
  void showNotifications() => state = false;
}

/// Provider for notifications filter toggle
final notificationsFilterProvider = StateNotifierProvider<NotificationsFilterNotifier, bool>((ref) {
  return NotificationsFilterNotifier();
});
