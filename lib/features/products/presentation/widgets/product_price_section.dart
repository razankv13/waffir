import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';

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
    final promo = Theme.of(context).extension<PromoColors>()!;
    final responsive = context.responsive;

    final bool isOnSale = originalPrice != null && originalPrice! > price;

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: price pills (current and original if on sale)
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: responsive.scale(8),
              runSpacing: responsive.scale(8),
              children: [
                // Current/Sale price pill
                _PricePill(
                  priceText: _formatPriceNumber(price),
                  backgroundColor: promo.saleBg,
                  textColor: promo.saleText,
                  iconSize: responsive.scale(20),
                  fontSize: responsive.scale(20),
                  fontWeight: FontWeight.w700, // Bold per Figma
                  padding: responsive.scalePadding(const EdgeInsets.all(8)),
                ),
                if (isOnSale)
                  _PricePill(
                    priceText: _formatPriceNumber(originalPrice!),
                    backgroundColor: promo.originalBg,
                    textColor: promo.originalText,
                    iconSize: responsive.scale(14),
                    fontSize: responsive.scale(16),
                    fontWeight: FontWeight.w400, // Regular per Figma
                    padding: responsive.scalePadding(const EdgeInsets.all(8)),
                  ),
              ],
            ),
          ),
          SizedBox(width: responsive.scale(8)),
          // Right: discount tag pill (if provided and > 0)
          if ((discountPercentage ?? 0) > 0)
            _DiscountTagPill(
              text: '${discountPercentage!}% off',
              backgroundColor: promo.discountBg,
              textColor: promo.discountText,
              iconSize: responsive.scale(16),
              fontSize: responsive.scale(16),
              padding: responsive.scalePadding(const EdgeInsets.all(8)),
            ),
        ],
      ),
    );
  }

  // Formats numeric value matching Figma examples:
  // - If whole number: no decimals (e.g., 400)
  // - Otherwise: up to 2 decimals
  String _formatPriceNumber(double value) {
    final bool isWhole = value % 1 == 0;
    return isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

}

// Internal: Figma-accurate price pill with riyal icon
class _PricePill extends StatelessWidget {
  const _PricePill({
    required this.priceText,
    required this.backgroundColor,
    required this.textColor,
    required this.iconSize,
    required this.fontSize,
    required this.fontWeight,
    required this.padding,
  });

  final String priceText;
  final Color backgroundColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(26.73), // Exact Figma radius for discount pill
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/riyal.svg',
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          SizedBox(width: (iconSize * 0.2).clamp(4, 8)), // ~4–8px gap
          Text(
            priceText,
            style: AppTypography.priceText.copyWith(
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: 1.15, // From Figma
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Internal: Figma-accurate discount tag pill with tag icon
class _DiscountTagPill extends StatelessWidget {
  const _DiscountTagPill({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.iconSize,
    required this.fontSize,
    required this.padding,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/tag.svg',
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          SizedBox(width: (iconSize * 0.25).clamp(4, 8)), // ~4–8px gap
          Text(
            text,
            style: AppTypography.bodyLarge.copyWith(
              fontFamily: 'Parkinsans',
              fontSize: fontSize,
              fontWeight: FontWeight.w500, // Medium per Figma
              height: 1.15,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
