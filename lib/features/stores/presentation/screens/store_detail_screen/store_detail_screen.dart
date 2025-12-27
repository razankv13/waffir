import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/stores/domain/entities/store.dart' as store_entity;
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/presentation/controllers/store_catalog_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_view.dart';

class StoreDetailScreen extends ConsumerWidget {
  const StoreDetailScreen({
    super.key,
    required this.storeId,
    this.initialStore,
    this.initialOffers,
  });

  final String storeId;
  final store_entity.Store? initialStore;
  final List<StoreOffer>? initialOffers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create args with initial data for the controller
    final catalogArgs = StoreCatalogArgs(
      storeId: storeId,
      initialStore: initialStore,
      initialOffers: initialOffers,
    );
    final catalogState = ref.watch(storeCatalogControllerProvider(catalogArgs));
    final catalogController = ref.read(storeCatalogControllerProvider(catalogArgs).notifier);

    final uiState = ref.watch(storeDetailUiControllerProvider(storeId));
    final uiController = ref.read(storeDetailUiControllerProvider(storeId).notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final isRTL = context.locale.languageCode == 'ar';

    ref.listen(storeCatalogControllerProvider(catalogArgs), (previous, next) {
      final previousFailure = previous?.value?.lastActionFailure;
      final nextFailure = next.value?.lastActionFailure;
      if (nextFailure == null || nextFailure == previousFailure) return;

      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.clearSnackBars();
      messenger?.showSnackBar(
        SnackBar(content: Text(nextFailure.userMessage), behavior: SnackBarBehavior.floating),
      );
    });

    // Seed UI state from store when loaded
    ref.listen(storeCatalogControllerProvider(catalogArgs), (previous, next) {
      final store = next.value?.store;
      if (store != null && previous?.value?.store == null) {
        uiController.seedFromStore(store);
      }
    });

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: catalogState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _StoreDetailErrorView(onRetry: catalogController.refresh),
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
              onToggleFavorite: () => unawaited(handleToggleFavorite()),
              onOfferTap: (offer) {
                context.pushNamed(
                  AppRouteNames.dealDetail,
                  pathParameters: {'type': DealDetailsType.store.routeValue, 'id': offer.id},
                );
              },
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
    final responsive = context.rs;

    return Center(
      child: Padding(
        padding: responsive.sPadding(const EdgeInsets.all(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.s(64),
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            SizedBox(height: responsive.s(16)),
            Text(
              'Failed to load store.',
              style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.s(16)),
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
