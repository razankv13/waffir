import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';

/// Supabase-backed deals data source (Point #3: Home & Discovery feed).
class SupabaseDealsRemoteDataSource implements DealsRemoteDataSource {
  SupabaseDealsRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _storesTable = 'stores';
  static const String _likesTable = 'user_deal_likes';
  static const String _rpcFrontpageProducts = 'get_frontpage_products';
  static const String _rpcTrackView = 'track_deal_view';
  static const String _rpcToggleLike = 'toggle_deal_like';

  @override
  Future<List<DealModel>> fetchHotDeals({
    String? category,
    String? searchQuery,
    String languageCode = 'en',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final raw = await _client.rpc(
        _rpcFrontpageProducts,
        params: {'p_limit': limit, 'p_offset': offset},
      );

      final rows = raw is List ? raw : const <dynamic>[];
      final normalizedRows = rows.map(_normalizeRow).toList(growable: false);

      final storeIds = normalizedRows
          .map((row) => row['store_id'])
          .where((id) => id != null)
          .map((id) => id.toString())
          .toSet()
          .toList(growable: false);

      final storeNamesById = await _safeFetchStoreNamesById(
        languageCode: languageCode,
        storeIds: storeIds,
      );

      final deals = normalizedRows
          .map(
            (row) => _mapProductDealRowToDealModel(
              row,
              languageCode: languageCode,
              storeName: storeNamesById[row['store_id']?.toString()],
            ),
          )
          .toList(growable: false);

      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty || deals.isEmpty) return deals;

      final likedIds = await _fetchLikedDealIds(
        userId: userId,
        dealType: 'product',
        dealIds: deals.map((d) => d.id).toList(growable: false),
      );
      if (likedIds.isEmpty) return deals;

      return deals
          .map((deal) => likedIds.contains(deal.id) ? deal.copyWith(isLiked: true) : deal)
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to fetch hot deals',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  static Map<String, dynamic> _normalizeRow(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), v));
    }
    throw const Failure.parse(
      message: 'Invalid deal row.',
      code: 'DEALS_INVALID_ROW',
    );
  }

  static DealModel _mapProductDealRowToDealModel(
    Map<String, dynamic> row, {
    required String languageCode,
    String? storeName,
  }) {
    final isArabic = languageCode.toLowerCase() == 'ar';

    final title = _pickLocalizedText(
      isArabic: isArabic,
      primary: row['title_ar'],
      fallback: row['title'],
    );
    final description = _pickLocalizedText(
      isArabic: isArabic,
      primary: row['description_ar'],
      fallback: row['description'],
    );

    final originalPrice = _toDouble(row['original_price']);
    final discountedPrice = _toDouble(row['discounted_price']);
    final price = discountedPrice ?? originalPrice ?? 0;

    return DealModel(
      id: (row['id'] ?? '').toString(),
      title: title ?? '',
      description: description ?? '',
      price: price,
      originalPrice: originalPrice,
      discountPercentage: _toInt(row['discount_percent']),
      imageUrl: _pickImageUrl(row) ?? '',
      brand: storeName,
      likesCount: _toInt(row['likes_count']) ?? 0,
      viewsCount: _toInt(row['views_count']) ?? 0,
      isLiked: false,
      isFeatured: true,
      createdAt: _toDateTime(row['created_at']),
      expiresAt: _toDateTime(row['end_date']),
    );
  }

  static String? _pickLocalizedText({
    required bool isArabic,
    required Object? primary,
    required Object? fallback,
  }) {
    String? normalize(Object? value) {
      final text = value?.toString();
      if (text == null) return null;
      final trimmed = text.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final primaryText = normalize(primary);
    final fallbackText = normalize(fallback);
    return isArabic ? (primaryText ?? fallbackText) : (fallbackText ?? primaryText);
  }

  static String? _pickImageUrl(Map<String, dynamic> row) {
    final direct = row['image_url'];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();

    final urls = row['image_urls'];
    if (urls is List && urls.isNotEmpty) {
      final first = urls.first;
      if (first is String && first.trim().isNotEmpty) return first.trim();
    }
    return null;
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _toDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return DateTime.tryParse(value.toString());
  }

  @override
  Future<void> trackDealView({required String dealId, String dealType = 'product'}) async {
    try {
      await _client.rpc(_rpcTrackView, params: {'p_deal_type': dealType, 'p_deal_id': dealId});
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to track deal view',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<bool> toggleDealLike({required String dealId, String dealType = 'product'}) async {
    try {
      final raw = await _client.rpc(
        _rpcToggleLike,
        params: {'p_deal_type': dealType, 'p_deal_id': dealId},
      );
      return _parseBoolRpcResult(raw);
    } on PostgrestException catch (e) {
      final message = e.message;
      if (message.toLowerCase().contains('not authenticated')) {
        throw Failure.unauthorized(message: message, code: e.code);
      }
      throw Failure.server(message: message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to toggle deal like',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  Future<Set<String>> _fetchLikedDealIds({
    required String userId,
    required String dealType,
    required List<String> dealIds,
  }) async {
    if (dealIds.isEmpty) return const <String>{};
    try {
      final rows = await _client
          .from(_likesTable)
          .select('deal_id')
          .eq('user_id', userId)
          .eq('deal_type', dealType)
          .inFilter('deal_id', dealIds) as List<dynamic>;

      return rows
          .whereType<Map>()
          .map((row) => row['deal_id'])
          .where((id) => id != null)
          .map((id) => id.toString())
          .toSet();
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    }
  }

  static bool _parseBoolRpcResult(Object? raw) {
    if (raw is bool) return raw;
    if (raw is Map) {
      final data = raw['data'];
      if (data is bool) return data;
      final result = raw['result'];
      if (result is bool) return result;
    }
    throw const Failure.parse(
      message: 'Invalid toggle like response.',
      code: 'DEALS_TOGGLE_LIKE_INVALID',
    );
  }

  Future<Map<String, String>> _safeFetchStoreNamesById({
    required String languageCode,
    required List<String> storeIds,
  }) async {
    if (storeIds.isEmpty) return const <String, String>{};
    try {
      final rows = await _client
          .from(_storesTable)
          .select('id,name,name_ar')
          .inFilter('id', storeIds) as List<dynamic>;

      final isArabic = languageCode.toLowerCase() == 'ar';

      final result = <String, String>{};
      for (final row in rows.whereType<Map>()) {
        final map = Map<String, dynamic>.from(row);
        final id = map['id']?.toString();
        if (id == null || id.isEmpty) continue;

        final name = _pickLocalizedText(
          isArabic: isArabic,
          primary: map['name_ar'],
          fallback: map['name'],
        );
        if (name == null || name.isEmpty) continue;
        result[id] = name;
      }

      return result;
    } catch (_) {
      // Best-effort hydration; keep feed usable if store RLS changes.
      return const <String, String>{};
    }
  }
}
