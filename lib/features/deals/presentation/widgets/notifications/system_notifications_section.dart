import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/cards/system_notification_card.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_empty_state.dart';

/// System notifications section for notifications screen
///
/// Displays system notifications list.
/// Reads data from systemNotificationsProvider.
class SystemNotificationsSection extends ConsumerWidget {
  const SystemNotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper.of(context);
    final systemNotifications = ref.watch(systemNotificationsProvider);

    if (systemNotifications.isEmpty) {
      return NotificationsEmptyState(
        message: LocaleKeys.notifications.empty.systemNotifications.tr(),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: systemNotifications.length,
      separatorBuilder: (context, index) => Container(
        height: responsive.s(1),
        color: naTheme.dividerColor,
        margin: responsive.sPadding(
          const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      itemBuilder: (context, index) {
        final notification = systemNotifications[index];
        return SystemNotificationCard(
          title: notification.title,
          subtitle: notification.subtitle,
          timeAgo: notification.timeAgo,
          iconAssetPath: notification.iconAssetPath,
          isRead: notification.isRead,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.notifications.snackbar.view
                      .tr(namedArgs: {'title': notification.title}),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
