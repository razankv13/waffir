import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/stores/data/datasources/bank_catalog_remote_data_source.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank.dart';
import 'package:waffir/features/stores/domain/entities/catalog_bank_card.dart';
import 'package:waffir/features/stores/domain/entities/my_bank_card.dart';

class SupabaseBankCatalogRemoteDataSource
    implements BankCatalogRemoteDataSource {
  SupabaseBankCatalogRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _banksTable = 'banks';
  static const String _bankCardsTable = 'bank_cards';
  static const String _rpcGetBankOffers = 'get_bank_offers';
  static const String _rpcGetMyBankCards = 'get_my_bank_cards';
  static const String _rpcSetUserBankCards = 'set_user_bank_cards';

  @override
  Future<List<CatalogBank>> fetchActiveBanks({
    required String languageCode,
  }) async {
    try {
      final rows = await _client
          .from(_banksTable)
          .select('id,name,name_ar,logo_url,is_active,created_at')
          .eq('is_active', true);

      return rows
          .map(_normalizeRow)
          .map(
            (row) => CatalogBank(
              id: row['id'].toString(),
              name: (row['name'] ?? '').toString(),
              nameAr: row['name_ar']?.toString(),
              logoUrl: row['logo_url']?.toString(),
              isActive: (row['is_active'] as bool?) ?? true,
            ),
          )
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load banks',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<List<CatalogBankCard>> fetchActiveBankCards({
    required String languageCode,
  }) async {
    try {
      final rows = await _client
          .from(_bankCardsTable)
          .select('id,bank_id,name_en,name_ar,image_url,is_active,created_at')
          .eq('is_active', true);

      return rows
          .map(_normalizeRow)
          .map(
            (row) => CatalogBankCard(
              id: row['id'].toString(),
              bankId: row['bank_id'].toString(),
              name: (row['name_en'] ?? '').toString(),
              nameAr: row['name_ar']?.toString(),
              imageUrl: row['image_url']?.toString(),
              isActive: (row['is_active'] as bool?) ?? true,
            ),
          )
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load bank cards',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<List<BankOffer>> fetchBankOffers({
    String? bankId,
    required String languageCode,
    String? searchQuery,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'p_search_query': searchQuery,
        'p_bank_id': bankId,
        'p_limit': limit,
        'p_offset': offset,
      };
      if (categoryId != null && categoryId.trim().isNotEmpty) {
        params['p_category_id'] = categoryId;
      }

      final stopwatch = Stopwatch()..start();
      final raw = await _client.rpc(_rpcGetBankOffers, params: params);
      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcGetBankOffers bankId=${bankId ?? ''} offset=$offset limit=$limit '
        'categoryId=${categoryId ?? ''} search=${searchQuery ?? ''} '
        'took=${stopwatch.elapsedMilliseconds}ms',
      );
      final rows = raw is List ? raw : const <dynamic>[];

      return rows
          .map(_normalizeRow)
          .map(
            (row) => BankOffer(
              id: row['id'].toString(),
              bankId: row['bank_id'].toString(),
              bankCardId: row['bank_card_id']?.toString(),
              merchantStoreId: row['merchant_store_id']?.toString(),
              merchantNameText: row['merchant_name_text']?.toString(),
              title: (row['title'] ?? '').toString(),
              titleAr: row['title_ar']?.toString(),
              description: row['description']?.toString(),
              descriptionAr: row['description_ar']?.toString(),
              termsText: row['terms_text']?.toString(),
              termsTextAr: row['terms_text_ar']?.toString(),
              bankName: row['bank_name']?.toString(),
              bankNameAr: row['bank_name_ar']?.toString(),
              bankCardName: row['bank_card_name']?.toString(),
              bankCardNameAr: row['bank_card_name_ar']?.toString(),
              merchantNameAr: row['merchant_name_ar']?.toString(),
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
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      throw Failure.unknown(
        message: 'Failed to load bank offers',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<List<MyBankCard>> fetchMyBankCards({
    required String languageCode,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final raw = await _client.rpc(_rpcGetMyBankCards);
      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcGetMyBankCards took=${stopwatch.elapsedMilliseconds}ms',
      );
      final rows = raw is List ? raw : const <dynamic>[];

      return rows
          .map(_normalizeRow)
          .map(
            (row) => MyBankCard(
              bankCardId: row['bank_card_id'].toString(),
              bankId: row['bank_id'].toString(),
              bankName: (row['bank_name'] ?? '').toString(),
              cardName: (row['card_name'] ?? '').toString(),
            ),
          )
          .toList(growable: false);
    } on PostgrestException catch (e) {
      final message = e.message;
      if (message.toLowerCase().contains('not authenticated')) {
        AppLogger.warning('Supabase RPC $_rpcGetMyBankCards unauthorized');
        throw Failure.unauthorized(message: message, code: e.code);
      }
      AppLogger.error(
        'Supabase RPC $_rpcGetMyBankCards failed code=${e.code ?? ''}',
        error: e,
      );
      throw Failure.server(message: message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error('Supabase RPC $_rpcGetMyBankCards crashed', error: e, stackTrace: stackTrace);
      throw Failure.unknown(
        message: 'Failed to load selected bank cards',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<void> setMyBankCards({required List<String> bankCardIds}) async {
    try {
      final stopwatch = Stopwatch()..start();
      await _client.rpc(
        _rpcSetUserBankCards,
        params: {'p_bank_card_ids': bankCardIds},
      );
      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcSetUserBankCards count=${bankCardIds.length} took=${stopwatch.elapsedMilliseconds}ms',
      );
    } on PostgrestException catch (e) {
      final message = e.message;
      if (message.toLowerCase().contains('not authenticated')) {
        AppLogger.warning('Supabase RPC $_rpcSetUserBankCards unauthorized count=${bankCardIds.length}');
        throw Failure.unauthorized(message: message, code: e.code);
      }
      AppLogger.error(
        'Supabase RPC $_rpcSetUserBankCards failed count=${bankCardIds.length} code=${e.code ?? ''}',
        error: e,
      );
      throw Failure.server(message: message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Supabase RPC $_rpcSetUserBankCards crashed count=${bankCardIds.length}',
        error: e,
        stackTrace: stackTrace,
      );
      throw Failure.unknown(
        message: 'Failed to save selected bank cards',
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
      message: 'Invalid bank row',
      code: 'BANK_INVALID_ROW',
    );
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
}
