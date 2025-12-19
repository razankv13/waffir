import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/profile/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Data model for user profile, handles JSON serialization.
///
/// Maps to combined data from:
/// - `user_profiles` table
/// - `user_settings` table
/// - `get_my_account_details` RPC response
@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') String? fullName,
    String? gender,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
    @Default('en') String language,
    @JsonKey(name: 'city_id') String? cityId,
    @JsonKey(name: 'notify_all_deals') @Default(true) bool notifyAllDeals,
    @JsonKey(name: 'notify_only_popular') @Default(false) bool notifyOnlyPopular,
    @JsonKey(name: 'marketing_consent') @Default(false) bool marketingConsent,
    @JsonKey(name: 'notify_push_enabled') @Default(true) bool notifyPushEnabled,
    @JsonKey(name: 'notify_email_enabled') @Default(true) bool notifyEmailEnabled,
    @JsonKey(name: 'notify_offer_preference') @Default('all') String notifyOfferPreference,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfileModel;

  const UserProfileModel._();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

  /// Factory from combined RPC responses.
  ///
  /// [accountDetails] comes from `get_my_account_details` RPC.
  /// [userSettings] comes from `user_settings` table query.
  factory UserProfileModel.fromRpcResponses({
    required String userId,
    Map<String, dynamic>? accountDetails,
    Map<String, dynamic>? userSettings,
  }) {
    return UserProfileModel(
      userId: userId,
      fullName: accountDetails?['full_name'] as String?,
      gender: accountDetails?['gender'] as String?,
      avatarUrl: accountDetails?['avatar_url'] as String?,
      language:
          (userSettings?['language'] as String?) ?? (accountDetails?['language'] as String?) ?? 'en',
      cityId: (userSettings?['city_id'] as String?) ?? (accountDetails?['city_id'] as String?),
      notifyAllDeals: (userSettings?['notify_all_deals'] as bool?) ?? true,
      notifyOnlyPopular: (userSettings?['notify_only_popular'] as bool?) ?? false,
      marketingConsent: (userSettings?['marketing_consent'] as bool?) ??
          (accountDetails?['marketing_consent'] as bool?) ??
          false,
      notifyPushEnabled: (userSettings?['notify_push_enabled'] as bool?) ?? true,
      notifyEmailEnabled: (userSettings?['notify_email_enabled'] as bool?) ?? true,
      notifyOfferPreference: (userSettings?['notify_offer_preference'] as String?) ?? 'all',
    );
  }

  /// Convert to domain entity.
  UserProfile toDomain() => UserProfile(
        userId: userId,
        fullName: fullName,
        gender: gender,
        avatarUrl: avatarUrl,
        termsAcceptedAt: termsAcceptedAt,
        language: language,
        cityId: cityId,
        notifyAllDeals: notifyAllDeals,
        notifyOnlyPopular: notifyOnlyPopular,
        marketingConsent: marketingConsent,
        notifyPushEnabled: notifyPushEnabled,
        notifyEmailEnabled: notifyEmailEnabled,
        notifyOfferPreference: notifyOfferPreference,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
