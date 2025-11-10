import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design/tokens.dart';
import '../shared/formatters.dart';
import '../shared/widgets/sticky_footer.dart';
import '../features/cart/domain/cart_models.dart';
import '../features/cart/providers/cart_providers.dart';

/// Cart Screen - Full Implementation
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isVerifying = false;

  /// Ensures the verify step never leaves an orphan overlay.
  /// Uses root navigator so dialogs/sheets aren't nested under the shell.
  Future<void> verifyAndProceed() async {
    if (_isVerifying) return; // Guard against double taps
    
    setState(() => _isVerifying = true);
    
    final rootNav = Navigator.of(context, rootNavigator: true);

    // 1) Blocking spinner
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await ref
          .read(cartProvider.notifier)
          .verify()
          .timeout(const Duration(seconds: 10));

      // Always close spinner before any UI change
      if (rootNav.canPop()) rootNav.pop();
      setState(() => _isVerifying = false);

      // Accept either a bool or an object with `adjusted` + optional `changes`
      final adjusted = result['adjusted'] == true;
      final changes = (result['changes'] as List<dynamic>?) ?? const [];

      if (adjusted) {
        if (!mounted) return;
        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          builder: (_) => _CartAdjustmentsSheet(
            key: const Key('cart_adjustments_sheet'),
            changes: changes.cast<String>(),
            onTryAgain: () {
              Navigator.of(context, rootNavigator: true).pop();
              verifyAndProceed(); // re-run after sheet closes
            },
            onReviewCart: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        );
      } else {
        if (!mounted) return;
        context.push('/checkout'); // route outside shell (no bottom nav)
      }
    } on TimeoutException {
      if (rootNav.canPop()) rootNav.pop();
      setState(() => _isVerifying = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification took too long. Please try again.'),
          ),
        );
      }
    } catch (e) {
      if (rootNav.canPop()) rootNav.pop();
      setState(() => _isVerifying = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not verify cart: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartState.when(
        data: (cart) => cart.isEmpty
            ? _buildEmptyState(context)
            : _buildCartContent(context, ref, cart),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  /// Empty cart state
  Widget _buildEmptyState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(DesignTokens.spaceXl * 2),
                decoration: BoxDecoration(
                  color: DesignTokens.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignTokens.borderColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: DesignTokens.textSecondary,
                ),
              ),
              SizedBox(height: DesignTokens.spaceXl),
              Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: DesignTokens.spaceMd),
              Text(
                'Add items to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spaceXl * 2),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Error state
  Widget _buildErrorState(BuildContext context, Object error) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: DesignTokens.error,
              ),
              SizedBox(height: DesignTokens.spaceLg),
              Text(
                'Failed to load cart',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: DesignTokens.spaceMd),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Main cart content with items
  Widget _buildCartContent(BuildContext context, WidgetRef ref, Cart cart) {
    return SafeArea(
      child: Column(
        children: [
          // Cart items list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(DesignTokens.spaceLg),
              itemCount: cart.items.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: DesignTokens.spaceMd),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return _CartItemCard(
                  key: Key('cart_item_${item.id}'),
                  item: item,
                  onIncrement: () {
                    ref.read(cartProvider.notifier).increment(item.id);
                  },
                  onDecrement: () {
                    ref.read(cartProvider.notifier).decrement(item.id);
                  },
                  onRemove: () {
                    ref.read(cartProvider.notifier).remove(item.id);
                  },
                );
              },
            ),
          ),

          // Summary and checkout button
          _buildCartSummary(context, ref, cart),
        ],
      ),
    );
  }

  /// Cart summary with sticky footer
  Widget _buildCartSummary(BuildContext context, WidgetRef ref, Cart cart) {
    return StickyFooter(
      child: Column(
        children: [
          // Summary rows
          _buildSummaryRow(
            context,
            'Subtotal',
            cart.subtotalPkr,
          ),
          if (cart.discountPkr > 0) ...[
            SizedBox(height: DesignTokens.spaceXs),
            _buildSummaryRow(
              context,
              'Discount',
              -cart.discountPkr,
              valueColor: DesignTokens.success,
            ),
          ],
          SizedBox(height: DesignTokens.spaceXs),
          _buildSummaryRow(
            context,
            'Shipping',
            cart.shippingPkr,
            subtitle: cart.shippingPkr == 0 ? 'Free shipping' : null,
          ),
          Divider(height: DesignTokens.spaceXl),
          _buildSummaryRow(
            context,
            'Total',
            cart.totalPkr,
            isBold: true,
          ),
          SizedBox(height: DesignTokens.spaceLg),

          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('cart_proceed_btn'),
              onPressed: _isVerifying ? null : verifyAndProceed,
              child: _isVerifying
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  /// Summary row helper
  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    int amount, {
    bool isBold = false,
    Color? valueColor,
    String? subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: isBold
                  ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
            if (subtitle != null) ...[
              SizedBox(height: DesignTokens.spaceXs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DesignTokens.success,
                    ),
              ),
            ],
          ],
        ),
        Text(
          AppFormatters.pkCurrency(amount.abs()),
          style: isBold
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  )
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                  ),
        ),
      ],
    );
  }

}

/// Cart item card widget
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('dismissible_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: DesignTokens.spaceLg),
        decoration: BoxDecoration(
          color: DesignTokens.error,
          borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => onRemove(),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusInput),
                child: Image.network(
                  item.thumbnailUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64,
                    height: 64,
                    color: DesignTokens.background,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: DesignTokens.spaceMd),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignTokens.spaceXs),

                    // Unit price
                    Text(
                      AppFormatters.pkCurrency(item.unitPricePkr),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: DesignTokens.textSecondary,
                          ),
                    ),

                    // Warning if low stock
                    if (item.available && item.quantity > 5) ...[
                      SizedBox(height: DesignTokens.spaceXs),
                      Text(
                        'Only 5 left',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: DesignTokens.warning,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],

                    // Out of stock warning
                    if (!item.available) ...[
                      SizedBox(height: DesignTokens.spaceXs),
                      Text(
                        'Out of stock',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: DesignTokens.error,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Quantity controls and remove button
              Column(
                children: [
                  // Quantity stepper
                  if (item.available)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: DesignTokens.borderColor,
                          width: 1,
                        ),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusChip),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decrement button
                          InkWell(
                            key: Key('cart_qty_minus_${item.id}'),
                            onTap: onDecrement,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(DesignTokens.radiusChip),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(DesignTokens.spaceXs),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                          ),

                          // Quantity display
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spaceMd,
                            ),
                            child: Text(
                              item.quantity.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),

                          // Increment button
                          InkWell(
                            key: Key('cart_qty_plus_${item.id}'),
                            onTap: onIncrement,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(DesignTokens.radiusChip),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(DesignTokens.spaceXs),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: DesignTokens.spaceSm),

                  // Remove button
                  IconButton(
                    key: Key('cart_remove_${item.id}'),
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    color: DesignTokens.error,
                    onPressed: onRemove,
                    padding: EdgeInsets.all(DesignTokens.spaceXs),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cart adjustments bottom sheet widget
class _CartAdjustmentsSheet extends StatelessWidget {
  final List<String> changes;
  final VoidCallback onTryAgain;
  final VoidCallback onReviewCart;

  const _CartAdjustmentsSheet({
    super.key,
    required this.changes,
    required this.onTryAgain,
    required this.onReviewCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spaceXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DesignTokens.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spaceLg),

          // Title
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: DesignTokens.warning,
                size: 28,
              ),
              SizedBox(width: DesignTokens.spaceMd),
              Expanded(
                child: Text(
                  'We updated your cart',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spaceLg),

          // Description
          Text(
            'Some items were adjusted due to availability or price changes:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
          ),
          SizedBox(height: DesignTokens.spaceMd),

          // Issues list
          ...changes.map((change) => Padding(
                padding: EdgeInsets.only(
                  left: DesignTokens.spaceMd,
                  bottom: DesignTokens.spaceSm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: Text(
                        change,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),

          SizedBox(height: DesignTokens.spaceXl),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTryAgain,
                  child: const Text('Try Again'),
                ),
              ),
              SizedBox(width: DesignTokens.spaceMd),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReviewCart,
                  child: const Text('Review Cart'),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spaceMd),
        ],
      ),
    );
  }
}

