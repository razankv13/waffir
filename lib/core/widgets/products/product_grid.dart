import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/product_card.dart';

/// Product grid widget for displaying multiple products in a grid layout
///
/// Example usage:
/// ```dart
/// ProductGrid(
///   products: productList,
///   onProductTap: (product) => navigateToDetail(product),
/// )
/// ```
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.7,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.shrinkWrap = false,
  });

  final List<ProductGridItem> products;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No products found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          imageUrl: product.imageUrl,
          title: product.title,
          salePrice: product.salePrice,
          originalPrice: product.originalPrice,
          discountPercentage: product.discountPercentage,
          storeName: product.storeName,
          badge: product.badge,
          badgeType: product.badgeType,
          likeCount: product.likeCount,
          commentCount: product.commentCount,
          isLiked: product.isLiked,
          onTap: product.onTap,
          onLike: product.onLike,
          onComment: product.onComment,
        );
      },
    );
  }
}

/// Data model for product grid items
class ProductGridItem {
  const ProductGridItem({
    required this.id,
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
    this.isLiked = false,
    this.onTap,
    this.onLike,
    this.onComment,
  });

  final String id;
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
  final bool isLiked;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
}
