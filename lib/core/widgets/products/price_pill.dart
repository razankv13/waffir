import 'package:flutter/material.dart';

/// Price pill widget - pill-shaped price container with riyal icon
///
/// Displays price in a rounded pill shape matching Figma design.
/// Two variants: sale (dark bg, green text) and original (gray bg, red text)
///
/// Example usage:
/// ```dart
/// // Sale price
/// PricePill(
///   price: '400',
///   isSalePrice: true,
/// )
///
/// // Original price
/// PricePill(
///   price: '809',
///   isSalePrice: false,
/// )
/// ```
class PricePill extends StatelessWidget {
  const PricePill({
    super.key,
    required this.price,
    this.isSalePrice = true,
  });

  final String price;
  final bool isSalePrice;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine colors based on type
    final Color backgroundColor = isSalePrice
        ? const Color(0xFF0F352D) // Dark green for sale price
        : colorScheme.surfaceContainerHighest; // Light gray for original

    final Color textColor = isSalePrice
        ? const Color(0xFF00FF88) // Bright green for sale price
        : colorScheme.error; // Red for original price

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1000), // Fully rounded pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Riyal icon (12×12px)
          SizedBox(
            width: 12,
            height: 12,
            child: _RiyalIcon(color: textColor),
          ),
          const SizedBox(width: 4), // Small gap
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: 12,
              fontWeight: FontWeight.w400, // Regular
              height: 1.15, // Line height from Figma
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Riyal icon - simplified SVG representation
class _RiyalIcon extends StatelessWidget {
  const _RiyalIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    // Using a simple Text representation for now
    // TODO: Replace with actual Riyal SVG icon from Figma
    return Center(
      child: Text(
        'ر.س',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}
