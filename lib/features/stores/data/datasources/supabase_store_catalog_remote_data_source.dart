import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/stores/data/datasources/store_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/domain/entities/top_offer.dart';

class SupabaseStoreCatalogRemoteDataSource implements StoreCatalogRemoteDataSource {
  SupabaseStoreCatalogRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _storesTable = 'stores';
  static const String _categoriesTable = 'categories';
  static const String _rpcGetStoreOffers = 'get_store_offers';
  static const String _rpcToggleFavoriteStore = 'toggle_favorite_store';
  static const String _rpcGetStoresWithTopOffers = 'get_stores_with_top_offers';

  @override
  Future<List<StoreModel>> fetchStores({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
    Set<String>? selectedBankCardIds,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final isArabic = languageCode.toLowerCase() == 'ar';

      // Look up category ID from slug if provided
      String? categoryId;
      if (categorySlug != null && categorySlug.trim().isNotEmpty) {
        final categoryRow = await _client
            .from(_categoriesTable)
            .select('id')
            .eq('slug', categorySlug.toLowerCase())
            .maybeSingle();
        categoryId = categoryRow?['id']?.toString();
      }

      // Build base query with category join for localized names
      var query = _client
          .from(_storesTable)
          .select('''
        id,
        name,
        name_ar,
        logo_url,
        website_url,
        country_code,
        is_active,
        created_at,
        updated_at,
        primary_category_id,
        categories!stores_primary_category_fk(name_en, name_ar, slug)
      ''')
          .eq('is_active', true);

      // Apply category filter if provided
      if (categoryId != null) {
        query = query.or(
          'primary_category_id.eq.$categoryId,'
          'secondary_category_id_1.eq.$categoryId,'
          'secondary_category_id_2.eq.$categoryId',
        );
      }

      // Apply search filter
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final search = searchQuery.trim();
        query = query.or('name.ilike.%$search%,name_ar.ilike.%$search%');
      }

      // Execute query ordered by name
      final rows = await query.order('name', ascending: true);

      stopwatch.stop();
      AppLogger.debug(
        'Supabase fetchStores categorySlug=$categorySlug '
        'search=${searchQuery ?? ''} took=${stopwatch.elapsedMilliseconds}ms '
        'rows=${rows.length}',
      );

      var stores = rows
          .map((row) {
            final data = _normalizeRow(row);
            return _mapRowToStoreModel(data, isArabic);
          })
          .toList(growable: false);

      // Filter stores by selected bank cards if provided
      if (selectedBankCardIds != null && selectedBankCardIds.isNotEmpty) {
        stores = await _filterStoresByBankCards(stores, selectedBankCardIds);
      }

      return stores;
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load stores',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  StoreModel _mapRowToStoreModel(Map<String, dynamic> data, bool isArabic) {
    final name = _pickLocalizedText(
      isArabic: isArabic,
      primary: data['name_ar'],
      fallback: data['name'],
    );
    final logoUrl = (data['logo_url'] as String?)?.trim();
    final websiteUrl = (data['website_url'] as String?)?.trim();

    // Extract category from joined data
    final categoryData = data['categories'];
    String categoryName = 'Other';
    if (categoryData != null && categoryData is Map<String, dynamic>) {
      categoryName = _pickLocalizedText(
        isArabic: isArabic,
        primary: categoryData['name_ar'],
        fallback: categoryData['name_en'],
      );
    }

    return StoreModel(
      id: (data['id'] ?? '').toString(),
      name: name,
      category: categoryName,
      imageUrl: logoUrl ?? '',
      logoUrl: logoUrl,
      bannerUrl: logoUrl,
      website: websiteUrl,
      isActive: (data['is_active'] as bool?) ?? true,
      createdAt: _parseDateTime(data['created_at']),
      updatedAt: _parseDateTime(data['updated_at']),
    );
  }

  /// Filters stores to only include those with offers from the selected bank cards.
  ///
  /// Queries the bank_offers table to find store IDs that have offers for the
  /// given bank card IDs, then filters the stores list accordingly.
  Future<List<StoreModel>> _filterStoresByBankCards(
    List<StoreModel> stores,
    Set<String> selectedBankCardIds,
  ) async {
    if (stores.isEmpty || selectedBankCardIds.isEmpty) return stores;

    try {
      final stopwatch = Stopwatch()..start();

      // Query bank_offers to find store IDs with offers for selected cards
      final cardIdsList = selectedBankCardIds.toList();
      final response = await _client
          .from('bank_offers')
          .select('merchant_store_id')
          .inFilter('bank_card_id', cardIdsList)
          .not('merchant_store_id', 'is', null);

      // Extract unique store IDs that have matching offers
      final matchingStoreIds = <String>{};
      for (final row in response) {
        final storeId = row['merchant_store_id']?.toString();
        if (storeId != null && storeId.isNotEmpty) {
          matchingStoreIds.add(storeId);
        }
      }

      stopwatch.stop();
      AppLogger.debug(
        'Supabase _filterStoresByBankCards: '
        'selectedCards=${selectedBankCardIds.length} '
        'matchingStores=${matchingStoreIds.length} '
        'took=${stopwatch.elapsedMilliseconds}ms',
      );

      // If no matching stores found, return empty list
      if (matchingStoreIds.isEmpty) {
        return const [];
      }

      // Filter stores to only those with matching offers
      return stores.where((store) => matchingStoreIds.contains(store.id)).toList();
    } on PostgrestException catch (e) {
      AppLogger.warning(
        'Failed to filter stores by bank cards: ${e.message}. '
        'Returning all stores as fallback.',
      );
      // On error, return all stores as fallback (graceful degradation)
      return stores;
    } catch (e) {
      AppLogger.warning(
        'Unexpected error filtering stores by bank cards: $e. '
        'Returning all stores as fallback.',
      );
      return stores;
    }
  }

  @override
  Future<StoreModel> fetchStoreById({required String storeId, required String languageCode}) async {
    try {
      final row = await _client
          .from(_storesTable)
          .select('''
            id,
            name,
            name_ar,
            logo_url,
            website_url,
            country_code,
            is_active,
            created_at,
            updated_at,
            primary_category:categories!stores_primary_category_fk(id, name_en, name_ar),
            secondary_category_1:categories!stores_secondary_category_1_fk(id, name_en, name_ar),
            secondary_category_2:categories!stores_secondary_category_2_fk(id, name_en, name_ar)
          ''')
          .eq('id', storeId)
          .single();

      final data = _normalizeRow(row);
      final isArabic = languageCode.toLowerCase() == 'ar';
      final name = _pickLocalizedText(
        isArabic: isArabic,
        primary: data['name_ar'],
        fallback: data['name'],
      );
      final logoUrl = (data['logo_url'] as String?)?.trim();
      final websiteUrl = (data['website_url'] as String?)?.trim();

      // Extract all category names
      final List<String> categoryNames = [];
      String primaryCategory = 'Other';

      final primaryCategoryData = data['primary_category'];
      if (primaryCategoryData != null && primaryCategoryData is Map<String, dynamic>) {
        primaryCategory = _pickLocalizedText(
          isArabic: isArabic,
          primary: primaryCategoryData['name_ar'],
          fallback: primaryCategoryData['name_en'],
        );
        categoryNames.add(primaryCategory);
      }

      final secondary1Data = data['secondary_category_1'];
      if (secondary1Data != null && secondary1Data is Map<String, dynamic>) {
        final catName = _pickLocalizedText(
          isArabic: isArabic,
          primary: secondary1Data['name_ar'],
          fallback: secondary1Data['name_en'],
        );
        if (catName.isNotEmpty && !categoryNames.contains(catName)) {
          categoryNames.add(catName);
        }
      }

      final secondary2Data = data['secondary_category_2'];
      if (secondary2Data != null && secondary2Data is Map<String, dynamic>) {
        final catName = _pickLocalizedText(
          isArabic: isArabic,
          primary: secondary2Data['name_ar'],
          fallback: secondary2Data['name_en'],
        );
        if (catName.isNotEmpty && !categoryNames.contains(catName)) {
          categoryNames.add(catName);
        }
      }

      return StoreModel(
        id: (data['id'] ?? storeId).toString(),
        name: name,
        category: primaryCategory,
        categories: categoryNames,
        imageUrl: logoUrl ?? '',
        logoUrl: logoUrl,
        bannerUrl: logoUrl,
        website: websiteUrl,
        isActive: (data['is_active'] as bool?) ?? true,
        createdAt: _parseDateTime(data['created_at']),
        updatedAt: _parseDateTime(data['updated_at']),
      );
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load store details',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<List<StoreOffer>> fetchStoreOffers({
    required String storeId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Always pass all 5 parameters to avoid PostgREST PGRST203 function overload ambiguity
      final params = <String, dynamic>{
        'p_search_query': searchQuery,
        'p_store_id': storeId,
        'p_category_id': (categoryId != null && categoryId.trim().isNotEmpty) ? categoryId : null,
        'p_limit': limit,
        'p_offset': offset,
      };

      final stopwatch = Stopwatch()..start();
      final raw = await _client.rpc(_rpcGetStoreOffers, params: params);
      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcGetStoreOffers storeId=$storeId offset=$offset limit=$limit '
        'categoryId=${categoryId ?? ''} search=${searchQuery ?? ''} '
        'took=${stopwatch.elapsedMilliseconds}ms',
      );
      final rows = raw is List ? raw : const <dynamic>[];

      return rows
          .map(_normalizeRow)
          .map(
            (row) => StoreOffer(
              id: row['id'].toString(),
              storeId: (row['store_id'] ?? storeId).toString(),
              title: (row['title'] ?? '').toString(),
              titleAr: row['title_ar']?.toString(),
              description: row['description']?.toString(),
              descriptionAr: row['description_ar']?.toString(),
              termsText: row['terms_text']?.toString(),
              termsTextAr: row['terms_text_ar']?.toString(),
              discountMinPercent: row['discount_min_percent'] as num?,
              discountMaxPercent: row['discount_max_percent'] as num?,
              promoCode: row['promo_code']?.toString(),
              onlineOrInstore: row['online_or_instore']?.toString(),
              startDate: _parseDateTime(row['start_date']),
              endDate: _parseDateTime(row['end_date']),
              imageUrl: row['image_url']?.toString(),
              refUrl: row['ref_url']?.toString(),
              popularityScore: _parseInt(row['popularity_score']),
              createdAt: _parseDateTime(row['created_at']),
            ),
          )
          .toList(growable: false);
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Supabase RPC $_rpcGetStoreOffers failed storeId=$storeId code=${e.code ?? ''}',
        error: e,
        stackTrace: stackTrace,
      );
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Supabase RPC $_rpcGetStoreOffers crashed storeId=$storeId',
        error: e,
        stackTrace: stackTrace,
      );
      throw Failure.unknown(
        message: 'Failed to load store offers',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<bool> toggleFavoriteStore({required String storeId}) async {
    try {
      final stopwatch = Stopwatch()..start();
      final raw = await _client.rpc(_rpcToggleFavoriteStore, params: {'p_store_id': storeId});
      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcToggleFavoriteStore storeId=$storeId took=${stopwatch.elapsedMilliseconds}ms',
      );
      return _parseBoolRpcResult(raw);
    } on PostgrestException catch (e) {
      final message = e.message;
      if (message.toLowerCase().contains('not authenticated')) {
        AppLogger.warning('Supabase RPC $_rpcToggleFavoriteStore unauthorized storeId=$storeId');
        throw Failure.unauthorized(message: message, code: e.code);
      }
      AppLogger.error(
        'Supabase RPC $_rpcToggleFavoriteStore failed storeId=$storeId code=${e.code ?? ''}',
        error: e,
      );
      throw Failure.server(message: message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Supabase RPC $_rpcToggleFavoriteStore crashed storeId=$storeId',
        error: e,
        stackTrace: stackTrace,
      );
      throw Failure.unknown(
        message: 'Failed to toggle favorite store',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<StoresWithOffersResult> fetchStoresWithOffers({
    required String languageCode,
    String? categorySlug,
    String? searchQuery,
    Set<String>? selectedBankCardIds,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final isArabic = languageCode.toLowerCase() == 'ar';

      // Build RPC params
      final params = <String, dynamic>{
        'p_category_slug': categorySlug,
        'p_search_query': searchQuery,
        'p_bank_card_ids': null,
        'p_limit': limit,
        'p_offset': offset,
      };

      // Single optimized RPC call
      final raw = await _client.rpc(_rpcGetStoresWithTopOffers, params: params);

      stopwatch.stop();
      final rows = raw is List ? raw : const <dynamic>[];
      AppLogger.debug(
        'Supabase RPC $_rpcGetStoresWithTopOffers '
        'categorySlug=$categorySlug search=${searchQuery ?? ''} '
        'limit=$limit offset=$offset rows=${rows.length} '
        'took=${stopwatch.elapsedMilliseconds}ms',
      );

      if (rows.isEmpty) {
        return const StoresWithOffersResult(stores: [], totalCount: 0);
      }

      // Parse total count from first row
      final firstRow = _normalizeRow(rows.first);
      final totalCount = _parseInt(firstRow['total_count']) ?? 0;

      // Map rows to StoreModel with TopOffer
      final stores = rows.map((row) {
        final data = _normalizeRow(row);
        return _mapRpcRowToStoreModel(data, isArabic);
      }).toList(growable: false);

      return StoresWithOffersResult(
        stores: stores,
        totalCount: totalCount,
      );
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Supabase RPC $_rpcGetStoresWithTopOffers failed code=${e.code ?? ''}',
        error: e,
        stackTrace: stackTrace,
      );
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error('fetchStoresWithOffers crashed', error: e, stackTrace: stackTrace);
      throw Failure.unknown(
        message: 'Failed to load stores with offers',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  /// Maps a row from the get_stores_with_top_offers RPC to StoreModel.
  StoreModel _mapRpcRowToStoreModel(Map<String, dynamic> data, bool isArabic) {
    final name = _pickLocalizedText(
      isArabic: isArabic,
      primary: data['store_name_ar'],
      fallback: data['store_name'],
    );
    final categoryName = _pickLocalizedText(
      isArabic: isArabic,
      primary: data['category_name_ar'],
      fallback: data['category_name'],
    );
    final logoUrl = (data['logo_url'] as String?)?.trim();
    final websiteUrl = (data['website_url'] as String?)?.trim();

    // Build TopOffer if present
    TopOffer? topOffer;
    final topOfferId = data['top_offer_id'];
    if (topOfferId != null) {
      final offerTitle = _pickLocalizedText(
        isArabic: isArabic,
        primary: data['top_offer_title_ar'],
        fallback: data['top_offer_title'],
      );
      topOffer = TopOffer(
        id: topOfferId.toString(),
        title: offerTitle,
        titleAr: data['top_offer_title_ar']?.toString(),
        discountMaxPercent: _parseNum(data['top_offer_discount']),
      );
    }

    return StoreModel(
      id: (data['store_id'] ?? '').toString(),
      name: name,
      category: categoryName,
      imageUrl: logoUrl ?? '',
      logoUrl: logoUrl,
      bannerUrl: logoUrl,
      website: websiteUrl,
      isActive: (data['is_active'] as bool?) ?? true,
      createdAt: _parseDateTime(data['created_at']),
      updatedAt: _parseDateTime(data['updated_at']),
      topOffer: topOffer,
    );
  }

  static num? _parseNum(Object? value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  static Map<String, dynamic> _normalizeRow(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), v));
    }
    throw const Failure.parse(message: 'Invalid store row', code: 'STORE_INVALID_ROW');
  }

  static String _pickLocalizedText({required bool isArabic, Object? primary, Object? fallback}) {
    final primaryValue = (primary?.toString() ?? '').trim();
    final fallbackValue = (fallback?.toString() ?? '').trim();
    if (!isArabic) return fallbackValue.isNotEmpty ? fallbackValue : primaryValue;
    return primaryValue.isNotEmpty ? primaryValue : fallbackValue;
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static int? _parseInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool _parseBoolRpcResult(Object? raw) {
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    final text = raw?.toString().trim().toLowerCase();
    if (text == 'true') return true;
    if (text == 'false') return false;
    throw const Failure.parse(
      message: 'Invalid toggle_favorite_store response.',
      code: 'TOGGLE_FAVORITE_STORE_INVALID_RESPONSE',
    );
  }
}
