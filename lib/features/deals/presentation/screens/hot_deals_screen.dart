import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/bottom_login_overlay.dart';
import 'package:waffir/core/widgets/products/badge_widget.dart';
import 'package:waffir/core/widgets/products/product_card.dart';
import 'package:waffir/core/widgets/search/category_filter_chips.dart';
import 'package:waffir/core/widgets/search/search_bar_widget.dart';
import 'package:waffir/features/deals/presentation/controllers/hot_deals_controller.dart';

/// Hot Deals Screen - displays the feed with category filters and search.
class HotDealsScreen extends HookConsumerWidget {
  const HotDealsScreen({super.key});

  static const List<String> _categories = ['For You', 'Front Page', 'Popular'];

  static const List<String> _categoryIcons = [
    'assets/icons/categories/for_you_icon.svg',
    'assets/icons/categories/front_page_icon.svg',
    'assets/icons/categories/popular_icon.svg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotDealsState = ref.watch(hotDealsControllerProvider);
    final hotDealsController = ref.read(hotDealsControllerProvider.notifier);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    final selectedCategory = hotDealsState.value?.selectedCategory ?? defaultCategory;
    final categoryLabels = [
      LocaleKeys.deals.categories.forYou.tr(),
      LocaleKeys.deals.categories.frontPage.tr(),
      LocaleKeys.deals.categories.popular.tr(),
    ];

    void handleSearch(String query) {
      hotDealsController.updateSearch(query);
    }

    void handleFilterTap() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(LocaleKeys.deals.filterComingSoon.tr())));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
                final headerHorizontalPadding = responsive.scale(16);
                final headerVerticalPadding = responsive.scale(12);
                final logoHeight = responsive.scale(56);

                const searchBarHeight = 68.0;
                final searchGap = responsive.scale(12);
                final headerSearchHeight =
                    (headerVerticalPadding * 2) + logoHeight + searchGap + searchBarHeight;

                final chipsHeight = responsive.scale(71);
                final chipsTopSpacing = responsive.scale(6);
                final chipsHeaderHeight = chipsTopSpacing + chipsHeight;

                return [
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: headerHorizontalPadding,
                            vertical: headerVerticalPadding,
                          ),
                          child: SizedBox(
                            height: logoHeight,
                            child: Image.asset(
                              'assets/images/splash_logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: headerHorizontalPadding),
                          child: SearchBarWidget(
                            showFilterButton: true,
                            onChanged: handleSearch,
                            onSearch: handleSearch,
                            onFilterTap: handleFilterTap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyCategoryChipsHeaderDelegate(
                      height: chipsHeaderHeight,
                      topSpacing: chipsTopSpacing,
                      backgroundColor: colorScheme.surface,
                      child: CategoryFilterChips(
                        categories: _categories,
                        categoryIcons: _categoryIcons,
                        categoryLabels: categoryLabels,
                        selectedCategory: selectedCategory,
                        onCategorySelected: hotDealsController.updateCategory,
                      ),
                    ),
                  ),
                ];
              },
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    final metrics = notification.metrics;
                    if (metrics.extentAfter < responsive.scale(320)) {
                      hotDealsController.loadMore();
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: hotDealsController.refresh,
                  child: hotDealsState.when(
                  loading: () => const _HotDealsLoadingState(),
                  error: (_, __) => _HotDealsErrorState(
                    message: LocaleKeys.deals.loadError.tr(),
                    onRetry: hotDealsController.refresh,
                  ),
                  data: (data) {
                    if (data.hasError) {
                      return _HotDealsErrorState(
                        message: data.failure?.message ?? LocaleKeys.deals.loadErrorShort.tr(),
                        onRetry: hotDealsController.refresh,
                      );
                    }

                    if (data.deals.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: responsive.scalePadding(
                          const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
                        ),
                        children: [_buildEmptyState(context, data.searchQuery)],
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: responsive.scalePadding(
                        const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
                      ),
                      itemCount: data.deals.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.deals.length) {
                          if (data.isLoadingMore) {
                            return Padding(
                              padding: responsive.scalePadding(
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (data.loadMoreFailure != null) {
                            return Padding(
                              padding: responsive.scalePadding(
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: hotDealsController.loadMore,
                                  child: Text(LocaleKeys.buttons.retry.tr()),
                                ),
                              ),
                            );
                          }
                          return SizedBox(height: responsive.scale(16));
                        }

                        final deal = data.deals[index];

                        BadgeType? badgeType;
                        String? badgeText;
                        if (deal.isHot) {
                          badgeType = BadgeType.sale;
                          badgeText = LocaleKeys.deals.badges.hot.tr();
                        } else if (deal.isNew == true) {
                          badgeType = BadgeType.newBadge;
                          badgeText = LocaleKeys.deals.badges.newBadge.tr();
                        } else if (deal.isFeatured == true) {
                          badgeType = BadgeType.featured;
                          badgeText = LocaleKeys.deals.badges.featured.tr();
                        }

                        final salePrice = deal.price.toStringAsFixed(0);
                        final originalPriceStr = deal.originalPrice?.toStringAsFixed(0);

                        return ProductCard(
                          productId: deal.id,
                          imageUrl: deal.imageUrl,
                          title: deal.title,
                          salePrice: salePrice,
                          originalPrice: originalPriceStr,
                          discountPercentage: deal.hasDiscount
                              ? deal.calculatedDiscountPercentage
                              : null,
                          storeName: deal.brand ?? LocaleKeys.deals.storeFallback.tr(),
                          badge: badgeText,
                          badgeType: badgeType,
                          likeCount: deal.likesCount,
                          commentCount: (deal.viewsCount * 0.3).round(),
                          isLiked: deal.isLiked,
                          onTap: () async {
                            await hotDealsController.trackView(deal);
                            if (!context.mounted) return;
                            unawaited(
                              context.pushNamed(
                                AppRouteNames.productDetail,
                                pathParameters: {AppRouteParams.id: deal.id},
                              ),
                            );
                          },
                          onLike: () {
                            unawaited(() async {
                              final failure = await hotDealsController.toggleLike(deal);
                              if (failure == null) return;
                              if (failure is UnauthorizedFailure) {
                                if (context.mounted) unawaited(context.push(AppRoutes.login));
                                return;
                              }
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(failure.message)));
                            }());
                          },
                          onComment: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleKeys.deals.actions.commentComingSoon.tr()),
                              ),
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
          ),
          const BottomLoginOverlay(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: responsive.scale(80),
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: responsive.scale(16)),
          Text(
            LocaleKeys.deals.empty.title.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.scale(8)),
          Text(
            searchQuery.isEmpty
                ? LocaleKeys.deals.empty.categorySuggestion.tr()
                : LocaleKeys.deals.empty.searchSuggestion.tr(),
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
    final responsive = context.responsive;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: responsive.scalePadding(
        const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
      ),
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
    final responsive = context.responsive;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: responsive.scalePadding(
        const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 280),
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
          child: TextButton(onPressed: onRetry, child: Text(LocaleKeys.buttons.retry.tr())),
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
      height: height,
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
