import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/profile/domain/entities/user_profile.dart';

/// Abstract repository for profile and settings functionality.
///
/// Defines contracts for fetching and updating user profile/settings.
/// Implementations handle both Supabase-backed and mock data sources.
abstract class ProfileRepository {
  /// Fetches current user's profile and settings.
  ///
  /// Uses Supabase RPC: `get_my_account_details`
  /// Also fetches from `user_settings` table.
  ///
  /// Returns [UserProfile] combining both profile and settings data.
  AsyncResult<UserProfile> fetchProfile();

  /// Updates user profile fields.
  ///
  /// Uses Supabase RPC: `update_user_profile`
  /// Parameters:
  /// - [fullName]: User's display name
  /// - [gender]: User's gender ('male', 'female', or null)
  /// - [avatarUrl]: URL to user's profile picture
  /// - [acceptTerms]: Whether user accepts terms of service
  ///
  /// Returns updated [UserProfile] on success.
  AsyncResult<UserProfile> updateUserProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  });

  /// Updates user settings (language, city, notification preferences).
  ///
  /// Uses Supabase RPC: `update_user_settings`
  /// Parameters:
  /// - [language]: Preferred language ('en', 'ar')
  /// - [cityId]: UUID of selected city
  /// - [notifyAllDeals]: Whether to receive all deal notifications
  /// - [notifyOnlyPopular]: Whether to only receive popular deal notifications
  /// - [marketingConsent]: Whether user consents to marketing communications
  ///
  /// Returns updated [UserProfile] on success.
  AsyncResult<UserProfile> updateUserSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  });

  /// Updates notification-specific settings.
  ///
  /// Uses Supabase RPC: `update_notification_settings`
  /// Parameters:
  /// - [notifyPushEnabled]: Whether push notifications are enabled
  /// - [notifyEmailEnabled]: Whether email notifications are enabled
  /// - [notifyOfferPreference]: Offer preference ('all' or 'trending')
  ///
  /// Returns updated [UserProfile] on success.
  AsyncResult<UserProfile> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  });

  /// Requests account deletion.
  ///
  /// Future RPC: `request_account_deletion`
  /// Currently returns stubbed success for client-side preparation.
  ///
  /// Required by Apple App Store guidelines.
  AsyncResult<void> requestAccountDeletion();
}
