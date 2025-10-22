import 'package:flutter/material.dart';

/// App Colors Constants
/// Centralized color definitions for consistent theming across the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== Primary Colors ====================
  
  /// Main brand color - Professional Blue
  static const Color primary = Color(0xFF0A83BC);
  
  /// Lighter variant of primary color for gradients
  static const Color primaryLight = Color(0xFF4A90E2);
  
  /// Dark variant of primary color
  static const Color primaryDark = Color(0xFF075A85);
  
  /// Primary color for dark mode (lighter for better contrast)
  static const Color primaryDarkMode = Color(0xFF4682B4);

  // ==================== Secondary Colors ====================
  
  /// Secondary accent color
  static const Color secondary = Color(0xFF81D4FA);
  
  /// Tertiary accent color for highlights
  static const Color tertiary = Color(0xFF80DEEA);

  // ==================== Background Colors ====================
  
  /// Light mode scaffold background
  static const Color backgroundLight = Colors.white;
  
  /// Dark mode scaffold background
  static const Color backgroundDark = Color(0xFF1A1A1A);
  
  /// Light mode card background
  static const Color cardLight = Colors.white;
  
  /// Dark mode card background
  static const Color cardDark = Color(0xFF1E1E1E);
  
  /// Dark mode surface color (slightly lighter than background)
  static const Color surfaceDark = Color(0xFF202124);

  // ==================== Text Colors ====================
  
  /// Primary text color for light mode
  static const Color textPrimaryLight = Color(0xFF212121);
  
  /// Secondary text color for light mode
  static const Color textSecondaryLight = Color(0xFF757575);
  
  /// Primary text color for dark mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  
  /// Secondary text color for dark mode
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  // ==================== Input Field Colors ====================
  
  /// Light mode input field background
  static const Color inputBackgroundLight = Color(0xFFF5F5F5);
  
  /// Dark mode input field background (semi-transparent white)
  static Color inputBackgroundDark = Colors.white.withOpacity(0.05);

  // ==================== Status Colors ====================
  
  /// Success color (green)
  static const Color success = Color(0xFF4CAF50);
  
  /// Error color (red)
  static const Color error = Color(0xFFEF5350);
  
  /// Warning color (orange)
  static const Color warning = Color(0xFFFF9800);
  
  /// Info color (blue)
  static const Color info = Color(0xFF2196F3);

  // ==================== Badge Colors ====================
  
  /// Bestseller badge color (green)
  static const Color bestsellerBadge = Color.fromRGBO(36, 197, 101, 1);
  
  /// New badge color (red)
  static const Color newBadge = Color.fromRGBO(239, 75, 86, 1);

  // ==================== Gradient Colors ====================
  
  /// Primary gradient for headers and special sections
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      primaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Dark text color for light backgrounds
  static const Color darkTextForLight = Color(0xFF1F2937);
  
  /// Dark gradient for overlays
  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      darkTextForLight,
      Color(0xFF111827),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== Border Colors ====================
  
  /// Light mode border color
  static Color borderLight = Colors.grey[200]!;
  
  /// Dark mode border color
  static Color borderDark = Colors.white.withOpacity(0.1);

  // ==================== Divider Colors ====================
  
  /// Light mode divider color
  static Color dividerLight = Colors.grey[300]!;
  
  /// Dark mode divider color
  static Color dividerDark = Colors.white.withOpacity(0.12);

  // ==================== Shadow Colors ====================
  
  /// Light mode shadow color
  static Color shadowLight = Colors.black.withOpacity(0.05);
  
  /// Dark mode shadow color
  static Color shadowDark = Colors.black.withOpacity(0.3);

  // ==================== Icon Colors ====================
  
  /// Light mode icon color
  static Color iconLight = Colors.grey[700]!;
  
  /// Dark mode icon color
  static Color iconDark = Colors.white.withOpacity(0.87);

  // ==================== Utility Colors ====================
  
  /// Pure white
  static const Color white = Colors.white;
  
  /// Pure black
  static const Color black = Colors.black;
  
  /// Transparent
  static const Color transparent = Colors.transparent;

  // ==================== Helper Methods ====================
  
  /// Get appropriate background color based on brightness
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? backgroundDark : backgroundLight;
  }
  
  /// Get appropriate card color based on brightness
  static Color getCardColor(Brightness brightness) {
    return brightness == Brightness.dark ? cardDark : cardLight;
  }
  
  /// Get appropriate text color based on brightness
  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;
  }
  
  /// Get appropriate border color based on brightness
  static Color getBorderColor(Brightness brightness) {
    return brightness == Brightness.dark ? borderDark : borderLight;
  }
  
  /// Get appropriate shadow color based on brightness
  static Color getShadowColor(Brightness brightness) {
    return brightness == Brightness.dark ? shadowDark : shadowLight;
  }
  
  /// Get appropriate input background color based on brightness
  static Color getInputBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? inputBackgroundDark : inputBackgroundLight;
  }
}

