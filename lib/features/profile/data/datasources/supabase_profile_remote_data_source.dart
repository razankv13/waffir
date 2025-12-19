import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/models/user_profile_model.dart';

/// Supabase implementation of profile data source.
///
/// Handles RPC calls to Supabase for profile and settings management.
class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  SupabaseProfileRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// Gets current user ID or throws [Failure.unauthorized].
  String get _userId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const Failure.unauthorized(message: 'User not authenticated');
    }
    return userId;
  }

  @override
  Future<UserProfileModel> fetchProfile() async {
    try {
      AppLogger.debug('Fetching user profile');

      // Call get_my_account_details RPC
      final accountDetailsRaw = await _client.rpc('get_my_account_details');
      final accountDetails =
          accountDetailsRaw is Map ? Map<String, dynamic>.from(accountDetailsRaw) : null;

      // Query user_settings table
      final userSettingsRaw =
          await _client.from('user_settings').select('*').eq('user_id', _userId).maybeSingle();
      final userSettings =
          userSettingsRaw != null ? Map<String, dynamic>.from(userSettingsRaw) : null;

      final model = UserProfileModel.fromRpcResponses(
        userId: _userId,
        accountDetails: accountDetails,
        userSettings: userSettings,
      );

      AppLogger.debug('Profile fetched successfully');
      return model;
    } on PostgrestException catch (e) {
      AppLogger.error('Failed to fetch profile', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('Auth error fetching profile', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('Unexpected error fetching profile', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  }) async {
    try {
      AppLogger.debug('Updating user profile: fullName=$fullName, gender=$gender');

      await _client.rpc('update_user_profile', params: {
        'p_full_name': fullName,
        'p_gender': gender,
        'p_avatar_url': avatarUrl,
        'p_accept_terms': acceptTerms,
      });

      AppLogger.debug('Profile updated successfully, fetching updated data');
      return await fetchProfile();
    } on PostgrestException catch (e) {
      AppLogger.error('Failed to update profile', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('Auth error updating profile', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('Unexpected error updating profile', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateUserSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  }) async {
    try {
      AppLogger.debug('Updating user settings: language=$language, cityId=$cityId');

      await _client.rpc('update_user_settings', params: {
        'p_language': language,
        'p_city_id': cityId,
        'p_notify_all_deals': notifyAllDeals,
        'p_notify_only_popular': notifyOnlyPopular,
        'p_marketing_consent': marketingConsent,
      });

      AppLogger.debug('Settings updated successfully, fetching updated data');
      return await fetchProfile();
    } on PostgrestException catch (e) {
      AppLogger.error('Failed to update settings', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('Auth error updating settings', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('Unexpected error updating settings', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<UserProfileModel> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  }) async {
    try {
      AppLogger.debug(
        'Updating notification settings: push=$notifyPushEnabled, email=$notifyEmailEnabled, pref=$notifyOfferPreference',
      );

      await _client.rpc('update_notification_settings', params: {
        'p_notify_push_enabled': notifyPushEnabled,
        'p_notify_email_enabled': notifyEmailEnabled,
        'p_notify_offer_preference': notifyOfferPreference,
      });

      AppLogger.debug('Notification settings updated successfully, fetching updated data');
      return await fetchProfile();
    } on PostgrestException catch (e) {
      AppLogger.error('Failed to update notification settings', error: e.message);
      throw Failure.server(message: e.message, code: e.code);
    } on AuthException catch (e) {
      AppLogger.error('Auth error updating notification settings', error: e.message);
      throw Failure.unauthorized(message: e.message);
    } catch (e) {
      if (e is Failure) rethrow;
      AppLogger.error('Unexpected error updating notification settings', error: e);
      throw Failure.unknown(message: e.toString());
    }
  }

  @override
  Future<void> requestAccountDeletion() async {
    // STUB: RPC not yet implemented in Supabase
    // When the RPC is ready, uncomment the following:
    // await _client.rpc('request_account_deletion');

    AppLogger.info('Account deletion requested (stubbed - RPC not yet implemented)');

    // Simulate network delay for realistic UX
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
