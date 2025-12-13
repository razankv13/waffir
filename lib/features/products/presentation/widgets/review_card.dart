import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/domain/entities/review.dart';

/// Review card widget for displaying individual product reviews.
///
/// Note: intentionally avoids nested `ListView` (including horizontal).
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    this.onHelpfulTap,
  });

  final Review review;
  final VoidCallback? onHelpfulTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final responsive = context.responsive;

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: responsive.scale(1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: responsive.scale(20),
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: review.userAvatarUrl != null ? NetworkImage(review.userAvatarUrl!) : null,
                child: review.userAvatarUrl == null
                    ? Text(
                        review.userName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: responsive.scale(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Anonymous',
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontWeight: FontWeight.w500,
                      ).copyWith(
                        fontSize: responsive.scaleFontSize(14, minSize: 10),
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: responsive.scale(2)),
                    Text(
                      review.createdAt != null ? DateFormat('MMM yyyy').format(review.createdAt!) : '',
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontWeight: FontWeight.w400,
                      ).copyWith(
                        fontSize: responsive.scaleFontSize(12, minSize: 10),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.scale(12)),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Parkinsans',
              fontWeight: FontWeight.w500,
              height: 1.4,
            ).copyWith(
              fontSize: responsive.scaleFontSize(12, minSize: 10),
              color: colorScheme.onSurface,
            ),
          ),
          if (review.imageUrls.isNotEmpty) ...[
            SizedBox(height: responsive.scale(12)),
            SizedBox(
              height: responsive.scale(80),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < review.imageUrls.length; i++) ...[
                      if (i != 0) SizedBox(width: responsive.scale(8)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(responsive.scale(8)),
                        child: Image.network(
                          review.imageUrls[i],
                          width: responsive.scale(80),
                          height: responsive.scale(80),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: responsive.scale(80),
                            height: responsive.scale(80),
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: responsive.scale(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(responsive.scale(1000)),
                onTap: onHelpfulTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(responsive.scale(1000)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(6)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.scale(40),
                        height: responsive.scale(40),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/comment_figma.svg',
                          width: responsive.scale(20),
                          height: responsive.scale(20),
                          colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: responsive.scale(6)),
                      Text(
                        '${review.helpfulCount}',
                        style: const TextStyle(
                          fontFamily: 'Parkinsans',
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ).copyWith(
                          fontSize: responsive.scaleFontSize(14, minSize: 10),
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: responsive.scale(6)),
                      Container(
                        width: responsive.scale(40),
                        height: responsive.scale(40),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/comment_figma.svg',
                          width: responsive.scale(20),
                          height: responsive.scale(20),
                          colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                review.createdAt != null ? timeago.format(review.createdAt!) : '',
                style: const TextStyle(
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ).copyWith(
                  fontSize: responsive.scaleFontSize(12, minSize: 10),
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
