import 'package:waffir/features/deals/data/models/deal_model.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Abstract data source for favorites functionality.
///
/// Defines low-level data operations. Implementations handle Supabase RPC calls
/// or mock data generation. Methods throw [Failure] on errors.
abstract class FavoritesRemoteDataSource {
  /// Fetches all products/deals favorited by the authenticated user.
  ///
  /// Calls Supabase RPC: `get_user_favorites`
  /// Throws [Failure.server] on PostgrestException.
  /// Throws [Failure.unauthorized] if user not authenticated.
  Future<List<DealModel>> fetchFavoritedProducts({String languageCode = 'en'});

  /// Fetches all stores favorited by the authenticated user.
  ///
  /// Queries Supabase table: `user_favorite_stores` with join on `stores`.
  /// Throws [Failure.server] on PostgrestException.
  /// Throws [Failure.unauthorized] if user not authenticated.
  Future<List<StoreModel>> fetchFavoritedStores({String languageCode = 'en'});

  /// Toggles like status for a deal (product/store offer/bank offer).
  ///
  /// Calls Supabase RPC: `toggle_deal_like` with params:
  /// - p_deal_type: 'product' | 'store_offer' | 'bank_offer'
  /// - p_deal_id: UUID of deal
  ///
  /// Returns the new like state (true = liked, false = unliked).
  /// Throws [Failure.server] on PostgrestException.
  /// Throws [Failure.unauthorized] if user not authenticated.
  Future<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  });

  /// Toggles favorite status for a store.
  ///
  /// Calls Supabase RPC: `toggle_favorite_store` with param:
  /// - p_store_id: UUID of store
  ///
  /// Returns the new favorite state (true = favorited, false = unfavorited).
  /// Throws [Failure.server] on PostgrestException.
  /// Throws [Failure.unauthorized] if user not authenticated.
  Future<bool> toggleStoreFavorite({required String storeId});

  /// Migrates local favorites to Supabase backend.
  ///
  /// Performs batch insert by calling toggle methods for each ID.
  /// Idempotent - safe to call multiple times.
  /// Throws [Failure.server] on any PostgrestException.
  /// Throws [Failure.unauthorized] if user not authenticated.
  Future<void> migrateFavorites({
    required List<String> productIds,
    required List<String> storeIds,
  });
}
