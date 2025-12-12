import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
import 'package:waffir/features/products/presentation/widgets/review_card.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

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
    final responsive = context.responsive;

    return Container(
      height: height,
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Composer row (avatar, input pill, send button)
          Row(
            children: [
              // Avatar 64x64
              CircleAvatar(
                radius: responsive.scale(32),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.person_outline,
                  size: responsive.scale(28),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: responsive.scale(12)),
              // Input pill 232x56 (use Expanded to avoid overflow on small screens)
              Expanded(
                child: Container(
                  height: responsive.scale(56),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Write your comment',
                    style: TextStyle(
                      fontFamily: 'Parkinsans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA3A3A3),
                      height: 1.15,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.scale(11)),
              // Send button 44x44
              InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: () {},
                child: Container(
                  width: responsive.scale(44),
                  height: responsive.scale(44),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F352D),
                    borderRadius: BorderRadius.circular(1000),
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
          ),

          SizedBox(height: responsive.scale(12)),

          // Reviews list
          Expanded(
            child: reviews.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => SizedBox(height: responsive.scale(12)),
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
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: responsive.scale(64),
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
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
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
