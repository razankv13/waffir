import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';

class ProductPageTopOverlay extends StatelessWidget {
  const ProductPageTopOverlay({super.key, required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(gradient: theme.colors.topOverlayGradient),
      child: Padding(
        padding: EdgeInsets.only(
          top: responsive.scale(64),
          left: responsive.scale(16),
          right: responsive.scale(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WaffirBackButton(size: responsive.scale(44), padding: EdgeInsets.zero),
            _OnlinePill(theme: theme),
          ],
        ),
      ),
    );
  }
}

class _OnlinePill extends StatelessWidget {
  const _OnlinePill({required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.brandBrightGreen,
        borderRadius: BorderRadius.circular(responsive.scale(60)),
        boxShadow: [
          BoxShadow(
            color: theme.colors.backShadowColor,
            blurRadius: responsive.scale(8),
            spreadRadius: responsive.scale(2),
            offset: Offset.zero,
          ),
        ],
      ),
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      child: Text(
        LocaleKeys.productPage.availability.online.tr(),
        style: theme.textStyles.onlinePill.copyWith(
          color: theme.colors.textPrimary,
          fontSize: responsive.scaleFontSize(
            theme.textStyles.onlinePill.fontSize ?? 12,
            minSize: 10,
          ),
        ),
      ),
    );
  }
}
