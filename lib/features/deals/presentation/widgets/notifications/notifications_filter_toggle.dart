import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_filter_item.dart';

/// Filter toggle for switching between Deal Alerts and Notifications
///
/// Uses Riverpod state management via notificationsFilterProvider.
class NotificationsFilterToggle extends ConsumerWidget {
  const NotificationsFilterToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDealAlerts = ref.watch(notificationsFilterProvider);

    return Row(
      children: [
        // Deal Alerts filter
        Expanded(
          child: NotificationsFilterItem(
            label: 'Deal Alerts',
            iconPath: 'assets/icons/bolt.svg',
            isSelected: showDealAlerts,
            onTap: () => ref.read(notificationsFilterProvider.notifier).showDealAlerts(),
          ),
        ),

        // Notifications filter
        Expanded(
          child: NotificationsFilterItem(
            label: 'Notifications',
            iconPath: 'assets/icons/notification_bell.svg',
            isSelected: !showDealAlerts,
            onTap: () => ref.read(notificationsFilterProvider.notifier).showNotifications(),
          ),
        ),
      ],
    );
  }
}

