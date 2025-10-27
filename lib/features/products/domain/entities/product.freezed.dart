// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get title; String get description; double get price; List<String> get imageUrls; String get categoryId; String? get brand; double? get originalPrice; int? get discountPercentage; double? get rating; int? get reviewCount; List<String> get availableSizes; List<String> get availableColors; String? get badge; String? get badgeType; int get stockQuantity; bool get isAvailable; bool get isFeatured; bool get isFavorite; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other.availableSizes, availableSizes)&&const DeepCollectionEquality().equals(other.availableColors, availableColors)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.badgeType, badgeType) || other.badgeType == badgeType)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,description,price,const DeepCollectionEquality().hash(imageUrls),categoryId,brand,originalPrice,discountPercentage,rating,reviewCount,const DeepCollectionEquality().hash(availableSizes),const DeepCollectionEquality().hash(availableColors),badge,badgeType,stockQuantity,isAvailable,isFeatured,isFavorite,createdAt,updatedAt]);

@override
String toString() {
  return 'Product(id: $id, title: $title, description: $description, price: $price, imageUrls: $imageUrls, categoryId: $categoryId, brand: $brand, originalPrice: $originalPrice, discountPercentage: $discountPercentage, rating: $rating, reviewCount: $reviewCount, availableSizes: $availableSizes, availableColors: $availableColors, badge: $badge, badgeType: $badgeType, stockQuantity: $stockQuantity, isAvailable: $isAvailable, isFeatured: $isFeatured, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, double price, List<String> imageUrls, String categoryId, String? brand, double? originalPrice, int? discountPercentage, double? rating, int? reviewCount, List<String> availableSizes, List<String> availableColors, String? badge, String? badgeType, int stockQuantity, bool isAvailable, bool isFeatured, bool isFavorite, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? price = null,Object? imageUrls = null,Object? categoryId = null,Object? brand = freezed,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? rating = freezed,Object? reviewCount = freezed,Object? availableSizes = null,Object? availableColors = null,Object? badge = freezed,Object? badgeType = freezed,Object? stockQuantity = null,Object? isAvailable = null,Object? isFeatured = null,Object? isFavorite = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,availableSizes: null == availableSizes ? _self.availableSizes : availableSizes // ignore: cast_nullable_to_non_nullable
as List<String>,availableColors: null == availableColors ? _self.availableColors : availableColors // ignore: cast_nullable_to_non_nullable
as List<String>,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,badgeType: freezed == badgeType ? _self.badgeType : badgeType // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double price,  List<String> imageUrls,  String categoryId,  String? brand,  double? originalPrice,  int? discountPercentage,  double? rating,  int? reviewCount,  List<String> availableSizes,  List<String> availableColors,  String? badge,  String? badgeType,  int stockQuantity,  bool isAvailable,  bool isFeatured,  bool isFavorite,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.price,_that.imageUrls,_that.categoryId,_that.brand,_that.originalPrice,_that.discountPercentage,_that.rating,_that.reviewCount,_that.availableSizes,_that.availableColors,_that.badge,_that.badgeType,_that.stockQuantity,_that.isAvailable,_that.isFeatured,_that.isFavorite,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double price,  List<String> imageUrls,  String categoryId,  String? brand,  double? originalPrice,  int? discountPercentage,  double? rating,  int? reviewCount,  List<String> availableSizes,  List<String> availableColors,  String? badge,  String? badgeType,  int stockQuantity,  bool isAvailable,  bool isFeatured,  bool isFavorite,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.title,_that.description,_that.price,_that.imageUrls,_that.categoryId,_that.brand,_that.originalPrice,_that.discountPercentage,_that.rating,_that.reviewCount,_that.availableSizes,_that.availableColors,_that.badge,_that.badgeType,_that.stockQuantity,_that.isAvailable,_that.isFeatured,_that.isFavorite,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  double price,  List<String> imageUrls,  String categoryId,  String? brand,  double? originalPrice,  int? discountPercentage,  double? rating,  int? reviewCount,  List<String> availableSizes,  List<String> availableColors,  String? badge,  String? badgeType,  int stockQuantity,  bool isAvailable,  bool isFeatured,  bool isFavorite,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.price,_that.imageUrls,_that.categoryId,_that.brand,_that.originalPrice,_that.discountPercentage,_that.rating,_that.reviewCount,_that.availableSizes,_that.availableColors,_that.badge,_that.badgeType,_that.stockQuantity,_that.isAvailable,_that.isFeatured,_that.isFavorite,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.title, required this.description, required this.price, required final  List<String> imageUrls, required this.categoryId, this.brand, this.originalPrice, this.discountPercentage, this.rating, this.reviewCount, final  List<String> availableSizes = const [], final  List<String> availableColors = const [], this.badge, this.badgeType, this.stockQuantity = 0, this.isAvailable = true, this.isFeatured = false, this.isFavorite = false, this.createdAt, this.updatedAt}): _imageUrls = imageUrls,_availableSizes = availableSizes,_availableColors = availableColors;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  double price;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  String categoryId;
@override final  String? brand;
@override final  double? originalPrice;
@override final  int? discountPercentage;
@override final  double? rating;
@override final  int? reviewCount;
 final  List<String> _availableSizes;
@override@JsonKey() List<String> get availableSizes {
  if (_availableSizes is EqualUnmodifiableListView) return _availableSizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSizes);
}

 final  List<String> _availableColors;
@override@JsonKey() List<String> get availableColors {
  if (_availableColors is EqualUnmodifiableListView) return _availableColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableColors);
}

@override final  String? badge;
@override final  String? badgeType;
@override@JsonKey() final  int stockQuantity;
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other._availableSizes, _availableSizes)&&const DeepCollectionEquality().equals(other._availableColors, _availableColors)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.badgeType, badgeType) || other.badgeType == badgeType)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,description,price,const DeepCollectionEquality().hash(_imageUrls),categoryId,brand,originalPrice,discountPercentage,rating,reviewCount,const DeepCollectionEquality().hash(_availableSizes),const DeepCollectionEquality().hash(_availableColors),badge,badgeType,stockQuantity,isAvailable,isFeatured,isFavorite,createdAt,updatedAt]);

@override
String toString() {
  return 'Product(id: $id, title: $title, description: $description, price: $price, imageUrls: $imageUrls, categoryId: $categoryId, brand: $brand, originalPrice: $originalPrice, discountPercentage: $discountPercentage, rating: $rating, reviewCount: $reviewCount, availableSizes: $availableSizes, availableColors: $availableColors, badge: $badge, badgeType: $badgeType, stockQuantity: $stockQuantity, isAvailable: $isAvailable, isFeatured: $isFeatured, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, double price, List<String> imageUrls, String categoryId, String? brand, double? originalPrice, int? discountPercentage, double? rating, int? reviewCount, List<String> availableSizes, List<String> availableColors, String? badge, String? badgeType, int stockQuantity, bool isAvailable, bool isFeatured, bool isFavorite, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? price = null,Object? imageUrls = null,Object? categoryId = null,Object? brand = freezed,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? rating = freezed,Object? reviewCount = freezed,Object? availableSizes = null,Object? availableColors = null,Object? badge = freezed,Object? badgeType = freezed,Object? stockQuantity = null,Object? isAvailable = null,Object? isFeatured = null,Object? isFavorite = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,reviewCount: freezed == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int?,availableSizes: null == availableSizes ? _self._availableSizes : availableSizes // ignore: cast_nullable_to_non_nullable
as List<String>,availableColors: null == availableColors ? _self._availableColors : availableColors // ignore: cast_nullable_to_non_nullable
as List<String>,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,badgeType: freezed == badgeType ? _self.badgeType : badgeType // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
