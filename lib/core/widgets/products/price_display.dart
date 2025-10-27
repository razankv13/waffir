import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Price display widget for showing product prices with optional sale/discount
///
/// Example usage:
/// ```dart
/// // Regular price
/// PriceDisplay(price: 99.99)
///
/// // Sale price
/// PriceDisplay(
///   price: 79.99,
///   originalPrice: 99.99,
///   discountPercentage: 20,
/// )
/// ```
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.currency = '\$',
    this.size = PriceSize.medium,
    this.showCurrency = true,
  });

  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final String currency;
  final PriceSize size;
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isOnSale = originalPrice != null && originalPrice! > price;

    // Determine text styles based on size
    TextStyle priceStyle;
    TextStyle originalPriceStyle;

    switch (size) {
      case PriceSize.small:
        priceStyle = AppTypography.priceSmall;
        originalPriceStyle = AppTypography.bodySmall.copyWith(
          decoration: TextDecoration.lineThrough,
        );
        break;
      case PriceSize.medium:
        priceStyle = AppTypography.priceText;
        originalPriceStyle = AppTypography.originalPriceText;
        break;
      case PriceSize.large:
        priceStyle = AppTypography.priceText.copyWith(fontSize: 24);
        originalPriceStyle = AppTypography.originalPriceText.copyWith(fontSize: 16);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Current/Sale Price
        Text(
          '${showCurrency ? currency : ''}${price.toStringAsFixed(2)}',
          style: priceStyle.copyWith(
            color: isOnSale
                ? const Color(0xFFEF4444) // Sale red
                : colorScheme.onSurface,
          ),
        ),

        if (isOnSale) ...[
          const SizedBox(width: 8),

          // Original Price (strikethrough)
          Text(
            '${showCurrency ? currency : ''}${originalPrice!.toStringAsFixed(2)}',
            style: originalPriceStyle.copyWith(
              color: const Color(0xFF9CA3AF), // Gray
            ),
          ),

          if (discountPercentage != null && discountPercentage! > 0) ...[
            const SizedBox(width: 6),
            // Discount badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-$discountPercentage%',
                style: AppTypography.badgeText.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// Price display sizes
enum PriceSize {
  small,
  medium,
  large,
}
