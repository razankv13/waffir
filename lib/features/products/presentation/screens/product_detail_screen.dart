import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/features/products/data/providers/product_providers.dart';
import 'package:waffir/features/products/presentation/widgets/product_image_carousel.dart';
import 'package:waffir/features/products/presentation/widgets/product_price_section.dart';
import 'package:waffir/features/products/presentation/widgets/product_actions_bar.dart';
import 'package:waffir/features/products/presentation/widgets/product_info_section.dart';
import 'package:waffir/features/products/presentation/widgets/reviews_section.dart';
import 'package:waffir/features/products/presentation/widgets/size_color_selector.dart';

/// Product detail screen
///
/// Matches Figma design (Node 54:5767)
/// - Frame: 393×852px
/// - Image carousel: 390px height
/// - Reviews section: 714.2px height
/// - Bottom padding: 120px
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode == 'ar';

    // Watch product, reviews, and favorite status
    final productAsync = ref.watch(productByIdProvider(widget.productId));
    final reviewsAsync = ref.watch(productReviewsProvider(widget.productId));
    final averageRatingAsync = ref.watch(productAverageRatingProvider(widget.productId));
    final favoritesNotifier = ref.watch(favoritesProvider.notifier);
    final isFavorite = ref.watch(favoritesProvider).contains(widget.productId);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: productAsync.when(
          data: (product) {
            if (product == null) {
              return _buildNotFound(context);
            }

            return Stack(
              children: [
                // Main content
                CustomScrollView(
                  slivers: [
                    // Product image carousel
                    SliverToBoxAdapter(
                      child: ProductImageCarousel(
                        imageUrls: product.imageUrls,
                        height: 390,
                      ),
                    ),

                    // Body content
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Product actions (favorite, share, cart)
                          ProductActionsBar(
                            isFavorite: isFavorite,
                            onFavoriteToggle: () {
                              favoritesNotifier.toggle(widget.productId);
                            },
                            shareText: 'Check out ${product.title} on Waffir!',
                          ),

                          // Prices
                          ProductPriceSection(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            discountPercentage: product.discountPercentage,
                          ),

                          // Size and color selector
                          if (product.availableSizes.isNotEmpty || product.availableColors.isNotEmpty)
                            SizeColorSelector(
                              availableSizes: product.availableSizes,
                              availableColors: product.availableColors,
                              selectedSize: selectedSize,
                              selectedColor: selectedColor,
                              onSizeSelected: (size) {
                                setState(() => selectedSize = size);
                              },
                              onColorSelected: (color) {
                                setState(() => selectedColor = color);
                              },
                            ),

                          // Divider
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colorScheme.outline.withOpacity(0.2),
                          ),

                          // Product info
                          ProductInfoSection(
                            title: product.title,
                            description: product.description,
                            brand: product.brand,
                          ),

                          // Divider
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colorScheme.outline.withOpacity(0.2),
                          ),

                          // Reviews section
                          reviewsAsync.when(
                            data: (reviews) => ReviewsSection(
                              reviews: reviews,
                              averageRating: averageRatingAsync.value,
                              totalReviews: reviews.length,
                              height: 714.2,
                            ),
                            loading: () => Container(
                              height: 714.2,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            ),
                            error: (_, __) => const SizedBox(height: 714.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Back button (top left)
                Positioned(
                  top: 64,
                  left: isRTL ? null : 16,
                  right: isRTL ? 16 : null,
                  child: _buildBackButton(context),
                ),

                // Bottom action buttons
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomBar(context, product),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildError(context, error.toString()),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00FF88), // Bright green from Figma
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2F2F2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: colorScheme.surface,
          size: 20,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          context.pop();
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, product) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Favorite button (circular)
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF0F352D), // Dark green
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  // Add to wishlist
                },
              ),
            ),

            const SizedBox(width: 16),

            // Add to cart button
            Expanded(
              child: AppButton.primary(
                text: 'Add to Cart',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  // Add to cart logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                width: 247,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Product not found',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading product',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
