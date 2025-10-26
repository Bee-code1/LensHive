# app_colors.dart Documentation

**File Path:** `lenshive/lib/constants/app_colors.dart`

## Purpose
Centralized color management system for the LensHive app, providing consistent colors across light and dark themes.

## Key Concepts & Components

### 1. **Static Class Pattern**
```dart
class AppColors {
  AppColors._();  // Private constructor
  static const Color primary = Color(0xFF0A83BC);
}
```
- **What it is**: A class with only static members and no instances
- **Why we use it**: Provides namespace for colors without creating objects
- **Learning**: Private constructor `_()` prevents instantiation

### 2. **Color Representation**
```dart
Color(0xFF0A83BC)
```
- **Format**: `0xAARRGGBB` (hex notation)
- **AA**: Alpha (opacity) - `FF` = fully opaque
- **RR**: Red component
- **GG**: Green component
- **BB**: Blue component

### 3. **Theme-Aware Colors**
The file provides separate colors for light and dark modes, ensuring proper contrast and readability.

## Color Categories

### Primary Colors
```dart
primary = 0xFF0A83BC           // Professional Blue
primaryLight = 0xFF4A90E2      // Lighter variant
primaryDark = 0xFF075A85       // Darker variant
primaryDarkMode = 0xFF4682B4   // Dark mode primary
```
- **Usage**: Buttons, links, active states
- **Brand Identity**: Main LensHive color

### Secondary Colors
```dart
secondary = 0xFF81D4FA          // Light blue accent
tertiary = 0xFF80DEEA           // Cyan accent
```
- **Usage**: Highlights, secondary buttons, accents

### Background Colors
```dart
backgroundLight = Colors.white
backgroundDark = 0xFF1A1A1A
cardLight = Colors.white
cardDark = 0xFF1E1E1E
surfaceDark = 0xFF202124
```
- **Usage**: Screen backgrounds, card surfaces

### Text Colors
```dart
textPrimaryLight = 0xFF212121
textSecondaryLight = 0xFF757575
textPrimaryDark = 0xFFFFFFFF
textSecondaryDark = 0xFFB3B3B3
```
- **Usage**: Body text, headings, labels

### Input Field Colors
```dart
inputBackgroundLight = 0xFFF5F5F5
inputBackgroundDark = Colors.white.withOpacity(0.05)
```
- **Usage**: TextFormField backgrounds

### Status Colors
```dart
success = 0xFF4CAF50  // Green
error = 0xFFEF5350    // Red
warning = 0xFFFF9800  // Orange
info = 0xFF2196F3     // Blue
```
- **Usage**: Feedback messages, alerts, notifications

### Badge Colors
```dart
bestsellerBadge = Color.fromRGBO(36, 197, 101, 1)  // Green
newBadge = Color.fromRGBO(239, 75, 86, 1)          // Red
```
- **Usage**: Product cards (bestseller, new badges)

### Border & Divider Colors
```dart
borderLight = Colors.grey[200]!
borderDark = Colors.white.withOpacity(0.1)
dividerLight = Colors.grey[300]!
dividerDark = Colors.white.withOpacity(0.12)
```
- **Usage**: Container borders, dividing lines

### Shadow Colors
```dart
shadowLight = Colors.black.withOpacity(0.05)
shadowDark = Colors.black.withOpacity(0.3)
```
- **Usage**: Card shadows, elevation

## Gradients

### Primary Gradient
```dart
LinearGradient(
  colors: [primary, primaryLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```
- **Usage**: App bars, hero sections, special buttons

### Dark Gradient
```dart
LinearGradient(
  colors: [darkTextForLight, Color(0xFF111827)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
)
```
- **Usage**: Dark overlays on images

## Helper Methods

### 1. **getBackgroundColor()**
```dart
static Color getBackgroundColor(Brightness brightness)
```
- Returns appropriate background based on theme
- **Input**: Current theme brightness
- **Output**: Background color

### 2. **getCardColor()**
```dart
static Color getCardColor(Brightness brightness)
```
- Returns card background color
- Used for consistent card styling

### 3. **getTextColor()**
```dart
static Color getTextColor(Brightness brightness)
```
- Returns primary text color
- Ensures text is always readable

### 4. **getBorderColor()**
```dart
static Color getBorderColor(Brightness brightness)
```
- Returns border color for containers

### 5. **getShadowColor()**
```dart
static Color getShadowColor(Brightness brightness)
```
- Returns shadow color for elevations

### 6. **getInputBackgroundColor()**
```dart
static Color getInputBackgroundColor(Brightness brightness)
```
- Returns input field background color

## Usage Patterns

### In Widgets
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.white),
  ),
)
```

### Theme-Aware Usage
```dart
final brightness = Theme.of(context).brightness;
final bgColor = AppColors.getBackgroundColor(brightness);
```

### With Opacity
```dart
AppColors.primary.withOpacity(0.5)  // 50% transparent
```

## Learning Notes

### Why Centralize Colors?
1. **Consistency**: Same colors used everywhere
2. **Maintainability**: Change once, update everywhere
3. **Theming**: Easy light/dark mode switching
4. **Accessibility**: Ensure proper contrast ratios

### Color Opacity
```dart
withOpacity(0.1)  // 10% opacity
withOpacity(0.5)  // 50% opacity
withOpacity(0.9)  // 90% opacity
```

### Material Color Shades
```dart
Colors.grey[100]  // Lightest
Colors.grey[200]
...
Colors.grey[900]  // Darkest
```

## Accessibility Considerations

### Contrast Ratios
- **Text on Background**: Minimum 4.5:1 ratio
- **Large Text**: Minimum 3:1 ratio
- **Interactive Elements**: Minimum 3:1 ratio

### Current Implementation
- Primary text on light background: ✅ High contrast
- Primary text on dark background: ✅ High contrast
- Status colors: ✅ Distinct and recognizable

## Common Issues & Solutions

**Issue**: Colors look different on Android/iOS
- **Solution**: Colors are consistent; check device color profiles

**Issue**: Dark mode text not readable
- **Solution**: Use `getTextColor(brightness)` helper

**Issue**: Color not updating on theme change
- **Solution**: Ensure using helper methods, not hardcoded colors

## Best Practices

1. **Always use AppColors**: Never use `Colors.blue` directly
2. **Use helper methods**: For theme-aware colors
3. **Maintain consistency**: Stick to defined color palette
4. **Test both themes**: Verify colors in light and dark modes
5. **Accessibility first**: Ensure sufficient contrast

## Future Enhancements
- Add color schemes for different brands
- Implement dynamic color generation (Material You)
- Add color blind friendly alternatives
- Create color validation tools
- Support custom user themes

