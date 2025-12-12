import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';

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
    final promo = Theme.of(context).extension<PromoColors>()!;

    // Determine colors based on type
    final Color backgroundColor =
        isSalePrice ? promo.saleBg : promo.originalBg;

    final Color textColor =
        isSalePrice ? promo.saleText : promo.originalText;

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
          SvgPicture.asset(
            'assets/icons/riyal.svg',
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
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
