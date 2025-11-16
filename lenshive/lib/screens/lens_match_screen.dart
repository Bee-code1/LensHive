import 'package:flutter/material.dart';
import '../design/tokens.dart';

/// LensMatch Screen - Placeholder
/// NOTE: Currently used for Bookings tab until proper BookingsScreen is created
class LensMatchScreen extends StatelessWidget {
  const LensMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(DesignTokens.spaceLg),
                decoration: BoxDecoration(
                  color: DesignTokens.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event,
                  size: 48,
                  color: DesignTokens.primary,
                ),
              ),
              SizedBox(height: DesignTokens.spaceLg),
              Text(
                'Bookings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: DesignTokens.spaceSm),
              Text(
                'Your home service bookings will appear here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spaceXl),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to booking creation
                },
                child: const Text('Book Home Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

