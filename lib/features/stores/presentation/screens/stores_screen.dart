import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/bottom_login_overlay.dart';
import 'package:waffir/core/widgets/cards/store_card.dart';
import 'package:waffir/core/widgets/filters/stores_category_chips.dart';
import 'package:waffir/core/widgets/search/waffir_search_bar.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/data/providers/stores_providers.dart';

/// Stores Screen - displays stores with category filters and sections
///
/// Features:
/// - Search bar with filter button
/// - Horizontal scrollable category filters
/// - Two sections: Near You stores and Mall stores
/// - Store cards with distance, rating, and category
class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  String _searchQuery = '';

  /// Available categories for filtering
  static const List<String> _categories = [
    'All',
    'Dining',
    'Fashion',
    'Electronics',
    'Beauty',
    'Travel',
    'Lifestyle',
    'Jewelry',
    'Entertainment',
    'Other',
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

  List<StoreModel> _filterStoresBySearch(List<StoreModel> stores) {
    if (_searchQuery.isEmpty) return stores;

    return stores.where((store) {
      final nameLower = store.name.toLowerCase();
      final categoryLower = store.category.toLowerCase();
      final addressLower = store.address?.toLowerCase() ?? '';
      return nameLower.contains(_searchQuery) ||
          categoryLower.contains(_searchQuery) ||
          addressLower.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;
    final selectedCategory = ref.watch(selectedStoreCategoryProvider);
    final nearYouStores = ref.watch(filteredNearYouStoresProvider);
    final mallStores = ref.watch(filteredMallStoresProvider);

    // Filter by search query
    final filteredNearYou = _filterStoresBySearch(nearYouStores);
    final filteredMall = _filterStoresBySearch(mallStores);

    // Group mall stores by mall name
    final Map<String, List<StoreModel>> mallStoresByMall = {};
    for (final store in filteredMall) {
      final mallName = store.location ?? 'Other Locations';
      mallStoresByMall.putIfAbsent(mallName, () => []).add(store);
    }

    final hasResults = filteredNearYou.isNotEmpty || filteredMall.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
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

                // WaffirSearchBar has a fixed height of 68px by design.
                const searchBarHeight = 68.0;
                final searchPadding = responsive.scale(16);

                final rowHeight = logoHeight > notificationSize ? logoHeight : notificationSize;
                final headerSearchHeight =
                    (headerVerticalPadding * 2) + rowHeight + (searchPadding * 2) + searchBarHeight;

                // StoresCategoryChips has a fixed height of 66px currently.
                const chipsHeight = 66.0;
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
                        // Header row (logo + notifications)
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

                        // Search Bar (Waffir branded with exact Figma specs)
                        Padding(
                          padding: EdgeInsets.all(searchPadding),
                          child: WaffirSearchBar(
                            hintText: 'Search stores...',
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
                      child: StoresCategoryChips(
                        categories: _categories,
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          ref.read(selectedStoreCategoryProvider.notifier).selectCategory(category);
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: !hasResults
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(16),
                        bottom: responsive.scale(300), // CTA overlay + nav
                      ),
                      children: [
                        SizedBox(height: responsive.scale(120)),
                        _buildEmptyState(context),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(
                          16,
                        ), // Space below sticky chips (was SizedBox before ListView)
                        bottom: responsive.scale(300), // CTA overlay + nav
                      ),
                      children: [
                        // Near You Section
                        if (filteredNearYou.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            'Near to you',
                            'قريب منك',
                            filteredNearYou.length,
                          ),
                          SizedBox(height: responsive.scale(12)),
                          _buildStoreCarousel(context, filteredNearYou),
                          SizedBox(height: responsive.scale(24)),
                        ],

                        // Mall Stores Sections
                        if (filteredMall.isNotEmpty) ...[
                          for (final entry in mallStoresByMall.entries) ...[
                            _buildSectionHeader(
                              context,
                              'In Mall shops near to you',
                              entry.key, // Arabic mall name
                              entry.value.length,
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _buildStoreCarousel(context, entry.value),
                            SizedBox(height: responsive.scale(24)),
                          ],
                        ],
                      ],
                    ),
            ),
          ),

          // Bottom Gradient CTA Overlay
          const BottomLoginOverlay(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String titleAr, int count) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.storeSectionHeader.copyWith(color: colorScheme.onSurface)),
        Text(
          '$count ${count == 1 ? 'store' : 'stores'}',
          style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStoreCarousel(BuildContext context, List<StoreModel> stores) {
    final responsive = context.responsive;
    final cardWidth = responsive.scale(160);
    final horizontalSpacing = responsive.scale(
      16,
    ); // 16px gap from Figma layout_ZNFSE6/layout_I888LG
    final carouselHeight = responsive.scale(248);

    return SizedBox(
      height: carouselHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: stores.length,
        separatorBuilder: (_, _) => SizedBox(width: horizontalSpacing),
        itemBuilder: (context, index) {
          final store = stores[index];
          return SizedBox(
            width: cardWidth,
            child: StoreCard(
              storeId: store.id,
              imageUrl: store.imageUrl,
              storeName: store.name,
              discountText: store.discountText,
              // Removed category, distance, rating to match Figma Node 54:2349
            ),
          );
        },
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
            Icons.store_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No stores found',
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
