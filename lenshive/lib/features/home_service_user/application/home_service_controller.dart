import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/booking_models.dart';
import '../data/home_service_repository.dart';
import '../data/mock_home_service_repository.dart';
import '../../auth/current_user_provider.dart';

/// Provider for the home service repository
final homeServiceRepositoryProvider = Provider<HomeServiceRepository>((ref) {
  return MockHomeServiceRepository();
});

/// Provider for user's bookings list (user-scoped)
final myBookingsProvider =
    StateNotifierProvider<HomeServiceController, AsyncValue<List<BookingSummary>>>(
  (ref) {
    final repository = ref.watch(homeServiceRepositoryProvider);
    final userId = ref.watch(currentUserIdProvider);
    return HomeServiceController(repository, userId);
  },
);

/// Provider for a specific booking by ID (family)
final selectedBookingProvider = FutureProvider.family<BookingSummary, String>(
  (ref, id) async {
    final repository = ref.watch(homeServiceRepositoryProvider);
    return repository.getBooking(id);
  },
);

/// Controller for home service bookings (user-scoped)
class HomeServiceController
    extends StateNotifier<AsyncValue<List<BookingSummary>>> {
  final HomeServiceRepository _repository;
  final String _userId;

  HomeServiceController(this._repository, this._userId)
      : super(const AsyncValue.loading()) {
    // Auto-load bookings on initialization
    loadBookings();
  }

  /// Load bookings for the current user
  Future<void> loadBookings() async {
    state = const AsyncValue.loading();

    try {
      // Fetch only bookings for this user
      final bookings = await _repository.listMyBookings(_userId);
      state = AsyncValue.data(bookings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create a new booking request
  Future<String> createBooking(BookingRequest request) async {
    try {
      final bookingId = await _repository.createBooking(request);

      // Reload bookings to reflect the new one
      await loadBookings();

      return bookingId;
    } catch (error, stackTrace) {
      // Don't change state on error, just rethrow
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Reschedule an existing booking
  Future<void> reschedule(String id, DateTime newTime) async {
    // Check 24-hour rule before API call
    final currentBookings = state.value;
    if (currentBookings != null) {
      final booking = currentBookings.firstWhere(
        (b) => b.id == id,
        orElse: () => throw Exception('Booking not found'),
      );

      if (booking.isWithin24Hours) {
        throw const FriendlyFailure(
          "Changes aren't allowed within 24 hours of service time.",
        );
      }
    }

    try {
      await _repository.reschedule(id, newTime);

      // Reload bookings to reflect the change
      await loadBookings();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Cancel an existing booking
  Future<void> cancel(String id, String reason) async {
    // Check 24-hour rule before API call
    final currentBookings = state.value;
    if (currentBookings != null) {
      final booking = currentBookings.firstWhere(
        (b) => b.id == id,
        orElse: () => throw Exception('Booking not found'),
      );

      if (booking.isWithin24Hours) {
        throw const FriendlyFailure(
          "Changes aren't allowed within 24 hours of service time.",
        );
      }
    }

    try {
      await _repository.cancel(id, reason);

      // Reload bookings to reflect the cancellation
      await loadBookings();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Refresh bookings (pull-to-refresh)
  Future<void> refresh() async {
    await loadBookings();
  }

  /// Clear error state
  void clearError() {
    final bookings = state.value;
    if (bookings != null) {
      state = AsyncValue.data(bookings);
    }
  }
}

