import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
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
    this.productId,
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

  final String? productId;
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
      onTap: onTap ??
          () {
            if (productId == null) return;
            context.pushNamed(
              AppRouteNames.productDetail,
              pathParameters: {'id': productId!},
            );
          },
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
      width: 140,
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
          AppNetworkImage(
            imageUrl: imageUrl,
            width: 140,
            height: 120,
            borderRadius: BorderRadius.circular(8),
            contentType: ImageContentType.product,
            useResponsiveScaling: false,
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
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: 14,
            fontWeight: FontWeight.w700, // Bold from Figma
            height: 1.4, // Line height from Figma
            color: Theme.of(context).colorScheme.onSurface,
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
        _buildPriceRow(context),

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
  Widget _buildPriceRow(BuildContext context) {
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
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 12,
                fontWeight: FontWeight.w500, // Medium
                height: 1.15, // Line height from Figma
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
