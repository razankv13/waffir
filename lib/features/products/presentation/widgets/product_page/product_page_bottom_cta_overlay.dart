import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';
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
    final responsive = context.rs;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.colors.bottomCtaGradient,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: responsive.s(16),
          right: responsive.s(16),
          bottom: responsive.s(48),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: responsive.s(247),
              height: responsive.s(48),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colors.brandDarkGreen,
                  foregroundColor: theme.colors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.s(30)),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onCtaTap();
                },
                child: Text(
                  LocaleKeys.productPage.cta.seeDeal.tr(args: ['(store name)']),
                  textAlign: TextAlign.center,
                  style: theme.textStyles.cta.copyWith(
                    color: theme.colors.background,
                    fontSize: responsive.sFont(theme.textStyles.cta.fontSize ?? 14, minSize: 10),
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.s(16)),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onShareTap();
              },
              child: Container(
                width: responsive.s(44),
                height: responsive.s(44),
                decoration: BoxDecoration(
                  color: theme.colors.brandDarkGreen,
                  borderRadius: BorderRadius.circular(responsive.s(1000)),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/product_page/share_ios.svg',
                    width: responsive.s(13.33),
                    height: responsive.s(16.67),
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
