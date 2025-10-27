import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/price_display.dart';
import 'package:waffir/core/widgets/products/rating_display.dart';

/// Product card widget for displaying product in grid/list view
///
/// Example usage:
/// ```dart
/// ProductCard(
///   imageUrl: 'https://example.com/product.jpg',
///   title: 'Nike Air Max',
///   brand: 'Nike',
///   price: 129.99,
///   rating: 4.5,
///   reviewCount: 128,
///   onTap: () => navigateToProduct(),
/// )
/// ```
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.brand,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.badge,
    this.badgeType,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  final String imageUrl;
  final String title;
  final String? brand;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;
  final String? badge;
  final BadgeType? badgeType;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with badge and favorite
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: colorScheme.surfaceContainerHighest,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Badge overlay (top left)
                  if (badge != null && badgeType != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: BadgeWidget(
                        text: badge!,
                        type: badgeType!,
                      ),
                    ),

                  // Favorite button (top right)
                  if (onFavorite != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite
                                ? const Color(0xFFEF4444)
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand (if provided)
                  if (brand != null) ...[
                    Text(
                      brand!,
                      style: AppTypography.productBrand.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Product Title
                  Text(
                    title,
                    style: AppTypography.productTitle.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Rating (if provided)
                  if (rating != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RatingDisplay(
                        rating: rating!,
                        reviewCount: reviewCount,
                        size: RatingSize.small,
                      ),
                    ),

                  // Price
                  PriceDisplay(
                    price: price,
                    originalPrice: originalPrice,
                    discountPercentage: discountPercentage,
                    size: PriceSize.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
