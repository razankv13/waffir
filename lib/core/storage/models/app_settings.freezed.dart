// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

@HiveField(0) String get themeMode;@HiveField(1) String get languageCode;@HiveField(2) bool get notificationsEnabled;@HiveField(3) bool get biometricsEnabled;@HiveField(4) bool get onboardingCompleted;@HiveField(5) DateTime? get lastSyncTime;@HiveField(6) String? get lastKnownVersion;@HiveField(7) Map<String, bool>? get featureFlags;@HiveField(8) Map<String, dynamic>? get preferences;@HiveField(9) bool get analyticsEnabled;@HiveField(10) bool get crashReportingEnabled;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.biometricsEnabled, biometricsEnabled) || other.biometricsEnabled == biometricsEnabled)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.lastKnownVersion, lastKnownVersion) || other.lastKnownVersion == lastKnownVersion)&&const DeepCollectionEquality().equals(other.featureFlags, featureFlags)&&const DeepCollectionEquality().equals(other.preferences, preferences)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled)&&(identical(other.crashReportingEnabled, crashReportingEnabled) || other.crashReportingEnabled == crashReportingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,languageCode,notificationsEnabled,biometricsEnabled,onboardingCompleted,lastSyncTime,lastKnownVersion,const DeepCollectionEquality().hash(featureFlags),const DeepCollectionEquality().hash(preferences),analyticsEnabled,crashReportingEnabled);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, languageCode: $languageCode, notificationsEnabled: $notificationsEnabled, biometricsEnabled: $biometricsEnabled, onboardingCompleted: $onboardingCompleted, lastSyncTime: $lastSyncTime, lastKnownVersion: $lastKnownVersion, featureFlags: $featureFlags, preferences: $preferences, analyticsEnabled: $analyticsEnabled, crashReportingEnabled: $crashReportingEnabled)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String themeMode,@HiveField(1) String languageCode,@HiveField(2) bool notificationsEnabled,@HiveField(3) bool biometricsEnabled,@HiveField(4) bool onboardingCompleted,@HiveField(5) DateTime? lastSyncTime,@HiveField(6) String? lastKnownVersion,@HiveField(7) Map<String, bool>? featureFlags,@HiveField(8) Map<String, dynamic>? preferences,@HiveField(9) bool analyticsEnabled,@HiveField(10) bool crashReportingEnabled
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? languageCode = null,Object? notificationsEnabled = null,Object? biometricsEnabled = null,Object? onboardingCompleted = null,Object? lastSyncTime = freezed,Object? lastKnownVersion = freezed,Object? featureFlags = freezed,Object? preferences = freezed,Object? analyticsEnabled = null,Object? crashReportingEnabled = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricsEnabled: null == biometricsEnabled ? _self.biometricsEnabled : biometricsEnabled // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastKnownVersion: freezed == lastKnownVersion ? _self.lastKnownVersion : lastKnownVersion // ignore: cast_nullable_to_non_nullable
as String?,featureFlags: freezed == featureFlags ? _self.featureFlags : featureFlags // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,preferences: freezed == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,crashReportingEnabled: null == crashReportingEnabled ? _self.crashReportingEnabled : crashReportingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String themeMode, @HiveField(1)  String languageCode, @HiveField(2)  bool notificationsEnabled, @HiveField(3)  bool biometricsEnabled, @HiveField(4)  bool onboardingCompleted, @HiveField(5)  DateTime? lastSyncTime, @HiveField(6)  String? lastKnownVersion, @HiveField(7)  Map<String, bool>? featureFlags, @HiveField(8)  Map<String, dynamic>? preferences, @HiveField(9)  bool analyticsEnabled, @HiveField(10)  bool crashReportingEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.languageCode,_that.notificationsEnabled,_that.biometricsEnabled,_that.onboardingCompleted,_that.lastSyncTime,_that.lastKnownVersion,_that.featureFlags,_that.preferences,_that.analyticsEnabled,_that.crashReportingEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String themeMode, @HiveField(1)  String languageCode, @HiveField(2)  bool notificationsEnabled, @HiveField(3)  bool biometricsEnabled, @HiveField(4)  bool onboardingCompleted, @HiveField(5)  DateTime? lastSyncTime, @HiveField(6)  String? lastKnownVersion, @HiveField(7)  Map<String, bool>? featureFlags, @HiveField(8)  Map<String, dynamic>? preferences, @HiveField(9)  bool analyticsEnabled, @HiveField(10)  bool crashReportingEnabled)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.themeMode,_that.languageCode,_that.notificationsEnabled,_that.biometricsEnabled,_that.onboardingCompleted,_that.lastSyncTime,_that.lastKnownVersion,_that.featureFlags,_that.preferences,_that.analyticsEnabled,_that.crashReportingEnabled);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String themeMode, @HiveField(1)  String languageCode, @HiveField(2)  bool notificationsEnabled, @HiveField(3)  bool biometricsEnabled, @HiveField(4)  bool onboardingCompleted, @HiveField(5)  DateTime? lastSyncTime, @HiveField(6)  String? lastKnownVersion, @HiveField(7)  Map<String, bool>? featureFlags, @HiveField(8)  Map<String, dynamic>? preferences, @HiveField(9)  bool analyticsEnabled, @HiveField(10)  bool crashReportingEnabled)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.languageCode,_that.notificationsEnabled,_that.biometricsEnabled,_that.onboardingCompleted,_that.lastSyncTime,_that.lastKnownVersion,_that.featureFlags,_that.preferences,_that.analyticsEnabled,_that.crashReportingEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings extends AppSettings {
  const _AppSettings({@HiveField(0) this.themeMode = 'system', @HiveField(1) this.languageCode = 'en', @HiveField(2) this.notificationsEnabled = true, @HiveField(3) this.biometricsEnabled = false, @HiveField(4) this.onboardingCompleted = false, @HiveField(5) this.lastSyncTime, @HiveField(6) this.lastKnownVersion, @HiveField(7) final  Map<String, bool>? featureFlags, @HiveField(8) final  Map<String, dynamic>? preferences, @HiveField(9) this.analyticsEnabled = true, @HiveField(10) this.crashReportingEnabled = true}): _featureFlags = featureFlags,_preferences = preferences,super._();
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey()@HiveField(0) final  String themeMode;
@override@JsonKey()@HiveField(1) final  String languageCode;
@override@JsonKey()@HiveField(2) final  bool notificationsEnabled;
@override@JsonKey()@HiveField(3) final  bool biometricsEnabled;
@override@JsonKey()@HiveField(4) final  bool onboardingCompleted;
@override@HiveField(5) final  DateTime? lastSyncTime;
@override@HiveField(6) final  String? lastKnownVersion;
 final  Map<String, bool>? _featureFlags;
@override@HiveField(7) Map<String, bool>? get featureFlags {
  final value = _featureFlags;
  if (value == null) return null;
  if (_featureFlags is EqualUnmodifiableMapView) return _featureFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _preferences;
@override@HiveField(8) Map<String, dynamic>? get preferences {
  final value = _preferences;
  if (value == null) return null;
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey()@HiveField(9) final  bool analyticsEnabled;
@override@JsonKey()@HiveField(10) final  bool crashReportingEnabled;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.biometricsEnabled, biometricsEnabled) || other.biometricsEnabled == biometricsEnabled)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.lastKnownVersion, lastKnownVersion) || other.lastKnownVersion == lastKnownVersion)&&const DeepCollectionEquality().equals(other._featureFlags, _featureFlags)&&const DeepCollectionEquality().equals(other._preferences, _preferences)&&(identical(other.analyticsEnabled, analyticsEnabled) || other.analyticsEnabled == analyticsEnabled)&&(identical(other.crashReportingEnabled, crashReportingEnabled) || other.crashReportingEnabled == crashReportingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,languageCode,notificationsEnabled,biometricsEnabled,onboardingCompleted,lastSyncTime,lastKnownVersion,const DeepCollectionEquality().hash(_featureFlags),const DeepCollectionEquality().hash(_preferences),analyticsEnabled,crashReportingEnabled);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, languageCode: $languageCode, notificationsEnabled: $notificationsEnabled, biometricsEnabled: $biometricsEnabled, onboardingCompleted: $onboardingCompleted, lastSyncTime: $lastSyncTime, lastKnownVersion: $lastKnownVersion, featureFlags: $featureFlags, preferences: $preferences, analyticsEnabled: $analyticsEnabled, crashReportingEnabled: $crashReportingEnabled)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String themeMode,@HiveField(1) String languageCode,@HiveField(2) bool notificationsEnabled,@HiveField(3) bool biometricsEnabled,@HiveField(4) bool onboardingCompleted,@HiveField(5) DateTime? lastSyncTime,@HiveField(6) String? lastKnownVersion,@HiveField(7) Map<String, bool>? featureFlags,@HiveField(8) Map<String, dynamic>? preferences,@HiveField(9) bool analyticsEnabled,@HiveField(10) bool crashReportingEnabled
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? languageCode = null,Object? notificationsEnabled = null,Object? biometricsEnabled = null,Object? onboardingCompleted = null,Object? lastSyncTime = freezed,Object? lastKnownVersion = freezed,Object? featureFlags = freezed,Object? preferences = freezed,Object? analyticsEnabled = null,Object? crashReportingEnabled = null,}) {
  return _then(_AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricsEnabled: null == biometricsEnabled ? _self.biometricsEnabled : biometricsEnabled // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastKnownVersion: freezed == lastKnownVersion ? _self.lastKnownVersion : lastKnownVersion // ignore: cast_nullable_to_non_nullable
as String?,featureFlags: freezed == featureFlags ? _self._featureFlags : featureFlags // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,preferences: freezed == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,analyticsEnabled: null == analyticsEnabled ? _self.analyticsEnabled : analyticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,crashReportingEnabled: null == crashReportingEnabled ? _self.crashReportingEnabled : crashReportingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
