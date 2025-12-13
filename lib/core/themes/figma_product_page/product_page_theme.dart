import 'package:flutter/material.dart';

import 'package:waffir/core/themes/figma_product_page/app_colors.dart';
import 'package:waffir/core/themes/figma_product_page/app_text_styles.dart';

/// ThemeExtension for the pixel-perfect Product Page (Figma node `34:4022`).
///
/// Widgets must use `Theme.of(context).extension<ProductPageTheme>()!`.
class ProductPageTheme extends ThemeExtension<ProductPageTheme> {
  const ProductPageTheme({
    required this.colors,
    required this.textStyles,
  });

  final ProductPageThemeColors colors;
  final ProductPageThemeTextStyles textStyles;

  static const ProductPageTheme light = ProductPageTheme(
    colors: ProductPageThemeColors.light,
    textStyles: ProductPageThemeTextStyles.base,
  );

  @override
  ProductPageTheme copyWith({
    ProductPageThemeColors? colors,
    ProductPageThemeTextStyles? textStyles,
  }) {
    return ProductPageTheme(
      colors: colors ?? this.colors,
      textStyles: textStyles ?? this.textStyles,
    );
  }

  @override
  ProductPageTheme lerp(ThemeExtension<ProductPageTheme>? other, double t) {
    if (other is! ProductPageTheme) return this;
    return ProductPageTheme(
      colors: colors.lerp(other.colors, t),
      textStyles: textStyles,
    );
  }
}

class ProductPageThemeColors {
  const ProductPageThemeColors({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMid,
    required this.surfaceContainer,
    required this.brandDarkGreen,
    required this.brandBrightGreen,
    required this.badgeMint,
    required this.divider,
    required this.heroBorder,
    required this.backShadowColor,
    required this.topOverlayGradient,
    required this.bottomCtaGradient,
  });

  static const ProductPageThemeColors light = ProductPageThemeColors(
    background: ProductPageFigmaColors.background,
    textPrimary: ProductPageFigmaColors.textPrimary,
    textSecondary: ProductPageFigmaColors.textSecondary,
    textMid: ProductPageFigmaColors.textMid,
    surfaceContainer: ProductPageFigmaColors.surfaceContainer,
    brandDarkGreen: ProductPageFigmaColors.brandDarkGreen,
    brandBrightGreen: ProductPageFigmaColors.brandBrightGreen,
    badgeMint: ProductPageFigmaColors.badgeMint,
    divider: ProductPageFigmaColors.divider,
    heroBorder: ProductPageFigmaColors.heroBorder,
    backShadowColor: ProductPageFigmaColors.backShadowColor,
    topOverlayGradient: ProductPageFigmaColors.topOverlayGradient,
    bottomCtaGradient: ProductPageFigmaColors.bottomCtaGradient,
  );

  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMid;
  final Color surfaceContainer;
  final Color brandDarkGreen;
  final Color brandBrightGreen;
  final Color badgeMint;
  final Color divider;
  final Color heroBorder;
  final Color backShadowColor;
  final LinearGradient topOverlayGradient;
  final LinearGradient bottomCtaGradient;

  ProductPageThemeColors lerp(ProductPageThemeColors other, double t) {
    return ProductPageThemeColors(
      background: Color.lerp(background, other.background, t) ?? background,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMid: Color.lerp(textMid, other.textMid, t) ?? textMid,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t) ?? surfaceContainer,
      brandDarkGreen: Color.lerp(brandDarkGreen, other.brandDarkGreen, t) ?? brandDarkGreen,
      brandBrightGreen: Color.lerp(brandBrightGreen, other.brandBrightGreen, t) ?? brandBrightGreen,
      badgeMint: Color.lerp(badgeMint, other.badgeMint, t) ?? badgeMint,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      heroBorder: Color.lerp(heroBorder, other.heroBorder, t) ?? heroBorder,
      backShadowColor: Color.lerp(backShadowColor, other.backShadowColor, t) ?? backShadowColor,
      topOverlayGradient: LinearGradient.lerp(topOverlayGradient, other.topOverlayGradient, t) ?? topOverlayGradient,
      bottomCtaGradient: LinearGradient.lerp(bottomCtaGradient, other.bottomCtaGradient, t) ?? bottomCtaGradient,
    );
  }
}

class ProductPageThemeTextStyles {
  const ProductPageThemeTextStyles({
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.storeLine,
    required this.count,
    required this.timestamp,
    required this.commentPlaceholder,
    required this.sectionLabelRegular,
    required this.sectionLabelBold,
    required this.body,
    required this.bodyRegular,
    required this.reportExpired,
    required this.cta,
    required this.onlinePill,
  });

  static const ProductPageThemeTextStyles base = ProductPageThemeTextStyles(
    title: ProductPageFigmaTextStyles.title,
    price: ProductPageFigmaTextStyles.price,
    originalPrice: ProductPageFigmaTextStyles.originalPrice,
    storeLine: ProductPageFigmaTextStyles.storeLine,
    count: ProductPageFigmaTextStyles.count,
    timestamp: ProductPageFigmaTextStyles.timestamp,
    commentPlaceholder: ProductPageFigmaTextStyles.commentPlaceholder,
    sectionLabelRegular: ProductPageFigmaTextStyles.sectionLabelRegular,
    sectionLabelBold: ProductPageFigmaTextStyles.sectionLabelBold,
    body: ProductPageFigmaTextStyles.body,
    bodyRegular: ProductPageFigmaTextStyles.bodyRegular,
    reportExpired: ProductPageFigmaTextStyles.reportExpired,
    cta: ProductPageFigmaTextStyles.cta,
    onlinePill: ProductPageFigmaTextStyles.onlinePill,
  );

  final TextStyle title;
  final TextStyle price;
  final TextStyle originalPrice;
  final TextStyle storeLine;
  final TextStyle count;
  final TextStyle timestamp;
  final TextStyle commentPlaceholder;
  final TextStyle sectionLabelRegular;
  final TextStyle sectionLabelBold;
  final TextStyle body;
  final TextStyle bodyRegular;
  final TextStyle reportExpired;
  final TextStyle cta;
  final TextStyle onlinePill;
}
