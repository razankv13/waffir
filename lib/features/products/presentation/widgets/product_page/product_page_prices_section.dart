import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

class ProductPagePricesSection extends StatelessWidget {
  const ProductPagePricesSection({super.key, required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    Widget pill({
      required Widget child,
      required Color background,
      BorderRadius? radius,
      EdgeInsets padding = const EdgeInsets.all(8),
    }) {
      return Container(
        padding: responsive.sPadding(padding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: radius ?? BorderRadius.circular(responsive.s(1000)),
        ),
        child: child,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Nike Men’s Air Max 2025 Shoes (3 Colors)",
            style: theme.textStyles.title.copyWith(
              color: theme.colors.textPrimary,
              fontSize: responsive.sFont(
                theme.textStyles.title.fontSize ?? 18,
                minSize: 12,
              ),
            ),
          ),
          SizedBox(height: responsive.s(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  pill(
                    background: theme.colors.brandDarkGreen,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: responsive.s(20),
                          height: responsive.s(20),
                          child: SvgPicture.asset(
                            'assets/icons/product_page/riyal.svg',
                            colorFilter: ColorFilter.mode(
                              theme.colors.brandBrightGreen,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.s(4)),
                        Text(
                          '400',
                          style: theme.textStyles.price.copyWith(
                            color: theme.colors.brandBrightGreen,
                            fontSize: responsive.sFont(
                              theme.textStyles.price.fontSize ?? 20,
                              minSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: responsive.s(8)),
                  pill(
                    background: theme.colors.surfaceContainer,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: responsive.s(14),
                          height: responsive.s(14),
                          child: SvgPicture.asset(
                            Assets.icons.productPage.riyal.path,
                            colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                          ),
                        ),
                        SizedBox(width: responsive.s(4)),
                        Text(
                          '809',
                          style: theme.textStyles.originalPrice.copyWith(
                            color: AppColors.red,
                            decoration: TextDecoration.lineThrough,
                            fontSize: responsive.sFont(
                              theme.textStyles.originalPrice.fontSize ?? 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: responsive.s(8)),
                  pill(
                    background: theme.colors.badgeMint,
                    radius: BorderRadius.circular(responsive.s(26.726573944091797)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: responsive.s(16),
                          height: responsive.s(16),
                          child: SvgPicture.asset(
                            Assets.icons.productPage.tag.path,
                            colorFilter: ColorFilter.mode(
                              theme.colors.brandDarkGreen,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.s(4)),
                        Text(
                          '13% off',
                          style:
                              const TextStyle(
                                fontFamily: 'Parkinsans',
                                fontWeight: FontWeight.w500,
                                height: 1.149999976158142,
                              ).copyWith(
                                fontSize: responsive.sFont(16),
                                color: theme.colors.brandDarkGreen,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'At Nike store',
                style: theme.textStyles.storeLine.copyWith(
                  color: theme.colors.textPrimary,
                  fontSize: responsive.sFont(
                    theme.textStyles.storeLine.fontSize ?? 14.266104698181152,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
