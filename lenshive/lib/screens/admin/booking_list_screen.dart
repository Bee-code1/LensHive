import 'package:flutter/material.dart';
import '../../design/tokens.dart';
import '../../shared/widgets/status_pill.dart';

/// Admin Home Service Booking List Screen - Placeholder
class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Service Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Pending',
                      count: 5,
                      color: DesignTokens.warning,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spaceMd),
                  Expanded(
                    child: _StatCard(
                      label: 'Completed',
                      count: 23,
                      color: DesignTokens.success,
                    ),
                  ),
                ],
              ),
              SizedBox(height: DesignTokens.spaceXl),
              
              // List header
              Text(
                'Recent Bookings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: DesignTokens.spaceMd),
              
              // Placeholder list
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) => 
                    SizedBox(height: DesignTokens.spaceMd),
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      id: 'BK-${1000 + index}',
                      customerName: 'Customer ${index + 1}',
                      service: 'Eye Exam at Home',
                      date: 'Dec ${15 + index}, 2024',
                      status: index == 0 ? 'Pending' : 'Completed',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DesignTokens.textSecondary,
              ),
            ),
            SizedBox(height: DesignTokens.spaceSm),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String id;
  final String customerName;
  final String service;
  final String date;
  final String status;

  const _BookingCard({
    required this.id,
    required this.customerName,
    required this.service,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'Completed';
    
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    id,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  StatusPill(
                    label: status,
                    backgroundColor: isCompleted 
                      ? DesignTokens.success 
                      : DesignTokens.warning,
                  ),
                ],
              ),
              SizedBox(height: DesignTokens.spaceSm),
              Text(
                customerName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: DesignTokens.spaceXs),
              Text(
                service,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary,
                ),
              ),
              SizedBox(height: DesignTokens.spaceSm),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: DesignTokens.textSecondary,
                  ),
                  SizedBox(width: DesignTokens.spaceXs),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
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

