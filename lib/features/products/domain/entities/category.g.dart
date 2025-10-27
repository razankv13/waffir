// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  iconUrl: json['iconUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
  productCount: (json['productCount'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'iconUrl': instance.iconUrl,
  'imageUrl': instance.imageUrl,
  'productCount': instance.productCount,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
};
