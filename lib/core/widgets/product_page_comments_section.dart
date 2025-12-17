import 'package:easy_localization/easy_localization.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/presentation/widgets/product_page/product_page_actions_row.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Reusable comments/testimonials section styled like the product page (Figma 54:5588).
///
/// Renders as slivers so it can drop into a `CustomScrollView` or `NestedScrollView`.
class ProductPageCommentsSection extends StatelessWidget {
  const ProductPageCommentsSection({
    super.key,
    required this.theme,
    required this.comments,
    this.defaultAvatarAssetPath,
    this.padding,
    this.showComposer = true,
    this.composerHintText = 'productPage.comments.writeComment',

    this.onSendTap,
  });

  final ProductPageTheme theme;
  final List<ProductPageComment> comments;
  final String? defaultAvatarAssetPath;
  final EdgeInsets? padding;
  final bool showComposer;
  final String composerHintText;
  final VoidCallback? onSendTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final children = <Widget>[];

    if (showComposer) {
      children.add(
        _ProductPageCommentComposer(
          theme: theme,
          hintText: composerHintText.tr(),
          avatarAssetPath: defaultAvatarAssetPath,
          onSendTap: onSendTap,
        ),
      );
    }

    if (comments.isEmpty) {
      children.add(SizedBox(height: responsive.scale(12)));
      children.add(
        Text(
          LocaleKeys.productPage.comments.noComments.tr(),
          style: theme.textStyles.body.copyWith(
            color: theme.colors.textSecondary,
            fontSize: responsive.scaleFontSize(theme.textStyles.body.fontSize ?? 14),
          ),
        ),
      );
    } else {
      if (showComposer) {
        children.add(SizedBox(height: responsive.scale(12)));
      }

      for (var i = 0; i < comments.length; i++) {
        children.add(
          _ProductPageCommentCard(
            theme: theme,
            comment: comments[i],
            defaultAvatarAssetPath: defaultAvatarAssetPath,
          ),
        );

        final isLast = i == comments.length - 1;
        if (!isLast) {
          children.add(SizedBox(height: responsive.scale(16)));
        }
      }
    }

    return SliverPadding(
      padding: padding ?? responsive.scalePadding(const EdgeInsets.all(16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => children[index],
          childCount: children.length,
        ),
      ),
    );
  }
}

class ProductPageComment {
  const ProductPageComment({
    required this.author,
    required this.subtitle,
    required this.body,
    required this.timeText,
    this.helpfulCount = 0,
    this.avatarAssetPath,
  });

  final String author;
  final String subtitle;
  final String body;
  final String timeText;
  final int helpfulCount;
  final String? avatarAssetPath;
}

class _ProductPageCommentCard extends StatelessWidget {
  const _ProductPageCommentCard({
    required this.theme,
    required this.comment,
    required this.defaultAvatarAssetPath,
  });

  final ProductPageTheme theme;
  final ProductPageComment comment;
  final String? defaultAvatarAssetPath;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final avatarPath = comment.avatarAssetPath ?? defaultAvatarAssetPath;

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
                image: avatarPath != null
                    ? DecorationImage(image: AssetImage(avatarPath), fit: BoxFit.cover)
                    : null,
              ),
              child: avatarPath == null
                  ? Icon(
                      Icons.person_outline,
                      size: responsive.scale(22),
                      color: theme.colors.textSecondary,
                    )
                  : null,
            ),
            SizedBox(width: responsive.scale(10.699578285217285)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author,
                  style: theme.textStyles.sectionLabelBold.copyWith(
                    color: theme.colors.textPrimary,
                    fontSize: responsive.scaleFontSize(theme.textStyles.sectionLabelBold.fontSize ?? 14),
                  ),
                ),
                Text(
                  comment.subtitle,
                  style: theme.textStyles.sectionLabelRegular.copyWith(
                    color: theme.colors.textSecondary,
                    fontSize: responsive.scaleFontSize(theme.textStyles.sectionLabelRegular.fontSize ?? 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: responsive.scale(12.482841491699219)),
        Text(
          comment.body,
          style: theme.textStyles.body.copyWith(
            color: theme.colors.textPrimary,
            fontSize: responsive.scaleFontSize(theme.textStyles.body.fontSize ?? 12),
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
                    asset: Assets.icons.productPage.likeActive.path,
                  ),
                  Text(
                    '${comment.helpfulCount}',
                    style: theme.textStyles.count.copyWith(
                      color: theme.colors.textMid,
                      fontSize: responsive.scaleFontSize(theme.textStyles.count.fontSize ?? 14),
                    ),
                  ),
                  ProductPageIconBubble(
                    theme: theme,
                    asset: Assets.icons.productPage.likeInactive.path,
                  ),
                ],
              ),
            ),
            Text(
              comment.timeText,
              style: theme.textStyles.timestamp.copyWith(
                color: theme.colors.textSecondary,
                fontSize: responsive.scaleFontSize(theme.textStyles.timestamp.fontSize ?? 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductPageCommentComposer extends StatelessWidget {
  const _ProductPageCommentComposer({
    required this.theme,
    required this.hintText,
    required this.avatarAssetPath,
    required this.onSendTap,
  });

  final ProductPageTheme theme;
  final String hintText;
  final String? avatarAssetPath;
  final VoidCallback? onSendTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final avatarPath = avatarAssetPath;

    return Row(
      children: [
        Container(
          width: responsive.scale(64),
          height: responsive.scale(64),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colors.brandBrightGreen.withOpacity(0.4),
              width: responsive.scale(1.6),
            ),
          ),
          child: ClipOval(
            child: avatarPath != null
                ? Image.asset(avatarPath, fit: BoxFit.cover)
                : ColoredBox(
                    color: theme.colors.surfaceContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: responsive.scale(28),
                      color: theme.colors.textSecondary,
                    ),
                  ),
          ),
        ),
        SizedBox(width: responsive.scale(12)),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsive.scale(232)),
            child: SizedBox(
              height: responsive.scale(56),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(responsive.scale(16)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hintText,
                      textAlign: TextAlign.left,
                      style: theme.textStyles.commentPlaceholder.copyWith(
                        color: theme.colors.textSecondary,
                        fontSize: responsive.scaleFontSize(
                          theme.textStyles.commentPlaceholder.fontSize ?? 14,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: responsive.scale(11)),
        SizedBox(
          width: responsive.scale(44),
          height: responsive.scale(44),
          child: Material(
            color: theme.colors.brandDarkGreen,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.lightImpact();
                onSendTap?.call();
              },
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.arrowIcon.path,
                  width: responsive.scale(20),
                  height: responsive.scale(20),
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
