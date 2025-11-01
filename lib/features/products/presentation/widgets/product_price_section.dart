import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Product price section widget
///
/// Displays product prices with optional sale/discount information
/// Matches Figma specifications with 16px padding
class ProductPriceSection extends StatelessWidget {
  const ProductPriceSection({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.currency = 'SAR',
    this.showCurrency = true,
  });

  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final String currency;
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool isOnSale = originalPrice != null && originalPrice! > price;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price information
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // Current price
                Text(
                  _formatPrice(price),
                  style: AppTypography.priceText.copyWith(
                    color: isOnSale
                        ? const Color(0xFFEF4444) // Sale price red
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                // Original price (if on sale)
                if (isOnSale) ...[
                  Text(
                    _formatPrice(originalPrice!),
                    style: AppTypography.originalPriceText.copyWith(
                      color: const Color(0xFF9CA3AF), // Gray color
                      decoration: TextDecoration.lineThrough,
                      decorationColor: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Discount badge
          if (discountPercentage != null && discountPercentage! > 0)
            BadgeWidget(
              text: '${discountPercentage!}% OFF',
            ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (showCurrency) {
      return '$currency ${price.toStringAsFixed(2)}';
    }
    return price.toStringAsFixed(2);
  }
}
