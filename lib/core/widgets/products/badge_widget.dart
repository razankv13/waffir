import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Badge widget for displaying product labels like "NEW", "SALE", "20% OFF"
///
/// Example usage:
/// ```dart
/// BadgeWidget(
///   text: 'NEW',
///   type: BadgeType.newBadge,
/// )
/// ```
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.text,
    this.type = BadgeType.sale,
    this.size = BadgeSize.medium,
  });

  final String text;
  final BadgeType type;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine badge colors based on type
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case BadgeType.sale:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        break;
      case BadgeType.newBadge:
        backgroundColor = colorScheme.tertiary;
        textColor = colorScheme.onTertiary;
        break;
      case BadgeType.discount:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        break;
      case BadgeType.featured:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case BadgeType.custom:
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        break;
    }

    // Determine size
    double horizontalPadding;
    double verticalPadding;
    double fontSize;

    switch (size) {
      case BadgeSize.small:
        horizontalPadding = 6;
        verticalPadding = 2;
        fontSize = 9;
        break;
      case BadgeSize.medium:
        horizontalPadding = 8;
        verticalPadding = 3;
        fontSize = 10;
        break;
      case BadgeSize.large:
        horizontalPadding = 10;
        verticalPadding = 4;
        fontSize = 11;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.badgeText.copyWith(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

/// Badge types for different use cases
enum BadgeType {
  sale, // Red badge for sales
  newBadge, // Purple badge for new items
  discount, // Error color for discounts
  featured, // Primary color for featured items
  custom, // Secondary color for custom badges
}

/// Badge sizes
enum BadgeSize {
  small,
  medium,
  large,
}
