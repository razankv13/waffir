// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _Error value)?  error,TResult Function( _EmailVerificationRequired value)?  emailVerificationRequired,TResult Function( _PhoneVerificationRequired value)?  phoneVerificationRequired,TResult Function( _MfaRequired value)?  mfaRequired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case _PhoneVerificationRequired() when phoneVerificationRequired != null:
return phoneVerificationRequired(_that);case _MfaRequired() when mfaRequired != null:
return mfaRequired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _Error value)  error,required TResult Function( _EmailVerificationRequired value)  emailVerificationRequired,required TResult Function( _PhoneVerificationRequired value)  phoneVerificationRequired,required TResult Function( _MfaRequired value)  mfaRequired,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Authenticated():
return authenticated(_that);case _Unauthenticated():
return unauthenticated(_that);case _Error():
return error(_that);case _EmailVerificationRequired():
return emailVerificationRequired(_that);case _PhoneVerificationRequired():
return phoneVerificationRequired(_that);case _MfaRequired():
return mfaRequired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _Error value)?  error,TResult? Function( _EmailVerificationRequired value)?  emailVerificationRequired,TResult? Function( _PhoneVerificationRequired value)?  phoneVerificationRequired,TResult? Function( _MfaRequired value)?  mfaRequired,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Error() when error != null:
return error(_that);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case _PhoneVerificationRequired() when phoneVerificationRequired != null:
return phoneVerificationRequired(_that);case _MfaRequired() when mfaRequired != null:
return mfaRequired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserModel user,  String? idToken,  String? refreshToken,  DateTime? tokenExpiry)?  authenticated,TResult Function( String? message)?  unauthenticated,TResult Function( String message,  String? code,  dynamic exception)?  error,TResult Function( UserModel user,  String? message)?  emailVerificationRequired,TResult Function( String verificationId,  String phoneNumber,  String? message)?  phoneVerificationRequired,TResult Function( String multiFactorSession,  List<String> availableFactors,  String? message)?  mfaRequired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.idToken,_that.refreshToken,_that.tokenExpiry);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case _Error() when error != null:
return error(_that.message,_that.code,_that.exception);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.user,_that.message);case _PhoneVerificationRequired() when phoneVerificationRequired != null:
return phoneVerificationRequired(_that.verificationId,_that.phoneNumber,_that.message);case _MfaRequired() when mfaRequired != null:
return mfaRequired(_that.multiFactorSession,_that.availableFactors,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserModel user,  String? idToken,  String? refreshToken,  DateTime? tokenExpiry)  authenticated,required TResult Function( String? message)  unauthenticated,required TResult Function( String message,  String? code,  dynamic exception)  error,required TResult Function( UserModel user,  String? message)  emailVerificationRequired,required TResult Function( String verificationId,  String phoneNumber,  String? message)  phoneVerificationRequired,required TResult Function( String multiFactorSession,  List<String> availableFactors,  String? message)  mfaRequired,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Authenticated():
return authenticated(_that.user,_that.idToken,_that.refreshToken,_that.tokenExpiry);case _Unauthenticated():
return unauthenticated(_that.message);case _Error():
return error(_that.message,_that.code,_that.exception);case _EmailVerificationRequired():
return emailVerificationRequired(_that.user,_that.message);case _PhoneVerificationRequired():
return phoneVerificationRequired(_that.verificationId,_that.phoneNumber,_that.message);case _MfaRequired():
return mfaRequired(_that.multiFactorSession,_that.availableFactors,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserModel user,  String? idToken,  String? refreshToken,  DateTime? tokenExpiry)?  authenticated,TResult? Function( String? message)?  unauthenticated,TResult? Function( String message,  String? code,  dynamic exception)?  error,TResult? Function( UserModel user,  String? message)?  emailVerificationRequired,TResult? Function( String verificationId,  String phoneNumber,  String? message)?  phoneVerificationRequired,TResult? Function( String multiFactorSession,  List<String> availableFactors,  String? message)?  mfaRequired,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.idToken,_that.refreshToken,_that.tokenExpiry);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case _Error() when error != null:
return error(_that.message,_that.code,_that.exception);case _EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.user,_that.message);case _PhoneVerificationRequired() when phoneVerificationRequired != null:
return phoneVerificationRequired(_that.verificationId,_that.phoneNumber,_that.message);case _MfaRequired() when mfaRequired != null:
return mfaRequired(_that.multiFactorSession,_that.availableFactors,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated({required this.user, this.idToken, this.refreshToken, this.tokenExpiry});
  

 final  UserModel user;
 final  String? idToken;
 final  String? refreshToken;
 final  DateTime? tokenExpiry;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.idToken, idToken) || other.idToken == idToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenExpiry, tokenExpiry) || other.tokenExpiry == tokenExpiry));
}


@override
int get hashCode => Object.hash(runtimeType,user,idToken,refreshToken,tokenExpiry);

@override
String toString() {
  return 'AuthState.authenticated(user: $user, idToken: $idToken, refreshToken: $refreshToken, tokenExpiry: $tokenExpiry)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserModel user, String? idToken, String? refreshToken, DateTime? tokenExpiry
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? idToken = freezed,Object? refreshToken = freezed,Object? tokenExpiry = freezed,}) {
  return _then(_Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,idToken: freezed == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,tokenExpiry: freezed == tokenExpiry ? _self.tokenExpiry : tokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated({this.message});
  

 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthenticatedCopyWith<_Unauthenticated> get copyWith => __$UnauthenticatedCopyWithImpl<_Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.unauthenticated(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$UnauthenticatedCopyWith(_Unauthenticated value, $Res Function(_Unauthenticated) _then) = __$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnauthenticatedCopyWithImpl<$Res>
    implements _$UnauthenticatedCopyWith<$Res> {
  __$UnauthenticatedCopyWithImpl(this._self, this._then);

  final _Unauthenticated _self;
  final $Res Function(_Unauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Unauthenticated(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements AuthState {
  const _Error({required this.message, this.code, this.exception});
  

 final  String message;
 final  String? code;
 final  dynamic exception;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.exception, exception));
}


@override
int get hashCode => Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(exception));

@override
String toString() {
  return 'AuthState.error(message: $message, code: $code, exception: $exception)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? code, dynamic exception
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,Object? exception = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class _EmailVerificationRequired implements AuthState {
  const _EmailVerificationRequired({required this.user, this.message});
  

 final  UserModel user;
 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailVerificationRequiredCopyWith<_EmailVerificationRequired> get copyWith => __$EmailVerificationRequiredCopyWithImpl<_EmailVerificationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailVerificationRequired&&(identical(other.user, user) || other.user == user)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,user,message);

@override
String toString() {
  return 'AuthState.emailVerificationRequired(user: $user, message: $message)';
}


}

/// @nodoc
abstract mixin class _$EmailVerificationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$EmailVerificationRequiredCopyWith(_EmailVerificationRequired value, $Res Function(_EmailVerificationRequired) _then) = __$EmailVerificationRequiredCopyWithImpl;
@useResult
$Res call({
 UserModel user, String? message
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$EmailVerificationRequiredCopyWithImpl<$Res>
    implements _$EmailVerificationRequiredCopyWith<$Res> {
  __$EmailVerificationRequiredCopyWithImpl(this._self, this._then);

  final _EmailVerificationRequired _self;
  final $Res Function(_EmailVerificationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? message = freezed,}) {
  return _then(_EmailVerificationRequired(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class _PhoneVerificationRequired implements AuthState {
  const _PhoneVerificationRequired({required this.verificationId, required this.phoneNumber, this.message});
  

 final  String verificationId;
 final  String phoneNumber;
 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneVerificationRequiredCopyWith<_PhoneVerificationRequired> get copyWith => __$PhoneVerificationRequiredCopyWithImpl<_PhoneVerificationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerificationRequired&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,verificationId,phoneNumber,message);

@override
String toString() {
  return 'AuthState.phoneVerificationRequired(verificationId: $verificationId, phoneNumber: $phoneNumber, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PhoneVerificationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$PhoneVerificationRequiredCopyWith(_PhoneVerificationRequired value, $Res Function(_PhoneVerificationRequired) _then) = __$PhoneVerificationRequiredCopyWithImpl;
@useResult
$Res call({
 String verificationId, String phoneNumber, String? message
});




}
/// @nodoc
class __$PhoneVerificationRequiredCopyWithImpl<$Res>
    implements _$PhoneVerificationRequiredCopyWith<$Res> {
  __$PhoneVerificationRequiredCopyWithImpl(this._self, this._then);

  final _PhoneVerificationRequired _self;
  final $Res Function(_PhoneVerificationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? verificationId = null,Object? phoneNumber = null,Object? message = freezed,}) {
  return _then(_PhoneVerificationRequired(
verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _MfaRequired implements AuthState {
  const _MfaRequired({required this.multiFactorSession, required final  List<String> availableFactors, this.message}): _availableFactors = availableFactors;
  

 final  String multiFactorSession;
 final  List<String> _availableFactors;
 List<String> get availableFactors {
  if (_availableFactors is EqualUnmodifiableListView) return _availableFactors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableFactors);
}

 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MfaRequiredCopyWith<_MfaRequired> get copyWith => __$MfaRequiredCopyWithImpl<_MfaRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MfaRequired&&(identical(other.multiFactorSession, multiFactorSession) || other.multiFactorSession == multiFactorSession)&&const DeepCollectionEquality().equals(other._availableFactors, _availableFactors)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,multiFactorSession,const DeepCollectionEquality().hash(_availableFactors),message);

@override
String toString() {
  return 'AuthState.mfaRequired(multiFactorSession: $multiFactorSession, availableFactors: $availableFactors, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MfaRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$MfaRequiredCopyWith(_MfaRequired value, $Res Function(_MfaRequired) _then) = __$MfaRequiredCopyWithImpl;
@useResult
$Res call({
 String multiFactorSession, List<String> availableFactors, String? message
});




}
/// @nodoc
class __$MfaRequiredCopyWithImpl<$Res>
    implements _$MfaRequiredCopyWith<$Res> {
  __$MfaRequiredCopyWithImpl(this._self, this._then);

  final _MfaRequired _self;
  final $Res Function(_MfaRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? multiFactorSession = null,Object? availableFactors = null,Object? message = freezed,}) {
  return _then(_MfaRequired(
multiFactorSession: null == multiFactorSession ? _self.multiFactorSession : multiFactorSession // ignore: cast_nullable_to_non_nullable
as String,availableFactors: null == availableFactors ? _self._availableFactors : availableFactors // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
