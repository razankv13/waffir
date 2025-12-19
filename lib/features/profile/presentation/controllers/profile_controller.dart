import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/auth/data/providers/auth_bootstrap_providers.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/features/profile/data/providers/profile_backend_providers.dart';
import 'package:waffir/features/profile/domain/entities/user_profile.dart';
import 'package:waffir/features/profile/domain/repositories/profile_repository.dart';
import 'package:waffir/features/profile/presentation/controllers/profile_state.dart';

/// Provider for ProfileController.
final profileControllerProvider = AsyncNotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);

/// Controller for managing user profile and settings.
///
/// Responsibilities:
/// - Initialize from AuthBootstrapData to avoid duplicate network calls
/// - Handle profile updates with optimistic UI and rollback on failure
/// - Handle settings updates (language, city, notifications)
/// - Handle account deletion requests (stubbed)
/// - Listen for auth changes and reinitialize when user changes
class ProfileController extends AsyncNotifier<ProfileState> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<ProfileState> build() async {
    // Listen for auth changes to reinitialize profile when user changes
    ref.listen(authStateProvider, (previous, next) {
      unawaited(_handleAuthStateChange(next));
    });

    // Initialize from auth bootstrap data
    return await _initializeFromBootstrap();
  }

  /// Refresh profile from backend.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _fetchProfile());
  }

  /// Clear any error state.
  void clearError() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(lastError: null));
  }

  /// Update user profile fields (fullName, gender, avatarUrl, acceptTerms).
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> updateProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  }) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Optimistic update
    final optimisticProfile = current.profile.copyWith(
      fullName: fullName ?? current.profile.fullName,
      gender: gender ?? current.profile.gender,
      avatarUrl: avatarUrl ?? current.profile.avatarUrl,
    );
    state = AsyncValue.data(
      current.copyWith(profile: optimisticProfile, isSaving: true, lastError: null),
    );

    // Call backend
    final result = await _repository.updateUserProfile(
      fullName: fullName,
      gender: gender,
      avatarUrl: avatarUrl,
      acceptTerms: acceptTerms,
    );

    return result.when(
      success: (updatedProfile) {
        AppLogger.debug('✅ Profile updated successfully');
        state = AsyncValue.data(ProfileState(profile: updatedProfile));
        return null;
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to update profile: ${failure.message}');
        // Rollback to original state
        state = AsyncValue.data(current.copyWith(lastError: failure));
        return failure;
      },
    );
  }

  /// Update user settings (language, cityId, notifyAllDeals, notifyOnlyPopular, marketingConsent).
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> updateSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  }) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Optimistic update
    final optimisticProfile = current.profile.copyWith(
      language: language ?? current.profile.language,
      cityId: cityId ?? current.profile.cityId,
      notifyAllDeals: notifyAllDeals ?? current.profile.notifyAllDeals,
      notifyOnlyPopular: notifyOnlyPopular ?? current.profile.notifyOnlyPopular,
      marketingConsent: marketingConsent ?? current.profile.marketingConsent,
    );
    state = AsyncValue.data(
      current.copyWith(profile: optimisticProfile, isSaving: true, lastError: null),
    );

    // Call backend
    final result = await _repository.updateUserSettings(
      language: language,
      cityId: cityId,
      notifyAllDeals: notifyAllDeals,
      notifyOnlyPopular: notifyOnlyPopular,
      marketingConsent: marketingConsent,
    );

    return result.when(
      success: (updatedProfile) {
        AppLogger.debug('✅ Settings updated successfully');
        state = AsyncValue.data(ProfileState(profile: updatedProfile));
        return null;
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to update settings: ${failure.message}');
        // Rollback to original state
        state = AsyncValue.data(current.copyWith(lastError: failure));
        return failure;
      },
    );
  }

  /// Update notification settings (notifyPushEnabled, notifyEmailEnabled, notifyOfferPreference).
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  }) async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    // Optimistic update
    final optimisticProfile = current.profile.copyWith(
      notifyPushEnabled: notifyPushEnabled ?? current.profile.notifyPushEnabled,
      notifyEmailEnabled: notifyEmailEnabled ?? current.profile.notifyEmailEnabled,
      notifyOfferPreference: notifyOfferPreference ?? current.profile.notifyOfferPreference,
    );
    state = AsyncValue.data(
      current.copyWith(profile: optimisticProfile, isSaving: true, lastError: null),
    );

    // Call backend
    final result = await _repository.updateNotificationSettings(
      notifyPushEnabled: notifyPushEnabled,
      notifyEmailEnabled: notifyEmailEnabled,
      notifyOfferPreference: notifyOfferPreference,
    );

    return result.when(
      success: (updatedProfile) {
        AppLogger.debug('✅ Notification settings updated successfully');
        state = AsyncValue.data(ProfileState(profile: updatedProfile));
        return null;
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to update notification settings: ${failure.message}');
        // Rollback to original state
        state = AsyncValue.data(current.copyWith(lastError: failure));
        return failure;
      },
    );
  }

  /// Request account deletion (stubbed - RPC not yet implemented).
  ///
  /// Returns null on success, or Failure on error.
  Future<Failure?> requestAccountDeletion() async {
    final current = state.asData?.value;
    if (current == null) return const Failure.unknown(message: 'State not ready');

    state = AsyncValue.data(current.copyWith(isSaving: true, lastError: null));

    final result = await _repository.requestAccountDeletion();

    return result.when(
      success: (_) {
        AppLogger.info('✅ Account deletion requested successfully');
        state = AsyncValue.data(current.copyWith(isSaving: false));
        return null;
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to request account deletion: ${failure.message}');
        state = AsyncValue.data(current.copyWith(isSaving: false, lastError: failure));
        return failure;
      },
    );
  }

  /// Initialize profile from auth bootstrap data.
  Future<ProfileState> _initializeFromBootstrap() async {
    try {
      final bootstrapAsync = ref.read(authBootstrapControllerProvider);

      if (bootstrapAsync.hasValue && bootstrapAsync.value != null) {
        final bootstrap = bootstrapAsync.value!;
        final profile = UserProfile.fromBootstrapData(
          userId: bootstrap.userId,
          accountSummary: bootstrap.accountSummary,
          userSettings: bootstrap.userSettings,
        );
        AppLogger.debug('✅ Profile initialized from bootstrap data');
        return ProfileState(profile: profile);
      }

      // Bootstrap not available, fetch from backend
      return await _fetchProfile();
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize profile from bootstrap',
        error: e,
        stackTrace: stackTrace,
      );
      return await _fetchProfile();
    }
  }

  /// Fetch profile from backend.
  Future<ProfileState> _fetchProfile() async {
    final result = await _repository.fetchProfile();

    return result.when(
      success: (profile) {
        AppLogger.debug('✅ Profile fetched from backend');
        return ProfileState(profile: profile);
      },
      failure: (failure) {
        AppLogger.warning('⚠️ Failed to fetch profile: ${failure.message}');
        // Return empty profile with error
        return ProfileState(
          profile: UserProfile(userId: ''),
          lastError: failure,
        );
      },
    );
  }

  /// Handle auth state changes.
  Future<void> _handleAuthStateChange(AsyncValue<dynamic> next) async {
    if (next.isLoading) return;
    if (!next.hasValue) return;

    final authState = next.value;
    if (authState == null) return;

    // If user is not authenticated, reset profile state
    if (!authState.isAuthenticated) {
      state = AsyncValue.data(ProfileState(profile: UserProfile(userId: '')));
      return;
    }

    // If user changed, reinitialize profile
    final currentProfile = state.asData?.value.profile;
    final newUserId = authState.user?.id;

    if (newUserId != null && currentProfile?.userId != newUserId) {
      AppLogger.debug('🔄 User changed, reinitializing profile...');
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async => await _initializeFromBootstrap());
    }
  }
}
