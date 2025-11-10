import 'package:flutter/material.dart';
import '../../features/home_service_user/domain/booking_models.dart';

BookingStatus parseBookingStatus(String v) {
  switch (v.toLowerCase()) {
    case 'requested': return BookingStatus.requested;
    case 'scheduled': return BookingStatus.scheduled;
    case 'in progress':
    case 'in_progress': return BookingStatus.inProgress;
    case 'completed': return BookingStatus.completed;
    case 'cancelled':
    case 'canceled': return BookingStatus.cancelled;
    default: return BookingStatus.requested;
  }
}

class StatusPill extends StatelessWidget {
  final BookingStatus status;
  final EdgeInsets padding;
  const StatusPill(this.status, {super.key, this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6)});

  (Color bg, Color fg, String label) _map(BuildContext c) {
    final cs = Theme.of(c).colorScheme;
    switch (status) {
      case BookingStatus.requested:  return (cs.secondaryContainer, cs.onSecondaryContainer, 'REQUESTED');
      case BookingStatus.scheduled:  return (cs.primaryContainer,   cs.onPrimaryContainer,   'SCHEDULED');
      case BookingStatus.inProgress: return (cs.tertiaryContainer,  cs.onTertiaryContainer,  'IN PROGRESS');
      case BookingStatus.completed:  return (const Color(0xFFDEF7EC), const Color(0xFF065F46), 'COMPLETED');
      case BookingStatus.cancelled:  return (cs.errorContainer,     cs.onErrorContainer,     'CANCELLED');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _map(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}
