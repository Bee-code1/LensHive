# main.dart Documentation

**File Path:** `lenshive/lib/main.dart`

## Purpose
This is the entry point of the LensHive Flutter application. It initializes the app, sets up state management with Riverpod, configures responsive design with ScreenUtil, and establishes the app's navigation and theming.

## Key Concepts & Components

### 1. **State Management - Riverpod**
```dart
ProviderScope
```
- **What it is**: A widget that stores all providers (state managers) for the entire app
- **Why we use it**: Enables reactive state management across the app without context dependencies
- **Learning**: Riverpod is a more robust alternative to Provider, offering better compile-time safety

### 2. **Responsive Design - Flutter ScreenUtil**
```dart
ScreenUtilInit(
  designSize: const Size(375, 812)
)
```
- **What it is**: A package that makes UI elements scale proportionally across different screen sizes
- **Design Size**: iPhone 13 Pro dimensions (375×812) as the base reference
- **Why we use it**: Ensures consistent UI appearance on different devices
- **Learning**: `.r` suffix on numbers (like `16.r`) makes them responsive

### 3. **Widget Binding Initialization**
```dart
WidgetsFlutterBinding.ensureInitialized()
```
- **What it is**: Initializes Flutter engine binding before any async operations
- **Why we need it**: Required when performing async operations before `runApp()`
- **Learning**: Always call this when using plugins or async work in `main()`

### 4. **Theme Management**
```dart
theme: AppTheme.lightTheme
darkTheme: AppTheme.darkTheme
themeMode: themeMode
```
- **What it is**: Centralized theme configuration supporting light/dark modes
- **How it works**: Watches `themeProvider` for theme changes and updates UI automatically
- **Learning**: Material Design 3 (`useMaterial3: true`) provides modern UI components

### 5. **Navigation - GoRouter**
```dart
MaterialApp.router(
  routerConfig: appRouter
)
```
- **What it is**: Declarative routing system replacing Navigator 1.0
- **Why we use it**: Type-safe navigation, deep linking support, better state management
- **Learning**: GoRouter provides URL-based navigation similar to web apps

## Data Flow

1. **App Starts** → `main()` function executes
2. **Initialization** → `WidgetsFlutterBinding.ensureInitialized()`
3. **Provider Setup** → `ProviderScope` wraps entire app
4. **App Widget** → `MyApp` (ConsumerWidget) builds
5. **Theme Watching** → Listens to `themeProvider` for theme changes
6. **ScreenUtil Setup** → Initializes responsive sizing
7. **Router Ready** → MaterialApp.router with `appRouter` configuration
8. **Initial Route** → Navigates to splash screen (`/`)

## Dependencies Used

| Package | Purpose | Version |
|---------|---------|---------|
| `flutter_riverpod` | State management | Latest |
| `flutter_screenutil` | Responsive UI | Latest |
| `go_router` | Navigation | Latest |

## Sub-Modules

- **ThemeProvider**: Manages light/dark mode switching and persistence
- **AppTheme**: Defines light and dark theme configurations
- **AppRouter**: Contains all route definitions and navigation logic

## Features Implemented

1. ✅ Responsive design with ScreenUtil
2. ✅ Light/Dark theme switching
3. ✅ State management with Riverpod
4. ✅ Declarative navigation with GoRouter
5. ✅ Material Design 3 support

## Learning Notes

### ConsumerWidget vs StatelessWidget
- **ConsumerWidget**: Can access Riverpod providers using `ref.watch()`
- **StatelessWidget**: Cannot directly access providers
- **When to use**: Use ConsumerWidget when you need to read providers

### Why ProviderScope?
- Stores all provider states
- Must wrap the root widget
- Enables dependency injection pattern
- Makes testing easier by allowing provider overrides

### Responsive Design Pattern
```dart
16.r   // Responsive for size/padding
1.sw   // Screen width percentage
1.sh   // Screen height percentage
```

## Common Issues & Solutions

**Issue**: UI doesn't scale on different devices
- **Solution**: Make sure all size values use `.r` suffix

**Issue**: Theme doesn't change
- **Solution**: Verify `themeProvider` is being watched with `ref.watch()`

**Issue**: App crashes on startup
- **Solution**: Check if `WidgetsFlutterBinding.ensureInitialized()` is called

## Future Enhancements
- Add locale/language support
- Implement app-wide error handling
- Add analytics initialization
- Setup push notification configuration

