import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// System notification card for activity feed
///
/// Designer-quality UI matching the Deal Alerts visual language:
/// - 48×48 rounded tile with SVG icon
/// - Title (Parkinsans 16 w500)
/// - Subtitle (Parkinsans 12 w400)
/// - Timestamp (Parkinsans 11.9 w400) on the right
/// - Optional unread dot (8×8)
/// - Chevron-right for affordance
///
/// Example usage:
/// ```dart
/// SystemNotificationCard(
///   title: 'Premium subscription renewed',
///   subtitle: 'Your monthly subscription has been renewed',
///   timeAgo: '2h ago',
///   iconAssetPath: 'assets/icons/bolt.svg',
///   isRead: false,
///   onTap: () => navigateToDetails(),
/// )
/// ```
class SystemNotificationCard extends StatelessWidget {
  const SystemNotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.iconAssetPath,
    this.isRead = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final String iconAssetPath;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(vertical: 12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Icon tile (48×48)
            Container(
              width: responsive.scale(48),
              height: responsive.scale(48),
              decoration: BoxDecoration(
                color: naTheme.notificationTileBackground,
                borderRadius: BorderRadius.circular(responsive.scale(8)),
                border: Border.all(
                  color: naTheme.notificationTileBorder,
                  width: responsive.scale(1),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconAssetPath,
                  width: responsive.scale(24),
                  height: responsive.scale(24),
                  colorFilter: ColorFilter.mode(
                    naTheme.selectedColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            SizedBox(width: responsive.scale(12)),

            // Middle: Title, subtitle, timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Unread dot (if unread)
                      if (!isRead) ...[
                        Container(
                          width: responsive.scale(8),
                          height: responsive.scale(8),
                          decoration: BoxDecoration(
                            color: naTheme.selectedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: responsive.scale(8)),
                      ],

                      // Title
                      Expanded(
                        child: Text(
                          title,
                          style: naTheme.notificationTitleStyle.copyWith(
                            color: naTheme.textPrimary,
                            fontSize: responsive.scaleFontSize(16, minSize: 14),
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: responsive.scale(4)),

                  // Subtitle
                  Text(
                    subtitle,
                    style: naTheme.notificationSubtitleStyle.copyWith(
                      color: naTheme.unselectedColor,
                      fontSize: responsive.scaleFontSize(12, minSize: 10),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: responsive.scale(4)),

                  // Timestamp
                  Text(
                    timeAgo,
                    style: naTheme.notificationTimestampStyle.copyWith(
                      color: naTheme.timestampColor,
                      fontSize: responsive.scaleFontSize(11.899999618530273, minSize: 10),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: responsive.scale(8)),

            // Right: Chevron indicator
            SvgPicture.asset(
              'assets/icons/chevron_right.svg',
              width: responsive.scale(20),
              height: responsive.scale(20),
              colorFilter: ColorFilter.mode(
                naTheme.unselectedColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}












