import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/stores/domain/entities/store.dart';

/// Abstract repository for favorites functionality.
///
/// Defines contracts for fetching favorited items and toggling favorites.
/// Implementations handle both Supabase-backed and mock data sources.
abstract class FavoritesRepository {
  /// Fetches all products/deals favorited by the authenticated user.
  ///
  /// Uses Supabase RPC: `get_user_favorites`
  /// Returns mixed list of product deals that user has liked.
  AsyncResult<List<Deal>> fetchFavoritedProducts({String languageCode = 'en'});

  /// Fetches all stores favorited by the authenticated user.
  ///
  /// Uses Supabase table: `user_favorite_stores`
  /// Returns list of stores user has hearted.
  AsyncResult<List<Store>> fetchFavoritedStores({String languageCode = 'en'});

  /// Toggles like status for a deal (product/store offer/bank offer).
  ///
  /// Uses Supabase RPC: `toggle_deal_like`
  /// Returns the new like state (true = now liked, false = now unliked).
  /// Idempotent - can be called multiple times safely.
  AsyncResult<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  });

  /// Toggles favorite status for a store.
  ///
  /// Uses Supabase RPC: `toggle_favorite_store`
  /// Returns the new favorite state (true = now favorited, false = now unfavorited).
  /// Idempotent - can be called multiple times safely.
  AsyncResult<bool> toggleStoreFavorite({required String storeId});

  /// Migrates local favorites to Supabase backend.
  ///
  /// Used for one-time migration from Hive-stored local favorites to Supabase.
  /// Performs batch insert via idempotent toggle operations.
  /// Non-destructive - local data remains until confirmed synced.
  AsyncResult<void> migrateFavorites({
    required List<String> productIds,
    required List<String> storeIds,
  });
}
