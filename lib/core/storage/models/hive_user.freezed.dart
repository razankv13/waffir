// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hive_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HiveUser {

@HiveField(0) String get id;@HiveField(1) String get email;@HiveField(2) String? get firstName;@HiveField(3) String? get lastName;@HiveField(4) String? get avatar;@HiveField(5) bool get isEmailVerified;@HiveField(6) DateTime get createdAt;@HiveField(7) DateTime get updatedAt;@HiveField(8) Map<String, dynamic>? get metadata;
/// Create a copy of HiveUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HiveUserCopyWith<HiveUser> get copyWith => _$HiveUserCopyWithImpl<HiveUser>(this as HiveUser, _$identity);

  /// Serializes this HiveUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HiveUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,avatar,isEmailVerified,createdAt,updatedAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'HiveUser(id: $id, email: $email, firstName: $firstName, lastName: $lastName, avatar: $avatar, isEmailVerified: $isEmailVerified, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $HiveUserCopyWith<$Res>  {
  factory $HiveUserCopyWith(HiveUser value, $Res Function(HiveUser) _then) = _$HiveUserCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String email,@HiveField(2) String? firstName,@HiveField(3) String? lastName,@HiveField(4) String? avatar,@HiveField(5) bool isEmailVerified,@HiveField(6) DateTime createdAt,@HiveField(7) DateTime updatedAt,@HiveField(8) Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$HiveUserCopyWithImpl<$Res>
    implements $HiveUserCopyWith<$Res> {
  _$HiveUserCopyWithImpl(this._self, this._then);

  final HiveUser _self;
  final $Res Function(HiveUser) _then;

/// Create a copy of HiveUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? avatar = freezed,Object? isEmailVerified = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HiveUser].
extension HiveUserPatterns on HiveUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HiveUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HiveUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HiveUser value)  $default,){
final _that = this;
switch (_that) {
case _HiveUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HiveUser value)?  $default,){
final _that = this;
switch (_that) {
case _HiveUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? firstName, @HiveField(3)  String? lastName, @HiveField(4)  String? avatar, @HiveField(5)  bool isEmailVerified, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime updatedAt, @HiveField(8)  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HiveUser() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.avatar,_that.isEmailVerified,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? firstName, @HiveField(3)  String? lastName, @HiveField(4)  String? avatar, @HiveField(5)  bool isEmailVerified, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime updatedAt, @HiveField(8)  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _HiveUser():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.avatar,_that.isEmailVerified,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String email, @HiveField(2)  String? firstName, @HiveField(3)  String? lastName, @HiveField(4)  String? avatar, @HiveField(5)  bool isEmailVerified, @HiveField(6)  DateTime createdAt, @HiveField(7)  DateTime updatedAt, @HiveField(8)  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _HiveUser() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.avatar,_that.isEmailVerified,_that.createdAt,_that.updatedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HiveUser extends HiveUser {
  const _HiveUser({@HiveField(0) required this.id, @HiveField(1) required this.email, @HiveField(2) this.firstName, @HiveField(3) this.lastName, @HiveField(4) this.avatar, @HiveField(5) this.isEmailVerified = false, @HiveField(6) required this.createdAt, @HiveField(7) required this.updatedAt, @HiveField(8) final  Map<String, dynamic>? metadata}): _metadata = metadata,super._();
  factory _HiveUser.fromJson(Map<String, dynamic> json) => _$HiveUserFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String email;
@override@HiveField(2) final  String? firstName;
@override@HiveField(3) final  String? lastName;
@override@HiveField(4) final  String? avatar;
@override@JsonKey()@HiveField(5) final  bool isEmailVerified;
@override@HiveField(6) final  DateTime createdAt;
@override@HiveField(7) final  DateTime updatedAt;
 final  Map<String, dynamic>? _metadata;
@override@HiveField(8) Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HiveUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiveUserCopyWith<_HiveUser> get copyWith => __$HiveUserCopyWithImpl<_HiveUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HiveUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HiveUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,avatar,isEmailVerified,createdAt,updatedAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'HiveUser(id: $id, email: $email, firstName: $firstName, lastName: $lastName, avatar: $avatar, isEmailVerified: $isEmailVerified, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$HiveUserCopyWith<$Res> implements $HiveUserCopyWith<$Res> {
  factory _$HiveUserCopyWith(_HiveUser value, $Res Function(_HiveUser) _then) = __$HiveUserCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String email,@HiveField(2) String? firstName,@HiveField(3) String? lastName,@HiveField(4) String? avatar,@HiveField(5) bool isEmailVerified,@HiveField(6) DateTime createdAt,@HiveField(7) DateTime updatedAt,@HiveField(8) Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$HiveUserCopyWithImpl<$Res>
    implements _$HiveUserCopyWith<$Res> {
  __$HiveUserCopyWithImpl(this._self, this._then);

  final _HiveUser _self;
  final $Res Function(_HiveUser) _then;

/// Create a copy of HiveUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? avatar = freezed,Object? isEmailVerified = null,Object? createdAt = null,Object? updatedAt = null,Object? metadata = freezed,}) {
  return _then(_HiveUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
