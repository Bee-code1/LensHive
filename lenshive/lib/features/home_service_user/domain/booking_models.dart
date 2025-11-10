import 'package:flutter/foundation.dart';

/// Booking status from user perspective
enum BookingStatus {
  requested,   // User submitted, awaiting admin approval
  scheduled,   // Admin approved and scheduled
  inProgress,  // Service is currently happening
  completed,   // Service completed
  cancelled,   // Cancelled by user or admin
}

/// Extension for user-friendly status labels
extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.requested:
        return 'Requested';
      case BookingStatus.scheduled:
        return 'Scheduled';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive =>
      this == BookingStatus.requested ||
      this == BookingStatus.scheduled ||
      this == BookingStatus.inProgress;

  bool get canReschedule =>
      this == BookingStatus.requested || this == BookingStatus.scheduled;

  bool get canCancel =>
      this == BookingStatus.requested || this == BookingStatus.scheduled;
}

/// Booking request - data submitted by user when creating a new booking
@immutable
class BookingRequest {
  final String serviceType;
  final DateTime preferredAt;
  final String address;
  final String phone;
  final String? notes;

  const BookingRequest({
    required this.serviceType,
    required this.preferredAt,
    required this.address,
    required this.phone,
    this.notes,
  });

  /// Copy with method
  BookingRequest copyWith({
    String? serviceType,
    DateTime? preferredAt,
    String? address,
    String? phone,
    String? notes,
  }) {
    return BookingRequest(
      serviceType: serviceType ?? this.serviceType,
      preferredAt: preferredAt ?? this.preferredAt,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceType': serviceType,
      'preferredAt': preferredAt.toIso8601String(),
      'address': address,
      'phone': phone,
      if (notes != null) 'notes': notes,
    };
  }

  /// Create from JSON
  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      serviceType: json['serviceType'] as String,
      preferredAt: DateTime.parse(json['preferredAt'] as String),
      address: json['address'] as String,
      phone: json['phone'] as String,
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingRequest &&
          runtimeType == other.runtimeType &&
          serviceType == other.serviceType &&
          preferredAt == other.preferredAt &&
          address == other.address &&
          phone == other.phone &&
          notes == other.notes;

  @override
  int get hashCode =>
      serviceType.hashCode ^
      preferredAt.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      notes.hashCode;
}

/// Booking summary - simplified view of a booking for list displays
@immutable
class BookingSummary {
  final String id;
  final String userId; // Owner of the booking
  final BookingStatus status;
  final DateTime scheduledAt;
  final String addressShort;
  final String serviceType;
  final String? adminNote;

  const BookingSummary({
    required this.id,
    required this.userId,
    required this.status,
    required this.scheduledAt,
    required this.addressShort,
    required this.serviceType,
    this.adminNote,
  });

  /// Check if booking is within 24 hours
  bool get isWithin24Hours {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    return difference.isNegative || difference < const Duration(hours: 24);
  }

  /// Check if changes are allowed (not within 24h and status allows)
  bool get canModify {
    if (isWithin24Hours) return false;
    return status.canReschedule || status.canCancel;
  }

  /// Copy with method
  BookingSummary copyWith({
    String? id,
    String? userId,
    BookingStatus? status,
    DateTime? scheduledAt,
    String? addressShort,
    String? serviceType,
    String? adminNote,
  }) {
    return BookingSummary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      addressShort: addressShort ?? this.addressShort,
      serviceType: serviceType ?? this.serviceType,
      adminNote: adminNote ?? this.adminNote,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.name,
      'scheduledAt': scheduledAt.toIso8601String(),
      'addressShort': addressShort,
      'serviceType': serviceType,
      if (adminNote != null) 'adminNote': adminNote,
    };
  }

  /// Create from JSON
  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    return BookingSummary(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.requested,
      ),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      addressShort: json['addressShort'] as String,
      serviceType: json['serviceType'] as String,
      adminNote: json['adminNote'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingSummary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          status == other.status &&
          scheduledAt == other.scheduledAt &&
          addressShort == other.addressShort &&
          serviceType == other.serviceType &&
          adminNote == other.adminNote;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      status.hashCode ^
      scheduledAt.hashCode ^
      addressShort.hashCode ^
      serviceType.hashCode ^
      adminNote.hashCode;
}

/// Custom exception for user-friendly error messages
class FriendlyFailure implements Exception {
  final String message;

  const FriendlyFailure(this.message);

  @override
  String toString() => message;
}

