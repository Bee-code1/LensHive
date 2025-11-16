import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/router/routes.dart';
import '../../../design/tokens.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/booking_models.dart';
import '../application/home_service_controller.dart';

/// My Home Service Bookings Screen - List of user's bookings
class MyHomeServiceBookingsScreen extends ConsumerStatefulWidget {
  const MyHomeServiceBookingsScreen({super.key});

  @override
  ConsumerState<MyHomeServiceBookingsScreen> createState() =>
      _MyHomeServiceBookingsScreenState();
}

class _MyHomeServiceBookingsScreenState
    extends ConsumerState<MyHomeServiceBookingsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Service'),
        leading: IconButton(
          key: const Key('bookings_back_btn'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.home); // Fall back to home when at root
            }
          },
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go(Routes.home),
            tooltip: 'Go to Home',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceLg,
                vertical: DesignTokens.spaceMd,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    SizedBox(width: DesignTokens.spaceSm),
                    _buildFilterChip('Upcoming'),
                    SizedBox(width: DesignTokens.spaceSm),
                    _buildFilterChip('Completed'),
                    SizedBox(width: DesignTokens.spaceSm),
                    _buildFilterChip('Cancelled'),
                  ],
                ),
              ),
            ),

            // Bookings list
            Expanded(
              child: bookingsState.when(
                data: (bookings) {
                  final filteredBookings = _filterBookings(bookings);

                  if (filteredBookings.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(myBookingsProvider.notifier).refresh();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.all(DesignTokens.spaceLg),
                      itemCount: filteredBookings.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: DesignTokens.spaceMd),
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return _BookingCard(
                          key: Key('hs_list_card_${booking.id}'),
                          booking: booking,
                          onTap: () => context.push(
                            '/home-service/${booking.id}',
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
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
                          'Failed to load bookings',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: DesignTokens.spaceMd),
                        Text(
                          error.toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: DesignTokens.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: DesignTokens.spaceXl),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(myBookingsProvider.notifier).refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('bookings_new_btn'),
        onPressed: () => _openNewBookingForm(context),
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = label);
      },
    );
  }

  List<BookingSummary> _filterBookings(List<BookingSummary> bookings) {
    switch (_selectedFilter) {
      case 'Upcoming':
        return bookings.where((b) => b.status.isActive).toList();
      case 'Completed':
        return bookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
      case 'Cancelled':
        return bookings
            .where((b) => b.status == BookingStatus.cancelled)
            .toList();
      default:
        return bookings;
    }
  }

  /// Open new booking form in a bottom sheet
  void _openNewBookingForm(BuildContext context) {
    // Navigate to the full form screen
    context.push(Routes.homeServiceNew).then((_) {
      // After returning from the form, refresh the list
      ref.read(myBookingsProvider.notifier).refresh();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: DesignTokens.spaceLg),
              Text(
                'No bookings found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: DesignTokens.spaceMd),
              Text(
                _selectedFilter == 'All'
                    ? 'You haven\'t made any bookings yet'
                    : 'No $_selectedFilter bookings',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignTokens.spaceXl),
              ElevatedButton(
                key: const Key('bookings_empty_cta'),
                onPressed: () => _openNewBookingForm(context),
                child: const Text('Book Home Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Booking card widget
class _BookingCard extends StatelessWidget {
  final BookingSummary booking;
  final VoidCallback onTap;

  const _BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, h:mm a');

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.serviceType,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spaceSm),
                  StatusPill(booking.status),
                ],
              ),
              SizedBox(height: DesignTokens.spaceMd),

              // Meta information
              Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: 16,
                    color: DesignTokens.textSecondary,
                  ),
                  SizedBox(width: DesignTokens.spaceXs),
                  Text(
                    '#HS-${booking.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignTokens.textSecondary,
                        ),
                  ),
                  SizedBox(width: DesignTokens.spaceMd),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: DesignTokens.textSecondary,
                  ),
                  SizedBox(width: DesignTokens.spaceXs),
                  Text(
                    dateFormat.format(booking.scheduledAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignTokens.textSecondary,
                        ),
                  ),
                ],
              ),
              SizedBox(height: DesignTokens.spaceXs),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: DesignTokens.textSecondary,
                  ),
                  SizedBox(width: DesignTokens.spaceXs),
                  Expanded(
                    child: Text(
                      booking.addressShort,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: DesignTokens.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Admin note if present
              if (booking.adminNote != null) ...[
                SizedBox(height: DesignTokens.spaceMd),
                Container(
                  padding: EdgeInsets.all(DesignTokens.spaceMd),
                  decoration: BoxDecoration(
                    color: DesignTokens.primary.withValues(alpha: 0.05),
                    borderRadius:
                        BorderRadius.circular(DesignTokens.radiusInput),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: DesignTokens.primary,
                      ),
                      SizedBox(width: DesignTokens.spaceSm),
                      Expanded(
                        child: Text(
                          booking.adminNote!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: DesignTokens.primary,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

