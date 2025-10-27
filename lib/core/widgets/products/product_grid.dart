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
          brand: product.brand,
          price: product.price,
          originalPrice: product.originalPrice,
          discountPercentage: product.discountPercentage,
          rating: product.rating,
          reviewCount: product.reviewCount,
          badge: product.badge,
          badgeType: product.badgeType,
          isFavorite: product.isFavorite,
          onTap: product.onTap,
          onFavorite: product.onFavorite,
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
    required this.price,
    this.brand,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.badge,
    this.badgeType,
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
  });

  final String id;
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
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
}
