import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/deals/data/datasources/deals_remote_data_source.dart';
import 'package:waffir/features/deals/data/models/deal_model.dart';

/// Supabase-backed deals data source.
///
/// This implementation is wired behind `USE_MOCK_DEALS`. Keep that flag `true`
/// until the Supabase schema/RLS and data are deployed.
class SupabaseDealsRemoteDataSource implements DealsRemoteDataSource {
  SupabaseDealsRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'deals';

  @override
  Future<List<DealModel>> fetchHotDeals({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final normalizedCategory = category?.trim();
      final normalizedSearch = searchQuery?.trim();

      // Start with filters only. Apply ordering last to avoid changing the
      // builder type mid-chain (FilterBuilder -> TransformBuilder).
      var filteredQuery = _client
          .from(_table)
          .select()
          .gte('discount_percentage', 20);

      var orderByRating = false;
      if (normalizedCategory != null && normalizedCategory.isNotEmpty) {
        switch (normalizedCategory) {
          case 'For You':
          case 'All':
          case 'الكل':
            break;
          case 'Front Page':
            filteredQuery = filteredQuery.eq('is_featured', true);
            break;
          case 'Popular':
            orderByRating = true;
            break;
          default:
            filteredQuery = filteredQuery.eq('category', normalizedCategory);
            break;
        }
      }

      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        final like = '%$normalizedSearch%';
        filteredQuery = filteredQuery.or(
          'title.ilike.$like,description.ilike.$like,brand.ilike.$like',
        );
      }

      final orderedQuery = orderByRating
          ? filteredQuery
                .order('rating', ascending: false)
                .order('review_count', ascending: false)
                .order('created_at', ascending: false)
          : filteredQuery.order('created_at', ascending: false);

      final rows = await orderedQuery.limit(50) as List<dynamic>;

      return rows
          .map(_normalizeRow)
          .map(_normalizeDealJson)
          .map(DealModel.fromJson)
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

  /// Accept both `snake_case` (typical Postgres) and `camelCase` keys to keep
  /// the Dart model stable while the DB schema is finalized.
  static Map<String, dynamic> _normalizeDealJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);

    void alias(String snake, String camel) {
      if (!data.containsKey(camel) && data.containsKey(snake)) {
        data[camel] = data[snake];
      }
    }

    alias('original_price', 'originalPrice');
    alias('discount_percentage', 'discountPercentage');
    alias('image_url', 'imageUrl');
    alias('review_count', 'reviewCount');
    alias('is_new', 'isNew');
    alias('is_featured', 'isFeatured');
    alias('created_at', 'createdAt');
    alias('expires_at', 'expiresAt');

    return data;
  }
}
