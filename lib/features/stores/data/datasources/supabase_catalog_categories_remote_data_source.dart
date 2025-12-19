import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/stores/data/datasources/catalog_categories_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';

class SupabaseCatalogCategoriesRemoteDataSource
    implements CatalogCategoriesRemoteDataSource {
  SupabaseCatalogCategoriesRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _categoriesTable = 'categories';

  @override
  Future<List<CatalogCategory>> fetchActiveCategories({
    required String languageCode,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final rows = await _client
          .from(_categoriesTable)
          .select('id,slug,name_en,name_ar,is_active')
          .eq('is_active', true)
          .order('name_en', ascending: true);
      stopwatch.stop();
      AppLogger.debug(
        'Supabase select $_categoriesTable (is_active=true) took=${stopwatch.elapsedMilliseconds}ms',
      );

      return rows
          .map(_normalizeRow)
          .map(
            (row) => CatalogCategory(
              id: row['id'].toString(),
              slug: (row['slug'] ?? '').toString(),
              nameEn: (row['name_en'] ?? '').toString(),
              nameAr: row['name_ar']?.toString(),
              isActive: (row['is_active'] as bool?) ?? true,
            ),
          )
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load categories',
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
      message: 'Invalid category row',
      code: 'CATEGORY_INVALID_ROW',
    );
  }
}
