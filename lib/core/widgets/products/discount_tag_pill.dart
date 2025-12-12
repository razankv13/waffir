import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';

/// Discount tag pill widget - pill-shaped discount badge
///
/// Displays discount percentage in a rounded pill shape matching Figma design.
/// Background: #DCFCE7 (light green), Text: #0F352D (dark green)
///
/// Example usage:
/// ```dart
/// DiscountTagPill(
///   discountText: '20% off',
/// )
/// ```
class DiscountTagPill extends StatelessWidget {
  const DiscountTagPill({
    super.key,
    required this.discountText,
    this.showIcon = true,
  });

  final String discountText;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final promo = Theme.of(context).extension<PromoColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: promo.discountBg,
        borderRadius: BorderRadius.circular(100), // Fully rounded pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            // Tag icon (16×16px)
            SvgPicture.asset(
              'assets/icons/tag.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(promo.discountText, BlendMode.srcIn),
            ),
            const SizedBox(width: 4), // Gap between icon and text
          ],
          Text(
            discountText,
            style: TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: 12,
              fontWeight: FontWeight.w500, // Medium
              height: 1.15, // Line height from Figma
              color: promo.discountText,
            ),
          ),
        ],
      ),
    );
  }
}
