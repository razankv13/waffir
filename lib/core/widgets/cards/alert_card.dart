import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';

/// Alert card for notifications screen (Figma component 7774:4697 + 7774:6283)
///
/// Displays a popular alert with:
/// - 48×48 image tile
/// - Alert title
/// - "Add" button with plus icon
///
/// Example usage:
/// ```dart
/// AlertCard(
///   title: 'Laptops',
///   imageUrl: 'https://example.com/laptop.png',
///   isSubscribed: false,
///   onToggle: (value) => print('Subscribed: $value'),
/// )
/// ```
class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.isSubscribed = false,
    this.onToggle,
  });

  final String title;
  final String? imageUrl;
  final bool isSubscribed;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: naTheme.alertCardBackground,
        borderRadius: BorderRadius.circular(responsive.scale(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Image tile + title
          Expanded(
            child: Row(
              children: [
                // Image tile (48×48)
                Container(
                  width: responsive.scale(48),
                  height: responsive.scale(48),
                  decoration: BoxDecoration(
                    color: naTheme.addButtonBackground,
                    borderRadius: BorderRadius.circular(responsive.scale(8)),
                    border: Border.all(color: naTheme.alertImageBorder, width: responsive.scale(1)),
                  ),
                  child: imageUrl != null
                      ? AppNetworkImage(
                          imageUrl: imageUrl!,
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(8),
                          errorWidget: const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                ),

                SizedBox(width: responsive.scale(12)),

                // Alert title
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: naTheme.alertTitleStyle.copyWith(
                      color: naTheme.textPrimary,
                      fontSize: responsive.scaleFontSize(16, minSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: Add button
          InkWell(
            onTap: () => onToggle?.call(!isSubscribed),
            borderRadius: BorderRadius.circular(responsive.scale(100)),
            child: Container(
              height: responsive.scale(40),
              padding: responsive.scalePadding(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              decoration: BoxDecoration(
                color: naTheme.addButtonBackground,
                borderRadius: BorderRadius.circular(responsive.scale(100)),
                border: Border.all(color: naTheme.addButtonBorder, width: responsive.scale(1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add',
                    style: naTheme.addButtonTextStyle.copyWith(
                      color: naTheme.textPrimary,
                      fontSize: responsive.scaleFontSize(12, minSize: 10),
                    ),
                  ),
                  SizedBox(width: responsive.scale(4)),
                  SvgPicture.asset(
                    'assets/icons/plus.svg',
                    width: responsive.scale(16),
                    height: responsive.scale(16),
                    colorFilter: ColorFilter.mode(naTheme.plusIconColor, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
