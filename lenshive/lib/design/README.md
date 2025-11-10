# Stitch Visual System

Design tokens and theme configuration matching Stitch visuals.

## Usage

### Import
```dart
import 'package:lenshive/design/tokens.dart';
import 'package:lenshive/design/app_theme.dart';
```

### Colors
```dart
// Brand colors
Container(color: DesignTokens.primary)
Container(color: DesignTokens.background)
Container(color: DesignTokens.card)

// Text colors
Text('Title', style: TextStyle(color: DesignTokens.textPrimary))
Text('Subtitle', style: TextStyle(color: DesignTokens.textSecondary))

// Status colors
Container(color: DesignTokens.success)
Container(color: DesignTokens.warning)
Container(color: DesignTokens.error)

// Gradient
Container(decoration: BoxDecoration(gradient: DesignTokens.premiumGradient))
```

### Border Radius
```dart
BorderRadius.circular(DesignTokens.radiusCard)    // 20px
BorderRadius.circular(DesignTokens.radiusButton)  // 16px
BorderRadius.circular(DesignTokens.radiusChip)    // 12px
BorderRadius.circular(DesignTokens.radiusInput)   // 12px
```

### Spacing
```dart
SizedBox(height: DesignTokens.spaceXs)  // 4px
SizedBox(height: DesignTokens.spaceSm)  // 8px
SizedBox(height: DesignTokens.spaceMd)  // 12px
SizedBox(height: DesignTokens.spaceLg)  // 16px
SizedBox(height: DesignTokens.spaceXl)  // 24px
```

### Shadows
```dart
Container(
  decoration: BoxDecoration(
    boxShadow: DesignTokens.subtleShadow,
  ),
)
```

### Buttons
```dart
// Primary filled button (auto-styled by theme)
ElevatedButton(
  onPressed: () {},
  child: Text('Primary'),
)

// Outlined button (auto-styled by theme)
OutlinedButton(
  onPressed: () {},
  child: Text('Secondary'),
)

// Text button (auto-styled by theme)
TextButton(
  onPressed: () {},
  child: Text('Tertiary'),
)
```

### Chips
```dart
// Filter chip (auto-styled by theme)
FilterChip(
  label: Text('Category'),
  selected: true,
  onSelected: (value) {},
)

// Choice chip (auto-styled by theme)
ChoiceChip(
  label: Text('Option'),
  selected: false,
  onSelected: (value) {},
)
```

### Status Pills
```dart
// Success pill
StatusPill(
  label: 'Active',
  backgroundColor: DesignTokens.success,
)

// Warning pill
StatusPill(
  label: 'Pending',
  backgroundColor: DesignTokens.warning,
)

// Error pill
StatusPill(
  label: 'Expired',
  backgroundColor: DesignTokens.error,
)

// Custom pill
StatusPill(
  label: 'New',
  backgroundColor: DesignTokens.primary,
  textColor: DesignTokens.white,
)
```

### Typography
```dart
// Using theme text styles (auto-configured)
Text('Display', style: Theme.of(context).textTheme.displayLarge)
Text('Headline', style: Theme.of(context).textTheme.headlineMedium)
Text('Title', style: Theme.of(context).textTheme.titleLarge)
Text('Body', style: Theme.of(context).textTheme.bodyMedium)
Text('Label', style: Theme.of(context).textTheme.labelSmall)
```

### Input Fields
```dart
// TextField (auto-styled by theme)
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
)
```

### Cards
```dart
// Card (auto-styled by theme with 20px radius and subtle shadow)
Card(
  child: Padding(
    padding: EdgeInsets.all(DesignTokens.spaceLg),
    child: Column(
      children: [
        Text('Card Title'),
        SizedBox(height: DesignTokens.spaceMd),
        Text('Card content'),
      ],
    ),
  ),
)
```

## Design Tokens Reference

| Token | Value |
|-------|-------|
| **Colors** | |
| primary | #2F6BFF |
| gradientStart | #D73F86 |
| gradientEnd | #1BB1E6 |
| background | #F3F4F6 |
| card | #FFFFFF |
| textPrimary | #111827 |
| textSecondary | #6B7280 |
| success | #10B981 |
| warning | #F59E0B |
| error | #EF4444 |
| **Radii** | |
| radiusCard | 20px |
| radiusButton | 16px |
| radiusChip | 12px |
| radiusInput | 12px |
| **Spacing** | |
| spaceXs | 4px |
| spaceSm | 8px |
| spaceMd | 12px |
| spaceLg | 16px |
| spaceXl | 24px |
| **Shadows** | |
| subtleShadow | y=6, blur=24, opacity=0.08 |

## Theme Configuration

The theme is automatically applied in `main.dart`:

```dart
MaterialApp.router(
  theme: AppTheme.light,
  // ... rest of config
)
```

All Material 3 widgets automatically use the Stitch design system!

