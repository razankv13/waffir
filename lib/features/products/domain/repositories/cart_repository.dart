import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/products/domain/entities/cart_item.dart';

/// Repository interface for shopping cart operations
abstract class CartRepository {
  /// Get all items in the cart
  AsyncResult<List<CartItem>> getCartItems();

  /// Add item to cart
  AsyncResult<void> addToCart(CartItem item);

  /// Update cart item quantity
  AsyncResult<void> updateItemQuantity(String itemId, int quantity);

  /// Remove item from cart
  AsyncResult<void> removeFromCart(String itemId);

  /// Clear all items from cart
  AsyncResult<void> clearCart();

  /// Get cart item count
  AsyncResult<int> getCartItemCount();

  /// Get cart total price
  AsyncResult<double> getCartTotal();

  /// Check if product is in cart
  AsyncResult<bool> isInCart(String productId);
}
