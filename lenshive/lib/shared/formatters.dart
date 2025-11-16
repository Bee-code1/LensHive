import 'package:intl/intl.dart';

/// Shared formatters for the app
class AppFormatters {
  AppFormatters._();

  /// Format Pakistani Rupees with thousands separator
  /// Example: 14999 → "PKR 14,999"
  /// No decimals shown for whole numbers
  static String pkCurrency(int pkr) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'PKR ${formatter.format(pkr)}';
  }

  /// Format with decimals if needed (for future use)
  static String pkCurrencyWithDecimals(double pkr) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return 'PKR ${formatter.format(pkr)}';
  }

  /// Format quantity
  static String quantity(int qty) {
    return qty.toString();
  }

  /// Format percentage
  static String percentage(int percent) {
    return '$percent%';
  }
}

