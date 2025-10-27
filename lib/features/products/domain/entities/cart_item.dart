import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// Cart item entity representing an item in the shopping cart
@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String productId,
    required String title,
    required String imageUrl,
    required double price,
    required int quantity,
    String? brand,
    String? size,
    String? color,
    double? originalPrice,
    @Default(10) int maxQuantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}

/// Extension methods for CartItem
extension CartItemX on CartItem {
  /// Calculate total price for this item
  double get totalPrice => price * quantity;

  /// Calculate total savings if on sale
  double get totalSavings => originalPrice != null ? (originalPrice! - price) * quantity : 0.0;

  /// Check if item is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;
}
