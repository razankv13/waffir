import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';
import 'package:waffir/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

/// Supabase implementation of favorites data source.
///
/// Handles RPC calls to Supabase backend for favorites functionality.
class SupabaseFavoritesRemoteDataSource implements FavoritesRemoteDataSource {
  SupabaseFavoritesRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<DealModel>> fetchFavoritedProducts({String languageCode = 'en'}) async {
    try {
      AppLogger.debug('🔍 Fetching favorited products (lang: $languageCode)');

      final raw = await _client.rpc('get_user_favorites');

      if (raw == null || raw is! List) {
        AppLogger.warning('⚠️ get_user_favorites returned null or invalid format');
        return [];
      }

      // Map raw results to DealModel using same pattern as deals feature
      final deals = _mapRawDealsToModels(raw, languageCode: languageCode);

      AppLogger.debug('✅ Fetched ${deals.length} favorited products');
      return deals;
    } on PostgrestException catch (e) {
      AppLogger.error('❌ Failed to fetch favorited products', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('❌ Auth error fetching favorited products', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      AppLogger.error('❌ Unexpected error fetching favorited products', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<List<StoreModel>> fetchFavoritedStores({String languageCode = 'en'}) async {
    try {
      AppLogger.debug('🔍 Fetching favorited stores (lang: $languageCode)');

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const Failure.unauthorized(message: 'User not authenticated');
      }

      final raw = await _client
          .from('user_favorite_stores')
          .select('store_id, stores(*)')
          .eq('user_id', userId);

      if (raw.isEmpty) {
        AppLogger.debug('✅ No favorited stores found');
        return [];
      }

      // Extract store objects and map to StoreModel
      final stores = <StoreModel>[];
      for (final row in raw) {
        final storeData = row['stores'];
        if (storeData != null && storeData is Map<String, dynamic>) {
          try {
            stores.add(StoreModel.fromJson(storeData));
          } catch (e) {
            AppLogger.warning('⚠️ Failed to parse store model: $e');
          }
        }
      }

      AppLogger.debug('✅ Fetched ${stores.length} favorited stores');
      return stores;
    } on PostgrestException catch (e) {
      AppLogger.error('❌ Failed to fetch favorited stores', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('❌ Auth error fetching favorited stores', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('❌ Unexpected error fetching favorited stores', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<bool> toggleDealLike({
    required String dealId,
    String dealType = 'product',
  }) async {
    try {
      AppLogger.debug('🔄 Toggling deal like (id: $dealId, type: $dealType)');

      final raw = await _client.rpc('toggle_deal_like', params: {
        'p_deal_type': dealType,
        'p_deal_id': dealId,
      });

      final result = _parseBoolResult(raw);
      AppLogger.debug('✅ Deal like toggled: $result');
      return result;
    } on PostgrestException catch (e) {
      AppLogger.error('❌ Failed to toggle deal like', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('❌ Auth error toggling deal like', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('❌ Unexpected error toggling deal like', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<bool> toggleStoreFavorite({required String storeId}) async {
    try {
      AppLogger.debug('🔄 Toggling store favorite (id: $storeId)');

      final raw = await _client.rpc('toggle_favorite_store', params: {
        'p_store_id': storeId,
      });

      final result = _parseBoolResult(raw);
      AppLogger.debug('✅ Store favorite toggled: $result');
      return result;
    } on PostgrestException catch (e) {
      AppLogger.error('❌ Failed to toggle store favorite', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('❌ Auth error toggling store favorite', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('❌ Unexpected error toggling store favorite', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<void> migrateFavorites({
    required List<String> productIds,
    required List<String> storeIds,
  }) async {
    try {
      AppLogger.info('🔄 Starting favorites migration (products: ${productIds.length}, stores: ${storeIds.length})');

      // Migrate products
      for (final productId in productIds) {
        try {
          await toggleDealLike(dealId: productId, dealType: 'product');
        } catch (e) {
          AppLogger.warning('⚠️ Failed to migrate product $productId: $e');
          // Continue with other items
        }
      }

      // Migrate stores
      for (final storeId in storeIds) {
        try {
          await toggleStoreFavorite(storeId: storeId);
        } catch (e) {
          AppLogger.warning('⚠️ Failed to migrate store $storeId: $e');
          // Continue with other items
        }
      }

      AppLogger.info('✅ Favorites migration completed');
    } catch (e) {
      AppLogger.error('❌ Favorites migration failed', error: e);
      throw Failure.unknown(message: 'Migration failed: ${e.toString()}');
    }
  }

  // Helper methods

  /// Parse boolean result from RPC response.
  ///
  /// Handles various response formats:
  /// - Direct bool value
  /// - Map with 'data' or 'result' key containing bool
  static bool _parseBoolResult(Object? raw) {
    if (raw is bool) return raw;
    if (raw is Map) {
      final data = raw['data'] ?? raw['result'];
      if (data is bool) return data;
    }
    throw const Failure.parse(message: 'Invalid toggle response - expected boolean.');
  }

  /// Map raw deal data to DealModel list.
  ///
  /// Follows the same pattern as deals feature for consistency.
  static List<DealModel> _mapRawDealsToModels(
    List<dynamic> raw, {
    required String languageCode,
  }) {
    final deals = <DealModel>[];

    for (final item in raw) {
      if (item is! Map<String, dynamic>) continue;

      try {
        // Normalize row to ensure consistent structure
        final normalized = _normalizeRow(item);

        // Pick localized text fields
        final title = _pickLocalizedText(
          normalized,
          'title',
          languageCode: languageCode,
        );
        final description = _pickLocalizedText(
          normalized,
          'description',
          languageCode: languageCode,
        );

        // Create deal model with normalized data
        final deal = DealModel.fromJson({
          ...normalized,
          'title': title,
          'description': description,
        });

        deals.add(deal);
      } catch (e) {
        AppLogger.warning('⚠️ Failed to parse deal from favorites: $e');
        // Skip invalid items
      }
    }

    return deals;
  }

  /// Normalize a database row to ensure consistent field names.
  static Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    return {
      'id': row['id'],
      'title': row['title'],
      'title_ar': row['title_ar'],
      'subtitle': row['subtitle'],
      'subtitle_ar': row['subtitle_ar'],
      'description': row['description'],
      'description_ar': row['description_ar'],
      'image_url': row['image_url'],
      'brand': row['brand'],
      'category': row['category'],
      'price': row['price'],
      'original_price': row['original_price'],
      'discount_percentage': row['discount_percentage'],
      'is_liked': row['is_liked'] ?? false,
      'likes_count': row['likes_count'] ?? 0,
      'views_count': row['views_count'] ?? 0,
      'is_featured': row['is_featured'] ?? false,
      'rating': row['rating'],
      'review_count': row['review_count'],
      'created_at': row['created_at'],
    };
  }

  /// Pick localized text with fallback to English.
  static String _pickLocalizedText(
    Map<String, dynamic> row,
    String baseField, {
    required String languageCode,
  }) {
    if (languageCode == 'ar') {
      final arabicValue = row['${baseField}_ar'];
      if (arabicValue != null && arabicValue.toString().trim().isNotEmpty) {
        return arabicValue.toString();
      }
    }
    return row[baseField]?.toString() ?? '';
  }
}
