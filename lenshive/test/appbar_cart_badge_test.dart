import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lenshive/screens/home_screen.dart';
import 'package:lenshive/features/cart/providers/cart_providers.dart';
import 'package:lenshive/features/cart/domain/cart_models.dart';
import 'package:lenshive/features/cart/data/cart_repository.dart';

/// Mock Cart Repository with configurable cart items
class MockCartRepositoryWithBadge implements CartRepository {
  final List<CartItem> _items;

  MockCartRepositoryWithBadge(this._items);

  @override
  Future<Cart> fetchCart() async {
    final subtotal = _items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity * item.unitPricePkr),
    );
    
    return Cart(
      items: _items,
      subtotalPkr: subtotal,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: subtotal,
      hasBlockingIssue: false,
    );
  }

  @override
  Future<Cart> updateQuantity(String lineId, int qty) async {
    return fetchCart();
  }

  @override
  Future<Cart> removeItem(String lineId) async {
    final updatedItems = _items.where((item) => item.id != lineId).toList();
    final subtotal = updatedItems.fold<int>(
      0,
      (sum, item) => sum + (item.quantity * item.unitPricePkr),
    );
    
    return Cart(
      items: updatedItems,
      subtotalPkr: subtotal,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: subtotal,
      hasBlockingIssue: false,
    );
  }

  @override
  Future<Cart> verifyStockAndPrice() async {
    return fetchCart();
  }
}

void main() {
  group('AppBar Cart Badge', () {
    testWidgets('Badge is hidden when cart is empty',
        (WidgetTester tester) async {
      // Create mock repository with empty cart
      final mockRepository = MockCartRepositoryWithBadge([]);

      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Verify cart button exists
      expect(find.byKey(const Key('appbar_cart_button')), findsOneWidget);

      // Verify badge is NOT visible
      expect(find.byKey(const Key('appbar_cart_badge')), findsNothing);
    });

    testWidgets('Badge shows when cart has items',
        (WidgetTester tester) async {
      // Create mock repository with 2 items
      final mockRepository = MockCartRepositoryWithBadge([
        const CartItem(
          id: '1',
          name: 'Product 1',
          thumbnailUrl: 'https://example.com/1.jpg',
          quantity: 1,
          available: true,
          unitPricePkr: 5000,
        ),
        const CartItem(
          id: '2',
          name: 'Product 2',
          thumbnailUrl: 'https://example.com/2.jpg',
          quantity: 1,
          available: true,
          unitPricePkr: 3000,
        ),
      ]);

      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Verify badge is visible
      expect(find.byKey(const Key('appbar_cart_badge')), findsOneWidget);

      // Verify badge shows correct count (2 items)
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Badge updates count correctly',
        (WidgetTester tester) async {
      // Create mock repository with 5 items
      final mockRepository = MockCartRepositoryWithBadge([
        const CartItem(
          id: '1',
          name: 'Product 1',
          thumbnailUrl: 'https://example.com/1.jpg',
          quantity: 3, // 3 of this item
          available: true,
          unitPricePkr: 5000,
        ),
        const CartItem(
          id: '2',
          name: 'Product 2',
          thumbnailUrl: 'https://example.com/2.jpg',
          quantity: 2, // 2 of this item
          available: true,
          unitPricePkr: 3000,
        ),
      ]);

      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Verify badge shows total item count (3 + 2 = 5)
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Badge shows 99+ for counts over 99',
        (WidgetTester tester) async {
      // Create mock repository with 100 items
      final mockRepository = MockCartRepositoryWithBadge([
        const CartItem(
          id: '1',
          name: 'Product 1',
          thumbnailUrl: 'https://example.com/1.jpg',
          quantity: 100, // 100 items
          available: true,
          unitPricePkr: 5000,
        ),
      ]);

      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Verify badge shows 99+
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('Badge has correct styling',
        (WidgetTester tester) async {
      // Create mock repository with 1 item
      final mockRepository = MockCartRepositoryWithBadge([
        const CartItem(
          id: '1',
          name: 'Product 1',
          thumbnailUrl: 'https://example.com/1.jpg',
          quantity: 1,
          available: true,
          unitPricePkr: 5000,
        ),
      ]);

      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const HomeScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Find the badge container
      final badgeContainer = tester.widget<Container>(
        find.descendant(
          of: find.byKey(const Key('appbar_cart_badge')),
          matching: find.byType(Container),
        ).first,
      );

      // Verify badge has constraints (minimum size)
      expect(badgeContainer.constraints, isNotNull);
      expect(badgeContainer.constraints!.minWidth, greaterThanOrEqualTo(18.0));
      expect(badgeContainer.constraints!.minHeight, greaterThanOrEqualTo(18.0));
    });
  });
}

