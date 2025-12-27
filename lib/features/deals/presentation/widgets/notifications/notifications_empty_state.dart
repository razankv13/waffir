import 'package:flutter/material.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Empty state widget for notifications screen
///
/// Displays a centered message when there are no items to show.
class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper.of(context);

    return Center(
      child: Padding(
        padding: responsive.sPadding(const EdgeInsets.all(32)),
        child: Text(
          message,
          style: naTheme.subtitleStyle.copyWith(
            color: naTheme.unselectedColor,
            fontSize: responsive.sFont(16, minSize: 14),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

