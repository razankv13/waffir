// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message; String? get code;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( ServerFailure value)?  server,TResult Function( AuthFailure value)?  auth,TResult Function( ValidationFailure value)?  validation,TResult Function( StorageFailure value)?  storage,TResult Function( PermissionFailure value)?  permission,TResult Function( CacheFailure value)?  cache,TResult Function( TimeoutFailure value)?  timeout,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( ForbiddenFailure value)?  forbidden,TResult Function( NotFoundFailure value)?  notFound,TResult Function( ConflictFailure value)?  conflict,TResult Function( TooManyRequestsFailure value)?  tooManyRequests,TResult Function( InternalServerErrorFailure value)?  internalServerError,TResult Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult Function( DeviceFailure value)?  device,TResult Function( PlatformFailure value)?  platform,TResult Function( FileSystemFailure value)?  fileSystem,TResult Function( EncryptionFailure value)?  encryption,TResult Function( BiometricFailure value)?  biometric,TResult Function( LocationFailure value)?  location,TResult Function( CameraFailure value)?  camera,TResult Function( GalleryFailure value)?  gallery,TResult Function( NotificationFailure value)?  notification,TResult Function( ShareFailure value)?  share,TResult Function( UrlLauncherFailure value)?  urlLauncher,TResult Function( ConnectivityFailure value)?  connectivity,TResult Function( ParseFailure value)?  parse,TResult Function( DatabaseFailure value)?  database,TResult Function( MigrationFailure value)?  migration,TResult Function( SyncFailure value)?  sync,TResult Function( FeatureNotAvailableFailure value)?  featureNotAvailable,TResult Function( VersionMismatchFailure value)?  versionMismatch,TResult Function( MaintenanceModeFailure value)?  maintenanceMode,TResult Function( RateLimitFailure value)?  rateLimit,TResult Function( SubscriptionFailure value)?  subscription,TResult Function( PaymentFailure value)?  payment,TResult Function( ContentNotAvailableFailure value)?  contentNotAvailable,TResult Function( QuotaExceededFailure value)?  quotaExceeded,TResult Function( ConfigurationFailure value)?  configuration,TResult Function( DependencyFailure value)?  dependency,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case AuthFailure() when auth != null:
return auth(_that);case ValidationFailure() when validation != null:
return validation(_that);case StorageFailure() when storage != null:
return storage(_that);case PermissionFailure() when permission != null:
return permission(_that);case CacheFailure() when cache != null:
return cache(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case InternalServerErrorFailure() when internalServerError != null:
return internalServerError(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case DeviceFailure() when device != null:
return device(_that);case PlatformFailure() when platform != null:
return platform(_that);case FileSystemFailure() when fileSystem != null:
return fileSystem(_that);case EncryptionFailure() when encryption != null:
return encryption(_that);case BiometricFailure() when biometric != null:
return biometric(_that);case LocationFailure() when location != null:
return location(_that);case CameraFailure() when camera != null:
return camera(_that);case GalleryFailure() when gallery != null:
return gallery(_that);case NotificationFailure() when notification != null:
return notification(_that);case ShareFailure() when share != null:
return share(_that);case UrlLauncherFailure() when urlLauncher != null:
return urlLauncher(_that);case ConnectivityFailure() when connectivity != null:
return connectivity(_that);case ParseFailure() when parse != null:
return parse(_that);case DatabaseFailure() when database != null:
return database(_that);case MigrationFailure() when migration != null:
return migration(_that);case SyncFailure() when sync != null:
return sync(_that);case FeatureNotAvailableFailure() when featureNotAvailable != null:
return featureNotAvailable(_that);case VersionMismatchFailure() when versionMismatch != null:
return versionMismatch(_that);case MaintenanceModeFailure() when maintenanceMode != null:
return maintenanceMode(_that);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that);case SubscriptionFailure() when subscription != null:
return subscription(_that);case PaymentFailure() when payment != null:
return payment(_that);case ContentNotAvailableFailure() when contentNotAvailable != null:
return contentNotAvailable(_that);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that);case ConfigurationFailure() when configuration != null:
return configuration(_that);case DependencyFailure() when dependency != null:
return dependency(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( ServerFailure value)  server,required TResult Function( AuthFailure value)  auth,required TResult Function( ValidationFailure value)  validation,required TResult Function( StorageFailure value)  storage,required TResult Function( PermissionFailure value)  permission,required TResult Function( CacheFailure value)  cache,required TResult Function( TimeoutFailure value)  timeout,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( ForbiddenFailure value)  forbidden,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( ConflictFailure value)  conflict,required TResult Function( TooManyRequestsFailure value)  tooManyRequests,required TResult Function( InternalServerErrorFailure value)  internalServerError,required TResult Function( ServiceUnavailableFailure value)  serviceUnavailable,required TResult Function( DeviceFailure value)  device,required TResult Function( PlatformFailure value)  platform,required TResult Function( FileSystemFailure value)  fileSystem,required TResult Function( EncryptionFailure value)  encryption,required TResult Function( BiometricFailure value)  biometric,required TResult Function( LocationFailure value)  location,required TResult Function( CameraFailure value)  camera,required TResult Function( GalleryFailure value)  gallery,required TResult Function( NotificationFailure value)  notification,required TResult Function( ShareFailure value)  share,required TResult Function( UrlLauncherFailure value)  urlLauncher,required TResult Function( ConnectivityFailure value)  connectivity,required TResult Function( ParseFailure value)  parse,required TResult Function( DatabaseFailure value)  database,required TResult Function( MigrationFailure value)  migration,required TResult Function( SyncFailure value)  sync,required TResult Function( FeatureNotAvailableFailure value)  featureNotAvailable,required TResult Function( VersionMismatchFailure value)  versionMismatch,required TResult Function( MaintenanceModeFailure value)  maintenanceMode,required TResult Function( RateLimitFailure value)  rateLimit,required TResult Function( SubscriptionFailure value)  subscription,required TResult Function( PaymentFailure value)  payment,required TResult Function( ContentNotAvailableFailure value)  contentNotAvailable,required TResult Function( QuotaExceededFailure value)  quotaExceeded,required TResult Function( ConfigurationFailure value)  configuration,required TResult Function( DependencyFailure value)  dependency,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case ServerFailure():
return server(_that);case AuthFailure():
return auth(_that);case ValidationFailure():
return validation(_that);case StorageFailure():
return storage(_that);case PermissionFailure():
return permission(_that);case CacheFailure():
return cache(_that);case TimeoutFailure():
return timeout(_that);case UnauthorizedFailure():
return unauthorized(_that);case ForbiddenFailure():
return forbidden(_that);case NotFoundFailure():
return notFound(_that);case ConflictFailure():
return conflict(_that);case TooManyRequestsFailure():
return tooManyRequests(_that);case InternalServerErrorFailure():
return internalServerError(_that);case ServiceUnavailableFailure():
return serviceUnavailable(_that);case DeviceFailure():
return device(_that);case PlatformFailure():
return platform(_that);case FileSystemFailure():
return fileSystem(_that);case EncryptionFailure():
return encryption(_that);case BiometricFailure():
return biometric(_that);case LocationFailure():
return location(_that);case CameraFailure():
return camera(_that);case GalleryFailure():
return gallery(_that);case NotificationFailure():
return notification(_that);case ShareFailure():
return share(_that);case UrlLauncherFailure():
return urlLauncher(_that);case ConnectivityFailure():
return connectivity(_that);case ParseFailure():
return parse(_that);case DatabaseFailure():
return database(_that);case MigrationFailure():
return migration(_that);case SyncFailure():
return sync(_that);case FeatureNotAvailableFailure():
return featureNotAvailable(_that);case VersionMismatchFailure():
return versionMismatch(_that);case MaintenanceModeFailure():
return maintenanceMode(_that);case RateLimitFailure():
return rateLimit(_that);case SubscriptionFailure():
return subscription(_that);case PaymentFailure():
return payment(_that);case ContentNotAvailableFailure():
return contentNotAvailable(_that);case QuotaExceededFailure():
return quotaExceeded(_that);case ConfigurationFailure():
return configuration(_that);case DependencyFailure():
return dependency(_that);case UnknownFailure():
return unknown(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( ServerFailure value)?  server,TResult? Function( AuthFailure value)?  auth,TResult? Function( ValidationFailure value)?  validation,TResult? Function( StorageFailure value)?  storage,TResult? Function( PermissionFailure value)?  permission,TResult? Function( CacheFailure value)?  cache,TResult? Function( TimeoutFailure value)?  timeout,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( ForbiddenFailure value)?  forbidden,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( ConflictFailure value)?  conflict,TResult? Function( TooManyRequestsFailure value)?  tooManyRequests,TResult? Function( InternalServerErrorFailure value)?  internalServerError,TResult? Function( ServiceUnavailableFailure value)?  serviceUnavailable,TResult? Function( DeviceFailure value)?  device,TResult? Function( PlatformFailure value)?  platform,TResult? Function( FileSystemFailure value)?  fileSystem,TResult? Function( EncryptionFailure value)?  encryption,TResult? Function( BiometricFailure value)?  biometric,TResult? Function( LocationFailure value)?  location,TResult? Function( CameraFailure value)?  camera,TResult? Function( GalleryFailure value)?  gallery,TResult? Function( NotificationFailure value)?  notification,TResult? Function( ShareFailure value)?  share,TResult? Function( UrlLauncherFailure value)?  urlLauncher,TResult? Function( ConnectivityFailure value)?  connectivity,TResult? Function( ParseFailure value)?  parse,TResult? Function( DatabaseFailure value)?  database,TResult? Function( MigrationFailure value)?  migration,TResult? Function( SyncFailure value)?  sync,TResult? Function( FeatureNotAvailableFailure value)?  featureNotAvailable,TResult? Function( VersionMismatchFailure value)?  versionMismatch,TResult? Function( MaintenanceModeFailure value)?  maintenanceMode,TResult? Function( RateLimitFailure value)?  rateLimit,TResult? Function( SubscriptionFailure value)?  subscription,TResult? Function( PaymentFailure value)?  payment,TResult? Function( ContentNotAvailableFailure value)?  contentNotAvailable,TResult? Function( QuotaExceededFailure value)?  quotaExceeded,TResult? Function( ConfigurationFailure value)?  configuration,TResult? Function( DependencyFailure value)?  dependency,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ServerFailure() when server != null:
return server(_that);case AuthFailure() when auth != null:
return auth(_that);case ValidationFailure() when validation != null:
return validation(_that);case StorageFailure() when storage != null:
return storage(_that);case PermissionFailure() when permission != null:
return permission(_that);case CacheFailure() when cache != null:
return cache(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ForbiddenFailure() when forbidden != null:
return forbidden(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConflictFailure() when conflict != null:
return conflict(_that);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that);case InternalServerErrorFailure() when internalServerError != null:
return internalServerError(_that);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that);case DeviceFailure() when device != null:
return device(_that);case PlatformFailure() when platform != null:
return platform(_that);case FileSystemFailure() when fileSystem != null:
return fileSystem(_that);case EncryptionFailure() when encryption != null:
return encryption(_that);case BiometricFailure() when biometric != null:
return biometric(_that);case LocationFailure() when location != null:
return location(_that);case CameraFailure() when camera != null:
return camera(_that);case GalleryFailure() when gallery != null:
return gallery(_that);case NotificationFailure() when notification != null:
return notification(_that);case ShareFailure() when share != null:
return share(_that);case UrlLauncherFailure() when urlLauncher != null:
return urlLauncher(_that);case ConnectivityFailure() when connectivity != null:
return connectivity(_that);case ParseFailure() when parse != null:
return parse(_that);case DatabaseFailure() when database != null:
return database(_that);case MigrationFailure() when migration != null:
return migration(_that);case SyncFailure() when sync != null:
return sync(_that);case FeatureNotAvailableFailure() when featureNotAvailable != null:
return featureNotAvailable(_that);case VersionMismatchFailure() when versionMismatch != null:
return versionMismatch(_that);case MaintenanceModeFailure() when maintenanceMode != null:
return maintenanceMode(_that);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that);case SubscriptionFailure() when subscription != null:
return subscription(_that);case PaymentFailure() when payment != null:
return payment(_that);case ContentNotAvailableFailure() when contentNotAvailable != null:
return contentNotAvailable(_that);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that);case ConfigurationFailure() when configuration != null:
return configuration(_that);case DependencyFailure() when dependency != null:
return dependency(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? code)?  network,TResult Function( String message,  int? statusCode,  String? code)?  server,TResult Function( String message,  String? code)?  auth,TResult Function( String message,  String? field,  String? code)?  validation,TResult Function( String message,  String? code)?  storage,TResult Function( String message,  String? code)?  permission,TResult Function( String message,  String? code)?  cache,TResult Function( String message,  String? code)?  timeout,TResult Function( String message,  String? code)?  unauthorized,TResult Function( String message,  String? code)?  forbidden,TResult Function( String message,  String? code)?  notFound,TResult Function( String message,  String? code)?  conflict,TResult Function( String message,  Duration? retryAfter,  String? code)?  tooManyRequests,TResult Function( String message,  String? code)?  internalServerError,TResult Function( String message,  String? code)?  serviceUnavailable,TResult Function( String message,  String? code)?  device,TResult Function( String message,  String? platformCode,  String? code)?  platform,TResult Function( String message,  String? code)?  fileSystem,TResult Function( String message,  String? code)?  encryption,TResult Function( String message,  String? code)?  biometric,TResult Function( String message,  String? code)?  location,TResult Function( String message,  String? code)?  camera,TResult Function( String message,  String? code)?  gallery,TResult Function( String message,  String? code)?  notification,TResult Function( String message,  String? code)?  share,TResult Function( String message,  String? code)?  urlLauncher,TResult Function( String message,  String? code)?  connectivity,TResult Function( String message,  String? code)?  parse,TResult Function( String message,  String? code)?  database,TResult Function( String message,  String? code)?  migration,TResult Function( String message,  String? code)?  sync,TResult Function( String message,  String? code)?  featureNotAvailable,TResult Function( String message,  String? currentVersion,  String? requiredVersion,  String? code)?  versionMismatch,TResult Function( String message,  DateTime? estimatedEndTime,  String? code)?  maintenanceMode,TResult Function( String message,  Duration? retryAfter,  int? limit,  String? code)?  rateLimit,TResult Function( String message,  String? subscriptionType,  String? code)?  subscription,TResult Function( String message,  String? paymentMethod,  String? transactionId,  String? code)?  payment,TResult Function( String message,  String? contentId,  String? reason,  String? code)?  contentNotAvailable,TResult Function( String message,  int? currentUsage,  int? limit,  String? quotaType,  String? code)?  quotaExceeded,TResult Function( String message,  String? configKey,  String? code)?  configuration,TResult Function( String message,  String? dependencyName,  String? code)?  dependency,TResult Function( String message,  String? originalError,  String? stackTrace,  String? code)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message,_that.code);case ServerFailure() when server != null:
return server(_that.message,_that.statusCode,_that.code);case AuthFailure() when auth != null:
return auth(_that.message,_that.code);case ValidationFailure() when validation != null:
return validation(_that.message,_that.field,_that.code);case StorageFailure() when storage != null:
return storage(_that.message,_that.code);case PermissionFailure() when permission != null:
return permission(_that.message,_that.code);case CacheFailure() when cache != null:
return cache(_that.message,_that.code);case TimeoutFailure() when timeout != null:
return timeout(_that.message,_that.code);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.code);case ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.code);case NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.code);case ConflictFailure() when conflict != null:
return conflict(_that.message,_that.code);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message,_that.retryAfter,_that.code);case InternalServerErrorFailure() when internalServerError != null:
return internalServerError(_that.message,_that.code);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message,_that.code);case DeviceFailure() when device != null:
return device(_that.message,_that.code);case PlatformFailure() when platform != null:
return platform(_that.message,_that.platformCode,_that.code);case FileSystemFailure() when fileSystem != null:
return fileSystem(_that.message,_that.code);case EncryptionFailure() when encryption != null:
return encryption(_that.message,_that.code);case BiometricFailure() when biometric != null:
return biometric(_that.message,_that.code);case LocationFailure() when location != null:
return location(_that.message,_that.code);case CameraFailure() when camera != null:
return camera(_that.message,_that.code);case GalleryFailure() when gallery != null:
return gallery(_that.message,_that.code);case NotificationFailure() when notification != null:
return notification(_that.message,_that.code);case ShareFailure() when share != null:
return share(_that.message,_that.code);case UrlLauncherFailure() when urlLauncher != null:
return urlLauncher(_that.message,_that.code);case ConnectivityFailure() when connectivity != null:
return connectivity(_that.message,_that.code);case ParseFailure() when parse != null:
return parse(_that.message,_that.code);case DatabaseFailure() when database != null:
return database(_that.message,_that.code);case MigrationFailure() when migration != null:
return migration(_that.message,_that.code);case SyncFailure() when sync != null:
return sync(_that.message,_that.code);case FeatureNotAvailableFailure() when featureNotAvailable != null:
return featureNotAvailable(_that.message,_that.code);case VersionMismatchFailure() when versionMismatch != null:
return versionMismatch(_that.message,_that.currentVersion,_that.requiredVersion,_that.code);case MaintenanceModeFailure() when maintenanceMode != null:
return maintenanceMode(_that.message,_that.estimatedEndTime,_that.code);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that.message,_that.retryAfter,_that.limit,_that.code);case SubscriptionFailure() when subscription != null:
return subscription(_that.message,_that.subscriptionType,_that.code);case PaymentFailure() when payment != null:
return payment(_that.message,_that.paymentMethod,_that.transactionId,_that.code);case ContentNotAvailableFailure() when contentNotAvailable != null:
return contentNotAvailable(_that.message,_that.contentId,_that.reason,_that.code);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that.message,_that.currentUsage,_that.limit,_that.quotaType,_that.code);case ConfigurationFailure() when configuration != null:
return configuration(_that.message,_that.configKey,_that.code);case DependencyFailure() when dependency != null:
return dependency(_that.message,_that.dependencyName,_that.code);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.originalError,_that.stackTrace,_that.code);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? code)  network,required TResult Function( String message,  int? statusCode,  String? code)  server,required TResult Function( String message,  String? code)  auth,required TResult Function( String message,  String? field,  String? code)  validation,required TResult Function( String message,  String? code)  storage,required TResult Function( String message,  String? code)  permission,required TResult Function( String message,  String? code)  cache,required TResult Function( String message,  String? code)  timeout,required TResult Function( String message,  String? code)  unauthorized,required TResult Function( String message,  String? code)  forbidden,required TResult Function( String message,  String? code)  notFound,required TResult Function( String message,  String? code)  conflict,required TResult Function( String message,  Duration? retryAfter,  String? code)  tooManyRequests,required TResult Function( String message,  String? code)  internalServerError,required TResult Function( String message,  String? code)  serviceUnavailable,required TResult Function( String message,  String? code)  device,required TResult Function( String message,  String? platformCode,  String? code)  platform,required TResult Function( String message,  String? code)  fileSystem,required TResult Function( String message,  String? code)  encryption,required TResult Function( String message,  String? code)  biometric,required TResult Function( String message,  String? code)  location,required TResult Function( String message,  String? code)  camera,required TResult Function( String message,  String? code)  gallery,required TResult Function( String message,  String? code)  notification,required TResult Function( String message,  String? code)  share,required TResult Function( String message,  String? code)  urlLauncher,required TResult Function( String message,  String? code)  connectivity,required TResult Function( String message,  String? code)  parse,required TResult Function( String message,  String? code)  database,required TResult Function( String message,  String? code)  migration,required TResult Function( String message,  String? code)  sync,required TResult Function( String message,  String? code)  featureNotAvailable,required TResult Function( String message,  String? currentVersion,  String? requiredVersion,  String? code)  versionMismatch,required TResult Function( String message,  DateTime? estimatedEndTime,  String? code)  maintenanceMode,required TResult Function( String message,  Duration? retryAfter,  int? limit,  String? code)  rateLimit,required TResult Function( String message,  String? subscriptionType,  String? code)  subscription,required TResult Function( String message,  String? paymentMethod,  String? transactionId,  String? code)  payment,required TResult Function( String message,  String? contentId,  String? reason,  String? code)  contentNotAvailable,required TResult Function( String message,  int? currentUsage,  int? limit,  String? quotaType,  String? code)  quotaExceeded,required TResult Function( String message,  String? configKey,  String? code)  configuration,required TResult Function( String message,  String? dependencyName,  String? code)  dependency,required TResult Function( String message,  String? originalError,  String? stackTrace,  String? code)  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that.message,_that.code);case ServerFailure():
return server(_that.message,_that.statusCode,_that.code);case AuthFailure():
return auth(_that.message,_that.code);case ValidationFailure():
return validation(_that.message,_that.field,_that.code);case StorageFailure():
return storage(_that.message,_that.code);case PermissionFailure():
return permission(_that.message,_that.code);case CacheFailure():
return cache(_that.message,_that.code);case TimeoutFailure():
return timeout(_that.message,_that.code);case UnauthorizedFailure():
return unauthorized(_that.message,_that.code);case ForbiddenFailure():
return forbidden(_that.message,_that.code);case NotFoundFailure():
return notFound(_that.message,_that.code);case ConflictFailure():
return conflict(_that.message,_that.code);case TooManyRequestsFailure():
return tooManyRequests(_that.message,_that.retryAfter,_that.code);case InternalServerErrorFailure():
return internalServerError(_that.message,_that.code);case ServiceUnavailableFailure():
return serviceUnavailable(_that.message,_that.code);case DeviceFailure():
return device(_that.message,_that.code);case PlatformFailure():
return platform(_that.message,_that.platformCode,_that.code);case FileSystemFailure():
return fileSystem(_that.message,_that.code);case EncryptionFailure():
return encryption(_that.message,_that.code);case BiometricFailure():
return biometric(_that.message,_that.code);case LocationFailure():
return location(_that.message,_that.code);case CameraFailure():
return camera(_that.message,_that.code);case GalleryFailure():
return gallery(_that.message,_that.code);case NotificationFailure():
return notification(_that.message,_that.code);case ShareFailure():
return share(_that.message,_that.code);case UrlLauncherFailure():
return urlLauncher(_that.message,_that.code);case ConnectivityFailure():
return connectivity(_that.message,_that.code);case ParseFailure():
return parse(_that.message,_that.code);case DatabaseFailure():
return database(_that.message,_that.code);case MigrationFailure():
return migration(_that.message,_that.code);case SyncFailure():
return sync(_that.message,_that.code);case FeatureNotAvailableFailure():
return featureNotAvailable(_that.message,_that.code);case VersionMismatchFailure():
return versionMismatch(_that.message,_that.currentVersion,_that.requiredVersion,_that.code);case MaintenanceModeFailure():
return maintenanceMode(_that.message,_that.estimatedEndTime,_that.code);case RateLimitFailure():
return rateLimit(_that.message,_that.retryAfter,_that.limit,_that.code);case SubscriptionFailure():
return subscription(_that.message,_that.subscriptionType,_that.code);case PaymentFailure():
return payment(_that.message,_that.paymentMethod,_that.transactionId,_that.code);case ContentNotAvailableFailure():
return contentNotAvailable(_that.message,_that.contentId,_that.reason,_that.code);case QuotaExceededFailure():
return quotaExceeded(_that.message,_that.currentUsage,_that.limit,_that.quotaType,_that.code);case ConfigurationFailure():
return configuration(_that.message,_that.configKey,_that.code);case DependencyFailure():
return dependency(_that.message,_that.dependencyName,_that.code);case UnknownFailure():
return unknown(_that.message,_that.originalError,_that.stackTrace,_that.code);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? code)?  network,TResult? Function( String message,  int? statusCode,  String? code)?  server,TResult? Function( String message,  String? code)?  auth,TResult? Function( String message,  String? field,  String? code)?  validation,TResult? Function( String message,  String? code)?  storage,TResult? Function( String message,  String? code)?  permission,TResult? Function( String message,  String? code)?  cache,TResult? Function( String message,  String? code)?  timeout,TResult? Function( String message,  String? code)?  unauthorized,TResult? Function( String message,  String? code)?  forbidden,TResult? Function( String message,  String? code)?  notFound,TResult? Function( String message,  String? code)?  conflict,TResult? Function( String message,  Duration? retryAfter,  String? code)?  tooManyRequests,TResult? Function( String message,  String? code)?  internalServerError,TResult? Function( String message,  String? code)?  serviceUnavailable,TResult? Function( String message,  String? code)?  device,TResult? Function( String message,  String? platformCode,  String? code)?  platform,TResult? Function( String message,  String? code)?  fileSystem,TResult? Function( String message,  String? code)?  encryption,TResult? Function( String message,  String? code)?  biometric,TResult? Function( String message,  String? code)?  location,TResult? Function( String message,  String? code)?  camera,TResult? Function( String message,  String? code)?  gallery,TResult? Function( String message,  String? code)?  notification,TResult? Function( String message,  String? code)?  share,TResult? Function( String message,  String? code)?  urlLauncher,TResult? Function( String message,  String? code)?  connectivity,TResult? Function( String message,  String? code)?  parse,TResult? Function( String message,  String? code)?  database,TResult? Function( String message,  String? code)?  migration,TResult? Function( String message,  String? code)?  sync,TResult? Function( String message,  String? code)?  featureNotAvailable,TResult? Function( String message,  String? currentVersion,  String? requiredVersion,  String? code)?  versionMismatch,TResult? Function( String message,  DateTime? estimatedEndTime,  String? code)?  maintenanceMode,TResult? Function( String message,  Duration? retryAfter,  int? limit,  String? code)?  rateLimit,TResult? Function( String message,  String? subscriptionType,  String? code)?  subscription,TResult? Function( String message,  String? paymentMethod,  String? transactionId,  String? code)?  payment,TResult? Function( String message,  String? contentId,  String? reason,  String? code)?  contentNotAvailable,TResult? Function( String message,  int? currentUsage,  int? limit,  String? quotaType,  String? code)?  quotaExceeded,TResult? Function( String message,  String? configKey,  String? code)?  configuration,TResult? Function( String message,  String? dependencyName,  String? code)?  dependency,TResult? Function( String message,  String? originalError,  String? stackTrace,  String? code)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.message,_that.code);case ServerFailure() when server != null:
return server(_that.message,_that.statusCode,_that.code);case AuthFailure() when auth != null:
return auth(_that.message,_that.code);case ValidationFailure() when validation != null:
return validation(_that.message,_that.field,_that.code);case StorageFailure() when storage != null:
return storage(_that.message,_that.code);case PermissionFailure() when permission != null:
return permission(_that.message,_that.code);case CacheFailure() when cache != null:
return cache(_that.message,_that.code);case TimeoutFailure() when timeout != null:
return timeout(_that.message,_that.code);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that.message,_that.code);case ForbiddenFailure() when forbidden != null:
return forbidden(_that.message,_that.code);case NotFoundFailure() when notFound != null:
return notFound(_that.message,_that.code);case ConflictFailure() when conflict != null:
return conflict(_that.message,_that.code);case TooManyRequestsFailure() when tooManyRequests != null:
return tooManyRequests(_that.message,_that.retryAfter,_that.code);case InternalServerErrorFailure() when internalServerError != null:
return internalServerError(_that.message,_that.code);case ServiceUnavailableFailure() when serviceUnavailable != null:
return serviceUnavailable(_that.message,_that.code);case DeviceFailure() when device != null:
return device(_that.message,_that.code);case PlatformFailure() when platform != null:
return platform(_that.message,_that.platformCode,_that.code);case FileSystemFailure() when fileSystem != null:
return fileSystem(_that.message,_that.code);case EncryptionFailure() when encryption != null:
return encryption(_that.message,_that.code);case BiometricFailure() when biometric != null:
return biometric(_that.message,_that.code);case LocationFailure() when location != null:
return location(_that.message,_that.code);case CameraFailure() when camera != null:
return camera(_that.message,_that.code);case GalleryFailure() when gallery != null:
return gallery(_that.message,_that.code);case NotificationFailure() when notification != null:
return notification(_that.message,_that.code);case ShareFailure() when share != null:
return share(_that.message,_that.code);case UrlLauncherFailure() when urlLauncher != null:
return urlLauncher(_that.message,_that.code);case ConnectivityFailure() when connectivity != null:
return connectivity(_that.message,_that.code);case ParseFailure() when parse != null:
return parse(_that.message,_that.code);case DatabaseFailure() when database != null:
return database(_that.message,_that.code);case MigrationFailure() when migration != null:
return migration(_that.message,_that.code);case SyncFailure() when sync != null:
return sync(_that.message,_that.code);case FeatureNotAvailableFailure() when featureNotAvailable != null:
return featureNotAvailable(_that.message,_that.code);case VersionMismatchFailure() when versionMismatch != null:
return versionMismatch(_that.message,_that.currentVersion,_that.requiredVersion,_that.code);case MaintenanceModeFailure() when maintenanceMode != null:
return maintenanceMode(_that.message,_that.estimatedEndTime,_that.code);case RateLimitFailure() when rateLimit != null:
return rateLimit(_that.message,_that.retryAfter,_that.limit,_that.code);case SubscriptionFailure() when subscription != null:
return subscription(_that.message,_that.subscriptionType,_that.code);case PaymentFailure() when payment != null:
return payment(_that.message,_that.paymentMethod,_that.transactionId,_that.code);case ContentNotAvailableFailure() when contentNotAvailable != null:
return contentNotAvailable(_that.message,_that.contentId,_that.reason,_that.code);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that.message,_that.currentUsage,_that.limit,_that.quotaType,_that.code);case ConfigurationFailure() when configuration != null:
return configuration(_that.message,_that.configKey,_that.code);case DependencyFailure() when dependency != null:
return dependency(_that.message,_that.dependencyName,_that.code);case UnknownFailure() when unknown != null:
return unknown(_that.message,_that.originalError,_that.stackTrace,_that.code);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.network(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerFailure implements Failure {
  const ServerFailure({required this.message, this.statusCode, this.code});
  

@override final  String message;
 final  int? statusCode;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,statusCode,code);

@override
String toString() {
  return 'Failure.server(message: $message, statusCode: $statusCode, code: $code)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode, String? code
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,Object? code = freezed,}) {
  return _then(ServerFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AuthFailure implements Failure {
  const AuthFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<AuthFailure> get copyWith => _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.auth(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(AuthFailure value, $Res Function(AuthFailure) _then) = _$AuthFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$AuthFailureCopyWithImpl<$Res>
    implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(AuthFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ValidationFailure implements Failure {
  const ValidationFailure({required this.message, this.field, this.code});
  

@override final  String message;
 final  String? field;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.field, field) || other.field == field)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,field,code);

@override
String toString() {
  return 'Failure.validation(message: $message, field: $field, code: $code)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? field, String? code
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? field = freezed,Object? code = freezed,}) {
  return _then(ValidationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class StorageFailure implements Failure {
  const StorageFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFailureCopyWith<StorageFailure> get copyWith => _$StorageFailureCopyWithImpl<StorageFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.storage(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $StorageFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $StorageFailureCopyWith(StorageFailure value, $Res Function(StorageFailure) _then) = _$StorageFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$StorageFailureCopyWithImpl<$Res>
    implements $StorageFailureCopyWith<$Res> {
  _$StorageFailureCopyWithImpl(this._self, this._then);

  final StorageFailure _self;
  final $Res Function(StorageFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(StorageFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PermissionFailure implements Failure {
  const PermissionFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionFailureCopyWith<PermissionFailure> get copyWith => _$PermissionFailureCopyWithImpl<PermissionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.permission(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $PermissionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PermissionFailureCopyWith(PermissionFailure value, $Res Function(PermissionFailure) _then) = _$PermissionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$PermissionFailureCopyWithImpl<$Res>
    implements $PermissionFailureCopyWith<$Res> {
  _$PermissionFailureCopyWithImpl(this._self, this._then);

  final PermissionFailure _self;
  final $Res Function(PermissionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(PermissionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CacheFailure implements Failure {
  const CacheFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.cache(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(CacheFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TimeoutFailure implements Failure {
  const TimeoutFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeoutFailureCopyWith<TimeoutFailure> get copyWith => _$TimeoutFailureCopyWithImpl<TimeoutFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.timeout(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $TimeoutFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TimeoutFailureCopyWith(TimeoutFailure value, $Res Function(TimeoutFailure) _then) = _$TimeoutFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$TimeoutFailureCopyWithImpl<$Res>
    implements $TimeoutFailureCopyWith<$Res> {
  _$TimeoutFailureCopyWithImpl(this._self, this._then);

  final TimeoutFailure _self;
  final $Res Function(TimeoutFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(TimeoutFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnauthorizedFailure implements Failure {
  const UnauthorizedFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedFailureCopyWith<UnauthorizedFailure> get copyWith => _$UnauthorizedFailureCopyWithImpl<UnauthorizedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.unauthorized(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnauthorizedFailureCopyWith(UnauthorizedFailure value, $Res Function(UnauthorizedFailure) _then) = _$UnauthorizedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$UnauthorizedFailureCopyWithImpl<$Res>
    implements $UnauthorizedFailureCopyWith<$Res> {
  _$UnauthorizedFailureCopyWithImpl(this._self, this._then);

  final UnauthorizedFailure _self;
  final $Res Function(UnauthorizedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(UnauthorizedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ForbiddenFailure implements Failure {
  const ForbiddenFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForbiddenFailureCopyWith<ForbiddenFailure> get copyWith => _$ForbiddenFailureCopyWithImpl<ForbiddenFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForbiddenFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.forbidden(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ForbiddenFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ForbiddenFailureCopyWith(ForbiddenFailure value, $Res Function(ForbiddenFailure) _then) = _$ForbiddenFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ForbiddenFailureCopyWithImpl<$Res>
    implements $ForbiddenFailureCopyWith<$Res> {
  _$ForbiddenFailureCopyWithImpl(this._self, this._then);

  final ForbiddenFailure _self;
  final $Res Function(ForbiddenFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ForbiddenFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotFoundFailure implements Failure {
  const NotFoundFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundFailureCopyWith<NotFoundFailure> get copyWith => _$NotFoundFailureCopyWithImpl<NotFoundFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.notFound(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NotFoundFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NotFoundFailureCopyWith(NotFoundFailure value, $Res Function(NotFoundFailure) _then) = _$NotFoundFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NotFoundFailureCopyWithImpl<$Res>
    implements $NotFoundFailureCopyWith<$Res> {
  _$NotFoundFailureCopyWithImpl(this._self, this._then);

  final NotFoundFailure _self;
  final $Res Function(NotFoundFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NotFoundFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConflictFailure implements Failure {
  const ConflictFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictFailureCopyWith<ConflictFailure> get copyWith => _$ConflictFailureCopyWithImpl<ConflictFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.conflict(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ConflictFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConflictFailureCopyWith(ConflictFailure value, $Res Function(ConflictFailure) _then) = _$ConflictFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ConflictFailureCopyWithImpl<$Res>
    implements $ConflictFailureCopyWith<$Res> {
  _$ConflictFailureCopyWithImpl(this._self, this._then);

  final ConflictFailure _self;
  final $Res Function(ConflictFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ConflictFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TooManyRequestsFailure implements Failure {
  const TooManyRequestsFailure({required this.message, this.retryAfter, this.code});
  

@override final  String message;
 final  Duration? retryAfter;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooManyRequestsFailureCopyWith<TooManyRequestsFailure> get copyWith => _$TooManyRequestsFailureCopyWithImpl<TooManyRequestsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequestsFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,retryAfter,code);

@override
String toString() {
  return 'Failure.tooManyRequests(message: $message, retryAfter: $retryAfter, code: $code)';
}


}

/// @nodoc
abstract mixin class $TooManyRequestsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $TooManyRequestsFailureCopyWith(TooManyRequestsFailure value, $Res Function(TooManyRequestsFailure) _then) = _$TooManyRequestsFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Duration? retryAfter, String? code
});




}
/// @nodoc
class _$TooManyRequestsFailureCopyWithImpl<$Res>
    implements $TooManyRequestsFailureCopyWith<$Res> {
  _$TooManyRequestsFailureCopyWithImpl(this._self, this._then);

  final TooManyRequestsFailure _self;
  final $Res Function(TooManyRequestsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? retryAfter = freezed,Object? code = freezed,}) {
  return _then(TooManyRequestsFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class InternalServerErrorFailure implements Failure {
  const InternalServerErrorFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalServerErrorFailureCopyWith<InternalServerErrorFailure> get copyWith => _$InternalServerErrorFailureCopyWithImpl<InternalServerErrorFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalServerErrorFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.internalServerError(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $InternalServerErrorFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $InternalServerErrorFailureCopyWith(InternalServerErrorFailure value, $Res Function(InternalServerErrorFailure) _then) = _$InternalServerErrorFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$InternalServerErrorFailureCopyWithImpl<$Res>
    implements $InternalServerErrorFailureCopyWith<$Res> {
  _$InternalServerErrorFailureCopyWithImpl(this._self, this._then);

  final InternalServerErrorFailure _self;
  final $Res Function(InternalServerErrorFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(InternalServerErrorFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServiceUnavailableFailure implements Failure {
  const ServiceUnavailableFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUnavailableFailureCopyWith<ServiceUnavailableFailure> get copyWith => _$ServiceUnavailableFailureCopyWithImpl<ServiceUnavailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailableFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.serviceUnavailable(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ServiceUnavailableFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ServiceUnavailableFailureCopyWith(ServiceUnavailableFailure value, $Res Function(ServiceUnavailableFailure) _then) = _$ServiceUnavailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ServiceUnavailableFailureCopyWithImpl<$Res>
    implements $ServiceUnavailableFailureCopyWith<$Res> {
  _$ServiceUnavailableFailureCopyWithImpl(this._self, this._then);

  final ServiceUnavailableFailure _self;
  final $Res Function(ServiceUnavailableFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ServiceUnavailableFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DeviceFailure implements Failure {
  const DeviceFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceFailureCopyWith<DeviceFailure> get copyWith => _$DeviceFailureCopyWithImpl<DeviceFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.device(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $DeviceFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $DeviceFailureCopyWith(DeviceFailure value, $Res Function(DeviceFailure) _then) = _$DeviceFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$DeviceFailureCopyWithImpl<$Res>
    implements $DeviceFailureCopyWith<$Res> {
  _$DeviceFailureCopyWithImpl(this._self, this._then);

  final DeviceFailure _self;
  final $Res Function(DeviceFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(DeviceFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PlatformFailure implements Failure {
  const PlatformFailure({required this.message, this.platformCode, this.code});
  

@override final  String message;
 final  String? platformCode;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFailureCopyWith<PlatformFailure> get copyWith => _$PlatformFailureCopyWithImpl<PlatformFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.platformCode, platformCode) || other.platformCode == platformCode)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,platformCode,code);

@override
String toString() {
  return 'Failure.platform(message: $message, platformCode: $platformCode, code: $code)';
}


}

/// @nodoc
abstract mixin class $PlatformFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PlatformFailureCopyWith(PlatformFailure value, $Res Function(PlatformFailure) _then) = _$PlatformFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? platformCode, String? code
});




}
/// @nodoc
class _$PlatformFailureCopyWithImpl<$Res>
    implements $PlatformFailureCopyWith<$Res> {
  _$PlatformFailureCopyWithImpl(this._self, this._then);

  final PlatformFailure _self;
  final $Res Function(PlatformFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? platformCode = freezed,Object? code = freezed,}) {
  return _then(PlatformFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,platformCode: freezed == platformCode ? _self.platformCode : platformCode // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class FileSystemFailure implements Failure {
  const FileSystemFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileSystemFailureCopyWith<FileSystemFailure> get copyWith => _$FileSystemFailureCopyWithImpl<FileSystemFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileSystemFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.fileSystem(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $FileSystemFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $FileSystemFailureCopyWith(FileSystemFailure value, $Res Function(FileSystemFailure) _then) = _$FileSystemFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$FileSystemFailureCopyWithImpl<$Res>
    implements $FileSystemFailureCopyWith<$Res> {
  _$FileSystemFailureCopyWithImpl(this._self, this._then);

  final FileSystemFailure _self;
  final $Res Function(FileSystemFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(FileSystemFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class EncryptionFailure implements Failure {
  const EncryptionFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncryptionFailureCopyWith<EncryptionFailure> get copyWith => _$EncryptionFailureCopyWithImpl<EncryptionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EncryptionFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.encryption(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $EncryptionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $EncryptionFailureCopyWith(EncryptionFailure value, $Res Function(EncryptionFailure) _then) = _$EncryptionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$EncryptionFailureCopyWithImpl<$Res>
    implements $EncryptionFailureCopyWith<$Res> {
  _$EncryptionFailureCopyWithImpl(this._self, this._then);

  final EncryptionFailure _self;
  final $Res Function(EncryptionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(EncryptionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class BiometricFailure implements Failure {
  const BiometricFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiometricFailureCopyWith<BiometricFailure> get copyWith => _$BiometricFailureCopyWithImpl<BiometricFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiometricFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.biometric(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $BiometricFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $BiometricFailureCopyWith(BiometricFailure value, $Res Function(BiometricFailure) _then) = _$BiometricFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$BiometricFailureCopyWithImpl<$Res>
    implements $BiometricFailureCopyWith<$Res> {
  _$BiometricFailureCopyWithImpl(this._self, this._then);

  final BiometricFailure _self;
  final $Res Function(BiometricFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(BiometricFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LocationFailure implements Failure {
  const LocationFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationFailureCopyWith<LocationFailure> get copyWith => _$LocationFailureCopyWithImpl<LocationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.location(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $LocationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $LocationFailureCopyWith(LocationFailure value, $Res Function(LocationFailure) _then) = _$LocationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$LocationFailureCopyWithImpl<$Res>
    implements $LocationFailureCopyWith<$Res> {
  _$LocationFailureCopyWithImpl(this._self, this._then);

  final LocationFailure _self;
  final $Res Function(LocationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(LocationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CameraFailure implements Failure {
  const CameraFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraFailureCopyWith<CameraFailure> get copyWith => _$CameraFailureCopyWithImpl<CameraFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.camera(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $CameraFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CameraFailureCopyWith(CameraFailure value, $Res Function(CameraFailure) _then) = _$CameraFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$CameraFailureCopyWithImpl<$Res>
    implements $CameraFailureCopyWith<$Res> {
  _$CameraFailureCopyWithImpl(this._self, this._then);

  final CameraFailure _self;
  final $Res Function(CameraFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(CameraFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class GalleryFailure implements Failure {
  const GalleryFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryFailureCopyWith<GalleryFailure> get copyWith => _$GalleryFailureCopyWithImpl<GalleryFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.gallery(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $GalleryFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $GalleryFailureCopyWith(GalleryFailure value, $Res Function(GalleryFailure) _then) = _$GalleryFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$GalleryFailureCopyWithImpl<$Res>
    implements $GalleryFailureCopyWith<$Res> {
  _$GalleryFailureCopyWithImpl(this._self, this._then);

  final GalleryFailure _self;
  final $Res Function(GalleryFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(GalleryFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotificationFailure implements Failure {
  const NotificationFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationFailureCopyWith<NotificationFailure> get copyWith => _$NotificationFailureCopyWithImpl<NotificationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.notification(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NotificationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NotificationFailureCopyWith(NotificationFailure value, $Res Function(NotificationFailure) _then) = _$NotificationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NotificationFailureCopyWithImpl<$Res>
    implements $NotificationFailureCopyWith<$Res> {
  _$NotificationFailureCopyWithImpl(this._self, this._then);

  final NotificationFailure _self;
  final $Res Function(NotificationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NotificationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ShareFailure implements Failure {
  const ShareFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareFailureCopyWith<ShareFailure> get copyWith => _$ShareFailureCopyWithImpl<ShareFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.share(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ShareFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ShareFailureCopyWith(ShareFailure value, $Res Function(ShareFailure) _then) = _$ShareFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ShareFailureCopyWithImpl<$Res>
    implements $ShareFailureCopyWith<$Res> {
  _$ShareFailureCopyWithImpl(this._self, this._then);

  final ShareFailure _self;
  final $Res Function(ShareFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ShareFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UrlLauncherFailure implements Failure {
  const UrlLauncherFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlLauncherFailureCopyWith<UrlLauncherFailure> get copyWith => _$UrlLauncherFailureCopyWithImpl<UrlLauncherFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrlLauncherFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.urlLauncher(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $UrlLauncherFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UrlLauncherFailureCopyWith(UrlLauncherFailure value, $Res Function(UrlLauncherFailure) _then) = _$UrlLauncherFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$UrlLauncherFailureCopyWithImpl<$Res>
    implements $UrlLauncherFailureCopyWith<$Res> {
  _$UrlLauncherFailureCopyWithImpl(this._self, this._then);

  final UrlLauncherFailure _self;
  final $Res Function(UrlLauncherFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(UrlLauncherFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConnectivityFailure implements Failure {
  const ConnectivityFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectivityFailureCopyWith<ConnectivityFailure> get copyWith => _$ConnectivityFailureCopyWithImpl<ConnectivityFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectivityFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.connectivity(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ConnectivityFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConnectivityFailureCopyWith(ConnectivityFailure value, $Res Function(ConnectivityFailure) _then) = _$ConnectivityFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ConnectivityFailureCopyWithImpl<$Res>
    implements $ConnectivityFailureCopyWith<$Res> {
  _$ConnectivityFailureCopyWithImpl(this._self, this._then);

  final ConnectivityFailure _self;
  final $Res Function(ConnectivityFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ConnectivityFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ParseFailure implements Failure {
  const ParseFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseFailureCopyWith<ParseFailure> get copyWith => _$ParseFailureCopyWithImpl<ParseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.parse(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ParseFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ParseFailureCopyWith(ParseFailure value, $Res Function(ParseFailure) _then) = _$ParseFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$ParseFailureCopyWithImpl<$Res>
    implements $ParseFailureCopyWith<$Res> {
  _$ParseFailureCopyWithImpl(this._self, this._then);

  final ParseFailure _self;
  final $Res Function(ParseFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(ParseFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DatabaseFailure implements Failure {
  const DatabaseFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseFailureCopyWith<DatabaseFailure> get copyWith => _$DatabaseFailureCopyWithImpl<DatabaseFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.database(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $DatabaseFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $DatabaseFailureCopyWith(DatabaseFailure value, $Res Function(DatabaseFailure) _then) = _$DatabaseFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$DatabaseFailureCopyWithImpl<$Res>
    implements $DatabaseFailureCopyWith<$Res> {
  _$DatabaseFailureCopyWithImpl(this._self, this._then);

  final DatabaseFailure _self;
  final $Res Function(DatabaseFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(DatabaseFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class MigrationFailure implements Failure {
  const MigrationFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationFailureCopyWith<MigrationFailure> get copyWith => _$MigrationFailureCopyWithImpl<MigrationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MigrationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.migration(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $MigrationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $MigrationFailureCopyWith(MigrationFailure value, $Res Function(MigrationFailure) _then) = _$MigrationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$MigrationFailureCopyWithImpl<$Res>
    implements $MigrationFailureCopyWith<$Res> {
  _$MigrationFailureCopyWithImpl(this._self, this._then);

  final MigrationFailure _self;
  final $Res Function(MigrationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(MigrationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SyncFailure implements Failure {
  const SyncFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncFailureCopyWith<SyncFailure> get copyWith => _$SyncFailureCopyWithImpl<SyncFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.sync(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $SyncFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $SyncFailureCopyWith(SyncFailure value, $Res Function(SyncFailure) _then) = _$SyncFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$SyncFailureCopyWithImpl<$Res>
    implements $SyncFailureCopyWith<$Res> {
  _$SyncFailureCopyWithImpl(this._self, this._then);

  final SyncFailure _self;
  final $Res Function(SyncFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(SyncFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class FeatureNotAvailableFailure implements Failure {
  const FeatureNotAvailableFailure({required this.message, this.code});
  

@override final  String message;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureNotAvailableFailureCopyWith<FeatureNotAvailableFailure> get copyWith => _$FeatureNotAvailableFailureCopyWithImpl<FeatureNotAvailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureNotAvailableFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'Failure.featureNotAvailable(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $FeatureNotAvailableFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $FeatureNotAvailableFailureCopyWith(FeatureNotAvailableFailure value, $Res Function(FeatureNotAvailableFailure) _then) = _$FeatureNotAvailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$FeatureNotAvailableFailureCopyWithImpl<$Res>
    implements $FeatureNotAvailableFailureCopyWith<$Res> {
  _$FeatureNotAvailableFailureCopyWithImpl(this._self, this._then);

  final FeatureNotAvailableFailure _self;
  final $Res Function(FeatureNotAvailableFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(FeatureNotAvailableFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class VersionMismatchFailure implements Failure {
  const VersionMismatchFailure({required this.message, this.currentVersion, this.requiredVersion, this.code});
  

@override final  String message;
 final  String? currentVersion;
 final  String? requiredVersion;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionMismatchFailureCopyWith<VersionMismatchFailure> get copyWith => _$VersionMismatchFailureCopyWithImpl<VersionMismatchFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionMismatchFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.requiredVersion, requiredVersion) || other.requiredVersion == requiredVersion)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,currentVersion,requiredVersion,code);

@override
String toString() {
  return 'Failure.versionMismatch(message: $message, currentVersion: $currentVersion, requiredVersion: $requiredVersion, code: $code)';
}


}

/// @nodoc
abstract mixin class $VersionMismatchFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $VersionMismatchFailureCopyWith(VersionMismatchFailure value, $Res Function(VersionMismatchFailure) _then) = _$VersionMismatchFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? currentVersion, String? requiredVersion, String? code
});




}
/// @nodoc
class _$VersionMismatchFailureCopyWithImpl<$Res>
    implements $VersionMismatchFailureCopyWith<$Res> {
  _$VersionMismatchFailureCopyWithImpl(this._self, this._then);

  final VersionMismatchFailure _self;
  final $Res Function(VersionMismatchFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? currentVersion = freezed,Object? requiredVersion = freezed,Object? code = freezed,}) {
  return _then(VersionMismatchFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,currentVersion: freezed == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as String?,requiredVersion: freezed == requiredVersion ? _self.requiredVersion : requiredVersion // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class MaintenanceModeFailure implements Failure {
  const MaintenanceModeFailure({required this.message, this.estimatedEndTime, this.code});
  

@override final  String message;
 final  DateTime? estimatedEndTime;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceModeFailureCopyWith<MaintenanceModeFailure> get copyWith => _$MaintenanceModeFailureCopyWithImpl<MaintenanceModeFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceModeFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.estimatedEndTime, estimatedEndTime) || other.estimatedEndTime == estimatedEndTime)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,estimatedEndTime,code);

@override
String toString() {
  return 'Failure.maintenanceMode(message: $message, estimatedEndTime: $estimatedEndTime, code: $code)';
}


}

/// @nodoc
abstract mixin class $MaintenanceModeFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $MaintenanceModeFailureCopyWith(MaintenanceModeFailure value, $Res Function(MaintenanceModeFailure) _then) = _$MaintenanceModeFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, DateTime? estimatedEndTime, String? code
});




}
/// @nodoc
class _$MaintenanceModeFailureCopyWithImpl<$Res>
    implements $MaintenanceModeFailureCopyWith<$Res> {
  _$MaintenanceModeFailureCopyWithImpl(this._self, this._then);

  final MaintenanceModeFailure _self;
  final $Res Function(MaintenanceModeFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? estimatedEndTime = freezed,Object? code = freezed,}) {
  return _then(MaintenanceModeFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,estimatedEndTime: freezed == estimatedEndTime ? _self.estimatedEndTime : estimatedEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RateLimitFailure implements Failure {
  const RateLimitFailure({required this.message, this.retryAfter, this.limit, this.code});
  

@override final  String message;
 final  Duration? retryAfter;
 final  int? limit;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitFailureCopyWith<RateLimitFailure> get copyWith => _$RateLimitFailureCopyWithImpl<RateLimitFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.retryAfter, retryAfter) || other.retryAfter == retryAfter)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,retryAfter,limit,code);

@override
String toString() {
  return 'Failure.rateLimit(message: $message, retryAfter: $retryAfter, limit: $limit, code: $code)';
}


}

/// @nodoc
abstract mixin class $RateLimitFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $RateLimitFailureCopyWith(RateLimitFailure value, $Res Function(RateLimitFailure) _then) = _$RateLimitFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Duration? retryAfter, int? limit, String? code
});




}
/// @nodoc
class _$RateLimitFailureCopyWithImpl<$Res>
    implements $RateLimitFailureCopyWith<$Res> {
  _$RateLimitFailureCopyWithImpl(this._self, this._then);

  final RateLimitFailure _self;
  final $Res Function(RateLimitFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? retryAfter = freezed,Object? limit = freezed,Object? code = freezed,}) {
  return _then(RateLimitFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryAfter: freezed == retryAfter ? _self.retryAfter : retryAfter // ignore: cast_nullable_to_non_nullable
as Duration?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SubscriptionFailure implements Failure {
  const SubscriptionFailure({required this.message, this.subscriptionType, this.code});
  

@override final  String message;
 final  String? subscriptionType;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionFailureCopyWith<SubscriptionFailure> get copyWith => _$SubscriptionFailureCopyWithImpl<SubscriptionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.subscriptionType, subscriptionType) || other.subscriptionType == subscriptionType)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,subscriptionType,code);

@override
String toString() {
  return 'Failure.subscription(message: $message, subscriptionType: $subscriptionType, code: $code)';
}


}

/// @nodoc
abstract mixin class $SubscriptionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $SubscriptionFailureCopyWith(SubscriptionFailure value, $Res Function(SubscriptionFailure) _then) = _$SubscriptionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? subscriptionType, String? code
});




}
/// @nodoc
class _$SubscriptionFailureCopyWithImpl<$Res>
    implements $SubscriptionFailureCopyWith<$Res> {
  _$SubscriptionFailureCopyWithImpl(this._self, this._then);

  final SubscriptionFailure _self;
  final $Res Function(SubscriptionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? subscriptionType = freezed,Object? code = freezed,}) {
  return _then(SubscriptionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,subscriptionType: freezed == subscriptionType ? _self.subscriptionType : subscriptionType // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PaymentFailure implements Failure {
  const PaymentFailure({required this.message, this.paymentMethod, this.transactionId, this.code});
  

@override final  String message;
 final  String? paymentMethod;
 final  String? transactionId;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentFailureCopyWith<PaymentFailure> get copyWith => _$PaymentFailureCopyWithImpl<PaymentFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,paymentMethod,transactionId,code);

@override
String toString() {
  return 'Failure.payment(message: $message, paymentMethod: $paymentMethod, transactionId: $transactionId, code: $code)';
}


}

/// @nodoc
abstract mixin class $PaymentFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PaymentFailureCopyWith(PaymentFailure value, $Res Function(PaymentFailure) _then) = _$PaymentFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? paymentMethod, String? transactionId, String? code
});




}
/// @nodoc
class _$PaymentFailureCopyWithImpl<$Res>
    implements $PaymentFailureCopyWith<$Res> {
  _$PaymentFailureCopyWithImpl(this._self, this._then);

  final PaymentFailure _self;
  final $Res Function(PaymentFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? paymentMethod = freezed,Object? transactionId = freezed,Object? code = freezed,}) {
  return _then(PaymentFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ContentNotAvailableFailure implements Failure {
  const ContentNotAvailableFailure({required this.message, this.contentId, this.reason, this.code});
  

@override final  String message;
 final  String? contentId;
 final  String? reason;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentNotAvailableFailureCopyWith<ContentNotAvailableFailure> get copyWith => _$ContentNotAvailableFailureCopyWithImpl<ContentNotAvailableFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentNotAvailableFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,contentId,reason,code);

@override
String toString() {
  return 'Failure.contentNotAvailable(message: $message, contentId: $contentId, reason: $reason, code: $code)';
}


}

/// @nodoc
abstract mixin class $ContentNotAvailableFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ContentNotAvailableFailureCopyWith(ContentNotAvailableFailure value, $Res Function(ContentNotAvailableFailure) _then) = _$ContentNotAvailableFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? contentId, String? reason, String? code
});




}
/// @nodoc
class _$ContentNotAvailableFailureCopyWithImpl<$Res>
    implements $ContentNotAvailableFailureCopyWith<$Res> {
  _$ContentNotAvailableFailureCopyWithImpl(this._self, this._then);

  final ContentNotAvailableFailure _self;
  final $Res Function(ContentNotAvailableFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? contentId = freezed,Object? reason = freezed,Object? code = freezed,}) {
  return _then(ContentNotAvailableFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,contentId: freezed == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class QuotaExceededFailure implements Failure {
  const QuotaExceededFailure({required this.message, this.currentUsage, this.limit, this.quotaType, this.code});
  

@override final  String message;
 final  int? currentUsage;
 final  int? limit;
 final  String? quotaType;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotaExceededFailureCopyWith<QuotaExceededFailure> get copyWith => _$QuotaExceededFailureCopyWithImpl<QuotaExceededFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotaExceededFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.currentUsage, currentUsage) || other.currentUsage == currentUsage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.quotaType, quotaType) || other.quotaType == quotaType)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,currentUsage,limit,quotaType,code);

@override
String toString() {
  return 'Failure.quotaExceeded(message: $message, currentUsage: $currentUsage, limit: $limit, quotaType: $quotaType, code: $code)';
}


}

/// @nodoc
abstract mixin class $QuotaExceededFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $QuotaExceededFailureCopyWith(QuotaExceededFailure value, $Res Function(QuotaExceededFailure) _then) = _$QuotaExceededFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? currentUsage, int? limit, String? quotaType, String? code
});




}
/// @nodoc
class _$QuotaExceededFailureCopyWithImpl<$Res>
    implements $QuotaExceededFailureCopyWith<$Res> {
  _$QuotaExceededFailureCopyWithImpl(this._self, this._then);

  final QuotaExceededFailure _self;
  final $Res Function(QuotaExceededFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? currentUsage = freezed,Object? limit = freezed,Object? quotaType = freezed,Object? code = freezed,}) {
  return _then(QuotaExceededFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,currentUsage: freezed == currentUsage ? _self.currentUsage : currentUsage // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,quotaType: freezed == quotaType ? _self.quotaType : quotaType // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConfigurationFailure implements Failure {
  const ConfigurationFailure({required this.message, this.configKey, this.code});
  

@override final  String message;
 final  String? configKey;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigurationFailureCopyWith<ConfigurationFailure> get copyWith => _$ConfigurationFailureCopyWithImpl<ConfigurationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigurationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.configKey, configKey) || other.configKey == configKey)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,configKey,code);

@override
String toString() {
  return 'Failure.configuration(message: $message, configKey: $configKey, code: $code)';
}


}

/// @nodoc
abstract mixin class $ConfigurationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConfigurationFailureCopyWith(ConfigurationFailure value, $Res Function(ConfigurationFailure) _then) = _$ConfigurationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? configKey, String? code
});




}
/// @nodoc
class _$ConfigurationFailureCopyWithImpl<$Res>
    implements $ConfigurationFailureCopyWith<$Res> {
  _$ConfigurationFailureCopyWithImpl(this._self, this._then);

  final ConfigurationFailure _self;
  final $Res Function(ConfigurationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? configKey = freezed,Object? code = freezed,}) {
  return _then(ConfigurationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,configKey: freezed == configKey ? _self.configKey : configKey // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DependencyFailure implements Failure {
  const DependencyFailure({required this.message, this.dependencyName, this.code});
  

@override final  String message;
 final  String? dependencyName;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyFailureCopyWith<DependencyFailure> get copyWith => _$DependencyFailureCopyWithImpl<DependencyFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DependencyFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.dependencyName, dependencyName) || other.dependencyName == dependencyName)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,dependencyName,code);

@override
String toString() {
  return 'Failure.dependency(message: $message, dependencyName: $dependencyName, code: $code)';
}


}

/// @nodoc
abstract mixin class $DependencyFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $DependencyFailureCopyWith(DependencyFailure value, $Res Function(DependencyFailure) _then) = _$DependencyFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? dependencyName, String? code
});




}
/// @nodoc
class _$DependencyFailureCopyWithImpl<$Res>
    implements $DependencyFailureCopyWith<$Res> {
  _$DependencyFailureCopyWithImpl(this._self, this._then);

  final DependencyFailure _self;
  final $Res Function(DependencyFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? dependencyName = freezed,Object? code = freezed,}) {
  return _then(DependencyFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,dependencyName: freezed == dependencyName ? _self.dependencyName : dependencyName // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnknownFailure implements Failure {
  const UnknownFailure({required this.message, this.originalError, this.stackTrace, this.code});
  

@override final  String message;
 final  String? originalError;
 final  String? stackTrace;
@override final  String? code;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.originalError, originalError) || other.originalError == originalError)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,originalError,stackTrace,code);

@override
String toString() {
  return 'Failure.unknown(message: $message, originalError: $originalError, stackTrace: $stackTrace, code: $code)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? originalError, String? stackTrace, String? code
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? originalError = freezed,Object? stackTrace = freezed,Object? code = freezed,}) {
  return _then(UnknownFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,originalError: freezed == originalError ? _self.originalError : originalError // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
