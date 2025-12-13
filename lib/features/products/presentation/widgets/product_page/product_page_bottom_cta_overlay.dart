import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageBottomCtaOverlay extends StatelessWidget {
  const ProductPageBottomCtaOverlay({
    super.key,
    required this.theme,
    required this.onCtaTap,
    required this.onShareTap,
  });

  final ProductPageTheme theme;
  final VoidCallback onCtaTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.colors.bottomCtaGradient,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: responsive.scale(16),
          right: responsive.scale(16),
          bottom: responsive.scale(48),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: responsive.scale(247),
              height: responsive.scale(48),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colors.brandDarkGreen,
                  foregroundColor: theme.colors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.scale(30)),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onCtaTap();
                },
                child: Text(
                  'See the deal at (store name)',
                  textAlign: TextAlign.center,
                  style: theme.textStyles.cta.copyWith(
                    color: theme.colors.background,
                    fontSize: responsive.scaleFontSize(theme.textStyles.cta.fontSize ?? 14, minSize: 10),
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.scale(16)),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onShareTap();
              },
              child: Container(
                width: responsive.scale(44),
                height: responsive.scale(44),
                decoration: BoxDecoration(
                  color: theme.colors.brandDarkGreen,
                  borderRadius: BorderRadius.circular(responsive.scale(1000)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/product_page/share_ios.svg',
                    width: responsive.scale(13.33),
                    height: responsive.scale(16.67),
                    colorFilter: ColorFilter.mode(theme.colors.background, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
