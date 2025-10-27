// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Review {

 String get id; String get productId; String get userId; double get rating; String get comment; String? get userName; String? get userAvatarUrl; List<String> get imageUrls; int get helpfulCount; bool get isVerifiedPurchase; DateTime? get createdAt;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount)&&(identical(other.isVerifiedPurchase, isVerifiedPurchase) || other.isVerifiedPurchase == isVerifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,userId,rating,comment,userName,userAvatarUrl,const DeepCollectionEquality().hash(imageUrls),helpfulCount,isVerifiedPurchase,createdAt);

@override
String toString() {
  return 'Review(id: $id, productId: $productId, userId: $userId, rating: $rating, comment: $comment, userName: $userName, userAvatarUrl: $userAvatarUrl, imageUrls: $imageUrls, helpfulCount: $helpfulCount, isVerifiedPurchase: $isVerifiedPurchase, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String userId, double rating, String comment, String? userName, String? userAvatarUrl, List<String> imageUrls, int helpfulCount, bool isVerifiedPurchase, DateTime? createdAt
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? userId = null,Object? rating = null,Object? comment = null,Object? userName = freezed,Object? userAvatarUrl = freezed,Object? imageUrls = null,Object? helpfulCount = null,Object? isVerifiedPurchase = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,isVerifiedPurchase: null == isVerifiedPurchase ? _self.isVerifiedPurchase : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String userId,  double rating,  String comment,  String? userName,  String? userAvatarUrl,  List<String> imageUrls,  int helpfulCount,  bool isVerifiedPurchase,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.productId,_that.userId,_that.rating,_that.comment,_that.userName,_that.userAvatarUrl,_that.imageUrls,_that.helpfulCount,_that.isVerifiedPurchase,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String userId,  double rating,  String comment,  String? userName,  String? userAvatarUrl,  List<String> imageUrls,  int helpfulCount,  bool isVerifiedPurchase,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.productId,_that.userId,_that.rating,_that.comment,_that.userName,_that.userAvatarUrl,_that.imageUrls,_that.helpfulCount,_that.isVerifiedPurchase,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String userId,  double rating,  String comment,  String? userName,  String? userAvatarUrl,  List<String> imageUrls,  int helpfulCount,  bool isVerifiedPurchase,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.productId,_that.userId,_that.rating,_that.comment,_that.userName,_that.userAvatarUrl,_that.imageUrls,_that.helpfulCount,_that.isVerifiedPurchase,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, required this.productId, required this.userId, required this.rating, required this.comment, this.userName, this.userAvatarUrl, final  List<String> imageUrls = const [], this.helpfulCount = 0, this.isVerifiedPurchase = false, this.createdAt}): _imageUrls = imageUrls;
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String id;
@override final  String productId;
@override final  String userId;
@override final  double rating;
@override final  String comment;
@override final  String? userName;
@override final  String? userAvatarUrl;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  int helpfulCount;
@override@JsonKey() final  bool isVerifiedPurchase;
@override final  DateTime? createdAt;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount)&&(identical(other.isVerifiedPurchase, isVerifiedPurchase) || other.isVerifiedPurchase == isVerifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,userId,rating,comment,userName,userAvatarUrl,const DeepCollectionEquality().hash(_imageUrls),helpfulCount,isVerifiedPurchase,createdAt);

@override
String toString() {
  return 'Review(id: $id, productId: $productId, userId: $userId, rating: $rating, comment: $comment, userName: $userName, userAvatarUrl: $userAvatarUrl, imageUrls: $imageUrls, helpfulCount: $helpfulCount, isVerifiedPurchase: $isVerifiedPurchase, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String userId, double rating, String comment, String? userName, String? userAvatarUrl, List<String> imageUrls, int helpfulCount, bool isVerifiedPurchase, DateTime? createdAt
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? userId = null,Object? rating = null,Object? comment = null,Object? userName = freezed,Object? userAvatarUrl = freezed,Object? imageUrls = null,Object? helpfulCount = null,Object? isVerifiedPurchase = null,Object? createdAt = freezed,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,isVerifiedPurchase: null == isVerifiedPurchase ? _self.isVerifiedPurchase : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
