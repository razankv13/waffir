import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

class ProductPageActionsRow extends StatelessWidget {
  const ProductPageActionsRow({super.key, required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    Widget pill({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
      return Container(
        height: responsive.s(44),
        padding: responsive.sPadding(padding),
        decoration: BoxDecoration(
          color: theme.colors.surfaceContainer,
          borderRadius: BorderRadius.circular(responsive.s(1000)),
        ),
        child: child,
      );
    }

    return Padding(
      padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Like/Dislike tag
                pill(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProductPageIconBubble(
                        theme: theme,
                        asset: 'assets/icons/product_page/like_active.svg',
                      ),
                      SizedBox(width: responsive.s(6)),
                      Text(
                        '21',
                        style: theme.textStyles.count.copyWith(
                          color: theme.colors.textMid,
                          fontSize: responsive.sFont(theme.textStyles.count.fontSize ?? 14),
                        ),
                      ),
                      SizedBox(width: responsive.s(6)),
                      ProductPageIconBubble(
                        theme: theme,
                        asset: 'assets/icons/product_page/like_inactive.svg',
                      ),
                    ],
                  ),
                ),

                SizedBox(width: responsive.s(16)),

                // Comment pill
                Container(
                  padding: responsive.sPadding(const EdgeInsets.all(12)),
                  decoration: BoxDecoration(
                    color: theme.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(responsive.s(1000)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: responsive.s(20),
                        height: responsive.s(20),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/product_page/comment.svg',
                            width: responsive.s(17.22),
                            height: responsive.s(17.22),
                            colorFilter: const ColorFilter.mode(AppColors.gray03, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.s(6)),
                      Text(
                        '45',
                        style: theme.textStyles.count.copyWith(
                          color: theme.colors.textMid,
                          fontSize: responsive.sFont(theme.textStyles.count.fontSize ?? 14),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: responsive.s(16)),

                // Third circular action
                Container(
                  padding: responsive.sPadding(const EdgeInsets.all(12)),
                  decoration: BoxDecoration(
                    color: theme.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(responsive.s(1000)),
                  ),
                  child: SizedBox(
                    width: responsive.s(20),
                    height: responsive.s(20),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.productPage.tag.path,
                        width: responsive.s(19.17),
                        height: responsive.s(18.31),
                        colorFilter: const ColorFilter.mode(AppColors.gray03, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '3 hours ago',
            style: theme.textStyles.timestamp.copyWith(
              color: theme.colors.textSecondary,
              fontSize: responsive.sFont(theme.textStyles.timestamp.fontSize ?? 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPageIconBubble extends StatelessWidget {
  const ProductPageIconBubble({super.key, required this.theme, required this.asset});

  final ProductPageTheme theme;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    return Container(
      width: responsive.s(40),
      height: responsive.s(40),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(responsive.s(1000)),
      ),
      child: Center(
        child: SvgPicture.asset(
          asset,
          width: responsive.s(24),
          height: responsive.s(24),
          colorFilter: const ColorFilter.mode(AppColors.gray03, BlendMode.srcIn),
        ),
      ),
    );
  }
}
