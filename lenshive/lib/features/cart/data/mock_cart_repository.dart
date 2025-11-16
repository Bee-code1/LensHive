import 'dart:math';
import '../domain/cart_models.dart';
import 'cart_repository.dart';

/// Mock implementation of CartRepository for development and testing
class MockCartRepository implements CartRepository {
  // Mock cart state
  Cart _cart = Cart(
    items: [
      const CartItem(
        id: 'line_1',
        name: 'Blue Light Blocking Glasses - Classic Frame',
        thumbnailUrl: 'https://via.placeholder.com/150',
        quantity: 2,
        available: true,
        unitPricePkr: 3499,
      ),
      const CartItem(
        id: 'line_2',
        name: 'Anti-Glare Computer Glasses - Modern Style',
        thumbnailUrl: 'https://via.placeholder.com/150',
        quantity: 1,
        available: true,
        unitPricePkr: 4999,
      ),
      const CartItem(
        id: 'line_3',
        name: 'Prescription Sunglasses - Polarized',
        thumbnailUrl: 'https://via.placeholder.com/150',
        quantity: 1,
        available: true,
        unitPricePkr: 7999,
      ),
      const CartItem(
        id: 'line_4',
        name: 'Reading Glasses +2.5 - Lightweight',
        thumbnailUrl: 'https://via.placeholder.com/150',
        quantity: 3,
        available: true,
        unitPricePkr: 2499,
      ),
    ],
    subtotalPkr: 0,
    discountPkr: 0,
    shippingPkr: 0,
    totalPkr: 0,
  );

  MockCartRepository() {
    _cart = _recalculateTotals(_cart);
  }

  @override
  Future<Cart> fetchCart() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _cart;
  }

  @override
  Future<Cart> updateQuantity(String lineId, int quantity) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative');
    }

    if (quantity == 0) {
      return removeItem(lineId);
    }

    final updatedItems = _cart.items.map((item) {
      if (item.id == lineId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    _cart = _recalculateTotals(_cart.copyWith(items: updatedItems));
    return _cart;
  }

  @override
  Future<Cart> removeItem(String lineId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedItems =
        _cart.items.where((item) => item.id != lineId).toList();

    _cart = _recalculateTotals(_cart.copyWith(items: updatedItems));
    return _cart;
  }

  @override
  Future<Cart> verifyStockAndPrice() async {
    // Simulate network delay for verification
    await Future.delayed(const Duration(milliseconds: 1200));

    final random = Random();
    final updatedItems = <CartItem>[];
    bool hasIssues = false;

    for (final item in _cart.items) {
      // 20% chance of stock/price issue
      final hasIssue = random.nextInt(100) < 20;

      if (hasIssue) {
        final issueType = random.nextInt(3);

        switch (issueType) {
          case 0:
            // Out of stock
            updatedItems.add(item.copyWith(available: false, quantity: 0));
            hasIssues = true;
            break;
          case 1:
            // Reduced stock availability
            if (item.quantity > 1) {
              final newQty = max(1, item.quantity - random.nextInt(2) - 1);
              updatedItems.add(item.copyWith(quantity: newQty));
              hasIssues = true;
            } else {
              updatedItems.add(item);
            }
            break;
          case 2:
            // Price change (usually small increase)
            final priceChange = (random.nextInt(500) - 100); // -100 to +400
            final newPrice = max(1000, item.unitPricePkr + priceChange);
            if (newPrice != item.unitPricePkr) {
              updatedItems.add(item.copyWith(unitPricePkr: newPrice));
              hasIssues = true;
            } else {
              updatedItems.add(item);
            }
            break;
          default:
            updatedItems.add(item);
        }
      } else {
        updatedItems.add(item);
      }
    }

    _cart = _recalculateTotals(
      _cart.copyWith(
        items: updatedItems,
        hasBlockingIssue: hasIssues,
      ),
    );

    return _cart;
  }

  /// Recalculate cart totals based on items
  Cart _recalculateTotals(Cart cart) {
    // Calculate subtotal from available items only
    final subtotal = cart.items
        .where((item) => item.available)
        .fold<int>(0, (sum, item) => sum + item.totalPricePkr);

    // Apply discount (10% off if subtotal > 10000)
    final discount = subtotal > 10000 ? (subtotal * 0.1).round() : 0;

    // Free shipping if subtotal - discount > 8000, otherwise 250 PKR
    final shipping = (subtotal - discount) > 8000 ? 0 : 250;

    // Calculate total
    final total = subtotal - discount + shipping;

    return cart.copyWith(
      subtotalPkr: subtotal,
      discountPkr: discount,
      shippingPkr: shipping,
      totalPkr: total,
    );
  }
}

