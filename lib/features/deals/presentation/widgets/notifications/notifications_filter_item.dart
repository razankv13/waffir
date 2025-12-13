import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/notifications_alerts_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Individual filter button for notifications screen
///
/// Displays an icon and label with selection state.
/// Used in NotificationsFilterToggle.
class NotificationsFilterItem extends StatelessWidget {
  const NotificationsFilterItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final naTheme = Theme.of(context).extension<NotificationsAlertsTheme>()!;
    final responsive = ResponsiveHelper(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(vertical: 8)),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: naTheme.selectedColor,
                    width: responsive.scale(2),
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: responsive.scale(24),
              height: responsive.scale(24),
              colorFilter: ColorFilter.mode(
                isSelected ? naTheme.selectedColor : naTheme.unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: responsive.scale(4)),
            Text(
              label,
              style: (isSelected
                      ? naTheme.filterSelectedStyle
                      : naTheme.filterUnselectedStyle)
                  .copyWith(
                color: isSelected ? naTheme.selectedColor : naTheme.unselectedColor,
                fontSize: responsive.scaleFontSize(14, minSize: 12),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

