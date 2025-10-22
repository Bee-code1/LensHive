# Color Centralization Guide

## Overview
All hardcoded colors across the LensHive app have been centralized into a single location for easy maintenance and consistent theming.

## What Was Changed

### 1. New Files Created

#### `lib/constants/app_colors.dart`
- Centralized color definitions for the entire app
- Contains all primary, secondary, background, text, and utility colors
- Includes helper methods for getting colors based on theme brightness
- Organized into logical sections:
  - **Primary Colors**: Brand colors and variations
  - **Secondary Colors**: Accent colors
  - **Background Colors**: Light/dark mode backgrounds
  - **Text Colors**: Text colors for different themes
  - **Input Field Colors**: Form input backgrounds
  - **Status Colors**: Success, error, warning, info
  - **Badge Colors**: Product badges (bestseller, new)
  - **Gradient Colors**: Pre-defined gradients
  - **Border/Divider/Shadow Colors**: UI element colors
  - **Icon Colors**: Icon tint colors

#### `lib/constants/app_theme.dart`
- Complete theme configuration using AppColors
- Pre-configured light and dark themes
- Eliminates need to define themes in multiple places
- Easy to maintain and update

### 2. Files Updated

#### `lib/main.dart`
- Replaced inline theme configuration with `AppTheme.lightTheme` and `AppTheme.darkTheme`
- Added import for `constants/app_theme.dart`

#### `lib/screens/profile_screen.dart`
- Replaced all hardcoded colors with `AppColors` constants:
  - `Color(0xFF0A83BC)` → `AppColors.primary`
  - `Color(0xFF4A90E2)` → `AppColors.primaryLight` (in gradient)
  - `Color(0xFF1E1E1E)` → `AppColors.cardDark`
- Updated gradient to use `AppColors.primaryGradient`
- Updated shadow colors to use `AppColors.shadowDark` / `AppColors.shadowLight`

#### `lib/screens/login_screen.dart`
- Replaced input field background colors:
  - `Color(0xFFF5F5F5)` → `AppColors.inputBackgroundLight`
  - `Colors.white.withOpacity(0.05)` → `AppColors.inputBackgroundDark`
- Added import for `constants/app_colors.dart`

#### `lib/screens/registration_screen.dart`
- Same updates as login_screen.dart for consistent input field styling
- Added import for `constants/app_colors.dart`

#### `lib/screens/splash_screen.dart`
- Replaced dark text color:
  - `Color(0xFF1F2937)` → `AppColors.darkTextForLight`
- Added import for `constants/app_colors.dart`

#### `lib/widgets/enhanced_product_card.dart`
- Replaced badge colors:
  - `Color.fromRGBO(36, 197, 101, 1)` → `AppColors.bestsellerBadge`
  - `Color.fromRGBO(239, 75, 86, 1)` → `AppColors.newBadge`
- Updated cart icon background color to use `AppColors.bestsellerBadge`
- Added import for `constants/app_colors.dart`

### 3. Widgets Already Using Theme Colors
These widgets were already properly using theme colors and required no changes:
- `lib/widgets/bottom_nav_bar.dart`
- `lib/widgets/custom_search_bar.dart`
- `lib/widgets/category_tabs.dart`
- `lib/screens/home_screen.dart`

## How to Use AppColors

### Basic Usage
```dart
import 'package:lenshive/constants/app_colors.dart';

// Use primary color
Container(
  color: AppColors.primary,
)

// Use gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)

// Use badge colors
Container(
  color: AppColors.bestsellerBadge,
)
```

### Context-Aware Colors
```dart
import 'package:lenshive/constants/app_colors.dart';

// Get color based on current theme
final bgColor = AppColors.getBackgroundColor(Theme.of(context).brightness);
final cardColor = AppColors.getCardColor(Theme.of(context).brightness);
final textColor = AppColors.getTextColor(Theme.of(context).brightness);
```

### Using AppTheme
```dart
import 'package:lenshive/constants/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
)
```

## Benefits

1. **Single Source of Truth**: All colors defined in one place
2. **Easy Maintenance**: Change a color once, updates everywhere
3. **Consistent Design**: Ensures consistent color usage across the app
4. **Better Organization**: Colors grouped by purpose/usage
5. **Type Safety**: Compile-time checking for color usage
6. **Documentation**: Each color has a descriptive name and comment
7. **Theme Support**: Built-in support for light/dark modes
8. **Helper Methods**: Utility methods for common color operations

## Future Additions

When adding new screens or features, use AppColors instead of hardcoding colors:

```dart
// ❌ DON'T DO THIS
Container(
  color: Color(0xFF0A83BC),
)

// ✅ DO THIS
Container(
  color: AppColors.primary,
)
```

If you need a new color that doesn't exist in AppColors:
1. Add it to `lib/constants/app_colors.dart` in the appropriate section
2. Give it a descriptive name
3. Add a comment explaining its purpose
4. Use it throughout your code

## Color Reference

### Primary Colors
- `AppColors.primary` - Main brand blue (#0A83BC)
- `AppColors.primaryLight` - Light variant (#4A90E2)
- `AppColors.primaryDark` - Dark variant (#075A85)
- `AppColors.primaryDarkMode` - Dark mode primary (#4682B4)

### Background Colors
- `AppColors.backgroundLight` - White
- `AppColors.backgroundDark` - #1A1A1A
- `AppColors.cardLight` - White
- `AppColors.cardDark` - #1E1E1E
- `AppColors.surfaceDark` - #202124

### Status Colors
- `AppColors.success` - Green (#4CAF50)
- `AppColors.error` - Red (#EF5350)
- `AppColors.warning` - Orange (#FF9800)
- `AppColors.info` - Blue (#2196F3)

### Badge Colors
- `AppColors.bestsellerBadge` - Green (rgb(36, 197, 101))
- `AppColors.newBadge` - Red (rgb(239, 75, 86))

### Special Colors
- `AppColors.darkTextForLight` - Dark gray text for light backgrounds (#1F2937)
- `AppColors.primaryGradient` - Gradient from primary to primaryLight

## Notes

- All widgets using `Theme.of(context)` for colors are already theme-aware and don't need changes
- The centralized colors work seamlessly with Flutter's theme system
- Helper methods in AppColors make it easy to get the right color for the current theme

