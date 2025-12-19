import 'package:waffir/features/profile/data/models/user_profile_model.dart';

/// Abstract data source for profile functionality.
///
/// Defines low-level data operations. Implementations handle Supabase RPC calls
/// or mock data generation. Methods throw [Failure] on errors.
abstract class ProfileRemoteDataSource {
  /// Fetches current user's profile and settings.
  ///
  /// Calls Supabase RPC: `get_my_account_details`
  /// Also queries: `user_settings` table
  ///
  /// Throws [Failure.unauthorized] if user not authenticated.
  /// Throws [Failure.server] on database errors.
  Future<UserProfileModel> fetchProfile();

  /// Updates user profile fields.
  ///
  /// Calls Supabase RPC: `update_user_profile` with params:
  /// - p_full_name: String?
  /// - p_gender: String?
  /// - p_avatar_url: String?
  /// - p_accept_terms: bool?
  ///
  /// Returns updated profile after successful update.
  /// Throws [Failure] on errors.
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  });

  /// Updates user settings.
  ///
  /// Calls Supabase RPC: `update_user_settings` with params:
  /// - p_language: String?
  /// - p_city_id: UUID?
  /// - p_notify_all_deals: bool?
  /// - p_notify_only_popular: bool?
  /// - p_marketing_consent: bool?
  ///
  /// Returns updated profile after successful update.
  /// Throws [Failure] on errors.
  Future<UserProfileModel> updateUserSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  });

  /// Updates notification settings.
  ///
  /// Calls Supabase RPC: `update_notification_settings` with params:
  /// - p_notify_push_enabled: bool?
  /// - p_notify_email_enabled: bool?
  /// - p_notify_offer_preference: String? ('all' | 'trending')
  ///
  /// Returns updated profile after successful update.
  /// Throws [Failure] on errors.
  Future<UserProfileModel> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  });

  /// Requests account deletion (stub).
  ///
  /// Future RPC: `request_account_deletion`
  /// Currently a no-op stub for client-side preparation.
  Future<void> requestAccountDeletion();
}
