import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/features/products/domain/entities/product.dart';
import 'package:waffir/features/products/domain/entities/review.dart';
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
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;
  late final Product staticProduct;
  late final List<Review> staticReviews;
  late final double staticAverageRating;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Static product data aligned with Figma
    staticProduct = const Product(
      id: 'demo-1',
      title: "Nike Men's Air Max 2025 Shoes (3 Colors)",
      description:
          'Experience ultimate comfort and style with the Air Max 2025. Engineered cushioning, breathable mesh, and a sleek silhouette make this your go-to for everyday wear.',
      price: 400.0,
      originalPrice: 809.0,
      discountPercentage: 50,
      imageUrls: [
        'https://images.unsplash.com/photo-1542293787938-c9e299b88054?q=80&w=1080&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1080&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=1080&auto=format&fit=crop',
      ],
      categoryId: 'shoes',
      brand: 'Nike store',
      rating: 4.6,
      reviewCount: 3,
      availableSizes: ['S', 'M', 'L', 'XL'],
      availableColors: ['Black', 'White', 'Green'],
    );

    staticReviews = <Review>[
      Review(
        id: 'r1',
        productId: staticProduct.id,
        userId: 'u1',
        rating: 5.0,
        comment: 'Fantastic shoes! Super comfy and the cushioning is next-level.',
        userName: 'Omar',
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r2',
        productId: staticProduct.id,
        userId: 'u2',
        rating: 4.0,
        comment: 'Great fit and quality. Runs a bit small, consider sizing up.',
        userName: 'Sara',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Review(
        id: 'r3',
        productId: staticProduct.id,
        userId: 'u3',
        rating: 4.8,
        comment: 'Love the design and comfort. Perfect for daily wear.',
        userName: 'Ali',
        isVerifiedPurchase: true,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];

    staticAverageRating = staticReviews.isEmpty
        ? 0.0
        : staticReviews.map((r) => r.rating).reduce((a, b) => a + b) /
            staticReviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode == 'ar';
    final responsive = context.responsive;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            // Main content
            CustomScrollView(
              slivers: [
                // Product image carousel
                SliverToBoxAdapter(
                  child: ProductImageCarousel(
                    imageUrls: staticProduct.imageUrls,
                    height: responsive.scale(390),
                  ),
                ),

                // Body content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                    child: Column(
                      children: [
                        // Product actions (favorite, share, cart)
                        ProductActionsBar(
                          isFavorite: isFavorite,
                          onFavoriteToggle: () {
                            setState(() => isFavorite = !isFavorite);
                          },
                          shareText: 'Check out ${staticProduct.title} on Waffir!',
                        ),

                        // Prices
                        ProductPriceSection(
                          price: staticProduct.price,
                          originalPrice: staticProduct.originalPrice,
                          discountPercentage: staticProduct.discountPercentage,
                        ),

                        // Size and color selector
                        if (staticProduct.availableSizes.isNotEmpty || staticProduct.availableColors.isNotEmpty)
                          SizeColorSelector(
                            availableSizes: staticProduct.availableSizes,
                            availableColors: staticProduct.availableColors,
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
                          title: staticProduct.title,
                          description: staticProduct.description,
                          brand: staticProduct.brand,
                        ),

                        // Divider
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.outline.withOpacity(0.2),
                        ),

                        // Reviews section
                        ReviewsSection(
                          reviews: staticReviews,
                          averageRating: staticAverageRating,
                          totalReviews: staticReviews.length,
                          height: responsive.scale(714.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Back button (top left)
            Positioned(
              top: responsive.scale(64),
              left: isRTL ? null : responsive.scale(16),
              right: isRTL ? responsive.scale(16) : null,
              child: _buildBackButton(context),
            ),

            // Bottom action buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(context, staticProduct),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00FF88), // Bright green from Figma
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2F2F2),
            blurRadius: responsive.scale(8),
            spreadRadius: responsive.scale(2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: colorScheme.surface,
          size: responsive.scale(20),
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
    final responsive = context.responsive;

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.scale(10),
            offset: responsive.scaleOffset(const Offset(0, -2)),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Favorite button (circular)
            Container(
              width: responsive.scale(44),
              height: responsive.scale(44),
              decoration: const BoxDecoration(
                color: Color(0xFF0F352D), // Dark green
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: responsive.scale(20),
                  ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  // Add to wishlist
                },
              ),
            ),

            SizedBox(width: responsive.scale(16)),

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
                width: responsive.scale(247),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
