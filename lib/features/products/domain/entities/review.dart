import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Review entity representing a product review
@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String productId,
    required String userId,
    required double rating,
    required String comment,
    String? userName,
    String? userAvatarUrl,
    @Default([]) List<String> imageUrls,
    @Default(0) int helpfulCount,
    @Default(false) bool isVerifiedPurchase,
    DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
