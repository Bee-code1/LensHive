import 'package:flutter/material.dart';

/// Design Tokens for Stitch Visual System
/// Centralized design tokens for colors, spacing, radii, and shadows
class DesignTokens {
  DesignTokens._();

  // ==================== Colors ====================
  
  /// Primary brand color - Stitch Blue
  static const Color primary = Color(0xFF2F6BFF);
  
  /// Gradient colors for premium elements
  static const Color gradientStart = Color(0xFFD73F86);
  static const Color gradientEnd = Color(0xFF1BB1E6);
  
  /// Background color - Light Gray
  static const Color background = Color(0xFFF3F4F6);
  
  /// Background color - Dark
  static const Color backgroundDark = Color(0xFF0B1220);
  
  /// Card background - Pure White
  static const Color card = Color(0xFFFFFFFF);
  
  /// Card background - Dark
  static const Color cardDark = Color(0xFF111827);
  
  /// Surface variant - Light
  static const Color surfaceVariant = Color(0xFFE5E7EB);
  
  /// Surface variant - Dark
  static const Color surfaceVariantDark = Color(0xFF1F2937);
  
  /// Primary text color - Dark
  static const Color textPrimary = Color(0xFF111827);
  
  /// Secondary text color - Gray
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// Text color on dark backgrounds
  static const Color textOnDark = Color(0xFFE5E7EB);
  
  /// Secondary text on dark backgrounds
  static const Color textOnDarkSecondary = Color(0xFF9CA3AF);
  
  /// Outline color - Light
  static const Color outline = Color(0xFFCBD5E1);
  
  /// Outline color - Dark
  static const Color outlineDark = Color(0xFF374151);
  
  /// Success color - Green
  static const Color success = Color(0xFF10B981);
  
  /// Warning color - Amber
  static const Color warning = Color(0xFFF59E0B);
  
  /// Error color - Red
  static const Color error = Color(0xFFEF4444);
  
  /// White
  static const Color white = Color(0xFFFFFFFF);
  
  /// Black
  static const Color black = Color(0xFF000000);
  
  // ==================== Gradients ====================
  
  /// Premium gradient for accents and CTAs
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== Border Radii ====================
  
  /// Card border radius - 20px
  static const double radiusCard = 20.0;
  
  /// Button border radius - 16px
  static const double radiusButton = 16.0;
  
  /// Chip border radius - 12px
  static const double radiusChip = 12.0;
  
  /// Input border radius - 12px
  static const double radiusInput = 12.0;
  
  // ==================== Spacing ====================
  
  /// Extra small spacing - 4px
  static const double spaceXs = 4.0;
  
  /// Small spacing - 8px
  static const double spaceSm = 8.0;
  
  /// Medium spacing - 12px
  static const double spaceMd = 12.0;
  
  /// Large spacing - 16px
  static const double spaceLg = 16.0;
  
  /// Extra large spacing - 24px
  static const double spaceXl = 24.0;
  
  // ==================== Shadows ====================
  
  /// Subtle shadow for cards and elevated elements
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 6),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
  
  // ==================== Typography ====================
  
  /// Font family - Inter (with Poppins fallback)
  static const String fontFamily = 'Inter';
  static const String fontFamilyFallback = 'Poppins';
  
  // ==================== Border ====================
  
  /// Standard border width
  static const double borderWidth = 1.0;
  
  /// Border color for outlined elements
  static Color borderColor = Colors.grey.shade300;
}

