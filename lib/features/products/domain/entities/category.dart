import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Category entity representing a product category
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? iconUrl,
    String? imageUrl,
    int? productCount,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
