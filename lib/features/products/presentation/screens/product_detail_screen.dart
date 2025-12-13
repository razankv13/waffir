import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_actions_row.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_additional_actions.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_bottom_cta_overlay.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_comments_section.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_divider_line.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_hero.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_prices_section.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_product_info.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_top_overlay.dart';

/// Product detail screen (pixel-perfect)
///
/// Figma: Waffir Final → Product Page (node `34:4022`)
/// Baseline: 393px width (ResponsiveHelper.figmaWidth)
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isRTL = context.locale.languageCode == 'ar';
    final productTheme = Theme.of(context).extension<ProductPageTheme>() ?? ProductPageTheme.light;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: productTheme.colors.background,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: ProductPageHero(
                      height: responsive.scale(390),
                      borderColor: productTheme.colors.heroBorder,
                      imageAssetPath: 'assets/images/product_page/hero.png',
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                ];
              },
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: ProductPageActionsRow(theme: productTheme)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(child: ProductPagePricesSection(theme: productTheme)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(child: ProductPageAdditionalActions(theme: productTheme)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(child: ProductPageDividerLine(color: productTheme.colors.divider)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(child: ProductPageProductInfo(theme: productTheme)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(child: ProductPageDividerLine(color: productTheme.colors.divider)),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  ProductPageCommentsSection(
                    theme: productTheme,
                    avatarAssetPath: 'assets/images/product_page/avatar.png',
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
                  SliverToBoxAdapter(
                    child: ProductPageBottomCtaOverlay(
                      theme: productTheme,
                      onCtaTap: () {},
                      onShareTap: () {},
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: responsive.scale(24))),
                ],
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: ProductPageTopOverlay(theme: productTheme)),
          ],
        ),
      ),
    );
  }
}
