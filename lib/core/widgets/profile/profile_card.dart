import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// A reusable card widget for profile sections.
///
/// Pixel-perfect implementation matching Figma Profile screen (node 34:3080):
/// - Background: #F2F2F2 (gray01 / surfaceContainerHighest)
/// - Border radius: 8px
/// - Padding: 16px (default, can be overridden)
/// - Responsive scaling applied
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
  });

  /// The child widget to display inside the card
  final Widget child;

  /// Padding inside the card (default: 16px all around from Figma)
  final EdgeInsetsGeometry padding;

  /// Optional margin around the card
  final EdgeInsetsGeometry? margin;

  /// Optional background color (defaults to surfaceContainerHighest = #F2F2F2)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        // Background: #F2F2F2 (gray01) from Figma
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        // Border radius: 8px (exact from Figma)
        borderRadius: responsive.scaleBorderRadius(
          BorderRadius.circular(8),
        ),
      ),
      child: child,
    );
  }
}

/// A profile card with a title section at the top.
///
/// Useful for cards that have a header with title and optional action button.
class ProfileCardWithTitle extends StatelessWidget {
  const ProfileCardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.titleIcon,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.titleGap = 16,
  });

  /// The title text to display at the top
  final String title;

  /// The main content of the card
  final Widget child;

  /// Optional icon to display before the title
  final Widget? titleIcon;

  /// Optional trailing widget (e.g., button, badge)
  final Widget? trailing;

  /// Padding inside the card
  final EdgeInsetsGeometry padding;

  /// Optional margin around the card
  final EdgeInsetsGeometry? margin;

  /// Optional background color
  final Color? backgroundColor;

  /// Gap between title and content
  final double titleGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final responsive = ResponsiveHelper(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: responsive.scaleBorderRadius(
          BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title row
          Row(
            children: [
              if (titleIcon != null) ...[
                titleIcon!,
                SizedBox(width: responsive.scale(8)),
              ],
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),

          SizedBox(height: responsive.scale(titleGap)),

          // Content
          child,
        ],
      ),
    );
  }
}

/// A simple section divider for profile screens.
///
/// Creates a thin horizontal line with appropriate color and spacing.
class ProfileDivider extends StatelessWidget {
  const ProfileDivider({
    super.key,
    this.height = 8,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = ResponsiveHelper(context);

    return Divider(
      height: responsive.scale(height),
      thickness: thickness,
      indent: responsive.scale(indent),
      endIndent: responsive.scale(endIndent),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
    );
  }
}

/// A section header for grouping related profile items.
///
/// Displays a label with consistent styling and spacing.
class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.only(top: 24, bottom: 8),
  });

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final responsive = ResponsiveHelper(context);

    return Padding(
      padding: padding,
      child: Text(
        title,
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: responsive.scaleFontSize(14, minSize: 12),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
