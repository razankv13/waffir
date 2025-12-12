import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/product_card.dart';
import 'package:waffir/core/widgets/search/category_filter_chips.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/features/deals/data/providers/deals_providers.dart';

/// Hot Deals Screen - displays deals with category filters and search
///
/// Features:
/// - Search bar with filter button
/// - Horizontal scrollable category filters
/// - Product list (vertical scrolling)
/// - Discount badges
/// - Price display with original price
class HotDealsScreen extends ConsumerStatefulWidget {
  const HotDealsScreen({super.key});

  @override
  ConsumerState<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends ConsumerState<HotDealsScreen> {
  String _searchQuery = '';

  /// Available categories for filtering (matches Figma design node 34:6101)
  static const List<String> _categories = ['For You', 'Front Page', 'Popular'];

  /// Category icons (matches Figma design)
  static const List<String> _categoryIcons = [
    'assets/icons/categories/for_you_icon.svg',
    'assets/icons/categories/front_page_icon.svg',
    'assets/icons/categories/popular_icon.svg',
  ];

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _handleFilterTap() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filter dialog coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredDeals = ref.watch(filteredDealsProvider);

    // Further filter by search query
    final deals = _searchQuery.isEmpty
        ? filteredDeals
        : filteredDeals.where((deal) {
            final titleLower = deal.title.toLowerCase();
            final descLower = deal.description.toLowerCase();
            final categoryLower = deal.category?.toLowerCase() ?? '';
            return titleLower.contains(_searchQuery) ||
                descLower.contains(_searchQuery) ||
                categoryLower.contains(_searchQuery);
          }).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Main scrollable content
          SafeArea(
            bottom: false,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                // Keep responsive scaling for the header area (repo rule).
                final headerHorizontalPadding = responsive.scale(16);
                final headerVerticalPadding = responsive.scale(12);
                final logoHeight = responsive.scale(56);
                final notificationSize = responsive.scale(44);
                final notificationIconSize = responsive.scale(22);
                final notificationSplashRadius = responsive.scale(24);

                // SearchBarWidget is 68px height (per Figma / widget update).
                const searchBarHeight = 68.0;
                final searchGap = responsive.scale(12);

                final rowHeight = logoHeight > notificationSize ? logoHeight : notificationSize;
                final headerSearchHeight =
                    (headerVerticalPadding * 2) + rowHeight + searchGap + searchBarHeight;

                // CategoryFilterChips is 64px height.
                const chipsHeight = 64.0;
                final chipsTopSpacing = responsive.scale(6);
                final chipsHeaderHeight = chipsTopSpacing + chipsHeight;

                return [
                  // Header + Search (hides on scroll up, snaps back on scroll down)
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 0,
                    collapsedHeight: headerSearchHeight,
                    expandedHeight: headerSearchHeight,
                    elevation: 0,
                    backgroundColor: colorScheme.surface,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header with Waffir logo and notification icon
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: headerHorizontalPadding,
                            vertical: headerVerticalPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/splash_logo.png',
                                height: logoHeight,
                                fit: BoxFit.contain,
                              ),

                              // Notification Icon with soft background
                              Container(
                                width: notificationSize,
                                height: notificationSize,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.notifications,
                                    size: notificationIconSize,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    context.pushNamed(AppRouteNames.notifications);
                                  },
                                  padding: EdgeInsets.zero,
                                  splashRadius: notificationSplashRadius,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Search Bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: headerHorizontalPadding),
                          child: SearchBarWidget(
                            hintText: 'Search deals...',
                            showFilterButton: true,
                            onChanged: _handleSearch,
                            onSearch: _handleSearch,
                            onFilterTap: _handleFilterTap,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Filters (always visible + sticky)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyCategoryChipsHeaderDelegate(
                      height: chipsHeaderHeight,
                      topSpacing: chipsTopSpacing,
                      backgroundColor: colorScheme.surface,
                      child: CategoryFilterChips(
                        categories: _categories,
                        categoryIcons: _categoryIcons,
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          ref.read(selectedCategoryProvider.notifier).selectCategory(category);
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: deals.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 16,
                        right: 16,
                        bottom: 280, // Extra space for gradient overlay + bottom nav
                      ),
                      children: [
                        _buildEmptyState(context),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 16,
                        right: 16,
                        bottom: 280, // Extra space for gradient overlay + bottom nav
                      ),
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        final deal = deals[index];

                        // Determine badge type based on deal properties
                        BadgeType? badgeType;
                        String? badgeText;

                        if (deal.isHot) {
                          badgeType = BadgeType.sale;
                          badgeText = 'HOT';
                        } else if (deal.isNew == true) {
                          badgeType = BadgeType.newBadge;
                          badgeText = 'NEW';
                        } else if (deal.isFeatured == true) {
                          badgeType = BadgeType.featured;
                          badgeText = 'FEATURED';
                        }

                        // Convert prices to strings (format to whole numbers)
                        final salePrice = deal.price.toStringAsFixed(0);
                        final originalPriceStr = deal.originalPrice?.toStringAsFixed(0);

                        // Generate like and comment counts based on review count or random
                        final likeCount = deal.reviewCount ?? (index * 15 + 23);
                        final commentCount = deal.reviewCount != null
                            ? (deal.reviewCount! * 0.3).round()
                            : (index * 8 + 12);

                        return ProductCard(
                          productId: deal.id,
                          imageUrl: deal.imageUrl,
                          title: deal.title,
                          salePrice: salePrice,
                          originalPrice: originalPriceStr,
                          discountPercentage: deal.hasDiscount ? deal.calculatedDiscountPercentage : null,
                          storeName: deal.brand ?? 'Store',
                          badge: badgeText,
                          badgeType: badgeType,
                          likeCount: likeCount,
                          commentCount: commentCount,
                          onLike: () {
                            // TODO: Implement like functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Like functionality coming soon')),
                            );
                          },
                          onComment: () {
                            // TODO: Implement comment functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Comment functionality coming soon')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),

          // Bottom Gradient CTA Overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 88, // Above bottom navigation bar
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                height: 215,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface.withValues(alpha: 0.0),
                      colorScheme.surface.withValues(alpha: 0.8),
                      colorScheme.surface,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton.primary(
                      text: 'Login to view full deal details',
                      onPressed: () {
                        // Navigate to login screen
                        context.push('/login');
                      },
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No deals found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Try selecting a different category'
                : 'Try a different search term',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StickyCategoryChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyCategoryChipsHeaderDelegate({
    required this.height,
    required this.topSpacing,
    required this.backgroundColor,
    required this.child,
  });

  final double height;
  final double topSpacing;
  final Color backgroundColor;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCategoryChipsHeaderDelegate oldDelegate) {
    return height != oldDelegate.height ||
        topSpacing != oldDelegate.topSpacing ||
        backgroundColor != oldDelegate.backgroundColor ||
        child != oldDelegate.child;
  }
}
