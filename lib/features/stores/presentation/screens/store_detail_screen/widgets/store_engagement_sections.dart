import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Product actions row (Figma node 54:5549 / 54:5550).
class StoreActionsSection extends StatelessWidget {
  const StoreActionsSection({super.key, required this.isFavorite, required this.onToggleFavorite});

  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();

    // Outer container is provided by parent padding (12px 16px in StoreDetailView).
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              StoreLikeDislikePill(
                countText: '21',
                isLiked: isFavorite,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onToggleFavorite();
                },
              ),
              SizedBox(width: responsive.scale(16)),
              StoreIconCountPill(
                iconAsset: 'assets/icons/store_detail/comment.svg',
                label: '45',
                textColor: colorScheme.onSurfaceVariant,
                countColor: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: responsive.scale(16)),
              StoreIconOnlyPill(
                iconAsset: 'assets/icons/store_detail/star.svg',
                iconColor: promoColors?.actionCount ?? colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        SizedBox(width: responsive.scale(8)),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            LocaleKeys.stores.detail.comments.timeAgo.tr(),
            textAlign: TextAlign.right,
            style: AppTextStyles.storePageTimestamp.copyWith(
              color: promoColors?.actionCount ?? const Color(0xFFA3A3A3),
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}

class StoreLikeDislikePill extends StatelessWidget {
  const StoreLikeDislikePill({
    super.key,
    required this.countText,
    required this.isLiked,
    this.onTap,
  });

  final String countText;
  final bool isLiked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest, // #F2F2F2
      borderRadius: BorderRadius.circular(responsive.scale(1000)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
        onTap: onTap,
        child: SizedBox(
          height: responsive.scale(44),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.scale(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionIconBox(assetPath: Assets.icons.storeDetail.likeActive.path),
                SizedBox(width: responsive.scale(6)),
                Text(
                  countText,
                  style: AppTextStyles.storePageActionCount.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: responsive.scale(6)),
                _ActionIconBox(assetPath: Assets.icons.productPage.likeInactive.path),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIconBox extends StatelessWidget {
  const _ActionIconBox({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: responsive.scale(40),
      height: responsive.scale(40),
      child: Center(
        child: SizedBox(
          width: responsive.scale(24),
          height: responsive.scale(24),
          child: SvgPicture.asset(
            assetPath,
            colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class StoreIconCountPill extends StatelessWidget {
  const StoreIconCountPill({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.textColor,
    required this.countColor,
  });

  final String iconAsset;
  final String label;
  final Color textColor;
  final Color countColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest, // #F2F2F2
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
      ),
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: responsive.scale(20),
              height: responsive.scale(20),
              child: SvgPicture.asset(
                iconAsset,
                colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: responsive.scale(6)),
            Text(label, style: AppTextStyles.storePageActionCount.copyWith(color: countColor)),
          ],
        ),
      ),
    );
  }
}

class StoreIconOnlyPill extends StatelessWidget {
  const StoreIconOnlyPill({super.key, required this.iconAsset, required this.iconColor});

  final String iconAsset;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
      ),
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(12)),
        child: SizedBox(
          width: responsive.scale(20),
          height: responsive.scale(20),
          child: SvgPicture.asset(
            iconAsset,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
