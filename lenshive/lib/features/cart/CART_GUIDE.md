# Cart Feature Guide

## Architecture Overview

```
lib/features/cart/
├── domain/
│   └── cart_models.dart          # CartItem, Cart domain models
├── data/
│   ├── cart_repository.dart      # Abstract repository interface
│   └── mock_cart_repository.dart # Mock implementation
└── providers/
    └── cart_providers.dart       # Riverpod state management
```

## Domain Models

### CartItem
```dart
class CartItem {
  final String id;
  final String name;
  final String thumbnailUrl;
  final int quantity;
  final bool available;
  final int unitPricePkr;
  final bool selected;
  
  int get totalPricePkr => unitPricePkr * quantity;
}
```

### Cart
```dart
class Cart {
  final List<CartItem> items;
  final int subtotalPkr;
  final int discountPkr;
  final int shippingPkr;
  final int totalPkr;
  final bool hasBlockingIssue;
  
  int get itemCount;
  bool get isEmpty;
  List<CartItem> get availableItems;
  List<CartItem> get unavailableItems;
}
```

## Repository

### Interface
```dart
abstract class CartRepository {
  Future<Cart> fetchCart();
  Future<Cart> updateQuantity(String lineId, int quantity);
  Future<Cart> removeItem(String lineId);
  Future<Cart> verifyStockAndPrice();
}
```

### Mock Implementation
- Simulates realistic network delays
- 20% chance of stock/price issues on verification
- Auto-calculates discounts and shipping
- **Discount**: 10% off if subtotal > PKR 10,000
- **Shipping**: Free if total > PKR 8,000, otherwise PKR 250

## State Management (Riverpod)

### Providers

```dart
// Repository provider
final cartRepositoryProvider = Provider<CartRepository>(...)

// Main cart state
final cartProvider = StateNotifierProvider<CartController, AsyncValue<Cart>>(...)

// Item count for badge
final cartItemCountProvider = Provider<int>(...)

// Check for blocking issues
final cartHasIssuesProvider = Provider<bool>(...)
```

### Usage in Widgets

#### Load Cart
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    
    return cartState.when(
      data: (cart) => Text('Items: ${cart.itemCount}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

#### Increment/Decrement Quantity
```dart
// Increment
ref.read(cartProvider.notifier).increment('line_1');

// Decrement
ref.read(cartProvider.notifier).decrement('line_1');
```

#### Remove Item
```dart
ref.read(cartProvider.notifier).remove('line_1');
```

#### Verify Before Checkout
```dart
// Call before proceeding to checkout
await ref.read(cartProvider.notifier).verify();

// Check if verification found issues
final hasIssues = ref.read(cartHasIssuesProvider);
if (hasIssues) {
  // Show warning/alert
}
```

#### Badge Display
```dart
// Show cart item count badge
final itemCount = ref.watch(cartItemCountProvider);

Badge(
  label: Text('$itemCount'),
  child: Icon(Icons.shopping_cart),
)
```

## Shared Utilities

### Currency Formatter
```dart
import 'package:lenshive/shared/formatters.dart';

// Format PKR currency
AppFormatters.pkCurrency(14999); // "PKR 14,999"
AppFormatters.pkCurrency(1500);  // "PKR 1,500"
```

### Sticky Footer
```dart
import 'package:lenshive/shared/widgets/sticky_footer.dart';

// Wrap checkout button
Scaffold(
  body: ListView(...),
  bottomNavigationBar: StickyFooter(
    child: ElevatedButton(
      onPressed: () {},
      child: Text('Checkout'),
    ),
  ),
)

// Or use extension
ElevatedButton(...).withStickyFooter()
```

## Widget Keys (for testing)

All cart widgets should use keys with `cart_` prefix:

```dart
// Examples
Key('cart_item_line_1')
Key('cart_quantity_increment')
Key('cart_quantity_decrement')
Key('cart_remove_button')
Key('cart_checkout_button')
Key('cart_subtotal')
Key('cart_total')
Key('cart_empty_state')
```

## Mock Data

The `MockCartRepository` provides realistic sample data:
- 4 pre-populated items
- Realistic product names and prices
- Simulated network delays (500-1200ms)
- Stock verification with random issues

## Business Logic

### Pricing Calculations
1. **Subtotal**: Sum of all available items
2. **Discount**: 10% if subtotal > PKR 10,000
3. **Shipping**: 
   - Free if (subtotal - discount) > PKR 8,000
   - Otherwise PKR 250
4. **Total**: Subtotal - Discount + Shipping

### Stock Verification
When `verifyStockAndPrice()` is called:
- 20% chance of finding an issue per item
- Issues types:
  - Out of stock (quantity → 0, available → false)
  - Reduced stock (quantity decreased)
  - Price change (usually small increase)

### Edge Cases Handled
- Quantity cannot be negative
- Quantity 0 → removes item
- Empty cart → shows empty state
- Unavailable items → excluded from totals
- Blocking issues → prevent checkout

## Testing

### Unit Tests
```dart
test('Cart calculates totals correctly', () {
  final cart = Cart(
    items: [...],
    subtotalPkr: 10000,
    discountPkr: 1000,
    shippingPkr: 0,
    totalPkr: 9000,
  );
  
  expect(cart.totalPkr, 9000);
});
```

### Widget Tests
```dart
testWidgets('Cart shows items', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        cartRepositoryProvider.overrideWithValue(MockCartRepository()),
      ],
      child: MaterialApp(home: CartScreen()),
    ),
  );
  
  await tester.pumpAndSettle();
  expect(find.byKey(Key('cart_item_line_1')), findsOneWidget);
});
```

## Next Steps

1. Create cart UI screen
2. Add cart item cards
3. Implement quantity controls
4. Add remove confirmation
5. Create checkout flow
6. Add empty cart state
7. Add stock verification warnings
8. Integrate with real API

