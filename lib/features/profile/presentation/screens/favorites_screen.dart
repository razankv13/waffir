import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/cards/horizontal_store_card.dart';
import 'package:waffir/core/widgets/products/product_card.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/auth/presentation/widgets/blurred_background.dart';
import 'package:waffir/features/favorites/presentation/controllers/favorites_controller.dart';

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

    // Watch the new favorites controller
    final favoritesAsync = ref.watch(favoritesControllerProvider);

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
                    child: favoritesAsync.when(
                      data: (favoritesState) {
                        // Show error state if backend call failed
                        if (favoritesState.hasError) {
                          return _ErrorState(
                            message: LocaleKeys.profile.favorites.loadError.tr(),
                            details: favoritesState.failure?.message ?? '',
                          );
                        }

                        // Show empty state if no favorites
                        if (favoritesState.hasNoFavorites) {
                          return _EmptyState(
                            title: LocaleKeys.profile.favorites.emptyTitle.tr(),
                            subtitle: LocaleKeys.profile.favorites.emptySubtitle.tr(),
                          );
                        }

                        // Build list of favorite items
                        final items = <Widget>[];

                        // Add product cards (deals)
                        for (final deal in favoritesState.favoritedProducts) {
                          items.add(
                            ProductCard(
                              productId: deal.id,
                              imageUrl: deal.imageUrl,
                              title: deal.title,
                              salePrice: deal.price.round().toString(),
                              originalPrice: deal.originalPrice?.round().toString(),
                              discountPercentage: deal.discountPercentage?.round(),
                              storeName: deal.brand,
                              isLiked: deal.isLiked,
                              onLike: () async {
                                final controller = ref.read(favoritesControllerProvider.notifier);
                                await controller.toggleProductLike(dealId: deal.id);
                              },
                            ),
                          );
                        }

                        // Add store cards
                        for (final store in favoritesState.favoritedStores) {
                          items.add(
                            HorizontalStoreCard(
                              storeId: store.id,
                              imageUrl: store.imageUrl,
                              storeName: store.name,
                              discountText: store.discountText,
                              distance: store.distance ?? '-,- kilometers',
                              isFavorite: true, // Always true since it's in favorites list
                              onFavoriteToggle: () async {
                                final controller = ref.read(favoritesControllerProvider.notifier);
                                await controller.toggleStoreFavorite(storeId: store.id);
                              },
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          itemCount: items.length,
                          separatorBuilder: (context, index) => SizedBox(height: responsive.scale(16)),
                          itemBuilder: (context, index) => items[index],
                        );
                      },
                      loading: () => Center(
                        child: SizedBox(
                          width: responsive.scale(28),
                          height: responsive.scale(28),
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (error, stack) => _ErrorState(
                        message: LocaleKeys.profile.favorites.loadError.tr(),
                        details: error.toString(),
                      ),
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
