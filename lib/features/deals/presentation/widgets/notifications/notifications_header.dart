import 'package:flutter/material.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_filter_toggle.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_search_bar.dart';

/// Header section for notifications screen
///
/// Contains back button, filter toggle, title/subtitle, and search bar.
class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: naTheme.headerDivider, width: responsive.scale(1)),
        ),
      ),
      child: Column(
        children: [
          // Back button row
          Align(
            alignment: Alignment.topLeft,
            child: WaffirBackButton(size: responsive.scale(44)),
          ),
          Padding(
            padding: responsive.scalePadding(
              const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            ),
            child: Column(
              children: [
                SizedBox(height: responsive.scale(12)),

                // Filter toggle (Deal Alerts / Notifications)
                const NotificationsFilterToggle(),

                SizedBox(height: responsive.scale(12)),

                // Title & subtitle
                Text(
                  'Don\'t miss out!',
                  style: naTheme.titleStyle.copyWith(
                    color: naTheme.textPrimary,
                    fontSize: responsive.scaleFontSize(18, minSize: 16),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.scale(16)),
                Text(
                  'Get notified when great deals drop!',
                  style: naTheme.subtitleStyle.copyWith(
                    color: naTheme.textPrimary,
                    fontSize: responsive.scaleFontSize(16, minSize: 14),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: responsive.scale(16)),

                // Search bar
                const NotificationsSearchBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
