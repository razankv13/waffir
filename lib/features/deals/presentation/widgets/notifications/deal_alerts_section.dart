import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/cards/alert_card.dart';
import 'package:waffir/core/widgets/cards/deal_card.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_empty_state.dart';

/// Deal alerts section for notifications screen
///
/// Displays "My deal alerts" and "Popular Alerts" sections.
/// Reads data from dealNotificationsProvider and popularAlertsProvider.
class DealAlertsSection extends ConsumerWidget {
  const DealAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);
    final dealNotifications = ref.watch(dealNotificationsProvider);
    final alerts = ref.watch(popularAlertsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "My deal alerts" section
        Text(
          'My deal alerts',
          style: naTheme.sectionTitleStyle.copyWith(
            color: naTheme.textPrimary,
            fontSize: responsive.scaleFontSize(16, minSize: 14),
          ),
        ),
        SizedBox(height: responsive.scale(16)),

        // Deal alerts list
        if (dealNotifications.isEmpty)
          const NotificationsEmptyState(message: 'No deal alerts yet')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dealNotifications.length,
            separatorBuilder: (context, index) => Container(
              height: responsive.scale(1),
              color: naTheme.dividerColor,
              margin: responsive.scalePadding(
                const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            itemBuilder: (context, index) {
              final notification = dealNotifications[index];
              return DealCard(
                initial: notification.title[0].toUpperCase(),
                title: notification.title,
                subtitle: notification.description,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('View: ${notification.title}')),
                  );
                },
              );
            },
          ),

        SizedBox(height: responsive.scale(16)),

        // "Popular Alerts" section
        Text(
          'Popular Alerts',
          style: naTheme.sectionTitleStyle.copyWith(
            color: naTheme.textPrimary,
            fontSize: responsive.scaleFontSize(16, minSize: 14),
          ),
        ),
        SizedBox(height: responsive.scale(16)),

        // Popular alerts cards
        if (alerts.isEmpty)
          const NotificationsEmptyState(message: 'No alerts available')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            separatorBuilder: (context, index) => SizedBox(
              height: responsive.scale(8),
            ),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return AlertCard(
                title: alert.title,
                imageUrl: alert.iconUrl,
                isSubscribed: alert.isSubscribed ?? false,
                onToggle: (bool isSubscribed) {
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
              );
            },
          ),
      ],
    );
  }
}

