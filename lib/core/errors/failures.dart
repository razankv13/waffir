import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class using Freezed for immutability and equality
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    required String message,
    String? code,
  }) = NetworkFailure;

  const factory Failure.server({
    required String message,
    int? statusCode,
    String? code,
  }) = ServerFailure;

  const factory Failure.auth({
    required String message,
    String? code,
  }) = AuthFailure;

  const factory Failure.validation({
    required String message,
    String? field,
    String? code,
  }) = ValidationFailure;

  const factory Failure.storage({
    required String message,
    String? code,
  }) = StorageFailure;

  const factory Failure.permission({
    required String message,
    String? code,
  }) = PermissionFailure;

  const factory Failure.cache({
    required String message,
    String? code,
  }) = CacheFailure;

  const factory Failure.timeout({
    required String message,
    String? code,
  }) = TimeoutFailure;

  const factory Failure.unauthorized({
    required String message,
    String? code,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({
    required String message,
    String? code,
  }) = ForbiddenFailure;

  const factory Failure.notFound({
    required String message,
    String? code,
  }) = NotFoundFailure;

  const factory Failure.conflict({
    required String message,
    String? code,
  }) = ConflictFailure;

  const factory Failure.tooManyRequests({
    required String message,
    Duration? retryAfter,
    String? code,
  }) = TooManyRequestsFailure;

  const factory Failure.internalServerError({
    required String message,
    String? code,
  }) = InternalServerErrorFailure;

  const factory Failure.serviceUnavailable({
    required String message,
    String? code,
  }) = ServiceUnavailableFailure;

  const factory Failure.device({
    required String message,
    String? code,
  }) = DeviceFailure;

  const factory Failure.platform({
    required String message,
    String? platformCode,
    String? code,
  }) = PlatformFailure;

  const factory Failure.fileSystem({
    required String message,
    String? code,
  }) = FileSystemFailure;

  const factory Failure.encryption({
    required String message,
    String? code,
  }) = EncryptionFailure;

  const factory Failure.biometric({
    required String message,
    String? code,
  }) = BiometricFailure;

  const factory Failure.location({
    required String message,
    String? code,
  }) = LocationFailure;

  const factory Failure.camera({
    required String message,
    String? code,
  }) = CameraFailure;

  const factory Failure.gallery({
    required String message,
    String? code,
  }) = GalleryFailure;

  const factory Failure.notification({
    required String message,
    String? code,
  }) = NotificationFailure;

  const factory Failure.share({
    required String message,
    String? code,
  }) = ShareFailure;

  const factory Failure.urlLauncher({
    required String message,
    String? code,
  }) = UrlLauncherFailure;

  const factory Failure.connectivity({
    required String message,
    String? code,
  }) = ConnectivityFailure;

  const factory Failure.parse({
    required String message,
    String? code,
  }) = ParseFailure;

  const factory Failure.database({
    required String message,
    String? code,
  }) = DatabaseFailure;

  const factory Failure.migration({
    required String message,
    String? code,
  }) = MigrationFailure;

  const factory Failure.sync({
    required String message,
    String? code,
  }) = SyncFailure;

  const factory Failure.featureNotAvailable({
    required String message,
    String? code,
  }) = FeatureNotAvailableFailure;

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

  const factory Failure.configuration({
    required String message,
    String? configKey,
    String? code,
  }) = ConfigurationFailure;

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
      network: (message, code) => 'Please check your internet connection and try again.',
      server: (message, statusCode, code) => 'Something went wrong on our end. Please try again later.',
      auth: (message, code) => 'Authentication failed. Please sign in again.',
      validation: (message, field, code) => message,
      storage: (message, code) => 'Unable to access local storage. Please try again.',
      permission: (message, code) => 'Permission required to continue.',
      cache: (message, code) => 'Cache error occurred. Please try again.',
      timeout: (message, code) => 'Request timed out. Please try again.',
      unauthorized: (message, code) => 'You are not authorized to perform this action.',
      forbidden: (message, code) => 'Access denied.',
      notFound: (message, code) => 'The requested content could not be found.',
      conflict: (message, code) => 'A conflict occurred. Please try again.',
      tooManyRequests: (message, retryAfter, code) => 'Too many requests. Please wait a moment and try again.',
      internalServerError: (message, code) => 'Internal server error. Please try again later.',
      serviceUnavailable: (message, code) => 'Service is temporarily unavailable. Please try again later.',
      device: (message, code) => 'Device error occurred.',
      platform: (message, platformCode, code) => 'Platform-specific error occurred.',
      fileSystem: (message, code) => 'File system error occurred.',
      encryption: (message, code) => 'Encryption error occurred.',
      biometric: (message, code) => 'Biometric authentication failed.',
      location: (message, code) => 'Location access failed.',
      camera: (message, code) => 'Camera access failed.',
      gallery: (message, code) => 'Gallery access failed.',
      notification: (message, code) => 'Notification error occurred.',
      share: (message, code) => 'Sharing failed.',
      urlLauncher: (message, code) => 'Unable to open link.',
      connectivity: (message, code) => 'Connectivity issue occurred.',
      parse: (message, code) => 'Data parsing failed.',
      database: (message, code) => 'Database error occurred.',
      migration: (message, code) => 'Database migration failed.',
      sync: (message, code) => 'Sync failed.',
      featureNotAvailable: (message, code) => 'This feature is not available.',
      versionMismatch: (message, currentVersion, requiredVersion, code) => 'App update required.',
      maintenanceMode: (message, estimatedEndTime, code) => 'App is under maintenance. Please try again later.',
      rateLimit: (message, retryAfter, limit, code) => 'Rate limit exceeded. Please wait and try again.',
      subscription: (message, subscriptionType, code) => 'Subscription issue occurred.',
      payment: (message, paymentMethod, transactionId, code) => 'Payment failed.',
      contentNotAvailable: (message, contentId, reason, code) => 'Content is not available.',
      quotaExceeded: (message, currentUsage, limit, quotaType, code) => 'Quota exceeded.',
      configuration: (message, configKey, code) => 'Configuration error occurred.',
      dependency: (message, dependencyName, code) => 'Dependency error occurred.',
      unknown: (message, originalError, stackTrace, code) => 'An unexpected error occurred.',
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