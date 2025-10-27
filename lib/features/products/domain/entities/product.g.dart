// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  categoryId: json['categoryId'] as String,
  brand: json['brand'] as String?,
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  discountPercentage: (json['discountPercentage'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  availableSizes:
      (json['availableSizes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  availableColors:
      (json['availableColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  badge: json['badge'] as String?,
  badgeType: json['badgeType'] as String?,
  stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
  isAvailable: json['isAvailable'] as bool? ?? true,
  isFeatured: json['isFeatured'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'imageUrls': instance.imageUrls,
  'categoryId': instance.categoryId,
  'brand': instance.brand,
  'originalPrice': instance.originalPrice,
  'discountPercentage': instance.discountPercentage,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'availableSizes': instance.availableSizes,
  'availableColors': instance.availableColors,
  'badge': instance.badge,
  'badgeType': instance.badgeType,
  'stockQuantity': instance.stockQuantity,
  'isAvailable': instance.isAvailable,
  'isFeatured': instance.isFeatured,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
