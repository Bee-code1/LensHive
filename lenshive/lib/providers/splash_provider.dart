import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum to represent the splash screen state
enum SplashState {
  loading,
  completed,
}

/// StateNotifier to manage splash screen state and logic
class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(SplashState.loading) {
    _initializeSplash();
  }

  /// Initialize splash screen with delay
  Future<void> _initializeSplash() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 6));
    
    // Navigate to login screen after delay
    if (mounted) {
      state = SplashState.completed;
    }
  }
}

/// Provider for splash screen state management
final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>(
  (ref) => SplashNotifier(),
);


