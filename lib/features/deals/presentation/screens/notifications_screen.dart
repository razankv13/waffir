import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/widgets/cards/deal_card.dart';
import 'package:waffir/core/widgets/cards/alert_card.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';

/// Notifications & Alerts Screen - displays deal notifications and popular alerts
///
/// Features:
/// - Two tabs: Notifications and Alerts
/// - Notifications tab shows deal notifications with read/unread status
/// - Alerts tab shows popular alerts with subscribe functionality
/// - Badge shows unread notifications count
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifications = ref.watch(dealNotificationsProvider);
    final alerts = ref.watch(popularAlertsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications & Alerts',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Notifications'),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(text: 'Alerts'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Notifications Tab
          _buildNotificationsTab(context, notifications),

          // Alerts Tab
          _buildAlertsTab(context, alerts),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(
    BuildContext context,
    List<dynamic> notifications,
  ) {
    if (notifications.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.notifications_outlined,
        title: 'No notifications',
        message: 'You don\'t have any notifications yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return DealCard(
          title: notification.title,
          description: notification.description,
          imageUrl: notification.imageUrl,
          timestamp: notification.timeAgo,
          isRead: notification.isRead,
          onTap: () {
            // TODO: Navigate to deal details and mark as read
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('View: ${notification.title}')),
            );
          },
        );
      },
    );
  }

  Widget _buildAlertsTab(
    BuildContext context,
    List<dynamic> alerts,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (alerts.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.notifications_active_outlined,
        title: 'No alerts available',
        message: 'Check back later for new alerts',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Instructions Card
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Subscribe to alerts to get notified about deals in your favorite categories',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Popular Alerts Section
        Text(
          'Popular Alerts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        // Alerts List
        ...alerts.map(
          (alert) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AlertCard(
              title: alert.title,
              description: alert.description,
              isSubscribed: alert.isSubscribed,
              onToggle: (bool isSubscribed) {
                // TODO: Implement subscribe/unsubscribe functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSubscribed
                          ? 'Subscribed to ${alert.title}'
                          : 'Unsubscribed from ${alert.title}',
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
