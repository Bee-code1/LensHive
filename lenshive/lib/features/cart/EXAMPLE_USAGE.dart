// Example usage of cart feature components
// This file is for reference only - not part of the app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/formatters.dart';
import '../../shared/widgets/sticky_footer.dart';
import 'domain/cart_models.dart';
import 'providers/cart_providers.dart';

// ============================================================================
// Example 1: Basic Cart Display
// ============================================================================

class ExampleCartDisplay extends ConsumerWidget {
  const ExampleCartDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartState.when(
        data: (cart) => _buildCartList(context, ref, cart),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, WidgetRef ref, Cart cart) {
    if (cart.isEmpty) {
      return const Center(child: Text('Cart is empty'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _buildCartItemCard(context, ref, item);
            },
          ),
        ),
        _buildCartSummary(context, cart),
      ],
    );
  }

  Widget _buildCartItemCard(BuildContext context, WidgetRef ref, CartItem item) {
    return Card(
      key: Key('cart_item_${item.id}'),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            Image.network(
              item.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppFormatters.pkCurrency(item.unitPricePkr),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (!item.available)
                    Text(
                      'Out of stock',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                ],
              ),
            ),
            
            // Quantity controls
            if (item.available) ...[
              IconButton(
                key: Key('cart_decrement_${item.id}'),
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  ref.read(cartProvider.notifier).decrement(item.id);
                },
              ),
              Text(
                item.quantity.toString(),
                key: Key('cart_quantity_${item.id}'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                key: Key('cart_increment_${item.id}'),
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  ref.read(cartProvider.notifier).increment(item.id);
                },
              ),
            ],
            
            // Remove button
            IconButton(
              key: Key('cart_remove_${item.id}'),
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).remove(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, Cart cart) {
    return StickyFooter(
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', cart.subtotalPkr, context),
          if (cart.discountPkr > 0)
            _buildSummaryRow('Discount', -cart.discountPkr, context),
          _buildSummaryRow('Shipping', cart.shippingPkr, context),
          const Divider(),
          _buildSummaryRow('Total', cart.totalPkr, context, isBold: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('cart_checkout_button'),
              onPressed: cart.hasBlockingIssue
                  ? null
                  : () {
                      // Navigate to checkout
                    },
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    int amount,
    BuildContext context, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            AppFormatters.pkCurrency(amount),
            style: isBold
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Example 2: Cart Badge in AppBar
// ============================================================================

class ExampleAppBarWithBadge extends ConsumerWidget {
  const ExampleAppBarWithBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);

    return AppBar(
      title: const Text('Shop'),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to cart
              },
            ),
            if (itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// Example 3: Verify Cart Before Checkout
// ============================================================================

class ExampleCheckoutFlow extends ConsumerWidget {
  const ExampleCheckoutFlow({super.key});

  Future<void> _proceedToCheckout(BuildContext context, WidgetRef ref) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Verify stock and prices
    await ref.read(cartProvider.notifier).verify();

    // Close loading
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Check for issues
    final hasIssues = ref.read(cartHasIssuesProvider);
    
    if (hasIssues && context.mounted) {
      // Show warning dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cart Updated'),
          content: const Text(
            'Some items in your cart have been updated due to stock or price changes. Please review before continuing.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Review Cart'),
            ),
          ],
        ),
      );
    } else if (context.mounted) {
      // Navigate to checkout
      // context.go('/checkout');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _proceedToCheckout(context, ref),
      child: const Text('Checkout'),
    );
  }
}

// ============================================================================
// Example 4: Using Formatters
// ============================================================================

class ExampleFormatters extends StatelessWidget {
  const ExampleFormatters({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Currency formatting
        Text(AppFormatters.pkCurrency(14999)), // "PKR 14,999"
        Text(AppFormatters.pkCurrency(1500)),  // "PKR 1,500"
        Text(AppFormatters.pkCurrency(999)),   // "PKR 999"
        
        // With decimals (if needed)
        Text(AppFormatters.pkCurrencyWithDecimals(14999.50)), // "PKR 14,999.5"
        
        // Quantity
        Text(AppFormatters.quantity(5)), // "5"
        
        // Percentage
        Text(AppFormatters.percentage(10)), // "10%"
      ],
    );
  }
}

// ============================================================================
// Example 5: Sticky Footer Usage
// ============================================================================

class ExampleStickyFooter extends StatelessWidget {
  const ExampleStickyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: List.generate(
                  20,
                  (index) => ListTile(title: Text('Item $index')),
                ),
              ),
            ),
            // Using StickyFooter directly
            StickyFooter(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleStickyFooterWithExtension extends StatelessWidget {
  const ExampleStickyFooterWithExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ListView()),
            // Using extension method
            ElevatedButton(
              onPressed: () {},
              child: const Text('Continue'),
            ).withStickyFooter(),
          ],
        ),
      ),
    );
  }
}

