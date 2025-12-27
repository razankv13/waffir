import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
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
    final responsive = context.rs;

    return Container(
      padding: responsive.sPadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: responsive.s(1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: responsive.s(20),
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: review.userAvatarUrl != null ? CachedNetworkImageProvider(review.userAvatarUrl!) : null,
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
              SizedBox(width: responsive.s(12)),
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
                        fontSize: responsive.sFont(14, minSize: 10),
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: responsive.s(2)),
                    Text(
                      review.createdAt != null ? DateFormat('MMM yyyy').format(review.createdAt!) : '',
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontWeight: FontWeight.w400,
                      ).copyWith(
                        fontSize: responsive.sFont(12, minSize: 10),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.s(12)),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Parkinsans',
              fontWeight: FontWeight.w500,
              height: 1.4,
            ).copyWith(
              fontSize: responsive.sFont(12, minSize: 10),
              color: colorScheme.onSurface,
            ),
          ),
          if (review.imageUrls.isNotEmpty) ...[
            SizedBox(height: responsive.s(12)),
            SizedBox(
              height: responsive.s(80),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < review.imageUrls.length; i++) ...[
                      if (i != 0) SizedBox(width: responsive.s(8)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(responsive.s(8)),
                        child: AppNetworkImage(
                          imageUrl: review.imageUrls[i],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          contentType: ImageContentType.generic,
                          errorWidget: Container(
                            width: responsive.s(80),
                            height: responsive.s(80),
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
          SizedBox(height: responsive.s(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(responsive.s(1000)),
                onTap: onHelpfulTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(responsive.s(1000)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: responsive.s(6)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.s(40),
                        height: responsive.s(40),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/comment_figma.svg',
                          width: responsive.s(20),
                          height: responsive.s(20),
                          colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: responsive.s(6)),
                      Text(
                        '${review.helpfulCount}',
                        style: const TextStyle(
                          fontFamily: 'Parkinsans',
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ).copyWith(
                          fontSize: responsive.sFont(14, minSize: 10),
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: responsive.s(6)),
                      Container(
                        width: responsive.s(40),
                        height: responsive.s(40),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/comment_figma.svg',
                          width: responsive.s(20),
                          height: responsive.s(20),
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
                  fontSize: responsive.sFont(12, minSize: 10),
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
