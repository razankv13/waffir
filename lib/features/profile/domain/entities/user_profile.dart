import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Domain entity representing user profile and settings.
///
/// Combines data from both `user_profiles` and `user_settings` Supabase tables.
/// Maps to:
/// - get_my_account_details RPC response
/// - user_profiles table columns
/// - user_settings table columns
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,

    // Profile data (from user_profiles table)
    String? fullName,
    String? gender,
    String? avatarUrl,
    DateTime? termsAcceptedAt,

    // Settings data (from user_settings table)
    @Default('en') String language,
    String? cityId,
    @Default(true) bool notifyAllDeals,
    @Default(false) bool notifyOnlyPopular,
    @Default(false) bool marketingConsent,
    @Default(true) bool notifyPushEnabled,
    @Default(true) bool notifyEmailEnabled,
    @Default('all') String notifyOfferPreference,

    // Metadata
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  const UserProfile._();

  /// Factory to create from AuthBootstrapData maps.
  ///
  /// [accountSummary] comes from `get_my_account_details` RPC.
  /// [userSettings] comes from `user_settings` table query.
  factory UserProfile.fromBootstrapData({
    required String userId,
    Map<String, dynamic>? accountSummary,
    Map<String, dynamic>? userSettings,
  }) {
    return UserProfile(
      userId: userId,
      // From accountSummary (get_my_account_details RPC)
      fullName: accountSummary?['full_name'] as String?,
      gender: accountSummary?['gender'] as String?,
      avatarUrl: accountSummary?['avatar_url'] as String?,
      // From userSettings or accountSummary (both may contain these)
      language: (userSettings?['language'] as String?) ??
          (accountSummary?['language'] as String?) ??
          'en',
      cityId: (userSettings?['city_id'] as String?) ?? (accountSummary?['city_id'] as String?),
      notifyAllDeals: (userSettings?['notify_all_deals'] as bool?) ?? true,
      notifyOnlyPopular: (userSettings?['notify_only_popular'] as bool?) ?? false,
      marketingConsent: (userSettings?['marketing_consent'] as bool?) ??
          (accountSummary?['marketing_consent'] as bool?) ??
          false,
      notifyPushEnabled: (userSettings?['notify_push_enabled'] as bool?) ?? true,
      notifyEmailEnabled: (userSettings?['notify_email_enabled'] as bool?) ?? true,
      notifyOfferPreference: (userSettings?['notify_offer_preference'] as String?) ?? 'all',
    );
  }

  /// Check if profile has required fields filled.
  bool get isComplete => fullName != null && fullName!.isNotEmpty;

  /// Get display name or fallback.
  String get displayName => fullName ?? 'User';

  /// Get initials for avatar fallback.
  String get initials {
    if (fullName == null || fullName!.isEmpty) return 'U';
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  /// Check if using Arabic language.
  bool get isArabic => language == 'ar';
}
