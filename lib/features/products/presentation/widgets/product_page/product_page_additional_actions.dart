import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

class ProductPageAdditionalActions extends StatelessWidget {
  const ProductPageAdditionalActions({super.key, required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: responsive.scale(16),
                height: responsive.scale(16),
                child: SvgPicture.asset(
                  Assets.icons.productPage.report.path,
                  colorFilter: ColorFilter.mode(theme.colors.textPrimary, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: responsive.scale(4)),
              Text(
                'Report Expired',
                style: theme.textStyles.reportExpired.copyWith(
                  color: theme.colors.textPrimary,
                  fontSize: responsive.scaleFontSize(theme.textStyles.reportExpired.fontSize ?? 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
