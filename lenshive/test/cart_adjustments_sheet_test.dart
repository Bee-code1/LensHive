import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lenshive/screens/cart_screen.dart';
import 'package:lenshive/features/cart/providers/cart_providers.dart';
import 'package:lenshive/features/cart/domain/cart_models.dart';
import 'package:lenshive/features/cart/data/cart_repository.dart';

/// Mock Cart Repository that returns adjusted cart
class MockAdjustedCartRepository implements CartRepository {
  @override
  Future<Cart> fetchCart() async {
    return const Cart(
      items: [
        CartItem(
          id: '1',
          name: 'Test Product',
          thumbnailUrl: 'https://example.com/image.jpg',
          quantity: 2,
          available: true,
          unitPricePkr: 5000,
        ),
      ],
      subtotalPkr: 10000,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: 10000,
      hasBlockingIssue: false,
    );
  }

  @override
  Future<Cart> updateQuantity(String lineId, int qty) async {
    return fetchCart();
  }

  @override
  Future<Cart> removeItem(String lineId) async {
    return const Cart(
      items: [],
      subtotalPkr: 0,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: 0,
      hasBlockingIssue: false,
    );
  }

  @override
  Future<Cart> verifyStockAndPrice() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Return cart with unavailable items
    return const Cart(
      items: [
        CartItem(
          id: '1',
          name: 'Test Product',
          thumbnailUrl: 'https://example.com/image.jpg',
          quantity: 2,
          available: false, // Out of stock
          unitPricePkr: 5000,
        ),
      ],
      subtotalPkr: 10000,
      discountPkr: 0,
      shippingPkr: 0,
      totalPkr: 10000,
      hasBlockingIssue: true,
    );
  }
}

void main() {
  group('Cart Adjustments Sheet', () {
    testWidgets('Shows sheet on adjusted=true',
        (WidgetTester tester) async {
      // Build the widget with mock repository that returns adjusted cart
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider
                .overrideWithValue(MockAdjustedCartRepository()),
          ],
          child: MaterialApp(
            home: const CartScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Find and tap the proceed button
      final proceedButton = find.byKey(const Key('cart_proceed_btn'));
      expect(proceedButton, findsOneWidget);

      await tester.tap(proceedButton);
      await tester.pump(); // Start verification

      // Wait for verification to complete and sheet to appear
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify sheet appears with correct key
      expect(find.byKey(const Key('cart_adjustments_sheet')), findsOneWidget);

      // Verify sheet contains expected content
      expect(find.text('We updated your cart'), findsOneWidget);
      expect(find.text('Test Product is out of stock'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Review Cart'), findsOneWidget);
    });

    testWidgets('Sheet closes cleanly when Review Cart is tapped',
        (WidgetTester tester) async {
      // Build the widget with mock repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider
                .overrideWithValue(MockAdjustedCartRepository()),
          ],
          child: MaterialApp(
            home: const CartScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Tap the proceed button
      final proceedButton = find.byKey(const Key('cart_proceed_btn'));
      await tester.tap(proceedButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify sheet is visible
      expect(find.byKey(const Key('cart_adjustments_sheet')), findsOneWidget);

      // Tap Review Cart button
      final reviewButton = find.text('Review Cart');
      expect(reviewButton, findsOneWidget);
      await tester.tap(reviewButton);
      await tester.pumpAndSettle();

      // Verify sheet is closed
      expect(find.byKey(const Key('cart_adjustments_sheet')), findsNothing);

      // Verify we're back on cart screen
      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('Sheet contains all adjustment messages',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider
                .overrideWithValue(MockAdjustedCartRepository()),
          ],
          child: MaterialApp(
            home: const CartScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Trigger verification
      final proceedButton = find.byKey(const Key('cart_proceed_btn'));
      await tester.tap(proceedButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify warning icon is present
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Verify description text
      expect(
        find.text(
            'Some items were adjusted due to availability or price changes:'),
        findsOneWidget,
      );

      // Verify specific change message
      expect(find.text('Test Product is out of stock'), findsOneWidget);
    });
  });
}

