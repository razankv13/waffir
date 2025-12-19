import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:waffir/features/profile/domain/entities/user_profile.dart';
import 'package:waffir/features/profile/domain/repositories/profile_repository.dart';

/// Concrete implementation of profile repository.
///
/// Wraps the remote data source with Result<T> error handling and
/// converts models to domain entities.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  AsyncResult<UserProfile> fetchProfile() async {
    try {
      final model = await _remoteDataSource.fetchProfile();
      return Result.success(model.toDomain());
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: fetchProfile failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in fetchProfile', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<UserProfile> updateUserProfile({
    String? fullName,
    String? gender,
    String? avatarUrl,
    bool? acceptTerms,
  }) async {
    try {
      final model = await _remoteDataSource.updateUserProfile(
        fullName: fullName,
        gender: gender,
        avatarUrl: avatarUrl,
        acceptTerms: acceptTerms,
      );
      return Result.success(model.toDomain());
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: updateUserProfile failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in updateUserProfile', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<UserProfile> updateUserSettings({
    String? language,
    String? cityId,
    bool? notifyAllDeals,
    bool? notifyOnlyPopular,
    bool? marketingConsent,
  }) async {
    try {
      final model = await _remoteDataSource.updateUserSettings(
        language: language,
        cityId: cityId,
        notifyAllDeals: notifyAllDeals,
        notifyOnlyPopular: notifyOnlyPopular,
        marketingConsent: marketingConsent,
      );
      return Result.success(model.toDomain());
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: updateUserSettings failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in updateUserSettings', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<UserProfile> updateNotificationSettings({
    bool? notifyPushEnabled,
    bool? notifyEmailEnabled,
    String? notifyOfferPreference,
  }) async {
    try {
      final model = await _remoteDataSource.updateNotificationSettings(
        notifyPushEnabled: notifyPushEnabled,
        notifyEmailEnabled: notifyEmailEnabled,
        notifyOfferPreference: notifyOfferPreference,
      );
      return Result.success(model.toDomain());
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: updateNotificationSettings failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in updateNotificationSettings', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  AsyncResult<void> requestAccountDeletion() async {
    try {
      await _remoteDataSource.requestAccountDeletion();
      return const Result.success(null);
    } on Failure catch (failure) {
      AppLogger.warning('⚠️ Repository: requestAccountDeletion failed - ${failure.message}');
      return Result.failure(failure);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Repository: Unexpected error in requestAccountDeletion', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
