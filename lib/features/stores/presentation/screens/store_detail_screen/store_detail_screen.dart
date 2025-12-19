import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/stores/presentation/controllers/catalog_categories_controller.dart';
import 'package:waffir/features/stores/presentation/controllers/store_catalog_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_view.dart';

class StoreDetailScreen extends HookConsumerWidget {
  const StoreDetailScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(storeCatalogControllerProvider(storeId));
    final catalogController = ref.read(
      storeCatalogControllerProvider(storeId).notifier,
    );
    final categoriesState = ref.watch(catalogCategoriesControllerProvider);

    final uiState = ref.watch(storeDetailUiControllerProvider(storeId));
    final uiController = ref.read(
      storeDetailUiControllerProvider(storeId).notifier,
    );
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode == 'ar';

    final offersSearchController = useTextEditingController();
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      return () {
        debounce.value?.cancel();
      };
    }, const []);

    ref.listen(storeCatalogControllerProvider(storeId), (previous, next) {
      final previousFailure = previous?.value?.lastActionFailure;
      final nextFailure = next.value?.lastActionFailure;
      if (nextFailure == null || nextFailure == previousFailure) return;

      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.clearSnackBars();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(nextFailure.userMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final store = catalogState.value?.store;
        if (store != null) {
          uiController.seedFromStore(store);
        }
      });
      return null;
    }, [catalogState.value?.store]);

    useEffect(() {
      final query = catalogState.value?.searchQuery ?? '';
      if (offersSearchController.text == query) return null;
      offersSearchController.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
      return null;
    }, [catalogState.value?.searchQuery]);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: catalogState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              _StoreDetailErrorView(onRetry: catalogController.refresh),
          data: (data) {
            Future<void> handleToggleFavorite() async {
              final user = ref.read(currentUserProvider);
              if (user == null) {
                final messenger = ScaffoldMessenger.maybeOf(context);
                messenger?.clearSnackBars();
                messenger?.showSnackBar(
                  const SnackBar(
                    content: Text('Please sign in to favorite stores.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final previous = uiState.isFavorite;
              uiController.toggleFavorite();
              final ok = await catalogController.toggleFavorite();
              if (!ok && context.mounted) {
                uiController.setFavorite(previous);
              }
            }

            return StoreDetailView(
              store: data.store,
              isRTL: isRTL,
              isFavorite: uiState.isFavorite,
              testimonials: uiState.testimonials,
              offers: data.offers,
              isLoadingOffers: data.isLoadingOffers,
              hasMoreOffers: data.hasMore,
              isLoadingMoreOffers: data.isLoadingMore,
              onLoadMoreOffers: catalogController.loadMore,
              onToggleFavorite: () => unawaited(handleToggleFavorite()),
              onOfferTap: (offer) {
                context.pushNamed(
                  AppRouteNames.dealDetail,
                  pathParameters: {
                    'type': DealDetailsType.store.routeValue,
                    'id': offer.id,
                  },
                );
              },
              offersSearchController: offersSearchController,
              onSearchChanged: (value) {
                debounce.value?.cancel();
                debounce.value = Timer(const Duration(milliseconds: 350), () {
                  if (!context.mounted) return;
                  catalogController.updateSearch(value);
                });
              },
              categories: categoriesState.value ?? const [],
              selectedCategoryId: data.selectedCategoryId,
              onSelectedCategoryChanged:
                  catalogController.updateSelectedCategory,
            );
          },
        ),
      ),
    );
  }
}

class _StoreDetailErrorView extends StatelessWidget {
  const _StoreDetailErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final responsive = context.responsive;

    return Center(
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.scale(64),
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            SizedBox(height: responsive.scale(16)),
            Text(
              'Failed to load store.',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.scale(16)),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text('Retry', style: textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
