import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/bottom_login_overlay.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/product_card.dart';
import 'package:waffir/core/widgets/search/category_filter_chips.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/features/deals/presentation/controllers/hot_deals_controller.dart';

/// Hot Deals Screen - displays deals with category filters and search
///
/// The screen now consumes data from HotDealsController, which can be backed by
/// mock data today and Supabase later without UI changes.
class HotDealsScreen extends ConsumerStatefulWidget {
  const HotDealsScreen({super.key});

  @override
  ConsumerState<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends ConsumerState<HotDealsScreen> {
  /// Available categories for filtering (matches Figma design node 34:6101)
  static const List<String> _categories = ['For You', 'Front Page', 'Popular'];

  /// Category icons (matches Figma design)
  static const List<String> _categoryIcons = [
    'assets/icons/categories/for_you_icon.svg',
    'assets/icons/categories/front_page_icon.svg',
    'assets/icons/categories/popular_icon.svg',
  ];

  void _handleSearch(String query) {
    ref.read(hotDealsControllerProvider.notifier).updateSearch(query);
  }

  void _handleFilterTap() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filter dialog coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final hotDealsState = ref.watch(hotDealsControllerProvider);
    final hotDealsController = ref.read(hotDealsControllerProvider.notifier);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final selectedCategory = hotDealsState.value?.selectedCategory ?? defaultCategory;

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
                        onCategorySelected: hotDealsController.updateCategory,
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: hotDealsController.refresh,
                child: hotDealsState.when(
                  loading: () => const _HotDealsLoadingState(),
                  error: (error, stackTrace) => _HotDealsErrorState(
                    message: 'Unable to load deals right now. Please try again.',
                    onRetry: hotDealsController.refresh,
                  ),
                  data: (data) {
                    if (data.hasError) {
                      return _HotDealsErrorState(
                        message: data.failure?.message ?? 'Unable to load deals right now.',
                        onRetry: hotDealsController.refresh,
                      );
                    }

                    final deals = data.deals;

                    if (deals.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 16,
                          right: 16,
                          bottom: 280, // Extra space for gradient overlay + bottom nav
                        ),
                        children: [_buildEmptyState(context, data.searchQuery)],
                      );
                    }

                    return ListView.builder(
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
                          discountPercentage: deal.hasDiscount
                              ? deal.calculatedDiscountPercentage
                              : null,
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
                    );
                  },
                ),
              ),
            ),
          ),

          // Bottom Gradient CTA Overlay
          const BottomLoginOverlay(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
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
            searchQuery.isEmpty
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

class _HotDealsLoadingState extends StatelessWidget {
  const _HotDealsLoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
      children: const [
        Center(
          child: Padding(padding: EdgeInsets.only(top: 48), child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _HotDealsErrorState extends StatelessWidget {
  const _HotDealsErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
      children: [
        const SizedBox(height: 48),
        Icon(Icons.error_outline, size: 56, color: colorScheme.error),
        const SizedBox(height: 12),
        Text(
          message,
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(onPressed: onRetry, child: const Text('Retry')),
        ),
      ],
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
