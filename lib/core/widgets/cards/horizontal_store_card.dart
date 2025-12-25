import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/products/discount_tag_pill.dart';

/// Horizontal store card designed to match the Favorites screen Figma example (node 7783:6484).
///
/// Layout:
/// - Row: fixed 120×120 image left, content right
/// - Optional discount pill + distance
/// - Optional favorite toggle overlay on image
class HorizontalStoreCard extends StatelessWidget {
  const HorizontalStoreCard({
    super.key,
    this.storeId,
    required this.imageUrl,
    required this.storeName,
    this.discountText,
    this.distance,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final String? storeId;
  final String imageUrl;
  final String storeName;
  final String? discountText;
  final String? distance;
  final VoidCallback? onTap;

  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    final imageSize = responsive.scale(120);
    final imagePadding = responsive.scale(8);
    final gap = responsive.scale(12);
    final cardRadius = responsive.scale(12);

    final favoriteOffset = responsive.scale(8);
    final favoriteSize = responsive.scale(32);
    final favoriteIconSize = responsive.scale(18);

    return InkWell(
      onTap:
          onTap ??
          () {
            if (storeId == null) return;
            context.pushNamed(
              AppRouteNames.storeDetail,
              pathParameters: {AppRouteParams.id: storeId!},
            );
          },
      borderRadius: BorderRadius.circular(cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image (fixed 120×120)
              Container(
                width: imageSize,
                height: imageSize,
                padding: EdgeInsets.all(imagePadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsive.scale(11)),
                    bottomLeft: Radius.circular(responsive.scale(11)),
                  ),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(responsive.scale(8)),
                      child: AppNetworkImage(
                        imageUrl: imageUrl,
                        contentType: ImageContentType.store,
                        useResponsiveScaling: false, // Parent container handles scaling
                      ),
                    ),

                    if (onFavoriteToggle != null)
                      Positioned(
                        top: favoriteOffset,
                        left: favoriteOffset,
                        child: GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Container(
                            width: favoriteSize,
                            height: favoriteSize,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: responsive.scale(4),
                                  offset: responsive.scaleOffset(const Offset(0, 2)),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.star : Icons.star_outline,
                              size: favoriteIconSize,
                              color: isFavorite
                                  ? const Color(0xFFFBBF24) // gold (matches existing store card)
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(width: gap),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: responsive.scale(8),
                    right: responsive.scale(8),
                    bottom: responsive.scale(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName,
                        style: TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: responsive.scaleFontSize(14),
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (discountText != null && discountText!.isNotEmpty) ...[
                        SizedBox(height: responsive.scale(8)),
                        DiscountTagPill(discountText: discountText!),
                      ],

                      if (distance != null && distance!.isNotEmpty) ...[
                        SizedBox(height: responsive.scale(8)),
                        Text(
                          distance!,
                          style: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: responsive.scaleFontSize(12),
                            fontWeight: FontWeight.w500,
                            height: 1.15,
                            color: const Color(0xFF595959),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
