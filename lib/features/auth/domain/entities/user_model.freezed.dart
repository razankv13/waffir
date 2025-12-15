// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

@HiveField(0) String get id;@HiveField(1) String get email;@HiveField(2) String? get displayName;@HiveField(3) String? get photoURL;@HiveField(4) String? get phoneNumber;@HiveField(5) bool get emailVerified;@HiveField(6) bool get isAnonymous;@HiveField(7) DateTime? get createdAt;@HiveField(8) DateTime? get lastSignInAt;@HiveField(9) Map<String, dynamic>? get metadata;// Custom fields for app-specific data
@HiveField(10) String? get firstName;@HiveField(11) String? get lastName;@HiveField(12) String? get dateOfBirth;@HiveField(13) String? get gender;@HiveField(14) String? get country;@HiveField(15) String? get language;@HiveField(16) String? get timezone;@HiveField(17) List<String> get roles;@HiveField(18) Map<String, dynamic> get preferences;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.country, country) || other.country == country)&&(identical(other.language, language) || other.language == language)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,displayName,photoURL,phoneNumber,emailVerified,isAnonymous,createdAt,lastSignInAt,const DeepCollectionEquality().hash(metadata),firstName,lastName,dateOfBirth,gender,country,language,timezone,const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(preferences)]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, emailVerified: $emailVerified, isAnonymous: $isAnonymous, createdAt: $createdAt, lastSignInAt: $lastSignInAt, metadata: $metadata, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, country: $country, language: $language, timezone: $timezone, roles: $roles, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String email,@HiveField(2) String? displayName,@HiveField(3) String? photoURL,@HiveField(4) String? phoneNumber,@HiveField(5) bool emailVerified,@HiveField(6) bool isAnonymous,@HiveField(7) DateTime? createdAt,@HiveField(8) DateTime? lastSignInAt,@HiveField(9) Map<String, dynamic>? metadata,@HiveField(10) String? firstName,@HiveField(11) String? lastName,@HiveField(12) String? dateOfBirth,@HiveField(13) String? gender,@HiveField(14) String? country,@HiveField(15) String? language,@HiveField(16) String? timezone,@HiveField(17) List<String> roles,@HiveField(18) Map<String, dynamic> preferences
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = freezed,Object? photoURL = freezed,Object? phoneNumber = freezed,Object? emailVerified = null,Object? isAnonymous = null,Object? createdAt = freezed,Object? lastSignInAt = freezed,Object? metadata = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? country = freezed,Object? language = freezed,Object? timezone = freezed,Object? roles = null,Object? preferences = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? displayName, @HiveField(3)  String? photoURL, @HiveField(4)  String? phoneNumber, @HiveField(5)  bool emailVerified, @HiveField(6)  bool isAnonymous, @HiveField(7)  DateTime? createdAt, @HiveField(8)  DateTime? lastSignInAt, @HiveField(9)  Map<String, dynamic>? metadata, @HiveField(10)  String? firstName, @HiveField(11)  String? lastName, @HiveField(12)  String? dateOfBirth, @HiveField(13)  String? gender, @HiveField(14)  String? country, @HiveField(15)  String? language, @HiveField(16)  String? timezone, @HiveField(17)  List<String> roles, @HiveField(18)  Map<String, dynamic> preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.emailVerified,_that.isAnonymous,_that.createdAt,_that.lastSignInAt,_that.metadata,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.country,_that.language,_that.timezone,_that.roles,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? displayName, @HiveField(3)  String? photoURL, @HiveField(4)  String? phoneNumber, @HiveField(5)  bool emailVerified, @HiveField(6)  bool isAnonymous, @HiveField(7)  DateTime? createdAt, @HiveField(8)  DateTime? lastSignInAt, @HiveField(9)  Map<String, dynamic>? metadata, @HiveField(10)  String? firstName, @HiveField(11)  String? lastName, @HiveField(12)  String? dateOfBirth, @HiveField(13)  String? gender, @HiveField(14)  String? country, @HiveField(15)  String? language, @HiveField(16)  String? timezone, @HiveField(17)  List<String> roles, @HiveField(18)  Map<String, dynamic> preferences)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.emailVerified,_that.isAnonymous,_that.createdAt,_that.lastSignInAt,_that.metadata,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.country,_that.language,_that.timezone,_that.roles,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? displayName, @HiveField(3)  String? photoURL, @HiveField(4)  String? phoneNumber, @HiveField(5)  bool emailVerified, @HiveField(6)  bool isAnonymous, @HiveField(7)  DateTime? createdAt, @HiveField(8)  DateTime? lastSignInAt, @HiveField(9)  Map<String, dynamic>? metadata, @HiveField(10)  String? firstName, @HiveField(11)  String? lastName, @HiveField(12)  String? dateOfBirth, @HiveField(13)  String? gender, @HiveField(14)  String? country, @HiveField(15)  String? language, @HiveField(16)  String? timezone, @HiveField(17)  List<String> roles, @HiveField(18)  Map<String, dynamic> preferences)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.emailVerified,_that.isAnonymous,_that.createdAt,_that.lastSignInAt,_that.metadata,_that.firstName,_that.lastName,_that.dateOfBirth,_that.gender,_that.country,_that.language,_that.timezone,_that.roles,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({@HiveField(0) required this.id, @HiveField(1) required this.email, @HiveField(2) this.displayName, @HiveField(3) this.photoURL, @HiveField(4) this.phoneNumber, @HiveField(5) this.emailVerified = false, @HiveField(6) this.isAnonymous = false, @HiveField(7) this.createdAt, @HiveField(8) this.lastSignInAt, @HiveField(9) final  Map<String, dynamic>? metadata, @HiveField(10) this.firstName, @HiveField(11) this.lastName, @HiveField(12) this.dateOfBirth, @HiveField(13) this.gender, @HiveField(14) this.country, @HiveField(15) this.language, @HiveField(16) this.timezone, @HiveField(17) final  List<String> roles = const <String>[], @HiveField(18) final  Map<String, dynamic> preferences = const <String, dynamic>{}}): _metadata = metadata,_roles = roles,_preferences = preferences;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String email;
@override@HiveField(2) final  String? displayName;
@override@HiveField(3) final  String? photoURL;
@override@HiveField(4) final  String? phoneNumber;
@override@JsonKey()@HiveField(5) final  bool emailVerified;
@override@JsonKey()@HiveField(6) final  bool isAnonymous;
@override@HiveField(7) final  DateTime? createdAt;
@override@HiveField(8) final  DateTime? lastSignInAt;
 final  Map<String, dynamic>? _metadata;
@override@HiveField(9) Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Custom fields for app-specific data
@override@HiveField(10) final  String? firstName;
@override@HiveField(11) final  String? lastName;
@override@HiveField(12) final  String? dateOfBirth;
@override@HiveField(13) final  String? gender;
@override@HiveField(14) final  String? country;
@override@HiveField(15) final  String? language;
@override@HiveField(16) final  String? timezone;
 final  List<String> _roles;
@override@JsonKey()@HiveField(17) List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

 final  Map<String, dynamic> _preferences;
@override@JsonKey()@HiveField(18) Map<String, dynamic> get preferences {
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preferences);
}


/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.country, country) || other.country == country)&&(identical(other.language, language) || other.language == language)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._roles, _roles)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,displayName,photoURL,phoneNumber,emailVerified,isAnonymous,createdAt,lastSignInAt,const DeepCollectionEquality().hash(_metadata),firstName,lastName,dateOfBirth,gender,country,language,timezone,const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_preferences)]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, emailVerified: $emailVerified, isAnonymous: $isAnonymous, createdAt: $createdAt, lastSignInAt: $lastSignInAt, metadata: $metadata, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, country: $country, language: $language, timezone: $timezone, roles: $roles, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String email,@HiveField(2) String? displayName,@HiveField(3) String? photoURL,@HiveField(4) String? phoneNumber,@HiveField(5) bool emailVerified,@HiveField(6) bool isAnonymous,@HiveField(7) DateTime? createdAt,@HiveField(8) DateTime? lastSignInAt,@HiveField(9) Map<String, dynamic>? metadata,@HiveField(10) String? firstName,@HiveField(11) String? lastName,@HiveField(12) String? dateOfBirth,@HiveField(13) String? gender,@HiveField(14) String? country,@HiveField(15) String? language,@HiveField(16) String? timezone,@HiveField(17) List<String> roles,@HiveField(18) Map<String, dynamic> preferences
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = freezed,Object? photoURL = freezed,Object? phoneNumber = freezed,Object? emailVerified = null,Object? isAnonymous = null,Object? createdAt = freezed,Object? lastSignInAt = freezed,Object? metadata = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? country = freezed,Object? language = freezed,Object? timezone = freezed,Object? roles = null,Object? preferences = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
