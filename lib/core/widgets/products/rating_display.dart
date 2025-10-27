import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Rating display widget with stars and optional review count
///
/// Example usage:
/// ```dart
/// RatingDisplay(
///   rating: 4.5,
///   reviewCount: 128,
/// )
/// ```
class RatingDisplay extends StatelessWidget {
  const RatingDisplay({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = RatingSize.medium,
    this.showRatingText = true,
    this.starColor,
  });

  final double rating;
  final int? reviewCount;
  final RatingSize size;
  final bool showRatingText;
  final Color? starColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine sizes based on rating size
    double iconSize;
    double fontSize;
    double spacing;

    switch (size) {
      case RatingSize.small:
        iconSize = 12;
        fontSize = 11;
        spacing = 4;
        break;
      case RatingSize.medium:
        iconSize = 14;
        fontSize = 12;
        spacing = 6;
        break;
      case RatingSize.large:
        iconSize = 18;
        fontSize = 14;
        spacing = 8;
        break;
    }

    final effectiveStarColor = starColor ?? const Color(0xFFFBBF24); // Gold

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star icons
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            // Full star
            return Icon(
              Icons.star,
              size: iconSize,
              color: effectiveStarColor,
            );
          } else if (index < rating) {
            // Half star
            return Icon(
              Icons.star_half,
              size: iconSize,
              color: effectiveStarColor,
            );
          } else {
            // Empty star
            return Icon(
              Icons.star_border,
              size: iconSize,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            );
          }
        }),

        if (showRatingText || reviewCount != null) ...[
          SizedBox(width: spacing),

          if (showRatingText)
            Text(
              rating.toStringAsFixed(1),
              style: AppTypography.bodySmall.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),

          if (reviewCount != null && reviewCount! > 0) ...[
            if (showRatingText) const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: AppTypography.bodySmall.copyWith(
                fontSize: fontSize,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// Rating sizes for different use cases
enum RatingSize {
  small,
  medium,
  large,
}
