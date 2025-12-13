import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';

/// Product actions row (Figma node 54:5549 / 54:5550).
class StoreActionsSection extends StatelessWidget {
  const StoreActionsSection({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

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
            '3 hours ago',
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
                _ActionIconBox(
                  assetPath: 'assets/icons/like_active.svg',
                ),
                SizedBox(width: responsive.scale(6)),
                Text(
                  countText,
                  style: AppTextStyles.storePageActionCount.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                SizedBox(width: responsive.scale(6)),
                const _ActionIconBox(assetPath: 'assets/icons/product_page/like_inactive.svg'),
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

    return SizedBox(
      width: responsive.scale(40),
      height: responsive.scale(40),
      child: Center(
        child: SizedBox(
          width: responsive.scale(24),
          height: responsive.scale(24),
          child: SvgPicture.asset(assetPath, fit: BoxFit.contain),
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
              child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
            ),
            SizedBox(width: responsive.scale(6)),
            Text(
              label,
              style: AppTextStyles.storePageActionCount.copyWith(color: countColor),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreIconOnlyPill extends StatelessWidget {
  const StoreIconOnlyPill({
    super.key,
    required this.iconAsset,
    required this.iconColor,
  });

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
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

/// Comments section (Figma node 54:5588).
class StoreCommentsSection extends StatelessWidget {
  const StoreCommentsSection({super.key, required this.testimonials});

  final List<StoreTestimonial> testimonials;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final hasTestimonials = testimonials.isNotEmpty;
    final trailingCount = hasTestimonials ? (1 + (testimonials.length * 2 - 1)) : 0;
    final childCount = 1 + trailingCount; // composer + (spacer + testimonial + separators)

    return SliverPadding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const StoreCommentComposer();
            }

            if (!hasTestimonials) {
              // childCount == 1 in this case, so this should never be reached.
              return const SizedBox.shrink();
            }

            if (index == 1) {
              return SizedBox(height: responsive.scale(12));
            }

            final m = index - 2;
            if (m.isOdd) {
              return SizedBox(height: responsive.scale(16));
            }

            final testimonialIndex = m ~/ 2;
            return StoreTestimonialStack(testimonial: testimonials[testimonialIndex]);
          },
          childCount: childCount,
        ),
      ),
    );
  }
}

class StoreCommentComposer extends StatelessWidget {
  const StoreCommentComposer({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();

    return Row(
      children: [
        Container(
          width: responsive.scale(64),
          height: responsive.scale(64),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onPrimary.withValues(alpha: 0.4),
              width: responsive.scale(1.6),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: colorScheme.surface,
            child: Icon(Icons.person_outline, color: colorScheme.onSurface),
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
                  color: colorScheme.surfaceContainerHighest, // #F2F2F2
                  borderRadius: BorderRadius.circular(responsive.scale(16)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                  child: Center(
                    child: Text(
                      'Write your comment',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.storePageCommentPlaceholder.copyWith(
                        color: promoColors?.actionCount ?? const Color(0xFFA3A3A3),
                      ),
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
            color: colorScheme.primary, // #0F352D
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment send tapped')),
                );
              },
              child: Center(
                child: SizedBox(
                  width: responsive.scale(20),
                  height: responsive.scale(20),
                  child: SvgPicture.asset(
                    'assets/icons/arrow_icon.svg',
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StoreTestimonialStack extends StatelessWidget {
  const StoreTestimonialStack({super.key, required this.testimonial});

  final StoreTestimonial testimonial;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: responsive.scale(40),
              height: responsive.scale(40),
              child: CircleAvatar(
                backgroundColor: colorScheme.surface,
                child: Icon(Icons.person_outline, color: colorScheme.onSurface),
              ),
            ),
            SizedBox(width: responsive.scale(10.699578285217285)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testimonial.author,
                  style: AppTextStyles.storePageTestimonialAuthor.copyWith(color: colorScheme.onSurface),
                ),
                SizedBox(height: responsive.scale(2)),
                Text(
                  testimonial.location,
                  style: AppTextStyles.storePageTestimonialDate.copyWith(
                    color: promoColors?.actionCount ?? const Color(0xFFA3A3A3),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: responsive.scale(12.482841491699219)),
        Text(
          testimonial.body,
          style: AppTextStyles.storePageTestimonialBody.copyWith(color: colorScheme.onSurface),
        ),
        SizedBox(height: responsive.scale(12.482841491699219)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StoreLikeDislikePill(countText: '21', isLiked: false),
            Text(
              '3 hours ago',
              style: AppTextStyles.storePageTimestamp.copyWith(
                color: promoColors?.actionCount ?? const Color(0xFFA3A3A3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
