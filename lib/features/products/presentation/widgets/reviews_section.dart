import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/rating_display.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
import 'package:waffir/features/products/presentation/widgets/review_card.dart';

/// Reviews section widget for displaying product reviews/comments
///
/// Matches Figma specifications:
/// - Height: 714.2px (fixed)
/// - 16px padding
/// - 12px gap between reviews
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
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews & Ratings',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (averageRating != null) ...[
                    const SizedBox(height: 8),
                    RatingDisplay(
                      rating: averageRating!,
                      reviewCount: totalReviews,
                      size: RatingSize.medium,
                      showRatingText: true,
                    ),
                  ],
                ],
              ),

              // View all button
              if (onViewAllReviews != null)
                TextButton(
                  onPressed: onViewAllReviews,
                  child: Text(
                    'View All',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Reviews list
          Expanded(
            child: reviews.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ReviewCard(
                        review: reviews[index],
                        onHelpfulTap: () => onReviewHelpful?.call(reviews[index].id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this product',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
