import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
import 'package:waffir/features/products/presentation/widgets/review_card.dart';

/// Reviews section widget as slivers.
///
/// Use inside a `CustomScrollView(slivers: ...)`.
///
/// Note: this is intentionally sliver-based (no nested `ListView`).
class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    super.key,
    required this.reviews,
    this.averageRating,
    this.totalReviews,
    this.onReviewHelpful,
    this.onViewAllReviews,
    this.height = 714.2,
  });

  final List<Review> reviews;
  final double? averageRating;
  final int? totalReviews;
  final Function(String reviewId)? onReviewHelpful;
  final VoidCallback? onViewAllReviews;

  /// Kept for backwards compatibility with the Figma spec, but not enforced in sliver mode.
  final double height;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    final hasReviews = reviews.isNotEmpty;

    // Layout:
    // 0 composer
    // 1 spacer
    // 2 emptyState OR list(ReviewCard + separators)
    final listChildCount = hasReviews ? (reviews.length * 2 - 1) : 1;
    final totalChildCount = 2 + listChildCount;

    return SliverPadding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return _ComposerRow(colorScheme: colorScheme);
            }

            if (index == 1) {
              return SizedBox(height: responsive.scale(12));
            }

            if (!hasReviews) {
              return _buildEmptyState(context);
            }

            // Reviews list starts at index 2.
            final listIndex = index - 2;
            if (listIndex.isOdd) {
              return SizedBox(height: responsive.scale(12));
            }

            final reviewIndex = listIndex ~/ 2;
            final review = reviews[reviewIndex];

            return ReviewCard(
              review: review,
              onHelpfulTap: () => onReviewHelpful?.call(review.id),
            );
          },
          childCount: totalChildCount,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.scale(32)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: responsive.scale(64),
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              'No reviews yet',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              'Be the first to review this product',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerRow extends StatelessWidget {
  const _ComposerRow({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      children: [
        CircleAvatar(
          radius: responsive.scale(32),
          backgroundColor: colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person_outline,
            size: responsive.scale(28),
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(width: responsive.scale(12)),
        Expanded(
          child: Container(
            height: responsive.scale(56),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(responsive.scale(16)),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
            child: Text(
              'Write your comment',
              style: const TextStyle(
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w500,
                height: 1.15,
              ).copyWith(
                fontSize: responsive.scaleFontSize(16, minSize: 10),
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SizedBox(width: responsive.scale(11)),
        InkWell(
          borderRadius: BorderRadius.circular(responsive.scale(1000)),
          onTap: () {},
          child: Container(
            width: responsive.scale(44),
            height: responsive.scale(44),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(responsive.scale(1000)),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/arrow_icon.svg',
              width: responsive.scale(20),
              height: responsive.scale(20),
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}
