import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:waffir/features/alerts/data/models/alert_model.dart';

/// Supabase implementation of AlertsRemoteDataSource
///
/// Handles alerts CRUD operations via Supabase backend.
/// Uses direct table access for alerts and RPC for popular keywords.
class SupabaseAlertsRemoteDataSource implements AlertsRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAlertsRemoteDataSource(this._client);

  @override
  Future<List<AlertModel>> fetchMyAlerts() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const Failure.unauthorized(message: 'User not authenticated');
      }

      final data = await _client
          .from('deal_alerts')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((row) => AlertModel.fromJson(row as Map<String, dynamic>))
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      throw Failure.unauthorized(message: e.message);
    }
  }

  @override
  Future<AlertModel> createAlert({required String keyword}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const Failure.unauthorized(message: 'User not authenticated');
      }

      final normalizedKeyword = keyword.trim().toLowerCase();

      final data = await _client
          .from('deal_alerts')
          .insert({
            'user_id': userId,
            'keyword': normalizedKeyword,
          })
          .select()
          .single();

      return AlertModel.fromJson(data as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      // Handle duplicate constraint violation (unique keyword per user)
      if (e.code == '23505') {
        throw const Failure.conflict(message: 'Alert already exists');
      }
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      throw Failure.unauthorized(message: e.message);
    }
  }

  @override
  Future<void> deleteAlert({required String alertId}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const Failure.unauthorized(message: 'User not authenticated');
      }

      await _client
          .from('deal_alerts')
          .delete()
          .eq('id', alertId)
          .eq('user_id', userId); // Ensure user owns this alert
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      throw Failure.unauthorized(message: e.message);
    }
  }

  @override
  Future<List<String>> fetchPopularKeywords() async {
    try {
      final data = await _client.rpc('get_popular_alert_keywords');

      if (data == null || data is! List) return [];

      return (data as List)
          .map((row) => row['keyword'] as String? ?? '')
          .where((k) => k.isNotEmpty)
          .toList(growable: false);
    } on PostgrestException catch (e) {
      throw Failure.server(message: e.message, code: e.code);
    }
  }
}
