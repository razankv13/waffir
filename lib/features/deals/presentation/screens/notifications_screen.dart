import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/deal_alerts_section.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_background_blur.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_header.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/system_notifications_section.dart';

/// Notifications & Alerts Screen - Deal Alerts view (Figma node 7774:3441)
///
/// Pixel-perfect implementation with:
/// - Background blur shape
/// - Back button & filter toggle
/// - Title/subtitle header
/// - Search bar
/// - Deal alerts list
/// - Popular alerts cards
///
/// Refactored into modular widgets for better maintainability.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper.of(context);
    final showDealAlerts = ref.watch(notificationsFilterProvider);

    return Scaffold(
      backgroundColor: naTheme.background,
      body: Stack(
        children: [
          // Background blur shape (positioned at top-left)
          const NotificationsBackgroundBlur(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header section
                const NotificationsHeader(),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: responsive.sPadding(const EdgeInsets.all(16)),
                    child: showDealAlerts
                        ? const DealAlertsSection()
                        : const SystemNotificationsSection(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
