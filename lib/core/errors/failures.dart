import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waffir/core/constants/locale_keys.dart';

part 'failures.freezed.dart';

/// Base failure class using Freezed for immutability and equality
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message, String? code}) = NetworkFailure;

  const factory Failure.server({required String message, int? statusCode, String? code}) =
      ServerFailure;

  const factory Failure.auth({required String message, String? code}) = AuthFailure;

  const factory Failure.validation({required String message, String? field, String? code}) =
      ValidationFailure;

  const factory Failure.storage({required String message, String? code}) = StorageFailure;

  const factory Failure.permission({required String message, String? code}) = PermissionFailure;

  const factory Failure.cache({required String message, String? code}) = CacheFailure;

  const factory Failure.timeout({required String message, String? code}) = TimeoutFailure;

  const factory Failure.unauthorized({required String message, String? code}) = UnauthorizedFailure;

  const factory Failure.forbidden({required String message, String? code}) = ForbiddenFailure;

  const factory Failure.notFound({required String message, String? code}) = NotFoundFailure;

  const factory Failure.conflict({required String message, String? code}) = ConflictFailure;

  const factory Failure.tooManyRequests({
    required String message,
    Duration? retryAfter,
    String? code,
  }) = TooManyRequestsFailure;

  const factory Failure.internalServerError({required String message, String? code}) =
      InternalServerErrorFailure;

  const factory Failure.serviceUnavailable({required String message, String? code}) =
      ServiceUnavailableFailure;

  const factory Failure.device({required String message, String? code}) = DeviceFailure;

  const factory Failure.platform({required String message, String? platformCode, String? code}) =
      PlatformFailure;

  const factory Failure.fileSystem({required String message, String? code}) = FileSystemFailure;

  const factory Failure.encryption({required String message, String? code}) = EncryptionFailure;

  const factory Failure.biometric({required String message, String? code}) = BiometricFailure;

  const factory Failure.location({required String message, String? code}) = LocationFailure;

  const factory Failure.camera({required String message, String? code}) = CameraFailure;

  const factory Failure.gallery({required String message, String? code}) = GalleryFailure;

  const factory Failure.notification({required String message, String? code}) = NotificationFailure;

  const factory Failure.share({required String message, String? code}) = ShareFailure;

  const factory Failure.urlLauncher({required String message, String? code}) = UrlLauncherFailure;

  const factory Failure.connectivity({required String message, String? code}) = ConnectivityFailure;

  const factory Failure.parse({required String message, String? code}) = ParseFailure;

  const factory Failure.database({required String message, String? code}) = DatabaseFailure;

  const factory Failure.migration({required String message, String? code}) = MigrationFailure;

  const factory Failure.sync({required String message, String? code}) = SyncFailure;

  const factory Failure.featureNotAvailable({required String message, String? code}) =
      FeatureNotAvailableFailure;

  const factory Failure.versionMismatch({
    required String message,
    String? currentVersion,
    String? requiredVersion,
    String? code,
  }) = VersionMismatchFailure;

  const factory Failure.maintenanceMode({
    required String message,
    DateTime? estimatedEndTime,
    String? code,
  }) = MaintenanceModeFailure;

  const factory Failure.rateLimit({
    required String message,
    Duration? retryAfter,
    int? limit,
    String? code,
  }) = RateLimitFailure;

  const factory Failure.subscription({
    required String message,
    String? subscriptionType,
    String? code,
  }) = SubscriptionFailure;

  const factory Failure.payment({
    required String message,
    String? paymentMethod,
    String? transactionId,
    String? code,
  }) = PaymentFailure;

  const factory Failure.contentNotAvailable({
    required String message,
    String? contentId,
    String? reason,
    String? code,
  }) = ContentNotAvailableFailure;

  const factory Failure.quotaExceeded({
    required String message,
    int? currentUsage,
    int? limit,
    String? quotaType,
    String? code,
  }) = QuotaExceededFailure;

  const factory Failure.configuration({required String message, String? configKey, String? code}) =
      ConfigurationFailure;

  const factory Failure.dependency({
    required String message,
    String? dependencyName,
    String? code,
  }) = DependencyFailure;

  const factory Failure.unknown({
    required String message,
    String? originalError,
    String? stackTrace,
    String? code,
  }) = UnknownFailure;
}

/// Extension to provide user-friendly messages
extension FailureExtension on Failure {
  /// Get a user-friendly message for display
  String get userMessage {
    return when(
      network: (message, code) => LocaleKeys.errors.networkError.tr(),
      server: (message, statusCode, code) => LocaleKeys.errors.serverError.tr(),
      auth: (message, code) => LocaleKeys.errors.authError.tr(),
      validation: (message, field, code) => message,
      storage: (message, code) => LocaleKeys.errors.storageError.tr(),
      permission: (message, code) => LocaleKeys.errors.permissionError.tr(),
      cache: (message, code) => LocaleKeys.errors.cacheError.tr(),
      timeout: (message, code) => LocaleKeys.errors.timeoutError.tr(),
      unauthorized: (message, code) => LocaleKeys.errors.unauthorizedError.tr(),
      forbidden: (message, code) => LocaleKeys.errors.forbiddenError.tr(),
      notFound: (message, code) => LocaleKeys.errors.notFoundError.tr(),
      conflict: (message, code) => LocaleKeys.errors.conflictError.tr(),
      tooManyRequests: (message, retryAfter, code) => LocaleKeys.errors.tooManyRequestsError.tr(),
      internalServerError: (message, code) => LocaleKeys.errors.internalServerError.tr(),
      serviceUnavailable: (message, code) => LocaleKeys.errors.serviceUnavailableError.tr(),
      device: (message, code) => LocaleKeys.errors.deviceError.tr(),
      platform: (message, platformCode, code) => LocaleKeys.errors.platformError.tr(),
      fileSystem: (message, code) => LocaleKeys.errors.fileSystemError.tr(),
      encryption: (message, code) => LocaleKeys.errors.encryptionError.tr(),
      biometric: (message, code) => LocaleKeys.errors.biometricError.tr(),
      location: (message, code) => LocaleKeys.errors.locationError.tr(),
      camera: (message, code) => LocaleKeys.errors.cameraError.tr(),
      gallery: (message, code) => LocaleKeys.errors.galleryError.tr(),
      notification: (message, code) => LocaleKeys.errors.notificationError.tr(),
      share: (message, code) => LocaleKeys.errors.shareError.tr(),
      urlLauncher: (message, code) => LocaleKeys.errors.urlLauncherError.tr(),
      connectivity: (message, code) => LocaleKeys.errors.connectivityError.tr(),
      parse: (message, code) => LocaleKeys.errors.parseError.tr(),
      database: (message, code) => LocaleKeys.errors.databaseError.tr(),
      migration: (message, code) => LocaleKeys.errors.migrationError.tr(),
      sync: (message, code) => LocaleKeys.errors.syncError.tr(),
      featureNotAvailable: (message, code) => LocaleKeys.errors.featureNotAvailableError.tr(),
      versionMismatch: (message, currentVersion, requiredVersion, code) =>
          LocaleKeys.errors.versionMismatchError.tr(),
      maintenanceMode: (message, estimatedEndTime, code) =>
          LocaleKeys.errors.maintenanceModeError.tr(),
      rateLimit: (message, retryAfter, limit, code) => LocaleKeys.errors.rateLimitError.tr(),
      subscription: (message, subscriptionType, code) => LocaleKeys.errors.subscriptionError.tr(),
      payment: (message, paymentMethod, transactionId, code) => LocaleKeys.errors.paymentError.tr(),
      contentNotAvailable: (message, contentId, reason, code) =>
          LocaleKeys.errors.contentNotAvailableError.tr(),
      quotaExceeded: (message, currentUsage, limit, quotaType, code) =>
          LocaleKeys.errors.quotaExceededError.tr(),
      configuration: (message, configKey, code) => LocaleKeys.errors.configurationError.tr(),
      dependency: (message, dependencyName, code) => LocaleKeys.errors.dependencyError.tr(),
      unknown: (message, originalError, stackTrace, code) => LocaleKeys.errors.unknownError.tr(),
    );
  }

  /// Check if this is a critical failure that should be reported
  bool get isCritical {
    return when(
      network: (_, __) => false,
      server: (_, __, ___) => true,
      auth: (_, __) => false,
      validation: (_, __, ___) => false,
      storage: (_, __) => true,
      permission: (_, __) => false,
      cache: (_, __) => false,
      timeout: (_, __) => false,
      unauthorized: (_, __) => false,
      forbidden: (_, __) => false,
      notFound: (_, __) => false,
      conflict: (_, __) => false,
      tooManyRequests: (_, __, ___) => false,
      internalServerError: (_, __) => true,
      serviceUnavailable: (_, __) => true,
      device: (_, __) => true,
      platform: (_, __, ___) => true,
      fileSystem: (_, __) => true,
      encryption: (_, __) => true,
      biometric: (_, __) => false,
      location: (_, __) => false,
      camera: (_, __) => false,
      gallery: (_, __) => false,
      notification: (_, __) => false,
      share: (_, __) => false,
      urlLauncher: (_, __) => false,
      connectivity: (_, __) => false,
      parse: (_, __) => true,
      database: (_, __) => true,
      migration: (_, __) => true,
      sync: (_, __) => false,
      featureNotAvailable: (_, __) => false,
      versionMismatch: (_, __, ___, ____) => false,
      maintenanceMode: (_, __, ___) => false,
      rateLimit: (_, __, ___, ____) => false,
      subscription: (_, __, ___) => false,
      payment: (_, __, ___, ____) => false,
      contentNotAvailable: (_, __, ___, ____) => false,
      quotaExceeded: (_, __, ___, ____, _____) => false,
      configuration: (_, __, ___) => true,
      dependency: (_, __, ___) => true,
      unknown: (_, __, ___, ____) => true,
    );
  }

  /// Check if this failure allows retry
  bool get canRetry {
    return when(
      network: (_, __) => true,
      server: (_, __, ___) => true,
      auth: (_, __) => false,
      validation: (_, __, ___) => false,
      storage: (_, __) => true,
      permission: (_, __) => false,
      cache: (_, __) => true,
      timeout: (_, __) => true,
      unauthorized: (_, __) => false,
      forbidden: (_, __) => false,
      notFound: (_, __) => false,
      conflict: (_, __) => true,
      tooManyRequests: (_, __, ___) => true,
      internalServerError: (_, __) => true,
      serviceUnavailable: (_, __) => true,
      device: (_, __) => false,
      platform: (_, __, ___) => false,
      fileSystem: (_, __) => true,
      encryption: (_, __) => false,
      biometric: (_, __) => true,
      location: (_, __) => true,
      camera: (_, __) => true,
      gallery: (_, __) => true,
      notification: (_, __) => true,
      share: (_, __) => true,
      urlLauncher: (_, __) => true,
      connectivity: (_, __) => true,
      parse: (_, __) => false,
      database: (_, __) => true,
      migration: (_, __) => false,
      sync: (_, __) => true,
      featureNotAvailable: (_, __) => false,
      versionMismatch: (_, __, ___, ____) => false,
      maintenanceMode: (_, __, ___) => true,
      rateLimit: (_, __, ___, ____) => true,
      subscription: (_, __, ___) => false,
      payment: (_, __, ___, ____) => true,
      contentNotAvailable: (_, __, ___, ____) => false,
      quotaExceeded: (_, __, ___, ____, _____) => false,
      configuration: (_, __, ___) => false,
      dependency: (_, __, ___) => false,
      unknown: (_, __, ___, ____) => true,
    );
  }
}
