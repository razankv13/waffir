/// Base exception class for the application
abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {this.code});

  final String? code;
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {this.field});

  final String? field;
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException(super.message);
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Format exceptions
class FormatException extends AppException {
  const FormatException(super.message);
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

/// Unauthorized exceptions
class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

/// Forbidden exceptions
class ForbiddenException extends AppException {
  const ForbiddenException(super.message);
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

/// Conflict exceptions
class ConflictException extends AppException {
  const ConflictException(super.message);
}

/// Too many requests exceptions
class TooManyRequestsException extends AppException {
  const TooManyRequestsException(super.message);
}

/// Internal server error exceptions
class InternalServerErrorException extends AppException {
  const InternalServerErrorException(super.message);
}

/// Service unavailable exceptions
class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException(super.message);
}

/// Device-specific exceptions
class DeviceException extends AppException {
  const DeviceException(super.message);
}

/// Platform-specific exceptions
class PlatformException extends AppException {
  const PlatformException(super.message, {this.code});

  final String? code;
}

/// File system exceptions
class FileSystemException extends AppException {
  const FileSystemException(super.message);
}

/// Encryption exceptions
class EncryptionException extends AppException {
  const EncryptionException(super.message);
}

/// Biometric exceptions
class BiometricException extends AppException {
  const BiometricException(super.message);
}

/// Location exceptions
class LocationException extends AppException {
  const LocationException(super.message);
}

/// Camera exceptions
class CameraException extends AppException {
  const CameraException(super.message);
}

/// Gallery exceptions
class GalleryException extends AppException {
  const GalleryException(super.message);
}

/// Notification exceptions
class NotificationException extends AppException {
  const NotificationException(super.message);
}

/// Share exceptions
class ShareException extends AppException {
  const ShareException(super.message);
}

/// URL launcher exceptions
class UrlLauncherException extends AppException {
  const UrlLauncherException(super.message);
}

/// Connectivity exceptions
class ConnectivityException extends AppException {
  const ConnectivityException(super.message);
}

/// Parse exceptions
class ParseException extends AppException {
  const ParseException(super.message);
}

/// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

/// Migration exceptions
class MigrationException extends AppException {
  const MigrationException(super.message);
}

/// Sync exceptions
class SyncException extends AppException {
  const SyncException(super.message);
}

/// Feature not available exceptions
class FeatureNotAvailableException extends AppException {
  const FeatureNotAvailableException(super.message);
}

/// Version mismatch exceptions
class VersionMismatchException extends AppException {
  const VersionMismatchException(super.message);
}

/// Maintenance mode exceptions
class MaintenanceModeException extends AppException {
  const MaintenanceModeException(super.message);
}

/// Rate limit exceptions
class RateLimitException extends AppException {
  const RateLimitException(super.message, {this.retryAfter});

  final Duration? retryAfter;
}

/// Subscription exceptions
class SubscriptionException extends AppException {
  const SubscriptionException(super.message);
}

/// Payment exceptions
class PaymentException extends AppException {
  const PaymentException(super.message);
}

/// Content not available exceptions
class ContentNotAvailableException extends AppException {
  const ContentNotAvailableException(super.message);
}

/// Quota exceeded exceptions
class QuotaExceededException extends AppException {
  const QuotaExceededException(super.message);
}

/// Configuration exceptions
class ConfigurationException extends AppException {
  const ConfigurationException(super.message);
}

/// Dependency exceptions
class DependencyException extends AppException {
  const DependencyException(super.message);
}

/// Unknown exceptions
class UnknownException extends AppException {
  const UnknownException(super.message);
}