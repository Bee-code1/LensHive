import '../domain/booking_models.dart';

/// Abstract repository for home service bookings (user-side)
abstract class HomeServiceRepository {
  /// Create a new booking request
  /// Returns the booking ID
  Future<String> createBooking(BookingRequest request);

  /// List all bookings for a specific user (user-scoped)
  Future<List<BookingSummary>> listMyBookings(String userId);

  /// List all bookings (admin view - returns all bookings regardless of user)
  Future<List<BookingSummary>> listBookings();

  /// Get details of a specific booking
  Future<BookingSummary> getBooking(String id);

  /// Reschedule a booking to a new time
  /// Throws FriendlyFailure if within 24 hours
  Future<BookingSummary> reschedule(String id, DateTime newTime);

  /// Cancel a booking with a reason
  /// Throws FriendlyFailure if within 24 hours
  Future<BookingSummary> cancel(String id, String reason);
}

