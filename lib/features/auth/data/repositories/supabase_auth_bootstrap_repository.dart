import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:waffir/core/result/exception_to_failure.dart';
import 'package:waffir/features/auth/domain/entities/auth_bootstrap_data.dart';

class SupabaseAuthBootstrapRepository {
  SupabaseAuthBootstrapRepository(this._client);

  final sb.SupabaseClient _client;

  Future<AuthBootstrapData> bootstrap() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw Exception('Cannot bootstrap without an authenticated user.');
    }

    try {
      final accountSummaryRaw = await _client.rpc('get_my_account_details');
      final accountSummary = accountSummaryRaw is Map
          ? Map<String, dynamic>.from(accountSummaryRaw)
          : null;

      final userSettingsRaw = await _client
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      final userSettings = userSettingsRaw == null
          ? null
          : Map<String, dynamic>.from(userSettingsRaw as Map);

      final hasHadSubscriptionBeforeRaw = await _client.rpc('user_has_had_subscription_before');
      final hasHadSubscriptionBefore = hasHadSubscriptionBeforeRaw is bool
          ? hasHadSubscriptionBeforeRaw
          : (hasHadSubscriptionBeforeRaw is Map
                ? (hasHadSubscriptionBeforeRaw['data'] as bool?) ??
                      (hasHadSubscriptionBeforeRaw['result'] as bool?)
                : null);

      final invitesRaw = await _client.rpc('get_my_family_invites');
      final familyInvites = invitesRaw is List
          ? invitesRaw
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList(growable: false)
          : const <Map<String, dynamic>>[];

      return AuthBootstrapData(
        userId: userId,
        accountSummary: accountSummary,
        userSettings: userSettings,
        hasHadSubscriptionBefore: hasHadSubscriptionBefore,
        familyInvites: familyInvites,
        fetchedAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      throw ExceptionToFailure.convert(e, stackTrace);
    }
  }

  Future<void> respondFamilyInvite({required String inviteId, required String action}) async {
    try {
      await _client.rpc(
        'respond_family_invite',
        params: {'p_invite_id': inviteId, 'p_action': action},
      );
    } catch (e, stackTrace) {
      throw ExceptionToFailure.convert(e, stackTrace);
    }
  }
}
