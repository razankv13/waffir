import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/cards/horizontal_store_card.dart';
import 'package:waffir/core/widgets/products/product_card.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/products/data/providers/product_providers.dart';
import 'package:waffir/features/products/domain/entities/product.dart';
import 'package:waffir/features/products/domain/entities/store.dart';
import 'package:waffir/core/constants/locale_keys.dart';

/// Favorites Screen
///
/// Figma node: 7783:4214
/// Shows favorited products (ProductCard) and favorited stores (HorizontalStoreCard).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final responsive = ResponsiveHelper(context);

    final bottomInset = MediaQuery.paddingOf(context).bottom;
 
    final horizontalPadding = responsive.scale(16);
    final bottomPadding = responsive.scale(120) + bottomInset;

    final favoritesProductIds = ref.watch(favoritesProvider);
    final favoritesStoreIds = ref.watch(followedStoresNotifierProvider);

    final productsAsync = ref.watch(allProductsProvider);
    final storesAsync = ref.watch(allStoresProvider);

    final isLoading = productsAsync.isLoading || storesAsync.isLoading;

    final productsError = productsAsync.hasError ? productsAsync.error : null;
    final storesError = storesAsync.hasError ? storesAsync.error : null;

    final favoriteProducts = productsAsync.maybeWhen(
      data: (products) => _filterProducts(products, favoritesProductIds),
      orElse: () => <Product>[],
    );

    final favoriteStores = storesAsync.maybeWhen(
      data: (stores) => _filterStores(stores, favoritesStoreIds),
      orElse: () => <Store>[],
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background blurred shape (same positioning as other Figma-based screens)
          const BlurredBackground(),

          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button row
                  Align(
                    alignment: Alignment.centerLeft,
                    child: WaffirBackButton(size: responsive.scale(44), onTap: () => context.pop()),
                  ),

                  SizedBox(height: responsive.scale(32)),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(LocaleKeys.profile.favorites.title.tr(), style: theme.textTheme.titleLarge),
                  ),

                  SizedBox(height: responsive.scale(32)),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (isLoading) {
                          return Center(
                            child: SizedBox(
                              width: responsive.scale(28),
                              height: responsive.scale(28),
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        if (productsError != null || storesError != null) {
                          return _ErrorState(
                            message: LocaleKeys.profile.favorites.loadError.tr(),
                            details: '${productsError ?? ''}${storesError ?? ''}',
                          );
                        }

                        final items = <Widget>[];

                        for (final product in favoriteProducts) {
                          final isLiked = favoritesProductIds.contains(product.id);
                          items.add(
                            ProductCard(
                              productId: product.id,
                              imageUrl: product.primaryImageUrl,
                              title: product.title,
                              salePrice: product.price.round().toString(),
                              originalPrice: product.originalPrice?.round().toString(),
                              discountPercentage: product.discountPercentage,
                              storeName: product.brand,
                              isLiked: isLiked,
                              onLike: () => ref.read(favoritesProvider.notifier).toggle(product.id),
                            ),
                          );
                        }

                        for (final store in favoriteStores) {
                          final isFavorite = favoritesStoreIds.contains(store.id);
                          items.add(
                            HorizontalStoreCard(
                              storeId: store.id,
                              imageUrl: store.imageUrl,
                              storeName: store.name,
                              discountText: store.discountText,
                              distance: store.distance ?? '-,- kilometers',
                              isFavorite: isFavorite,
                              onFavoriteToggle: () => ref
                                  .read(followedStoresNotifierProvider.notifier)
                                  .toggle(store.id),
                            ),
                          );
                        }

                        if (items.isEmpty) {
                          return _EmptyState(
                            title: LocaleKeys.profile.favorites.emptyTitle.tr(),
                            subtitle: LocaleKeys.profile.favorites.emptySubtitle.tr(),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: responsive.scale(16)),
                          itemBuilder: (context, index) => items[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products, Set<String> favoriteIds) {
    return products.where((p) => favoriteIds.contains(p.id)).toList(growable: false);
  }

  List<Store> _filterStores(List<Store> stores, Set<String> favoriteIds) {
    return stores.where((s) => favoriteIds.contains(s.id)).toList(growable: false);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Center(
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_outline,
              size: responsive.scaleWithRange(72, min: 56, max: 88),
              color: colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w600,
                fontSize: responsive.scaleFontSize(16, minSize: 14),
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w400,
                fontSize: responsive.scaleFontSize(14, minSize: 12),
                height: 1.4,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.details});

  final String message;
  final String details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Center(
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.scaleWithRange(64, min: 52, max: 80),
              color: colorScheme.error.withValues(alpha: 0.8),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w600,
                fontSize: responsive.scaleFontSize(16, minSize: 14),
                color: colorScheme.onSurface,
              ),
            ),
            if (details.trim().isNotEmpty) ...[
              SizedBox(height: responsive.scale(8)),
              Text(
                details,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
