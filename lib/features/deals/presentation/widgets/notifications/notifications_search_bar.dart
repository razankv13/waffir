import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Search bar widget for notifications screen
///
/// Displays a search field with label, placeholder text,
/// vertical divider, and arrow button.
class NotificationsSearchBar extends StatelessWidget {
  const NotificationsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);

    return Container(
      height: responsive.scale(68),
      padding: responsive.scalePadding(const EdgeInsets.all(12)),
      decoration: BoxDecoration(
        color: naTheme.background,
        borderRadius: BorderRadius.circular(responsive.scale(16)),
        border: Border.all(
          color: naTheme.searchBorder,
          width: responsive.scale(1),
        ),
      ),
      child: Row(
        children: [
          // Left: Search text stack
          Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.notifications.search.label.tr(),
                  style: naTheme.searchLabelStyle.copyWith(
                    color: naTheme.textPrimary,
                    fontSize: responsive.scaleFontSize(14, minSize: 12),
                  ),
                ),
                Text(
                  LocaleKeys.notifications.search.placeholder.tr(),
                  style: naTheme.searchPlaceholderStyle.copyWith(
                    color: naTheme.unselectedColor,
                    fontSize: responsive.scaleFontSize(12, minSize: 10),
                  ),
                ),
              ],
            ),
          ),

          // Vertical divider
          Container(
            width: responsive.scale(1),
            height: responsive.scale(24),
            margin: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 8)),
            color: naTheme.dividerColor,
          ),

          // Right: Arrow button
          Container(
            width: responsive.scale(44),
            height: responsive.scale(44),
            decoration: BoxDecoration(
              color: naTheme.searchButtonBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/categories/arrow_filter_icon.svg',
                width: responsive.scale(20),
                height: responsive.scale(20),
                colorFilter: ColorFilter.mode(
                  naTheme.background, // White icon on dark background
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
