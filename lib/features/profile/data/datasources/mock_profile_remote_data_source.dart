import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:waffir/features/profile/data/models/user_profile_model.dart';

/// Mock implementation of profile data source for testing.
///
/// Simulates Supabase behavior with hardcoded data and artificial delays.
/// Maintains in-memory state for profile and settings.
class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  MockProfileRemoteDataSource();

  // In-memory storage for mocked profile state
  String _userId = 'mock_user_001';
  String? _fullName = 'John Doe';
  String? _gender = 'male';
  String? _avatarUrl;
  String _language = 'en';
  String? _cityId;
  bool _notifyAllDeals = true;
  bool _notifyOnlyPopular = false;
  bool _marketingConsent = false;
  bool _notifyPushEnabled = true;
  bool _notifyEmailEnabled = true;
  String _notifyOfferPreference = 'all';

  @override
  Future<UserProfileModel> fetchProfile() async {
    AppLogger.debug('🎭 [MOCK] Fetching user profile');

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final model = UserProfileModel(
      userId: _userId,
      fullName: _fullName,
      gender: _gender,
      avatarUrl: _avatarUrl,
      language: _language,
      cityId: _cityId,
      notifyAllDeals: _notifyAllDeals,
      notifyOnlyPopular: _notifyOnlyPopular,
      marketingConsent: _marketingConsent,
      notifyPushEnabled: _notifyPushEnabled,
      notifyEmailEnabled: _notifyEmailEnabled,
      notifyOfferPreference: _notifyOfferPreference,
    );

    AppLogger.debug('✅ [MOCK] Profile fetched: ${_fullName ?? "unnamed"}');
    return model;
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  }) async {
    AppLogger.debug('🎭 [MOCK] Updating user profile: fullName=$fullName, gender=$gender');

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Update in-memory state
    if (fullName != null) _fullName = fullName;
    if (gender != null) _gender = gender;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    // acceptTerms would update termsAcceptedAt but we skip for mock

    AppLogger.debug('✅ [MOCK] Profile updated successfully');
    return fetchProfile();
  }

  @override
  Future<UserProfileModel> updateUserSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  }) async {
    AppLogger.debug('🎭 [MOCK] Updating user settings: language=$language, cityId=$cityId');

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Update in-memory state
    if (language != null) _language = language;
    if (cityId != null) _cityId = cityId;
    if (notifyAllDeals != null) _notifyAllDeals = notifyAllDeals;
    if (notifyOnlyPopular != null) _notifyOnlyPopular = notifyOnlyPopular;
    if (marketingConsent != null) _marketingConsent = marketingConsent;

    AppLogger.debug('✅ [MOCK] Settings updated successfully');
    return fetchProfile();
  }

  @override
  Future<UserProfileModel> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  }) async {
    AppLogger.debug(
      '🎭 [MOCK] Updating notification settings: push=$notifyPushEnabled, email=$notifyEmailEnabled',
    );

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Update in-memory state
    if (notifyPushEnabled != null) _notifyPushEnabled = notifyPushEnabled;
    if (notifyEmailEnabled != null) _notifyEmailEnabled = notifyEmailEnabled;
    if (notifyOfferPreference != null) _notifyOfferPreference = notifyOfferPreference;

    AppLogger.debug('✅ [MOCK] Notification settings updated successfully');
    return fetchProfile();
  }

  @override
  Future<void> requestAccountDeletion() async {
    AppLogger.info('🎭 [MOCK] Account deletion requested (stubbed)');

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    AppLogger.info('✅ [MOCK] Account deletion request acknowledged');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Test helper methods (for integration tests)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reset mock data to initial state.
  void reset() {
    _userId = 'mock_user_001';
    _fullName = 'John Doe';
    _gender = 'male';
    _avatarUrl = null;
    _language = 'en';
    _cityId = null;
    _notifyAllDeals = true;
    _notifyOnlyPopular = false;
    _marketingConsent = false;
    _notifyPushEnabled = true;
    _notifyEmailEnabled = true;
    _notifyOfferPreference = 'all';
  }

  /// Set a custom user ID (for testing different user scenarios).
  void setUserId(String userId) {
    _userId = userId;
  }

  /// Get current profile state (for testing assertions).
  Map<String, dynamic> get currentState => {
        'userId': _userId,
        'fullName': _fullName,
        'gender': _gender,
        'avatarUrl': _avatarUrl,
        'language': _language,
        'cityId': _cityId,
        'notifyAllDeals': _notifyAllDeals,
        'notifyOnlyPopular': _notifyOnlyPopular,
        'marketingConsent': _marketingConsent,
        'notifyPushEnabled': _notifyPushEnabled,
        'notifyEmailEnabled': _notifyEmailEnabled,
        'notifyOfferPreference': _notifyOfferPreference,
      };
}
