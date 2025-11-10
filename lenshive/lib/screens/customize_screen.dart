import 'package:flutter/material.dart';
import '../design/tokens.dart';

/// Customize Screen - Placeholder
class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.palette_outlined,
                size: 64,
                color: DesignTokens.textSecondary,
              ),
              SizedBox(height: DesignTokens.spaceLg),
              Text(
                'Customize Your Lenses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: DesignTokens.spaceSm),
              Text(
                'Feature coming soon',
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

