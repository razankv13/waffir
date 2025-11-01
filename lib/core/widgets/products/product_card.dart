import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/card_actions.dart';
import 'package:waffir/core/widgets/products/discount_tag_pill.dart';
import 'package:waffir/core/widgets/products/price_pill.dart';

/// Product card widget for displaying product in horizontal layout
///
/// Redesigned to match Figma specifications with:
/// - Horizontal layout (image left, content right)
/// - Fixed 120×120px image
/// - Pill-styled price displays
/// - Like and comment actions
///
/// Example usage:
/// ```dart
/// ProductCard(
///   imageUrl: 'https://example.com/product.jpg',
///   title: 'Nike Men\'s Air Max 2025 Shoes (3 Colors)',
///   salePrice: '400',
///   originalPrice: '809',
///   discountPercentage: 20,
///   storeName: 'Nike store',
///   likeCount: 45,
///   commentCount: 45,
///   onTap: () => navigateToProduct(),
/// )
/// ```
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.salePrice,
    this.originalPrice,
    this.discountPercentage,
    this.storeName,
    this.badge,
    this.badgeType,
    this.likeCount,
    this.commentCount,
    this.onTap,
    this.onLike,
    this.onComment,
    this.isLiked = false,
  });

  final String imageUrl;
  final String title;
  final String? salePrice;
  final String? originalPrice;
  final int? discountPercentage;
  final String? storeName;
  final String? badge;
  final BadgeType? badgeType;
  final int? likeCount;
  final int? commentCount;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image (Fixed 120×120px)
              _buildImageContainer(context),

              const SizedBox(width: 12), // Gap from Figma

              // Product Info (Fills remaining space)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: _buildContentColumn(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build image container with fixed size and badge overlay
  Widget _buildImageContainer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(8), // Padding from Figma
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(11),
          bottomLeft: Radius.circular(11),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Stack(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: colorScheme.surfaceContainerHighest,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Badge overlay (top left)
          if (badge != null && badgeType != null)
            Positioned(
              top: 4,
              left: 4,
              child: BadgeWidget(
                text: badge!,
                type: badgeType!,
                size: BadgeSize.small,
              ),
            ),
        ],
      ),
    );
  }

  /// Build content column with title, discount, prices, and actions
  Widget _buildContentColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: 14,
            fontWeight: FontWeight.w700, // Bold from Figma
            height: 1.4, // Line height from Figma
            color: Color(0xFF151515), // onSurface from Figma
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 12), // Gap from Figma

        // Discount tag (if discount exists)
        if (discountPercentage != null && discountPercentage! > 0)
          DiscountTagPill(
            discountText: '$discountPercentage% off',
          ),

        if (discountPercentage != null && discountPercentage! > 0)
          const SizedBox(height: 12), // Gap from Figma

        // Price row with store name
        _buildPriceRow(),

        const SizedBox(height: 12), // Gap from Figma

        // Card actions (like and comment)
        if (likeCount != null || commentCount != null)
          CardActions(
            likeCount: likeCount,
            commentCount: commentCount,
            onLike: onLike,
            onComment: onComment,
            isLiked: isLiked,
          ),
      ],
    );
  }

  /// Build price row with pill-styled prices and store name
  Widget _buildPriceRow() {
    return Row(
      children: [
        // Sale price pill
        if (salePrice != null)
          PricePill(
            price: salePrice!,
          ),

        if (salePrice != null && originalPrice != null)
          const SizedBox(width: 8), // Gap from Figma

        // Original price pill
        if (originalPrice != null)
          PricePill(
            price: originalPrice!,
            isSalePrice: false,
          ),

        if (storeName != null && (salePrice != null || originalPrice != null))
          const SizedBox(width: 8), // Gap from Figma

        // Store name
        if (storeName != null)
          Expanded(
            child: Text(
              'At $storeName',
              style: const TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 12,
                fontWeight: FontWeight.w500, // Medium
                height: 1.15, // Line height from Figma
                color: Color(0xFF595959), // Gray from Figma
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
