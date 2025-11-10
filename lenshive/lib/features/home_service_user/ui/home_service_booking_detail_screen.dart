import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../design/tokens.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/sticky_footer.dart';
import '../domain/booking_models.dart';
import '../application/home_service_controller.dart';

/// Home Service Booking Detail Screen
class HomeServiceBookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const HomeServiceBookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(selectedBookingProvider(bookingId));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Text('Booking #HS-$bookingId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/home-service/my'),
            child: const Text('Done'),
          ),
        ],
      ),
      body: bookingAsync.when(
        data: (booking) => _buildContent(context, ref, booking),
        loading: () => const Center(child: CircularProgressIndicator()),
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
                  'Booking not found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: DesignTokens.spaceMd),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, BookingSummary booking) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    final timeFormat = DateFormat('h:mm a');
    final canModify = booking.canModify;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(DesignTokens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(DesignTokens.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Status',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const Spacer(),
                              _StatusPill(status: booking.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: DesignTokens.spaceMd),

                  // Service details card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(DesignTokens.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Details',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceLg),
                          _InfoRow(
                            icon: Icons.medical_services_outlined,
                            label: 'Service',
                            value: booking.serviceType,
                          ),
                          SizedBox(height: DesignTokens.spaceMd),
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value: dateFormat.format(booking.scheduledAt),
                          ),
                          SizedBox(height: DesignTokens.spaceMd),
                          _InfoRow(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: timeFormat.format(booking.scheduledAt),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: DesignTokens.spaceMd),

                  // Contact details card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(DesignTokens.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Details',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceLg),
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'Address',
                            value: booking.addressShort,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Admin note card
                  if (booking.adminNote != null) ...[
                    SizedBox(height: DesignTokens.spaceMd),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(DesignTokens.spaceLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Note',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: DesignTokens.spaceMd),
                            Container(
                              padding: EdgeInsets.all(DesignTokens.spaceMd),
                              decoration: BoxDecoration(
                                color:
                                    DesignTokens.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusInput),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: DesignTokens.primary,
                                  ),
                                  SizedBox(width: DesignTokens.spaceMd),
                                  Expanded(
                                    child: Text(
                                      booking.adminNote!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: DesignTokens.primary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // 24-hour warning
                  if (booking.isWithin24Hours &&
                      (booking.status.canReschedule ||
                          booking.status.canCancel)) ...[
                    SizedBox(height: DesignTokens.spaceMd),
                    Container(
                      padding: EdgeInsets.all(DesignTokens.spaceMd),
                      decoration: BoxDecoration(
                        color: DesignTokens.warning.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusInput),
                        border: Border.all(
                          color: DesignTokens.warning.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: DesignTokens.warning,
                            size: 20,
                          ),
                          SizedBox(width: DesignTokens.spaceMd),
                          Expanded(
                            child: Text(
                              "Changes aren't allowed within 24 hours of service time.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: DesignTokens.warning,
                                    fontWeight: FontWeight.w500,
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

          // Actions footer
          if (booking.status.canReschedule || booking.status.canCancel)
            StickyFooter(
              child: Column(
                children: [
                  if (booking.status.canReschedule)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('hs_detail_reschedule'),
                        onPressed: canModify
                            ? () => _showRescheduleDialog(context, ref, booking)
                            : null,
                        child: const Text('Reschedule'),
                      ),
                    ),
                  if (booking.status.canReschedule &&
                      booking.status.canCancel)
                    SizedBox(height: DesignTokens.spaceMd),
                  if (booking.status.canCancel)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        key: const Key('hs_detail_cancel'),
                        onPressed: canModify
                            ? () => _showCancelDialog(context, ref, booking)
                            : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DesignTokens.error,
                          side: BorderSide(
                            color: canModify
                                ? DesignTokens.error
                                : DesignTokens.borderColor,
                          ),
                        ),
                        child: const Text('Cancel Booking'),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showRescheduleDialog(
      BuildContext context, WidgetRef ref, BookingSummary booking) async {
    DateTime? selectedDate = booking.scheduledAt;
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(booking.scheduledAt);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reschedule Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        selectedDate ?? now.add(const Duration(days: 1)),
                    firstDate: now.add(const Duration(days: 1)),
                    lastDate: now.add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(selectedDate == null
                    ? 'Select Date'
                    : DateFormat('dd MMM yyyy').format(selectedDate!)),
              ),
              SizedBox(height: DesignTokens.spaceMd),
              OutlinedButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text(selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null && selectedTime != null) {
                  final newDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  Navigator.of(context).pop();
                  await _performReschedule(context, ref, booking.id, newDateTime);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performReschedule(BuildContext context, WidgetRef ref,
      String bookingId, DateTime newTime) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(myBookingsProvider.notifier).reschedule(bookingId, newTime);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Booking rescheduled successfully'),
            backgroundColor: DesignTokens.success,
          ),
        );
        context.pop(); // Go back to list
      }
    } on FriendlyFailure catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to reschedule. Please try again.'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }

  Future<void> _showCancelDialog(
      BuildContext context, WidgetRef ref, BookingSummary booking) async {
    final reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please provide a reason for cancellation:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: DesignTokens.spaceMd),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'e.g., Schedule conflict, Health reasons',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a cancellation reason'),
                  ),
                );
                return;
              }

              Navigator.of(context).pop();
              await _performCancel(context, ref, booking.id, reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.error,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );

    reasonController.dispose();
  }

  Future<void> _performCancel(BuildContext context, WidgetRef ref,
      String bookingId, String reason) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(myBookingsProvider.notifier).cancel(bookingId, reason);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Booking cancelled'),
            backgroundColor: DesignTokens.success,
          ),
        );
        context.pop(); // Go back to list
      }
    } on FriendlyFailure catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to cancel. Please try again.'),
            backgroundColor: DesignTokens.error,
          ),
        );
      }
    }
  }
}

/// Info row widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: DesignTokens.textSecondary,
        ),
        SizedBox(width: DesignTokens.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DesignTokens.textSecondary,
                    ),
              ),
              SizedBox(height: DesignTokens.spaceXs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Status pill widget
class _StatusPill extends StatelessWidget {
  final BookingStatus status;

  const _StatusPill({required this.status});

  Color _getColor() {
    switch (status) {
      case BookingStatus.requested:
        return DesignTokens.warning;
      case BookingStatus.scheduled:
        return DesignTokens.primary;
      case BookingStatus.inProgress:
        return DesignTokens.primary;
      case BookingStatus.completed:
        return DesignTokens.success;
      case BookingStatus.cancelled:
        return DesignTokens.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: status.label,
      backgroundColor: _getColor(),
    );
  }
}

