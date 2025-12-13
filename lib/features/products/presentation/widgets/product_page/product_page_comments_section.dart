import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_actions_row.dart';

/// Product page comments section as slivers.
///
/// Use inside a `CustomScrollView(slivers: ...)`.
class ProductPageCommentsSection extends StatelessWidget {
  const ProductPageCommentsSection({
    super.key,
    required this.theme,
    required this.avatarAssetPath,
  });

  final ProductPageTheme theme;
  final String avatarAssetPath;

  static const List<String> _timeTexts = [
    '3 hours ago',
    '2 weeks ago',
    '3 weeks ago',
    '3 weeks ago',
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final itemCount = _timeTexts.isEmpty ? 0 : (_timeTexts.length * 2 - 1);

    return SliverPadding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              return SizedBox(height: responsive.scale(16));
            }

            final itemIndex = index ~/ 2;
            return ProductPageTestimonial(
              theme: theme,
              timeText: _timeTexts[itemIndex],
              avatarAssetPath: avatarAssetPath,
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }
}

class ProductPageTestimonial extends StatelessWidget {
  const ProductPageTestimonial({
    super.key,
    required this.theme,
    required this.timeText,
    required this.avatarAssetPath,
  });

  final ProductPageTheme theme;
  final String timeText;
  final String avatarAssetPath;

  static const String _testimonialText =
      'We were only sad not to stay longer. We hope to be back to explore Nantes some more and would love to stay '
      'at Golwen’s place again, if they’ll have us! :)';

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: responsive.scale(40),
              height: responsive.scale(40),
              decoration: BoxDecoration(
                color: theme.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(responsive.scale(1000)),
                image: DecorationImage(
                  image: AssetImage(avatarAssetPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: responsive.scale(10.699578285217285)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emma',
                  style: const TextStyle(
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1.4000000272478377,
                  ).copyWith(
                    fontSize: responsive.scaleFontSize(14),
                    color: theme.colors.textPrimary,
                  ),
                ),
                Text(
                  'May 2023',
                  style: const TextStyle(
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w400,
                    height: 1.3374473253885906,
                  ).copyWith(
                    fontSize: responsive.scaleFontSize(12),
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: responsive.scale(12.482841491699219)),
        Text(
          _testimonialText,
          style: const TextStyle(
            fontFamily: 'Parkinsans',
            fontWeight: FontWeight.w500,
            height: 1.3999999364217122,
          ).copyWith(
            fontSize: responsive.scaleFontSize(12),
            color: theme.colors.textPrimary,
          ),
        ),
        SizedBox(height: responsive.scale(12.482841491699219)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(responsive.scale(1000)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductPageIconBubble(
                    theme: theme,
                    asset: 'assets/icons/product_page/like_active.svg',
                  ),
                  Text(
                    '21',
                    style: theme.textStyles.count.copyWith(
                      color: theme.colors.textMid,
                      fontSize: responsive.scaleFontSize(
                        theme.textStyles.count.fontSize ?? 14,
                      ),
                    ),
                  ),
                  ProductPageIconBubble(
                    theme: theme,
                    asset: 'assets/icons/product_page/like_inactive.svg',
                  ),
                ],
              ),
            ),
            Text(
              timeText,
              style: theme.textStyles.timestamp.copyWith(
                color: theme.colors.textSecondary,
                fontSize: responsive.scaleFontSize(
                  theme.textStyles.timestamp.fontSize ?? 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
