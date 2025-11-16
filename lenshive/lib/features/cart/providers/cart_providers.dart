import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/cart_models.dart';
import '../data/cart_repository.dart';
import '../data/mock_cart_repository.dart';

/// Provider for the cart repository
/// Uses MockCartRepository by default
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return MockCartRepository();
});

/// State notifier provider for cart management
final cartProvider =
    StateNotifierProvider<CartController, AsyncValue<Cart>>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartController(repository);
});

/// Cart controller managing cart state and operations
class CartController extends StateNotifier<AsyncValue<Cart>> {
  final CartRepository _repository;

  CartController(this._repository) : super(const AsyncValue.loading()) {
    // Auto-load cart on initialization
    load();
  }

  /// Load cart from repository
  Future<void> load() async {
    state = const AsyncValue.loading();
    
    try {
      final cart = await _repository.fetchCart();
      state = AsyncValue.data(cart);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Increment quantity for a cart item
  Future<void> increment(String lineId) async {
    final currentCart = state.value;
    if (currentCart == null) return;

    final item = currentCart.items.firstWhere(
      (item) => item.id == lineId,
      orElse: () => throw Exception('Item not found'),
    );

    await _updateQuantity(lineId, item.quantity + 1);
  }

  /// Decrement quantity for a cart item
  Future<void> decrement(String lineId) async {
    final currentCart = state.value;
    if (currentCart == null) return;

    final item = currentCart.items.firstWhere(
      (item) => item.id == lineId,
      orElse: () => throw Exception('Item not found'),
    );

    if (item.quantity > 1) {
      await _updateQuantity(lineId, item.quantity - 1);
    } else {
      // Remove item if quantity would become 0
      await remove(lineId);
    }
  }

  /// Update quantity directly
  Future<void> _updateQuantity(String lineId, int quantity) async {
    try {
      final cart = await _repository.updateQuantity(lineId, quantity);
      state = AsyncValue.data(cart);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Remove item from cart
  Future<void> remove(String lineId) async {
    try {
      final cart = await _repository.removeItem(lineId);
      state = AsyncValue.data(cart);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Verify stock and prices
  /// Call this before checkout to ensure cart is valid
  /// Returns a map with {adjusted: bool, changes: List<String>}
  Future<Map<String, dynamic>> verify() async {
    final currentCart = state.value;
    if (currentCart == null) {
      return {'adjusted': false, 'changes': <String>[]};
    }

    try {
      final cart = await _repository.verifyStockAndPrice();
      state = AsyncValue.data(cart);
      
      // Check if cart was adjusted
      final wasAdjusted = cart.hasBlockingIssue || 
                         cart.unavailableItems.isNotEmpty;
      
      // Build list of changes
      final changes = <String>[];
      for (final item in cart.unavailableItems) {
        changes.add('${item.name} is out of stock');
      }
      
      return {
        'adjusted': wasAdjusted,
        'changes': changes,
      };
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Clear all error states
  void clearError() {
    final currentCart = state.value;
    if (currentCart != null) {
      state = AsyncValue.data(currentCart);
    }
  }
}

/// Provider to get cart item count (for badge display)
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.when(
    data: (cart) => cart.itemCount,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider to check if cart has blocking issues
final cartHasIssuesProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.when(
    data: (cart) => cart.hasBlockingIssue,
    loading: () => false,
    error: (_, __) => false,
  );
});

