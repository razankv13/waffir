import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/products/price_display.dart';

/// Cart item card widget for displaying items in shopping cart
///
/// Example usage:
/// ```dart
/// CartItemCard(
///   imageUrl: 'https://example.com/product.jpg',
///   title: 'Nike Air Max',
///   brand: 'Nike',
///   size: 'M',
///   price: 129.99,
///   quantity: 2,
///   onQuantityChanged: (qty) => updateQuantity(qty),
///   onRemove: () => removeItem(),
/// )
/// ```
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    this.brand,
    this.size,
    this.color,
    this.originalPrice,
    this.onQuantityChanged,
    this.onRemove,
    this.maxQuantity = 10,
  });

  final String imageUrl;
  final String title;
  final String? brand;
  final String? size;
  final String? color;
  final double price;
  final double? originalPrice;
  final int quantity;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;
  final int maxQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 80,
              color: colorScheme.surfaceContainerHighest,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurfaceVariant,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                if (brand != null) ...[
                  Text(
                    brand!,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],

                // Title
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Size and Color
                if (size != null || color != null)
                  Row(
                    children: [
                      if (size != null) ...[
                        Text(
                          'Size: $size',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (color != null) const SizedBox(width: 12),
                      ],
                      if (color != null)
                        Row(
                          children: [
                            Text(
                              'Color: ',
                              style: AppTypography.bodySmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _getColorFromName(color!),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                const SizedBox(height: 12),

                // Price and Quantity Control
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    PriceDisplay(
                      price: price,
                      originalPrice: originalPrice,
                      size: PriceSize.small,
                    ),

                    // Quantity Control
                    _QuantityControl(
                      quantity: quantity,
                      maxQuantity: maxQuantity,
                      onQuantityChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          if (onRemove != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20,
                color: colorScheme.error,
              ),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.maxQuantity,
    this.onQuantityChanged,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int>? onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          _QuantityButton(
            icon: Icons.remove,
            onPressed: quantity > 1 && onQuantityChanged != null
                ? () => onQuantityChanged!(quantity - 1)
                : null,
          ),

          // Quantity Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: AppTypography.labelLarge.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // Increase Button
          _QuantityButton(
            icon: Icons.add,
            onPressed: quantity < maxQuantity && onQuantityChanged != null
                ? () => onQuantityChanged!(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
