import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/credit_cards/data/datasources/bank_cards_remote_data_source.dart';
import 'package:waffir/features/credit_cards/data/models/credit_card_model.dart';

/// Supabase implementation of [BankCardsRemoteDataSource]
///
/// Fetches bank cards from the `bank_cards` table with bank info joined,
/// and manages user selections via RPC functions.
class SupabaseBankCardsRemoteDataSource implements BankCardsRemoteDataSource {
  SupabaseBankCardsRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _bankCardsTable = 'bank_cards';
  static const String _banksTable = 'banks';
  static const String _rpcSetUserBankCards = 'set_user_bank_cards';
  static const String _rpcGetMyBankCards = 'get_my_bank_cards';

  @override
  Future<List<BankCardModel>> fetchAllBankCards() async {
    try {
      final stopwatch = Stopwatch()..start();

      // Query bank_cards joined with banks
      final rows = await _client
          .from(_bankCardsTable)
          .select('''
            id,
            bank_id,
            name_en,
            name_ar,
            image_url,
            is_active,
            account_type_id,
            card_type_id,
            $_banksTable!inner(
              name,
              name_ar,
              logo_url
            )
          ''')
          .eq('is_active', true)
          .order('name_en');

      stopwatch.stop();
      AppLogger.debug(
        'Supabase fetch bank_cards count=${rows.length} took=${stopwatch.elapsedMilliseconds}ms',
      );

      return rows.map((row) {
        final normalized = _normalizeRow(row);
        // Extract bank info from nested object
        final bankData = normalized['banks'] as Map<String, dynamic>?;
        return BankCardModel(
          id: normalized['id'].toString(),
          bankId: normalized['bank_id'].toString(),
          nameEn: (normalized['name_en'] ?? '').toString(),
          nameAr: normalized['name_ar']?.toString(),
          imageUrl: normalized['image_url']?.toString(),
          isActive: (normalized['is_active'] as bool?) ?? true,
          accountTypeId: _parseInt(normalized['account_type_id']),
          cardTypeId: _parseInt(normalized['card_type_id']),
          bankName: bankData?['name']?.toString(),
          bankNameAr: bankData?['name_ar']?.toString(),
          bankLogoUrl: bankData?['logo_url']?.toString(),
        );
      }).toList(growable: false);
    } on PostgrestException catch (e) {
      AppLogger.error('Supabase fetch bank_cards failed code=${e.code}', error: e);
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error('Supabase fetch bank_cards crashed', error: e, stackTrace: stackTrace);
      throw Failure.unknown(
        message: 'Failed to load bank cards',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<Set<String>> fetchUserSelectedCardIds() async {
    try {
      final stopwatch = Stopwatch()..start();

      final raw = await _client.rpc(_rpcGetMyBankCards);

      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcGetMyBankCards took=${stopwatch.elapsedMilliseconds}ms',
      );

      if (raw == null) return {};

      final rows = raw is List ? raw : const <dynamic>[];
      return rows
          .map((row) {
            final normalized = _normalizeRow(row);
            return normalized['bank_card_id']?.toString();
          })
          .whereType<String>()
          .toSet();
    } on PostgrestException catch (e) {
      final message = e.message.toLowerCase();
      // If not authenticated, return empty set (non-logged-in users)
      if (message.contains('not authenticated') || message.contains('jwt')) {
        AppLogger.debug('Supabase RPC $_rpcGetMyBankCards: user not authenticated');
        return {};
      }
      AppLogger.error('Supabase RPC $_rpcGetMyBankCards failed code=${e.code}', error: e);
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error('Supabase RPC $_rpcGetMyBankCards crashed', error: e, stackTrace: stackTrace);
      throw Failure.unknown(
        message: 'Failed to load user bank cards',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  @override
  Future<void> setUserBankCards(Set<String> cardIds) async {
    try {
      final stopwatch = Stopwatch()..start();

      await _client.rpc(
        _rpcSetUserBankCards,
        params: {'p_bank_card_ids': cardIds.toList()},
      );

      stopwatch.stop();
      AppLogger.debug(
        'Supabase RPC $_rpcSetUserBankCards count=${cardIds.length} took=${stopwatch.elapsedMilliseconds}ms',
      );
    } on PostgrestException catch (e) {
      final message = e.message.toLowerCase();
      if (message.contains('not authenticated') || message.contains('authentication required')) {
        AppLogger.warning('Supabase RPC $_rpcSetUserBankCards: not authenticated');
        throw Failure.unauthorized(message: e.message, code: e.code);
      }
      AppLogger.error('Supabase RPC $_rpcSetUserBankCards failed code=${e.code}', error: e);
      throw Failure.server(message: e.message, code: e.code);
    } catch (e, stackTrace) {
      AppLogger.error('Supabase RPC $_rpcSetUserBankCards crashed', error: e, stackTrace: stackTrace);
      throw Failure.unknown(
        message: 'Failed to save bank card selections',
        originalError: e.toString(),
        stackTrace: stackTrace.toString(),
      );
    }
  }

  /// Normalizes a Supabase row to a consistent Map<String, dynamic>
  static Map<String, dynamic> _normalizeRow(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), v));
    }
    throw const Failure.parse(
      message: 'Invalid bank card row',
      code: 'BANK_CARD_INVALID_ROW',
    );
  }

  /// Parses an integer from various types
  static int? _parseInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
