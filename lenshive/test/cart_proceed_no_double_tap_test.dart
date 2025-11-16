import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lenshive/screens/cart_screen.dart';
import 'package:lenshive/features/cart/providers/cart_providers.dart';
import 'package:lenshive/features/cart/domain/cart_models.dart';
import 'package:lenshive/features/cart/data/cart_repository.dart';

/// Mock Cart Repository for testing
class MockCartRepository implements CartRepository {
  int verifyCallCount = 0;
  bool shouldAdjust = false;

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
    verifyCallCount++;
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (shouldAdjust) {
      return const Cart(
        items: [
          CartItem(
            id: '1',
            name: 'Test Product',
            thumbnailUrl: 'https://example.com/image.jpg',
            quantity: 2,
            available: false,
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
    
    return fetchCart();
  }
}

void main() {
  group('Cart Proceed No Double Tap', () {
    late MockCartRepository mockRepository;

    setUp(() {
      mockRepository = MockCartRepository();
    });

    testWidgets('Second tap is ignored while verifying',
        (WidgetTester tester) async {
      // Build the widget with mock repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const CartScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Find the proceed button
      final proceedButton = find.byKey(const Key('cart_proceed_btn'));
      expect(proceedButton, findsOneWidget);

      // Tap the button once
      await tester.tap(proceedButton);
      await tester.pump(); // Trigger setState

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Try to tap again immediately (should be ignored)
      await tester.tap(proceedButton);
      await tester.pump();

      // Wait for first verification to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that verify was only called once (double tap was ignored)
      expect(mockRepository.verifyCallCount, 1);
    });

    testWidgets('Button is disabled while verifying',
        (WidgetTester tester) async {
      // Build the widget with mock repository
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            home: const CartScreen(),
          ),
        ),
      );

      // Wait for cart to load
      await tester.pumpAndSettle();

      // Find the proceed button
      final proceedButton = find.byKey(const Key('cart_proceed_btn'));
      
      // Get the button widget
      final ElevatedButton button = tester.widget(proceedButton);
      
      // Initially button should be enabled
      expect(button.onPressed, isNotNull);

      // Tap the button
      await tester.tap(proceedButton);
      await tester.pump(); // Trigger setState

      // Get the button widget again
      final ElevatedButton disabledButton = tester.widget(proceedButton);
      
      // Button should now be disabled
      expect(disabledButton.onPressed, isNull);

      // Wait for verification to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Get the button widget once more
      final ElevatedButton enabledButton = tester.widget(proceedButton);
      
      // Button should be enabled again
      expect(enabledButton.onPressed, isNotNull);
    });
  });
}

