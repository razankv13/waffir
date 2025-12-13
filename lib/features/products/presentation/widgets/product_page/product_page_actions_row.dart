import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ProductPageActionsRow extends StatelessWidget {
  const ProductPageActionsRow({super.key, required this.theme});

  final ProductPageTheme theme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    Widget pill({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
      return Container(
        height: responsive.scale(44),
        padding: responsive.scalePadding(padding),
        decoration: BoxDecoration(
          color: theme.colors.surfaceContainer,
          borderRadius: BorderRadius.circular(responsive.scale(1000)),
        ),
        child: child,
      );
    }

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
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
                      SizedBox(width: responsive.scale(6)),
                      Text(
                        '21',
                        style: theme.textStyles.count.copyWith(
                          color: theme.colors.textMid,
                          fontSize: responsive.scaleFontSize(
                            theme.textStyles.count.fontSize ?? 14,
                            minSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.scale(6)),
                      ProductPageIconBubble(
                        theme: theme,
                        asset: 'assets/icons/product_page/like_inactive.svg',
                      ),
                    ],
                  ),
                ),

                SizedBox(width: responsive.scale(16)),

                // Comment pill
                Container(
                  padding: responsive.scalePadding(const EdgeInsets.all(12)),
                  decoration: BoxDecoration(
                    color: theme.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(responsive.scale(1000)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: responsive.scale(20),
                        height: responsive.scale(20),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/product_page/comment.svg',
                            width: responsive.scale(17.22),
                            height: responsive.scale(17.22),
                            colorFilter: ColorFilter.mode(
                              theme.colors.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: responsive.scale(6)),
                      Text(
                        '45',
                        style: theme.textStyles.count.copyWith(
                          color: theme.colors.textMid,
                          fontSize: responsive.scaleFontSize(
                            theme.textStyles.count.fontSize ?? 14,
                            minSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: responsive.scale(16)),

                // Third circular action
                Container(
                  padding: responsive.scalePadding(const EdgeInsets.all(12)),
                  decoration: BoxDecoration(
                    color: theme.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(responsive.scale(1000)),
                  ),
                  child: SizedBox(
                    width: responsive.scale(20),
                    height: responsive.scale(20),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/product_page/comment.svg',
                        width: responsive.scale(19.17),
                        height: responsive.scale(18.31),
                        colorFilter: ColorFilter.mode(theme.colors.textPrimary, BlendMode.srcIn),
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
              fontSize: responsive.scaleFontSize(
                theme.textStyles.timestamp.fontSize ?? 12,
                minSize: 10,
              ),
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
    final responsive = context.responsive;

    return Container(
      width: responsive.scale(40),
      height: responsive.scale(40),
      decoration: BoxDecoration(
        color: theme.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
      ),
      child: Center(
        child: SvgPicture.asset(
          asset,
          width: responsive.scale(24),
          height: responsive.scale(24),
          color: theme.colors.textPrimary,
        ),
      ),
    );
  }
}
