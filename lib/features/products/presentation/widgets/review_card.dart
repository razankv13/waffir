import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Review card widget for displaying individual product reviews
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
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: responsive.scale(20),
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: review.userAvatarUrl != null
                    ? NetworkImage(review.userAvatarUrl!)
                    : null,
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

              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName ?? 'Anonymous',
                          style: const TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF151515),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.scale(2)),
                    Text(
                      review.createdAt != null ? DateFormat('MMM yyyy').format(review.createdAt!) : '',
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA3A3A3),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

          SizedBox(height: responsive.scale(12)),

          // Review comment
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Parkinsans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF151515),
              height: 1.4,
            ),
          ),

          // Review images (if any)
          if (review.imageUrls.isNotEmpty) ...[
            SizedBox(height: responsive.scale(12)),
            SizedBox(
              height: responsive.scale(80),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                separatorBuilder: (context, index) => SizedBox(width: responsive.scale(8)),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(responsive.scale(8)),
                    child: Image.network(
                      review.imageUrls[index],
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
                  );
                },
              ),
            ),
          ],

          SizedBox(height: responsive.scale(12)),

          // Bottom row: like/dislike tag pill and relative time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: onHelpfulTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(1000),
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
                        ),
                      ),
                      SizedBox(width: responsive.scale(6)),
                      Text(
                        '${review.helpfulCount}',
                        style: const TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF595959),
                          height: 1.15,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA3A3A3),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
