import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Deal alert card for notifications screen (Figma component 7774:4257)
///
/// Displays a minimal deal alert with:
/// - 64×64 avatar tile with letter/initial
/// - Title and subtitle text
/// - Chevron-right indicator
///
/// Example usage:
/// ```dart
/// DealCard(
///   initial: 'A',
///   title: 'Apple iPhone 16',
///   subtitle: 'Rating.. +10 likes',
///   onTap: () => navigateToDeal(),
/// )
/// ```
class DealCard extends StatelessWidget {
  const DealCard({
    super.key,
    required this.initial,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String initial;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: responsive.sPadding(const EdgeInsets.symmetric(vertical: 8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Avatar tile + texts
            Expanded(
              child: Row(
                children: [
                  // Avatar tile with initial letter
                  Container(
                    width: responsive.s(64),
                    height: responsive.s(64),
                    decoration: BoxDecoration(
                      color: naTheme.dealTileBackground,
                      borderRadius: BorderRadius.circular(responsive.s(8)),
                      border: Border.all(
                        color: naTheme.dealTileBorder,
                        width: responsive.s(1.600000023841858),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: naTheme.dealLetterStyle.copyWith(
                        color: naTheme.dealTileLetterColor,
                        fontSize: responsive.sFont(20, minSize: 16),
                      ),
                    ),
                  ),

                  SizedBox(width: responsive.s(12)),

                  // Title and subtitle column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: naTheme.dealTitleStyle.copyWith(
                            color: naTheme.textPrimary,
                            fontSize: responsive.sFont(16, minSize: 14),
                          ),
                        ),
                        SizedBox(height: responsive.s(12)),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: naTheme.dealSubtitleStyle.copyWith(
                            color: naTheme.textPrimary,
                            fontSize: responsive.sFont(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right: Chevron indicator
            SvgPicture.asset(
              'assets/icons/chevron_right.svg',
              width: responsive.s(24),
              height: responsive.s(24),
              colorFilter: ColorFilter.mode(naTheme.chevronColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
