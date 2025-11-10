import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../shared/widgets/status_pill.dart';

/// Admin Home Service Booking Detail Screen - Placeholder
class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking $bookingId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(DesignTokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
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
                          StatusPill(
                            label: 'Pending',
                            backgroundColor: DesignTokens.warning,
                          ),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spaceLg),
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Customer',
                        value: 'John Doe',
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      _InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: '+1 234 567 8900',
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: '123 Main St, City, State 12345',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spaceLg),
              
              // Service Details Card
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
                        value: 'Eye Exam at Home',
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      _InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: 'Dec 15, 2024',
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      _InfoRow(
                        icon: Icons.access_time,
                        label: 'Time',
                        value: '10:00 AM - 11:00 AM',
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      _InfoRow(
                        icon: Icons.attach_money,
                        label: 'Price',
                        value: '\$75.00',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spaceLg),
              
              // Notes Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: DesignTokens.spaceMd),
                      Text(
                        'Customer requested morning appointment. Has pets at home.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spaceXl),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Reject'),
                    ),
                  ),
                  SizedBox(width: DesignTokens.spaceMd),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

