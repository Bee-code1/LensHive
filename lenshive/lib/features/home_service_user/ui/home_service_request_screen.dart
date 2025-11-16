import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/router/routes.dart';
import '../../../design/tokens.dart';
import '../../../shared/widgets/sticky_footer.dart';
import '../domain/booking_models.dart';
import '../application/home_service_controller.dart';

/// Home Service Request Screen - Form to create new booking
class HomeServiceRequestScreen extends ConsumerStatefulWidget {
  const HomeServiceRequestScreen({super.key});

  @override
  ConsumerState<HomeServiceRequestScreen> createState() =>
      _HomeServiceRequestScreenState();
}

class _HomeServiceRequestScreenState
    extends ConsumerState<HomeServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _serviceTypes = [
    'Eye Test at Home',
    'Frame Fitting',
    'Repair/Adjustment',
    'Contact Lens Fitting',
    'Lens Replacement',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 90));

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service')),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    // Combine date and time
    final preferredAt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final request = BookingRequest(
      serviceType: _selectedService!,
      preferredAt: preferredAt,
      address: _addressController.text,
      phone: _phoneController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    // Use root navigator to ensure spinner is above everything
    final rootNav = Navigator.of(context, rootNavigator: true);

    // Show loading spinner
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create booking with timeout
      final bookingId = await ref
          .read(myBookingsProvider.notifier)
          .createBooking(request)
          .timeout(const Duration(seconds: 12));

      // Close loading spinner
      if (rootNav.canPop()) rootNav.pop();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking created: #$bookingId'),
          backgroundColor: DesignTokens.success,
        ),
      );

      // Invalidate bookings list to trigger refresh
      ref.invalidate(myBookingsProvider);

      // Navigate back to bookings list
      context.go(Routes.homeServiceMy);
    } on TimeoutException {
      // Close loading spinner
      if (rootNav.canPop()) rootNav.pop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Network slow. Please try again.'),
          backgroundColor: DesignTokens.warning,
        ),
      );
    } on FriendlyFailure catch (e) {
      // Close loading spinner
      if (rootNav.canPop()) rootNav.pop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: DesignTokens.error,
        ),
      );
    } catch (e) {
      // Close loading spinner
      if (rootNav.canPop()) rootNav.pop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not create booking: $e'),
          backgroundColor: DesignTokens.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: const Text('Home Service Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        actions: [
          TextButton(
            onPressed: () => context.go(Routes.homeServiceMy),
            child: const Text('Done'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(DesignTokens.spaceLg),
                child: Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(DesignTokens.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service type dropdown
                          Text(
                            'Service Needed *',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceSm),
                          Semantics(
                            label: 'Service type',
                            hint: 'Select the type of service you need',
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: 'Select a service',
                                labelText: 'Service Type',
                              ),
                              items: _serviceTypes.map((service) {
                                return DropdownMenuItem(
                                  value: service,
                                  child: Text(service),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedService = value);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a service';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: DesignTokens.spaceLg),

                          // Date picker
                          Text(
                            'Preferred Date & Time *',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceSm),
                          Row(
                            children: [
                              Expanded(
                                child: Semantics(
                                  label: 'Preferred date',
                                  hint: 'Select your preferred appointment date',
                                  button: true,
                                  child: OutlinedButton.icon(
                                    onPressed: _selectDate,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48), // Minimum 48px height for touch target
                                    ),
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(
                                      _selectedDate == null
                                          ? 'Select Date'
                                          : dateFormat.format(_selectedDate!),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: DesignTokens.spaceMd),
                              Expanded(
                                child: Semantics(
                                  label: 'Preferred time',
                                  hint: 'Select your preferred appointment time',
                                  button: true,
                                  child: OutlinedButton.icon(
                                    onPressed: _selectTime,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48), // Minimum 48px height for touch target
                                    ),
                                    icon: const Icon(Icons.access_time),
                                    label: Text(
                                      _selectedTime == null
                                          ? 'Select Time'
                                          : timeFormat.format(
                                              DateTime(2024, 1, 1,
                                                  _selectedTime!.hour,
                                                  _selectedTime!.minute),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: DesignTokens.spaceLg),

                          // Address
                          Text(
                            'Address *',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceSm),
                          Semantics(
                            label: 'Address',
                            hint: 'Enter your complete address for home service',
                            child: TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText:
                                    'House 123, Street 45, Gulberg III, Lahore',
                                labelText: 'Complete Address',
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                if (value.length < 10) {
                                  return 'Please enter a complete address';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: DesignTokens.spaceLg),

                          // Phone
                          Text(
                            'Phone Number *',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceSm),
                          Semantics(
                            label: 'Phone number',
                            hint: 'Enter your phone number in Pakistani format',
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                hintText: '+92 300 1234567',
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                                helperText: 'Format: +92 3XX XXXXXXX',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                // Basic Pakistani phone number validation
                                final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
                                if (!cleanNumber.startsWith('+92') && !cleanNumber.startsWith('0')) {
                                  return 'Please enter a valid Pakistani phone number';
                                }
                                if (cleanNumber.length < 11) {
                                  return 'Phone number is too short';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: DesignTokens.spaceLg),

                          // Notes (optional)
                          Text(
                            'Additional Notes (Optional)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: DesignTokens.spaceSm),
                          Semantics(
                            label: 'Additional notes',
                            hint: 'Add any special instructions or requirements',
                            child: TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Any special instructions or requirements',
                                labelText: 'Notes',
                                prefixIcon: Icon(Icons.note_outlined),
                              ),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spaceLg),

                          // Helper text
                          Container(
                            padding: EdgeInsets.all(DesignTokens.spaceMd),
                            decoration: BoxDecoration(
                              color: DesignTokens.primary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(DesignTokens.radiusInput),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: DesignTokens.primary,
                                ),
                                SizedBox(width: DesignTokens.spaceMd),
                                Expanded(
                                  child: Text(
                                    "We'll confirm your slot by SMS/WhatsApp.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
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
                ),
              ),
            ),

            // Sticky footer with submit button
            StickyFooter(
              child: Semantics(
                label: 'Request booking',
                hint: 'Submit your home service booking request',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('hs_req_submit'),
                    onPressed: _submitBooking,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48), // Minimum 48px height for touch target
                    ),
                    child: const Text('Request Booking'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

