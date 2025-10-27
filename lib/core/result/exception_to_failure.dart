import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/errors/exceptions.dart';

/// Converts various exceptions to appropriate Failure types
///
/// This utility helps maintain consistent error handling across the app
/// by converting exceptions thrown in the data layer to domain failures.
class ExceptionToFailure {
  /// Converts any exception to an appropriate Failure
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await api.call();
  /// } catch (e) {
  ///   return Result.failure(ExceptionToFailure.convert(e));
  /// }
  /// ```
  static Failure convert(Object exception, [StackTrace? stackTrace]) {
    if (exception is Failure) {
      return exception;
    }

    if (exception is NetworkException) {
      return Failure.network(message: exception.message);
    }

    if (exception is ServerException) {
      return Failure.server(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }

    if (exception is AuthException) {
      return Failure.auth(
        message: exception.message,
        code: exception.code,
      );
    }

    if (exception is ValidationException) {
      return Failure.validation(
        message: exception.message,
        field: exception.field,
      );
    }

    if (exception is StorageException) {
      return Failure.storage(message: exception.message);
    }

    if (exception is PermissionException) {
      return Failure.permission(message: exception.message);
    }

    if (exception is CacheException) {
      return Failure.cache(message: exception.message);
    }

    if (exception is TimeoutException) {
      return Failure.timeout(message: exception.message);
    }

    if (exception is UnauthorizedException) {
      return Failure.unauthorized(message: exception.message);
    }

    if (exception is ForbiddenException) {
      return Failure.forbidden(message: exception.message);
    }

    if (exception is NotFoundException) {
      return Failure.notFound(message: exception.message);
    }

    if (exception is ConflictException) {
      return Failure.conflict(message: exception.message);
    }

    if (exception is TooManyRequestsException) {
      return Failure.tooManyRequests(message: exception.message);
    }

    if (exception is InternalServerErrorException) {
      return Failure.internalServerError(message: exception.message);
    }

    if (exception is ServiceUnavailableException) {
      return Failure.serviceUnavailable(message: exception.message);
    }

    if (exception is DeviceException) {
      return Failure.device(message: exception.message);
    }

    if (exception is PlatformException) {
      return Failure.platform(
        message: exception.message,
        platformCode: exception.code,
      );
    }

    if (exception is FileSystemException) {
      return Failure.fileSystem(message: exception.message);
    }

    if (exception is EncryptionException) {
      return Failure.encryption(message: exception.message);
    }

    if (exception is BiometricException) {
      return Failure.biometric(message: exception.message);
    }

    if (exception is LocationException) {
      return Failure.location(message: exception.message);
    }

    if (exception is CameraException) {
      return Failure.camera(message: exception.message);
    }

    if (exception is GalleryException) {
      return Failure.gallery(message: exception.message);
    }

    if (exception is NotificationException) {
      return Failure.notification(message: exception.message);
    }

    if (exception is ShareException) {
      return Failure.share(message: exception.message);
    }

    if (exception is UrlLauncherException) {
      return Failure.urlLauncher(message: exception.message);
    }

    if (exception is ConnectivityException) {
      return Failure.connectivity(message: exception.message);
    }

    if (exception is ParseException) {
      return Failure.parse(message: exception.message);
    }

    if (exception is DatabaseException) {
      return Failure.database(message: exception.message);
    }

    if (exception is MigrationException) {
      return Failure.migration(message: exception.message);
    }

    if (exception is SyncException) {
      return Failure.sync(message: exception.message);
    }

    if (exception is FeatureNotAvailableException) {
      return Failure.featureNotAvailable(message: exception.message);
    }

    if (exception is VersionMismatchException) {
      return Failure.versionMismatch(message: exception.message);
    }

    if (exception is MaintenanceModeException) {
      return Failure.maintenanceMode(message: exception.message);
    }

    if (exception is RateLimitException) {
      return Failure.rateLimit(
        message: exception.message,
        retryAfter: exception.retryAfter,
      );
    }

    if (exception is SubscriptionException) {
      return Failure.subscription(message: exception.message);
    }

    if (exception is PaymentException) {
      return Failure.payment(message: exception.message);
    }

    if (exception is ContentNotAvailableException) {
      return Failure.contentNotAvailable(message: exception.message);
    }

    if (exception is QuotaExceededException) {
      return Failure.quotaExceeded(message: exception.message);
    }

    if (exception is ConfigurationException) {
      return Failure.configuration(message: exception.message);
    }

    if (exception is DependencyException) {
      return Failure.dependency(message: exception.message);
    }

    // Unknown exception
    return Failure.unknown(
      message: 'An unexpected error occurred',
      originalError: exception.toString(),
      stackTrace: stackTrace?.toString(),
    );
  }
}
