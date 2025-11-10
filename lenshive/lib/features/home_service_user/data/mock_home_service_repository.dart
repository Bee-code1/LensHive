import '../domain/booking_models.dart';
import 'home_service_repository.dart';

/// Mock user IDs for testing
const String kCurrentUserId = 'u_me'; // Current logged-in user
const String kOtherUserId = 'u_other'; // Another user for testing

/// Mock implementation of HomeServiceRepository for development
class MockHomeServiceRepository implements HomeServiceRepository {
  // In-memory storage of bookings
  final Map<String, BookingSummary> _bookings = {};
  int _nextId = 1;

  MockHomeServiceRepository() {
    _seedData();
  }

  /// Seed initial test data
  void _seedData() {
    final now = DateTime.now();

    // Booking 1: Within 24 hours (tomorrow at 10 AM) - to test restriction (CURRENT USER)
    _bookings['BK-001'] = BookingSummary(
      id: 'BK-001',
      userId: kCurrentUserId,
      status: BookingStatus.scheduled,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day + 1,
        10,
        0,
      ),
      addressShort: 'Gulberg III, Lahore',
      serviceType: 'Eye Test at Home',
      adminNote: 'Optometrist will bring full equipment',
    );

    // Booking 2: Requested, 3 days out (CURRENT USER)
    _bookings['BK-002'] = BookingSummary(
      id: 'BK-002',
      userId: kCurrentUserId,
      status: BookingStatus.requested,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day + 3,
        14,
        0,
      ),
      addressShort: 'DHA Phase 5, Lahore',
      serviceType: 'Frame Repair & Adjustment',
      adminNote: null,
    );

    // Booking 3: Scheduled, 5 days out (OTHER USER)
    _bookings['BK-003'] = BookingSummary(
      id: 'BK-003',
      userId: kOtherUserId,
      status: BookingStatus.scheduled,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day + 5,
        16,
        30,
      ),
      addressShort: 'Johar Town, Lahore',
      serviceType: 'Contact Lens Fitting',
      adminNote: 'Please have your prescription ready',
    );

    // Booking 4: Completed (past) (CURRENT USER)
    _bookings['BK-004'] = BookingSummary(
      id: 'BK-004',
      userId: kCurrentUserId,
      status: BookingStatus.completed,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day - 7,
        11,
        0,
      ),
      addressShort: 'Model Town, Lahore',
      serviceType: 'Eye Test at Home',
      adminNote: 'Service completed successfully',
    );

    // Booking 5: Cancelled (past) (OTHER USER)
    _bookings['BK-005'] = BookingSummary(
      id: 'BK-005',
      userId: kOtherUserId,
      status: BookingStatus.cancelled,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day - 2,
        15,
        0,
      ),
      addressShort: 'Bahria Town, Lahore',
      serviceType: 'Lens Replacement',
      adminNote: 'Cancelled by customer',
    );

    // Booking 6: In Progress (right now, for testing) (CURRENT USER)
    _bookings['BK-006'] = BookingSummary(
      id: 'BK-006',
      userId: kCurrentUserId,
      status: BookingStatus.inProgress,
      scheduledAt: DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ),
      addressShort: 'Wapda Town, Lahore',
      serviceType: 'Progressive Lens Consultation',
      adminNote: 'Expert is on the way',
    );

    _nextId = 7;
  }

  @override
  Future<String> createBooking(BookingRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final id = 'BK-${_nextId.toString().padLeft(3, '0')}';
    _nextId++;

    // Create new booking with "requested" status (default to current user)
    final booking = BookingSummary(
      id: id,
      userId: kCurrentUserId, // Always created by the current user
      status: BookingStatus.requested,
      scheduledAt: request.preferredAt,
      addressShort: _shortenAddress(request.address),
      serviceType: request.serviceType,
      adminNote: null,
    );

    _bookings[id] = booking;
    return id;
  }

  @override
  Future<List<BookingSummary>> listMyBookings(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Return only bookings belonging to this user, sorted by scheduled date (newest first)
    final bookings = _bookings.values
        .where((booking) => booking.userId == userId)
        .toList();
    bookings.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return bookings;
  }

  @override
  Future<List<BookingSummary>> listBookings() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Return ALL bookings (admin view), sorted by scheduled date (newest first)
    final bookings = _bookings.values.toList();
    bookings.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return bookings;
  }

  @override
  Future<BookingSummary> getBooking(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final booking = _bookings[id];
    if (booking == null) {
      throw Exception('Booking not found: $id');
    }

    return booking;
  }

  @override
  Future<BookingSummary> reschedule(String id, DateTime newTime) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final booking = _bookings[id];
    if (booking == null) {
      throw Exception('Booking not found: $id');
    }

    // Check 24-hour rule
    if (booking.isWithin24Hours) {
      throw const FriendlyFailure(
        "Changes aren't allowed within 24 hours of service time.",
      );
    }

    // Check if status allows rescheduling
    if (!booking.status.canReschedule) {
      throw FriendlyFailure(
        'Cannot reschedule ${booking.status.label.toLowerCase()} booking',
      );
    }

    // Update booking
    final updatedBooking = booking.copyWith(
      scheduledAt: newTime,
      adminNote: 'Rescheduled by customer',
    );

    _bookings[id] = updatedBooking;
    return updatedBooking;
  }

  @override
  Future<BookingSummary> cancel(String id, String reason) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    final booking = _bookings[id];
    if (booking == null) {
      throw Exception('Booking not found: $id');
    }

    // Check 24-hour rule
    if (booking.isWithin24Hours) {
      throw const FriendlyFailure(
        "Changes aren't allowed within 24 hours of service time.",
      );
    }

    // Check if status allows cancellation
    if (!booking.status.canCancel) {
      throw FriendlyFailure(
        'Cannot cancel ${booking.status.label.toLowerCase()} booking',
      );
    }

    // Update booking to cancelled
    final updatedBooking = booking.copyWith(
      status: BookingStatus.cancelled,
      adminNote: 'Cancelled: $reason',
    );

    _bookings[id] = updatedBooking;
    return updatedBooking;
  }

  /// Helper to shorten address for display
  String _shortenAddress(String address) {
    // Extract main area/locality from full address
    final parts = address.split(',');
    if (parts.length >= 2) {
      return '${parts[0].trim()}, ${parts[parts.length - 1].trim()}';
    }
    return address.length > 40 ? '${address.substring(0, 37)}...' : address;
  }
}

