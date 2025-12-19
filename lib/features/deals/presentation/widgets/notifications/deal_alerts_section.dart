import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/cards/alert_card.dart';
import 'package:waffir/features/alerts/presentation/controllers/my_alerts_controller.dart';
import 'package:waffir/features/alerts/presentation/controllers/popular_keywords_provider.dart';
import 'package:waffir/features/deals/presentation/widgets/notifications/notifications_empty_state.dart';

/// Deal alerts section for notifications screen
///
/// Displays "My Alerts" and "Popular Keywords" sections.
/// Uses myAlertsControllerProvider and popularKeywordsProvider.
class DealAlertsSection extends ConsumerWidget {
  const DealAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);
    final myAlertsAsync = ref.watch(myAlertsControllerProvider);
    final popularKeywordsAsync = ref.watch(popularKeywordsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "My Alerts" section
        Text(
          LocaleKeys.notifications.sections.myDealAlerts.tr(),
          style: naTheme.sectionTitleStyle.copyWith(
            color: naTheme.textPrimary,
            fontSize: responsive.scaleFontSize(16, minSize: 14),
          ),
        ),
        SizedBox(height: responsive.scale(16)),

        // My alerts list
        myAlertsAsync.when(
          data: (state) {
            if (state.isEmpty) {
              return NotificationsEmptyState(
                message: LocaleKeys.notifications.empty.dealAlerts.tr(),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.alerts.length,
              separatorBuilder: (context, index) => SizedBox(height: responsive.scale(8)),
              itemBuilder: (context, index) {
                final alert = state.alerts[index];
                return AlertCard(
                  title: alert.keyword,
                  isSubscribed: true,
                  onToggle: (bool isSubscribed) async {
                    if (!isSubscribed) {
                      // Delete alert
                      final controller = ref.read(myAlertsControllerProvider.notifier);
                      final failure = await controller.deleteAlert(alert.id);
                      if (failure == null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LocaleKeys.notifications.snackbar.unsubscribed
                                  .tr(namedArgs: {'title': alert.keyword}),
                            ),
                          ),
                        );
                      } else if (failure != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(failure.message),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => NotificationsEmptyState(
            message: LocaleKeys.notifications.empty.dealAlerts.tr(),
          ),
        ),

        SizedBox(height: responsive.scale(24)),

        // "Popular Keywords" section
        Text(
          LocaleKeys.notifications.sections.popularAlerts.tr(),
          style: naTheme.sectionTitleStyle.copyWith(
            color: naTheme.textPrimary,
            fontSize: responsive.scaleFontSize(16, minSize: 14),
          ),
        ),
        SizedBox(height: responsive.scale(16)),

        // Popular keywords cards
        popularKeywordsAsync.when(
          data: (keywords) {
            if (keywords.isEmpty) {
              return NotificationsEmptyState(
                message: LocaleKeys.notifications.empty.popularAlerts.tr(),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: keywords.length,
              separatorBuilder: (context, index) => SizedBox(height: responsive.scale(8)),
              itemBuilder: (context, index) {
                final keyword = keywords[index];
                final controller = ref.read(myAlertsControllerProvider.notifier);
                final isSubscribed = controller.hasAlertFor(keyword);

                return AlertCard(
                  title: keyword,
                  isSubscribed: isSubscribed,
                  onToggle: (bool newValue) async {
                    if (newValue) {
                      // Create alert
                      final failure = await controller.createAlert(keyword);
                      if (failure == null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LocaleKeys.notifications.snackbar.subscribed
                                  .tr(namedArgs: {'title': keyword}),
                            ),
                          ),
                        );
                      } else if (failure != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(failure.message),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => NotificationsEmptyState(
            message: LocaleKeys.notifications.empty.popularAlerts.tr(),
          ),
        ),
      ],
    );
  }
}
