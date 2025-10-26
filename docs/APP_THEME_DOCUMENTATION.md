# app_theme.dart Documentation

**File Path:** `lenshive/lib/constants/app_theme.dart`

## Purpose
Defines complete Material Design 3 theme configurations for both light and dark modes, ensuring consistent styling across the entire LensHive application.

## Key Concepts & Components

### 1. **Material Design 3 (Material You)**
```dart
ThemeData(useMaterial3: true)
```
- **What it is**: Google's latest design system (2021+)
- **Key features**: Dynamic colors, enhanced components, modern aesthetics
- **Why we use it**: Modern look, better accessibility, improved UX
- **Learning**: Material 3 uses color roles (primary, secondary, tertiary) more systematically

### 2. **ThemeData Class**
```dart
ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(...),
  scaffoldBackgroundColor: ...,
  // ... more theme properties
)
```
- **What it is**: Flutter's comprehensive theme configuration class
- **Purpose**: Defines colors, typography, shapes, and behavior for all widgets
- **Learning**: Every Material widget respects ThemeData

### 3. **ColorScheme**
```dart
ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  brightness: Brightness.light,
)
```
- **What it is**: Systematic color palette for Material 3
- **How it works**: Generates harmonious colors from a seed color
- **Color roles**: primary, secondary, tertiary, error, surface, background
- **Learning**: Material 3 automatically calculates complementary colors

## Theme Components Breakdown

### Light Theme Configuration

#### Color Scheme
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: AppColors.primary,        // Base color for generation
  brightness: Brightness.light,
  primary: AppColors.primary,          // Main brand color
  secondary: AppColors.secondary,      // Accent color
  error: AppColors.error,              // Error states
  background: AppColors.backgroundLight,
  surface: AppColors.cardLight,        // Card/dialog backgrounds
)
```

**Color Roles Explained:**
- **primary**: Main actions (buttons, active states)
- **secondary**: Supporting actions, FAB
- **tertiary**: Accent highlights
- **error**: Error messages, destructive actions
- **background**: Screen backgrounds
- **surface**: Card, dialog, sheet backgrounds
- **onPrimary**: Text on primary color
- **onSurface**: Text on surface color

#### Scaffold Background
```dart
scaffoldBackgroundColor: AppColors.backgroundLight
```
- **What it is**: Default background for all screens
- **Light mode**: Pure white (#FFFFFF)
- **Purpose**: Clean, professional appearance

#### Card Theme
```dart
cardTheme: CardTheme(
  color: AppColors.cardLight,
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
)
```
- **color**: Card background color
- **elevation**: Shadow depth (0-24, higher = more shadow)
- **shape**: Corner rounding (16px radius for modern look)
- **Learning**: Elevation creates visual hierarchy

#### AppBar Theme
```dart
appBarTheme: const AppBarTheme(
  centerTitle: true,              // Center the title
  elevation: 0,                   // Flat design (no shadow)
  backgroundColor: AppColors.backgroundLight,
  foregroundColor: AppColors.textPrimaryLight,
  iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
)
```
- **centerTitle**: iOS-style centered title
- **elevation: 0**: Modern flat design trend
- **foregroundColor**: Text and icon color
- **Learning**: Elevation 0 creates seamless header

#### Text Theme
```dart
textTheme: const TextTheme(
  bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
  bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
  bodySmall: TextStyle(color: AppColors.textSecondaryLight),
  titleLarge: TextStyle(
    color: AppColors.textPrimaryLight,
    fontWeight: FontWeight.bold,
  ),
)
```

**Typography Scale:**
- **bodyLarge**: 16sp - Main body text
- **bodyMedium**: 14sp - Default body text
- **bodySmall**: 12sp - Captions, secondary text
- **titleLarge**: 22sp - Screen titles, headers
- **titleMedium**: 16sp - Section headers
- **titleSmall**: 14sp - List item titles

**Learning**: Material 3 uses type scale for visual hierarchy

#### Icon Theme
```dart
iconTheme: IconThemeData(color: AppColors.iconLight)
```
- **Purpose**: Default color for all icons
- **Light mode**: Dark gray for contrast
- **Size**: Default 24x24 dp (can be overridden)

#### Divider Theme
```dart
dividerTheme: DividerThemeData(
  color: AppColors.dividerLight,
  thickness: 1,
)
```
- **What it is**: Horizontal/vertical separating lines
- **thickness**: Line width in pixels
- **Usage**: List separators, section dividers

#### Input Decoration Theme
```dart
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: AppColors.inputBackgroundLight,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: AppColors.primary,
      width: 0.8,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: AppColors.error,
      width: 0.8,
    ),
  ),
)
```

**Border States:**
- **border**: Default state (no border, filled background)
- **focusedBorder**: When user taps field (primary color outline)
- **errorBorder**: When validation fails (error color outline)
- **enabledBorder**: When enabled but not focused
- **disabledBorder**: When disabled

**Learning**: Different borders for different states provide visual feedback

#### Elevated Button Theme
```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,                    // Flat design
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 24, 
      vertical: 12
    ),
  ),
)
```

**Button Properties:**
- **backgroundColor**: Button fill color
- **foregroundColor**: Text/icon color
- **elevation**: Shadow depth (0 = flat)
- **shape**: Rounded corners
- **padding**: Internal spacing
- **Learning**: elevation: 0 gives modern flat appearance

### Dark Theme Configuration

#### Color Scheme (Dark Mode)
```dart
colorScheme: ColorScheme.dark(
  primary: AppColors.primaryDarkMode,
  secondary: AppColors.secondary,
  tertiary: AppColors.tertiary,
  surface: AppColors.surfaceDark,
  background: AppColors.backgroundDark,
  onPrimary: AppColors.white,
  onSecondary: AppColors.white,
  onSurface: AppColors.textPrimaryDark,
  onBackground: AppColors.textPrimaryDark,
  error: AppColors.error,
)
```

**Dark Mode Principles:**
- **Higher contrast**: Better readability
- **Darker backgrounds**: #1A1A1A (not pure black)
- **Lighter primary**: #4682B4 (easier on eyes)
- **Why not pure black**: Reduces eye strain, shows depth better

#### Dark Mode Differences
```dart
// Light Mode
backgroundColor: AppColors.backgroundLight,  // #FFFFFF

// Dark Mode
backgroundColor: AppColors.backgroundDark,   // #1A1A1A
```

**Key Differences:**
1. **Backgrounds**: Dark instead of white
2. **Text**: White/light gray instead of black
3. **Primary color**: Lighter shade for better contrast
4. **Borders**: More transparent (opacity 0.1)
5. **Shadows**: Darker, more prominent

## Theme Usage in App

### Accessing Theme
```dart
// In any widget
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;
final textStyle = theme.textTheme.bodyLarge;
```

### Checking Current Theme
```dart
final brightness = Theme.of(context).brightness;
final isDark = brightness == Brightness.dark;

if (isDark) {
  // Use dark theme specific logic
} else {
  // Use light theme specific logic
}
```

### Using Theme Colors
```dart
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

## Material 3 Component Behavior

### How Widgets Use Theme

#### Buttons
```dart
ElevatedButton()  // Uses elevatedButtonTheme
TextButton()      // Uses textButtonTheme
OutlinedButton()  // Uses outlinedButtonTheme
```

#### Text Fields
```dart
TextField()       // Uses inputDecorationTheme
TextFormField()   // Uses inputDecorationTheme
```

#### Containers
```dart
Card()            // Uses cardTheme
AppBar()          // Uses appBarTheme
Scaffold()        // Uses scaffoldBackgroundColor
```

## Design Decisions

### Why Elevation 0?
```dart
elevation: 0
```
- **Modern trend**: Flat design (2020s)
- **Cleaner look**: Less visual noise
- **Performance**: Fewer shadow calculations
- **Accessibility**: Clearer visual hierarchy

### Why BorderRadius 8-16?
```dart
borderRadius: BorderRadius.circular(8)   // Buttons
borderRadius: BorderRadius.circular(16)  // Cards
```
- **8px**: Subtle rounding for small elements
- **16px**: Noticeable rounding for large elements
- **Why not 0**: Sharp corners feel dated
- **Why not 32+**: Too rounded, looks toy-like

### Why Filled Input Fields?
```dart
filled: true
fillColor: AppColors.inputBackgroundLight
```
- **Visibility**: Easier to spot input fields
- **Affordance**: Clear indication of interactivity
- **Modern**: Used by Google, Apple designs
- **Accessibility**: Better for users with visual impairments

## Theme Customization

### Adding New Button Style
```dart
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
)
```

### Adding New Text Style
```dart
textTheme: TextTheme(
  headlineLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  ),
  // ... other styles
)
```

## Accessibility Considerations

### Color Contrast
- **WCAG AA standard**: 4.5:1 for normal text
- **WCAG AAA standard**: 7:1 for normal text
- **Our implementation**: All text meets AA standard

### Text Sizes
```dart
bodyLarge: 16sp   // Readable without zoom
titleLarge: 22sp  // Clear hierarchy
```
- **Minimum**: 14sp for body text
- **Recommended**: 16sp for main content

### Touch Targets
```dart
padding: EdgeInsets.symmetric(vertical: 12)  // 48dp minimum
```
- **Minimum**: 48x48 dp (Material guideline)
- **Our buttons**: 48dp+ height

## Theme Testing

### Testing Both Themes
```dart
// Force light theme
MaterialApp(themeMode: ThemeMode.light)

// Force dark theme
MaterialApp(themeMode: ThemeMode.dark)

// System theme
MaterialApp(themeMode: ThemeMode.system)
```

### Visual Regression Testing
- Test all screens in light mode
- Test all screens in dark mode
- Check text readability
- Verify color contrast

## Common Issues & Solutions

**Issue**: Text not visible on background
- **Solution**: Use `Theme.of(context).textTheme.bodyLarge` instead of hardcoded colors

**Issue**: Button wrong color
- **Solution**: Check elevatedButtonTheme configuration

**Issue**: Card corners not rounded
- **Solution**: Verify cardTheme shape property

**Issue**: Dark mode looks washed out
- **Solution**: Check primaryDarkMode color, should be lighter than light mode primary

## Performance Considerations

### Theme Caching
- Flutter caches themes automatically
- No need to manually cache
- Theme changes trigger rebuild only for affected widgets

### Theme Switching Performance
```dart
// Efficient: Theme stored in provider
ref.watch(themeProvider)

// Less efficient: Rebuilding entire app
setState(() {}) on root widget
```

## Integration with Providers

### Theme Provider Integration
```dart
// main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ref.watch(themeProvider),  // Reactive theme switching
)
```

## Best Practices

1. **Use Theme Colors**: Never hardcode colors
```dart
// ❌ Bad
color: Colors.blue

// ✅ Good
color: Theme.of(context).colorScheme.primary
```

2. **Use Text Styles**: Never hardcode text styles
```dart
// ❌ Bad
TextStyle(fontSize: 16, color: Colors.black)

// ✅ Good
Theme.of(context).textTheme.bodyLarge
```

3. **Consistent Spacing**: Use multiples of 4 or 8
```dart
padding: EdgeInsets.all(16)  // Good
padding: EdgeInsets.all(15)  // Avoid
```

4. **Test Both Themes**: Always test in light and dark modes

5. **Accessibility First**: Ensure proper contrast ratios

## Material 3 Migration Notes

### From Material 2 to Material 3
```dart
// Material 2
ThemeData(
  primaryColor: ...,
  accentColor: ...,
)

// Material 3
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(...),
)
```

**Changes:**
- `primaryColor` → `colorScheme.primary`
- `accentColor` → `colorScheme.secondary`
- `backgroundColor` → `colorScheme.background`

## Learning Resources

### Understanding Color Roles
- **Primary**: Your brand (buttons, active nav)
- **Secondary**: Accents (FAB, switches)
- **Tertiary**: Highlights (chips, badges)
- **Error**: Errors (validation, warnings)
- **Surface**: Elevated elements (cards, dialogs)
- **Background**: Screen backgrounds

### Typography Hierarchy
- **Display**: Largest text (splash screens)
- **Headline**: Page titles
- **Title**: Section headers
- **Body**: Main content
- **Label**: Button text, labels

## Future Enhancements
- Add custom font family (Poppins, Roboto)
- Implement dynamic color (Material You)
- Add seasonal themes
- Support high contrast mode
- Add custom component themes
- Implement theme animations
- Support RTL (right-to-left) languages
- Add theme presets (warm, cool, colorful)

## Related Files
- **app_colors.dart**: Color constants
- **theme_provider.dart**: Theme state management
- **main.dart**: Theme application
- All widgets inherit from these themes

## Summary

The `app_theme.dart` file is crucial for:
- ✅ Consistent visual design
- ✅ Light/dark mode support
- ✅ Material 3 compliance
- ✅ Accessibility
- ✅ Maintainability
- ✅ Professional appearance

It ensures every widget in the app follows the same design language and responds correctly to theme changes.

