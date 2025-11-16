import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design/tokens.dart';

/// Checkout Screen - Stub Implementation
class CheckoutStubScreen extends StatelessWidget {
  const CheckoutStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          context.go('/cart');
        }
      },
      child: Scaffold(
        backgroundColor: DesignTokens.background,
        appBar: AppBar(
          title: const Text('Checkout'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back',
          ),
          actions: [
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Home'),
            ),
          ],
        ),
        body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.spaceXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: EdgeInsets.all(DesignTokens.spaceXl),
                  decoration: BoxDecoration(
                    color: DesignTokens.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: DesignTokens.success,
                  ),
                ),
                SizedBox(height: DesignTokens.spaceXl),
                
                // Title
                Text(
                  'Checkout Flow Stubbed',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceMd),
                
                // Message
                Text(
                  'Cart verified.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DesignTokens.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceXl * 2),
                
                // Return button
                ElevatedButton(
                  onPressed: () => context.go('/cart'),
                  child: const Text('Back to Cart'),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

