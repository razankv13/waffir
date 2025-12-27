import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// A reusable menu item widget for profile and settings screens.
///
/// Pixel-perfect implementation matching Figma Profile screen (node 34:3080):
/// - Width: 362px (controlled by parent container)
/// - Height: 44px
/// - Padding: 8px 0px (vertical only)
/// - Gap: 12px between icon, text, and chevron
/// - Icon size: 24×24px
/// - Text: Parkinsans 14px weight 500, line-height 1.25em, color #151515
/// - Chevron size: 24×24px, 2px stroke, color #151515
/// - Divider: 0px height with 1px stroke, color #F2F2F2 (gray01)
class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.showDivider = true,
  });

  /// The icon to display (24×24px from Figma). Optional - if null, no icon is shown.
  final Widget? icon;

  /// The label text to display
  final String label;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Optional trailing widget (e.g., chevron, switch, badge)
  final Widget? trailing;

  /// Whether to show a divider below the item (1px gray01 stroke)
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: responsive.sBorderRadius(BorderRadius.circular(8)),
          child: Container(
            // Exact height from Figma: 44px
            height: responsive.s(44),
            // Exact padding from Figma: 8px vertical only
            padding: responsive.sPadding(
              const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Row(
              children: [
                // Icon: 24×24px (exact from Figma) - only show if provided
                if (icon != null) ...[
                  SizedBox(
                    width: responsive.s(24),
                    height: responsive.s(24),
                    child: icon,
                  ),

                  // Gap: 12px (exact from Figma)
                  SizedBox(width: responsive.s(12)),
                ],

                // Label: Parkinsans 14px weight 500, line-height 1.25em
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.menuItemText.copyWith(
                      color: colorScheme.onSurface, // #151515
                      fontSize: responsive.sFont(14, minSize: 12),
                    ),
                  ),
                ),

                // Trailing widget (chevron, switch, etc.)
                if (trailing != null) trailing!,

                // Default chevron if no trailing widget provided and onTap is set
                // Chevron: 24×24px, 2px stroke (exact from Figma)
                if (trailing == null && onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: responsive.s(24),
                    color: colorScheme.onSurface, // #151515 per Figma
                  ),
              ],
            ),
          ),
        ),

        // Divider: 1px stroke, color #F2F2F2 (gray01 from Figma)
        if (showDivider)
          Divider(
            height: responsive.s(8),
            thickness: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest, // gray01
          ),
      ],
    );
  }
}

/// A variant of ProfileMenuItem with RTL support for Arabic layouts.
///
/// Mirrors the layout for right-to-left languages, placing the icon
/// on the right and the chevron on the left. Matches Figma specs.
class ProfileMenuItemRTL extends StatelessWidget {
  const ProfileMenuItemRTL({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.showDivider = true,
  });

  final Widget? icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: responsive.sBorderRadius(BorderRadius.circular(8)),
          child: Container(
            height: responsive.s(44),
            padding: responsive.sPadding(
              const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Row(
              children: [
                // Default chevron on left for RTL
                if (trailing == null && onTap != null)
                  Icon(
                    Icons.chevron_left,
                    size: responsive.s(24),
                    color: colorScheme.onSurface,
                  ),

                // Trailing widget
                if (trailing != null) trailing!,

                // Label
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.right,
                    style: AppTypography.menuItemText.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: responsive.sFont(14, minSize: 12),
                    ),
                  ),
                ),

                // Icon on right for RTL - only show if provided
                if (icon != null) ...[
                  SizedBox(width: responsive.s(12)),

                  SizedBox(
                    width: responsive.s(24),
                    height: responsive.s(24),
                    child: icon,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Divider
        if (showDivider)
          Divider(
            height: responsive.s(8),
            thickness: 1,
            color: colorScheme.surfaceContainerHighest,
          ),
      ],
    );
  }
}
