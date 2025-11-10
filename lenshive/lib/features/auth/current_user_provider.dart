import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the current user ID
/// In a real app, this would come from the auth state
/// For now, we return a mock user ID for testing
final currentUserIdProvider = Provider<String>((ref) {
  // In production, this would watch the auth provider and return the actual user ID
  // For development/testing, we return a static ID
  return 'u_me'; // Mock user ID matching the one in MockHomeServiceRepository
});

