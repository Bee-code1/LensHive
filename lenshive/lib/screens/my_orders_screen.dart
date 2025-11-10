import 'package:flutter/material.dart';
import '../design/tokens.dart';

/// My Orders Screen - Placeholder
class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: DesignTokens.textSecondary,
              ),
              SizedBox(height: DesignTokens.spaceLg),
              Text(
                'No orders yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: DesignTokens.spaceSm),
              Text(
                'Your orders will appear here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

