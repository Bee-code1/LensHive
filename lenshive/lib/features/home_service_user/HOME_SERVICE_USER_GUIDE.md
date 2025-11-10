# Home Service User Feature Guide

## Overview

User-facing home service booking system for LensHive customers in Lahore to request at-home eye care services.

## Architecture

```
lib/features/home_service_user/
├── domain/
│   └── booking_models.dart          # Domain models and enums
├── data/
│   ├── home_service_repository.dart # Abstract interface
│   └── mock_home_service_repository.dart # Mock implementation
└── application/
    └── home_service_controller.dart # Riverpod state management
```

## Domain Models

### BookingStatus Enum

```dart
enum BookingStatus {
  requested,   // User submitted, awaiting admin approval
  scheduled,   // Admin approved and scheduled
  inProgress,  // Service currently happening
  completed,   // Service finished
  cancelled,   // Cancelled by user or admin
}
```

**Extensions:**
- `label` - User-friendly display name
- `isActive` - Whether booking is still active
- `canReschedule` - Whether rescheduling is allowed
- `canCancel` - Whether cancellation is allowed

### BookingRequest

Data submitted when creating a new booking:

```dart
class BookingRequest {
  final String serviceType;      // e.g., "Eye test at home"
  final DateTime preferredAt;    // User's preferred time slot
  final String address;          // Full address
  final String phone;            // Contact number
  final String? notes;           // Optional notes for admin
}
```

### BookingSummary

Simplified booking view for lists:

```dart
class BookingSummary {
  final String id;               // Booking ID (e.g., "BK-001")
  final BookingStatus status;
  final DateTime scheduledAt;    // Assigned time (may differ from preferred)
  final String addressShort;     // Shortened address for display
  final String serviceType;
  final String? adminNote;       // Optional note from admin
}
```

**Properties:**
- `isWithin24Hours` - Whether booking is within 24h (computed)
- `canModify` - Whether changes are allowed (computed)

### FriendlyFailure

User-friendly exception for displaying errors:

```dart
throw FriendlyFailure("Changes aren't allowed within 24 hours of service time.");
```

## Repository

### Interface

```dart
abstract class HomeServiceRepository {
  Future<String> createBooking(BookingRequest request);
  Future<List<BookingSummary>> listMyBookings();
  Future<BookingSummary> getBooking(String id);
  Future<BookingSummary> reschedule(String id, DateTime newTime);
  Future<BookingSummary> cancel(String id, String reason);
}
```

### Mock Implementation

**Seeded Data (6 bookings):**

1. **BK-001** - Scheduled, **tomorrow 10 AM** (within 24h - tests restriction)
   - Service: Eye Test at Home
   - Location: Gulberg III, Lahore

2. **BK-002** - Requested, 3 days out
   - Service: Frame Repair & Adjustment
   - Location: DHA Phase 5, Lahore

3. **BK-003** - Scheduled, 5 days out
   - Service: Contact Lens Fitting
   - Location: Johar Town, Lahore

4. **BK-004** - Completed, 7 days ago
   - Service: Eye Test at Home
   - Location: Model Town, Lahore

5. **BK-005** - Cancelled, 2 days ago
   - Service: Lens Replacement
   - Location: Bahria Town, Lahore

6. **BK-006** - In Progress, now
   - Service: Progressive Lens Consultation
   - Location: Wapda Town, Lahore

**Network Delays:**
- Create: 800ms
- List: 600ms
- Get: 400ms
- Reschedule: 700ms
- Cancel: 700ms

## State Management (Riverpod)

### Providers

```dart
// Repository instance
final homeServiceRepositoryProvider = Provider<HomeServiceRepository>(...)

// All user bookings
final myBookingsProvider = StateNotifierProvider<HomeServiceController, AsyncValue<List<BookingSummary>>>(...)

// Single booking by ID (family)
final selectedBookingProvider = FutureProvider.family<BookingSummary, String>(...)
```

### Controller Methods

```dart
HomeServiceController:
  - loadBookings()                           // Fetch all bookings
  - createBooking(BookingRequest)           // Create new booking
  - reschedule(id, DateTime)                // Reschedule booking
  - cancel(id, String reason)               // Cancel booking
  - refresh()                               // Pull-to-refresh
  - clearError()                            // Clear error state
```

## 24-Hour Rule

**Restriction:** No changes allowed within 24 hours of scheduled service time.

### Implementation

**Domain Level:**
```dart
// BookingSummary property
bool get isWithin24Hours {
  final now = DateTime.now();
  final difference = scheduledAt.difference(now);
  return difference.isNegative || difference < Duration(hours: 24);
}
```

**Controller Level (Guard):**
```dart
Future<void> reschedule(String id, DateTime newTime) async {
  final booking = getCurrentBooking(id);
  
  if (booking.isWithin24Hours) {
    throw FriendlyFailure(
      "Changes aren't allowed within 24 hours of service time."
    );
  }
  
  // Proceed with reschedule...
}
```

**Repository Level (Enforcement):**
```dart
Future<BookingSummary> reschedule(String id, DateTime newTime) async {
  final booking = await getBooking(id);
  
  if (booking.isWithin24Hours) {
    throw FriendlyFailure(
      "Changes aren't allowed within 24 hours of service time."
    );
  }
  
  // Update booking...
}
```

### Testing 24-Hour Rule

Use **BK-001** which is seeded for tomorrow at 10 AM:
```dart
// This will throw FriendlyFailure
await controller.reschedule('BK-001', newTime);
await controller.cancel('BK-001', reason);
```

## Usage Examples

### Loading Bookings

```dart
class MyBookingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(myBookingsProvider);
    
    return bookingsState.when(
      data: (bookings) => ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(booking: booking);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Creating a Booking

```dart
final request = BookingRequest(
  serviceType: 'Eye Test at Home',
  preferredAt: DateTime(2024, 12, 20, 14, 0),
  address: 'House 123, Street 45, Gulberg III, Lahore',
  phone: '+92 300 1234567',
  notes: 'Please ring doorbell twice',
);

try {
  final bookingId = await ref.read(myBookingsProvider.notifier)
    .createBooking(request);
  
  print('Booking created: $bookingId');
} on FriendlyFailure catch (e) {
  // Show user-friendly error
  showSnackBar(e.message);
} catch (e) {
  // Show generic error
  showSnackBar('Failed to create booking');
}
```

### Rescheduling

```dart
try {
  await ref.read(myBookingsProvider.notifier)
    .reschedule('BK-002', DateTime(2024, 12, 25, 16, 0));
  
  showSnackBar('Booking rescheduled successfully');
} on FriendlyFailure catch (e) {
  // User-friendly error (e.g., 24-hour rule)
  showSnackBar(e.message);
} catch (e) {
  showSnackBar('Failed to reschedule');
}
```

### Cancelling

```dart
try {
  await ref.read(myBookingsProvider.notifier)
    .cancel('BK-002', 'Schedule conflict');
  
  showSnackBar('Booking cancelled');
} on FriendlyFailure catch (e) {
  // User-friendly error (e.g., 24-hour rule)
  showSnackBar(e.message);
} catch (e) {
  showSnackBar('Failed to cancel');
}
```

### Getting Single Booking

```dart
class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(
      selectedBookingProvider(bookingId)
    );
    
    return bookingAsync.when(
      data: (booking) => BookingDetails(booking),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### Pull-to-Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    await ref.read(myBookingsProvider.notifier).refresh();
  },
  child: BookingsList(),
)
```

## Service Types

Common service types for Lahore:

- **"Eye Test at Home"** - Full eye examination
- **"Contact Lens Fitting"** - Initial fitting and training
- **"Frame Repair & Adjustment"** - Fix or adjust existing frames
- **"Lens Replacement"** - Replace lenses in existing frames
- **"Progressive Lens Consultation"** - Specialized fitting
- **"Sports Eyewear Fitting"** - Athletic eyewear consultation

## Address Format

**Full Address:**
```
House/Flat Number, Street/Block, Area, City
Example: House 123, Street 45, Gulberg III, Lahore
```

**Short Address (Auto-generated):**
```
First part, Last part
Example: House 123, Lahore
```

## Business Rules

### Booking Creation
- Service type is required
- Preferred time must be in the future
- Full address required
- Phone number required (format validation in UI)
- Notes are optional

### Rescheduling
- Only allowed for `requested` or `scheduled` bookings
- Not allowed within 24 hours of scheduled time
- New time must be in the future

### Cancellation
- Only allowed for `requested` or `scheduled` bookings
- Not allowed within 24 hours of scheduled time
- Cancellation reason required

### Admin Notes
- Set by admin after approval/scheduling
- Read-only for users
- Examples:
  - "Optometrist will bring full equipment"
  - "Please have your prescription ready"
  - "Rescheduled by customer"
  - "Cancelled: Schedule conflict"

## Error Handling

### FriendlyFailure Examples

```dart
// 24-hour rule
"Changes aren't allowed within 24 hours of service time."

// Invalid status
"Cannot reschedule completed booking"
"Cannot cancel cancelled booking"

// Not found
"Booking not found: BK-999"
```

### Best Practices

```dart
try {
  await controller.createBooking(request);
} on FriendlyFailure catch (e) {
  // Show to user as-is (already user-friendly)
  showDialog(
    title: 'Unable to Proceed',
    message: e.message,
  );
} catch (e) {
  // Show generic error
  showDialog(
    title: 'Error',
    message: 'Something went wrong. Please try again.',
  );
}
```

## Testing

### Unit Tests

```dart
test('isWithin24Hours returns true for tomorrow', () {
  final booking = BookingSummary(
    id: 'TEST',
    status: BookingStatus.scheduled,
    scheduledAt: DateTime.now().add(Duration(hours: 12)),
    addressShort: 'Test',
    serviceType: 'Test',
  );
  
  expect(booking.isWithin24Hours, true);
});

test('reschedule throws within 24 hours', () async {
  final controller = HomeServiceController(mockRepo);
  
  expect(
    () => controller.reschedule('BK-001', newTime),
    throwsA(isA<FriendlyFailure>()),
  );
});
```

### Widget Tests

```dart
testWidgets('shows bookings list', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        homeServiceRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: MaterialApp(home: MyBookingsScreen()),
    ),
  );
  
  await tester.pumpAndSettle();
  expect(find.text('BK-001'), findsOneWidget);
});
```

## Future Enhancements

- [ ] Real-time booking status updates
- [ ] Push notifications for status changes
- [ ] Payment integration
- [ ] Service ratings and reviews
- [ ] Recurring bookings
- [ ] Multiple service locations
- [ ] Booking history export
- [ ] Family member management
- [ ] Insurance information
- [ ] Prescription upload

## Integration with Admin Side

The admin side (previously created) handles:
- Approving booking requests
- Assigning service providers
- Updating booking status
- Adding admin notes
- Managing schedules

User side handles:
- Creating booking requests
- Viewing booking status
- Rescheduling (if allowed)
- Cancelling (if allowed)
- Receiving updates via admin notes

## Next Steps

1. Create UI screens:
   - Booking list screen
   - Booking detail screen
   - Create booking form
   - Reschedule dialog
   - Cancel dialog

2. Add to navigation:
   - Add "Book Service" in home/profile
   - Add "My Bookings" in bottom nav or profile

3. Integrate with backend:
   - Replace mock repository
   - Add authentication
   - Real-time updates

4. Polish UX:
   - Loading states
   - Error messages
   - Success confirmations
   - Status badges with colors

