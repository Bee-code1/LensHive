import '../domain/cart_models.dart';

/// Abstract cart repository interface
/// Defines contract for cart data operations
abstract class CartRepository {
  /// Fetch the current cart
  Future<Cart> fetchCart();

  /// Update quantity for a cart line item
  /// Returns updated cart
  Future<Cart> updateQuantity(String lineId, int quantity);

  /// Remove an item from the cart
  /// Returns updated cart
  Future<Cart> removeItem(String lineId);

  /// Verify stock availability and prices
  /// May adjust quantities or mark items as unavailable
  /// Returns updated cart with any modifications
  Future<Cart> verifyStockAndPrice();
}

