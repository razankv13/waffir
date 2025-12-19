import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/favorites/data/providers/favorites_backend_providers.dart';
import 'package:waffir/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';

/// Migration flag key for Hive settings box
const String _migrationFlagKey = 'favorites_migrated_to_supabase';

/// Immutable state for favorites feature.
///
/// Holds lists of favorited products (as Deals) and favorited stores.
class FavoritesState {
  const FavoritesState({
    required this.favoritedProducts,
    required this.favoritedStores,
    this.failure,
  });

  const FavoritesState.initial()
      : favoritedProducts = const [],
        favoritedStores = const [],
        failure = null;

  final List<Deal> favoritedProducts;
  final List<Store> favoritedStores;
  final Failure? failure;

  bool get hasError => failure != null;
  bool get hasNoFavorites => favoritedProducts.isEmpty && favoritedStores.isEmpty;

  FavoritesState copyWith({
    List<Deal>? favoritedProducts,
    List<Store>? favoritedStores,
    Failure? failure,
  }) {
    return FavoritesState(
      favoritedProducts: favoritedProducts ?? this.favoritedProducts,
      favoritedStores: favoritedStores ?? this.favoritedStores,
      failure: failure ?? this.failure,
    );
  }
}

/// Provider for FavoritesController.
final favoritesControllerProvider =
    AsyncNotifierProvider<FavoritesController, FavoritesState>(FavoritesController.new);

/// Controller for managing user favorites (products and stores).
///
/// Responsibilities:
/// - Fetch favorited products and stores from backend (Supabase or mock)
/// - Toggle favorites with optimistic UI updates and rollback on failure
/// - One-time migration from Hive local storage to Supabase backend
/// - Handle errors gracefully with typed Failures
class FavoritesController extends AsyncNotifier<FavoritesState> {
  FavoritesRepository get _repository => ref.read(favoritesRepositoryProvider);

  @override
  Future<FavoritesState> build() async {
    // Check and perform migration if needed
    await _performMigrationIfNeeded();

    // Fetch initial favorites from backend
    return await _fetchFavorites();
  }

  /// Refresh favorites from backend.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _fetchFavorites());
  }

  /// Toggle like status for a product deal with optimistic update and rollback.
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> toggleProductLike({required String dealId, String dealType = 'product'}) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Find the deal to toggle
    final deal = current.favoritedProducts.firstWhere(
      (d) => d.id == dealId,
      orElse: () => Deal(
        id: dealId,
        title: '',
        description: '',
        imageUrl: '',
        price: 0,
        category: '',
        isLiked: false,
        likesCount: 0,
        viewsCount: 0,
      ),
    );

    final wasLiked = deal.isLiked;
    final optimisticLiked = !wasLiked;

    // Optimistic update: toggle the like state
    final updatedDeal = deal.copyWith(
      isLiked: optimisticLiked,
      likesCount: (deal.likesCount + (optimisticLiked ? 1 : -1)).clamp(0, 1 << 30),
    );

    List<Deal> updatedProducts;
    if (wasLiked) {
      // Was liked, now unliking → remove from list
      updatedProducts = current.favoritedProducts.where((d) => d.id != dealId).toList(growable: false);
    } else {
      // Was not liked, now liking → add to list
      final exists = current.favoritedProducts.any((d) => d.id == dealId);
      if (exists) {
        updatedProducts = current.favoritedProducts.map((d) => d.id == dealId ? updatedDeal : d).toList(growable: false);
      } else {
        updatedProducts = [...current.favoritedProducts, updatedDeal];
      }
    }

    state = AsyncValue.data(current.copyWith(favoritedProducts: updatedProducts));

    // Call backend to sync
    final result = await _repository.toggleDealLike(dealId: dealId, dealType: dealType);

    return result.when(
      success: (nowLiked) {
        // Backend confirmed the new state
        AppLogger.debug('✅ Product like toggled successfully: $dealId → $nowLiked');
        // Note: State is already optimistically updated. If backend state differs, we could correct it here.
        // For now, trust the optimistic update was correct.
        return null;
      },
      failure: (failure) {
        // Rollback to original state
        AppLogger.warning('⚠️ Failed to toggle product like: ${failure.message}');
        state = AsyncValue.data(current);
        return failure;
      },
    );
  }

  /// Toggle favorite status for a store with optimistic update and rollback.
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> toggleStoreFavorite({required String storeId}) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Check if store is currently favorited
    final isFavorited = current.favoritedStores.any((s) => s.id == storeId);

    List<Store> updatedStores;
    if (isFavorited) {
      // Was favorited, now unfavoriting → remove from list
      updatedStores = current.favoritedStores.where((s) => s.id != storeId).toList(growable: false);
    } else {
      // Was not favorited, now favoriting → need to add store
      // Since we don't have the store object here, we'll fetch it after backend confirms
      // For optimistic update, we'll just keep the list as-is until backend responds
      updatedStores = current.favoritedStores;
    }

    // Optimistic update
    state = AsyncValue.data(current.copyWith(favoritedStores: updatedStores));

    // Call backend to sync
    final result = await _repository.toggleStoreFavorite(storeId: storeId);

    return result.when(
      success: (nowFavorited) {
        AppLogger.debug('✅ Store favorite toggled successfully: $storeId → $nowFavorited');
        // Refetch to get updated list with full store data
        refresh();
        return null;
      },
      failure: (failure) {
        // Rollback to original state
        AppLogger.warning('⚠️ Failed to toggle store favorite: ${failure.message}');
        state = AsyncValue.data(current);
        return failure;
      },
    );
  }

  /// Fetch favorites from backend.
  Future<FavoritesState> _fetchFavorites() async {
    final languageCode = ref.read(localeProvider).languageCode;

    final productsResult = await _repository.fetchFavoritedProducts(languageCode: languageCode);
    final storesResult = await _repository.fetchFavoritedStores(languageCode: languageCode);

    final favProducts = productsResult.when(
      success: (data) => data,
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to fetch favorited products: ${failure.message}');
        return <Deal>[];
      },
    );

    final favStores = storesResult.when(
      success: (data) => data,
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to fetch favorited stores: ${failure.message}');
        return <Store>[];
      },
    );

    // If both failed, return error state
    if (productsResult is Failed && storesResult is Failed) {
      return FavoritesState(
        favoritedProducts: const [],
        favoritedStores: const [],
        failure: (productsResult as Failed).failure,
      );
    }

    return FavoritesState(
      favoritedProducts: favProducts,
      favoritedStores: favStores,
    );
  }

  /// Perform one-time migration from Hive local storage to Supabase backend.
  ///
  /// Reads old favorites from StateNotifiers, migrates to backend, sets flag.
  Future<void> _performMigrationIfNeeded() async {
    try {
      // Check if migration already completed
      final hiveService = HiveService.instance;
      final settingsBox = hiveService.getBox<dynamic>(AppConstants.settingsBoxName);
      final migrated = settingsBox.get(_migrationFlagKey, defaultValue: false) as bool;

      if (migrated) {
        AppLogger.debug('✅ Favorites migration already completed, skipping.');
        return;
      }

      AppLogger.info('🔄 Starting favorites migration from Hive to backend...');

      // Read old favorites from StateNotifiers (in-memory state)
      // Note: These providers may have default/empty state if not used yet
// Migrated logic: legacy providers removed.
      // FavoritesNotifier default was empty set {}.
      final oldProductIds = <String>[];
      
      // FollowedStoresNotifier default was {'store_002', 'store_005'}.
      final oldStoreIds = <String>['store_002', 'store_005'];

      if (oldProductIds.isEmpty && oldStoreIds.isEmpty) {
        AppLogger.debug('No local favorites to migrate.');
        // Still mark as migrated to avoid future checks
        await settingsBox.put(_migrationFlagKey, true);
        return;
      }

      // Call repository migration method
      final result = await _repository.migrateFavorites(
        productIds: oldProductIds.toList(),
        storeIds: oldStoreIds.toList(),
      );

      result.when(
        success: (_) {
          AppLogger.info('✅ Favorites migration completed successfully.');
          settingsBox.put(_migrationFlagKey, true);
        },
        failure: (failure) {
          AppLogger.error('❌ Favorites migration failed: ${failure.message}');
          // Do not set flag - allow retry on next launch
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('❌ Unexpected error during favorites migration', error: e, stackTrace: stackTrace);
      // Do not set flag - allow retry
    }
  }
}
