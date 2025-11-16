// lib/design/app_theme.dart
import 'package:flutter/material.dart';
import 'tokens.dart';

class AppTheme {
  // Helper to avoid hardcoded radii
  static BorderRadius get _cardRadius =>
      BorderRadius.circular(DesignTokens.radiusCard);
  static BorderRadius get _btnRadius =>
      BorderRadius.circular(DesignTokens.radiusButton);
  static BorderRadius get _chipRadius =>
      BorderRadius.circular(DesignTokens.radiusChip);
  static BorderRadius get _inputRadius =>
      BorderRadius.circular(DesignTokens.radiusInput);

  static ThemeData light() {
    final cs = ColorScheme(
      brightness: Brightness.light,
      primary: DesignTokens.primary,              // #2F6BFF
      onPrimary: DesignTokens.white,
      secondary: DesignTokens.gradientEnd,         // #1BB1E6
      onSecondary: DesignTokens.white,
      surface: DesignTokens.card,                  // white
      onSurface: DesignTokens.textPrimary,        // #111827
      surfaceVariant: DesignTokens.surfaceVariant, // #E5E7EB
      onSurfaceVariant: DesignTokens.textSecondary, // #6B7280
      background: DesignTokens.background,         // #F3F4F6
      onBackground: DesignTokens.textPrimary,
      error: DesignTokens.error,                  // #EF4444
      onError: DesignTokens.white,
      outline: DesignTokens.outline,              // #CBD5E1
      shadow: Colors.black12,
      tertiary: DesignTokens.success,             // #10B981
      onTertiary: DesignTokens.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.background,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: _cardRadius),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: cs.onSurfaceVariant,
        textColor: cs.onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: cs.outline),
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: _chipRadius),
        labelStyle: TextStyle(color: cs.onSurface),
        side: BorderSide(color: cs.outline),
        backgroundColor: cs.surfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.surface,
        contentTextStyle: TextStyle(color: cs.onSurface),
      ),
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme(
      brightness: Brightness.dark,
      primary: DesignTokens.primary,
      onPrimary: DesignTokens.white,
      secondary: DesignTokens.gradientEnd,
      onSecondary: DesignTokens.black,
      surface: DesignTokens.cardDark,             // #111827
      onSurface: DesignTokens.textOnDark,         // #E5E7EB
      surfaceVariant: DesignTokens.surfaceVariantDark, // #1F2937
      onSurfaceVariant: DesignTokens.textOnDarkSecondary, // #9CA3AF
      background: DesignTokens.backgroundDark,    // #0B1220
      onBackground: DesignTokens.textOnDark,      // #E5E7EB
      error: DesignTokens.error,
      onError: DesignTokens.white,
      outline: DesignTokens.outlineDark,          // #374151
      shadow: Colors.black26,
      tertiary: DesignTokens.success,
      onTertiary: DesignTokens.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.background,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: _cardRadius),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: cs.onSurfaceVariant,
        textColor: cs.onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: cs.outline),
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _btnRadius),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: _chipRadius),
        labelStyle: TextStyle(color: cs.onSurface),
        side: BorderSide(color: cs.outline),
        backgroundColor: cs.surfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.surface,
        contentTextStyle: TextStyle(color: cs.onSurface),
      ),
    );
  }
}
