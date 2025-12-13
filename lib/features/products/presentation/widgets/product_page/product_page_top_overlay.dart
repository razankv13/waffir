import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageTopOverlay extends StatelessWidget {
  const ProductPageTopOverlay({
    super.key,
    required this.theme,
  });

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.colors.topOverlayGradient,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: responsive.scale(64),
          left: responsive.scale(16),
          right: responsive.scale(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BackButton(theme: theme),
            _OnlinePill(theme: theme),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pop();
      },
      child: SizedBox(
        width: responsive.scale(44),
        height: responsive.scale(44),
        child: Center(
          // Figma export includes shadow bleed outside the 44×44 bounds.
          child: OverflowBox(
            maxWidth: responsive.scale(64),
            maxHeight: responsive.scale(64),
            child: SvgPicture.asset(
              'assets/icons/product_page/back_button.svg',
              width: responsive.scale(64),
              height: responsive.scale(64),
            ),
          ),
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
        'Online',
        style: theme.textStyles.onlinePill.copyWith(
          color: theme.colors.textPrimary,
          fontSize: responsive.scaleFontSize(theme.textStyles.onlinePill.fontSize ?? 12, minSize: 10),
        ),
      ),
    );
  }
}
