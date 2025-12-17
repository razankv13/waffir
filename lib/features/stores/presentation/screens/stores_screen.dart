import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/bottom_login_overlay.dart';
import 'package:waffir/core/widgets/cards/store_card.dart';
import 'package:waffir/core/widgets/filters/stores_category_chips.dart';
import 'package:waffir/core/widgets/search/waffir_search_bar.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';
import 'package:waffir/features/stores/presentation/controllers/stores_controller.dart';

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

  void _handleFilterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.stores.filterComingSoon.tr()),
      ),
    );
  }

  String _resolveCategoryLabel(BuildContext context, String category) {
    switch (category) {
      case 'All':
      case 'الكل':
        return LocaleKeys.stores.categories.all.tr();
      case 'Dining':
        return LocaleKeys.stores.categories.dining.tr();
      case 'Fashion':
        return LocaleKeys.stores.categories.fashion.tr();
      case 'Electronics':
        return LocaleKeys.stores.categories.electronics.tr();
      case 'Beauty':
        return LocaleKeys.stores.categories.beauty.tr();
      case 'Entertainment':
        return LocaleKeys.stores.categories.entertainment.tr();
      case 'Lifestyle':
        return LocaleKeys.stores.categories.lifestyle.tr();
      case 'Jewelry':
        return LocaleKeys.stores.categories.jewelry.tr();
      case 'Travel':
        return LocaleKeys.stores.categories.travel.tr();
      case 'Other':
        return LocaleKeys.stores.categories.other.tr();
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storesState = ref.watch(storesControllerProvider);
    final storesController = ref.read(storesControllerProvider.notifier);
    final selectedCategory = storesState.value?.selectedCategory ?? defaultStoresCategory;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

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
                            hintText: LocaleKeys.stores.searchHint.tr(),
                            onChanged: storesController.updateSearch,
                            onSearch: storesController.updateSearch,
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
                        onCategorySelected: storesController.updateCategory,
                        labelBuilder: (category) => _resolveCategoryLabel(context, category),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: storesController.refresh,
                child: storesState.when(
                  loading: () => const _StoresLoadingState(),
                  error: (error, stackTrace) => _StoresErrorState(
                    message: LocaleKeys.stores.loadError.tr(),
                    onRetry: storesController.refresh,
                  ),
                  data: (data) {
                    if (data.hasError) {
                      return _StoresErrorState(
                        message: data.failure?.message ?? LocaleKeys.stores.loadErrorShort.tr(),
                        onRetry: storesController.refresh,
                      );
                    }

                    final nearYouStores = data.nearYouStores;
                    final mallStores = data.mallStores;

                    // Group mall stores by mall name
                    final Map<String, List<Store>> mallStoresByMall = {};
                    for (final store in mallStores) {
                      final mallName = store.location ?? LocaleKeys.stores.otherLocations.tr();
                      mallStoresByMall.putIfAbsent(mallName, () => []).add(store);
                    }

                    final hasResults = nearYouStores.isNotEmpty || mallStores.isNotEmpty;
                    if (!hasResults) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: responsive.scale(16),
                          right: responsive.scale(16),
                          top: responsive.scale(16),
                          bottom: responsive.scale(300), // CTA overlay + nav
                        ),
                        children: [
                          SizedBox(height: responsive.scale(120)),
                          _buildEmptyState(context, data.searchQuery),
                        ],
                      );
                    }

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: responsive.scale(16),
                        right: responsive.scale(16),
                        top: responsive.scale(16),
                        bottom: responsive.scale(300), // CTA overlay + nav
                      ),
                      children: [
                        // Near You Section
                        if (nearYouStores.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            LocaleKeys.stores.section.nearYou,
                            nearYouStores.length,
                          ),
                          SizedBox(height: responsive.scale(12)),
                          _buildStoreCarousel(context, nearYouStores),
                          SizedBox(height: responsive.scale(24)),
                        ],

                        // Mall Stores Sections
                        if (mallStores.isNotEmpty) ...[
                          for (final entry in mallStoresByMall.entries) ...[
                            _buildSectionHeader(
                              context,
                              LocaleKeys.stores.section.mallPrefix,
                              entry.value.length,
                              namedArgs: {'mallName': entry.key},
                            ),
                            SizedBox(height: responsive.scale(12)),
                            _buildStoreCarousel(context, entry.value),
                            SizedBox(height: responsive.scale(24)),
                          ],
                        ],
                      ],
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

  Widget _buildSectionHeader(
    BuildContext context,
    String titleKey,
    int count, {
    Map<String, String>? namedArgs,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = titleKey.tr(namedArgs: namedArgs);
    final countLabel = LocaleKeys.stores.count.plural(
      count,
      namedArgs: {'count': '$count'},
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.storeSectionHeader.copyWith(color: colorScheme.onSurface),
        ),
        Text(
          countLabel,
          style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildStoreCarousel(BuildContext context, List<Store> stores) {
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

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
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
            LocaleKeys.stores.empty.title.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? LocaleKeys.stores.empty.categorySuggestion.tr()
                : LocaleKeys.stores.empty.searchSuggestion.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StoresLoadingState extends StatelessWidget {
  const _StoresLoadingState();

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: responsive.scale(24),
        left: responsive.scale(16),
        right: responsive.scale(16),
        bottom: responsive.scale(280),
      ),
      children: const [
        Center(
          child: Padding(padding: EdgeInsets.only(top: 48), child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _StoresErrorState extends StatelessWidget {
  const _StoresErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: responsive.scale(24),
        left: responsive.scale(16),
        right: responsive.scale(16),
        bottom: responsive.scale(280),
      ),
      children: [
        SizedBox(height: responsive.scale(48)),
        Icon(Icons.error_outline, size: responsive.scale(56), color: colorScheme.error),
        SizedBox(height: responsive.scale(12)),
        Text(
          message,
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.scale(12)),
        Center(
          child: TextButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.buttons.retry).tr(),
          ),
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
