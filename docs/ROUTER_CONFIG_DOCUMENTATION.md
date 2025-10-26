# router_config.dart Documentation

**File Path:** `lenshive/lib/config/router_config.dart`

## Purpose
Defines all application routes and navigation paths using GoRouter for declarative, type-safe navigation throughout the LensHive app.

## Key Concepts & Components

### 1. **GoRouter - Declarative Routing**
```dart
final GoRouter appRouter = GoRouter(...)
```
- **What it is**: A declarative routing package for Flutter
- **Why we use it**: Provides URL-based navigation, deep linking, and better state management
- **Learning**: Unlike Navigator 1.0 (imperative), GoRouter uses paths like web URLs

### 2. **Route Structure**
Each route has:
- **path**: URL-like path (e.g., `/home`, `/login`)
- **name**: Identifier for navigation
- **builder**: Function that returns the screen widget
- **extras**: Pass data between screens

### 3. **Navigation Methods**
```dart
context.go('/home')      // Replace current route
context.push('/profile')  // Add to stack
context.pop()            // Go back
```

## Routes Defined

### Authentication Routes
| Path | Name | Screen | Purpose |
|------|------|--------|---------|
| `/` | splash | SplashScreen | App entry point, shows branding |
| `/login` | login | LoginScreen | User login |
| `/register` | register | RegistrationScreen | New user registration |

### Main App Routes
| Path | Name | Screen | Purpose |
|------|------|--------|---------|
| `/home` | home | HomeScreen | Main product catalog |
| `/profile` | profile | ProfileScreen | User profile & settings |

### Quiz Feature Routes
| Path | Name | Screen | Purpose |
|------|------|--------|---------|
| `/quiz` | - | - | Redirects to step1 |
| `/quiz/step1` | quiz_step1 | QuizStep1Basics | Basic information |
| `/quiz/step2` | quiz_step2 | QuizStep2Usage | Usage patterns |
| `/quiz/step3` | quiz_step3 | QuizStep3Preferences | User preferences |
| `/quiz/result` | quiz_result | NewRecommendationScreen | Lens recommendations |

## Data Flow

### Passing Data Between Routes
```dart
// Passing data with extras
context.go('/quiz/result', extra: recommendationData);

// Receiving data
final recommendation = state.extra as RecommendationData?;
```

### Route Redirection
```dart
GoRoute(
  path: '/quiz',
  redirect: (context, state) => '/quiz/step1',
)
```
- Automatically redirects `/quiz` to `/quiz/step1`

## Error Handling

### Custom Error Page
```dart
errorBuilder: (context, state) => Scaffold(...)
```
- Displays user-friendly 404 page
- Shows the attempted path
- Provides "Go Home" button

## Key Features

### 1. **Initial Location**
```dart
initialLocation: '/'
```
- App always starts at splash screen
- Splash screen handles authentication check

### 2. **Debug Logging**
```dart
debugLogDiagnostics: false
```
- Disabled for cleaner console output
- Enable for debugging navigation issues

### 3. **Type Safety**
- Named routes prevent typos
- Compile-time checking for route names

## Navigation Patterns

### Stack-Based Navigation
```dart
// Add to navigation stack
context.push('/profile')

// Replace current route
context.go('/home')

// Go back
context.pop()
```

### Deep Linking Support
- GoRouter automatically supports deep links
- Can open app directly to specific screens
- Example: `lenshive://quiz/step2`

## Learning Notes

### Why GoRouter over Navigator?
1. **Declarative**: Define all routes in one place
2. **Type-safe**: No magic strings in navigation code
3. **Web-friendly**: URL-based routing
4. **Deep linking**: Built-in support
5. **Better state**: Easier to manage navigation state

### Route Parameters
```dart
// Path with parameter
path: '/product/:id'

// Access parameter
final id = state.pathParameters['id'];
```

### Query Parameters
```dart
// Navigate with query
context.go('/home?category=men')

// Access query
final category = state.uri.queryParameters['category'];
```

## Sub-Modules & Dependencies

### Screens Used
- `SplashScreen`: Entry point with animation
- `LoginScreen`: Email/password authentication
- `RegistrationScreen`: New user signup
- `HomeScreen`: Product catalog with categories
- `ProfileScreen`: User settings
- `QuizStep1Basics`: First quiz step
- `QuizStep2Usage`: Second quiz step
- `QuizStep3Preferences`: Third quiz step
- `NewRecommendationScreen`: Shows lens recommendations

### Models Used
- `RecommendationData`: Passed to result screen via extras

## Common Issues & Solutions

**Issue**: Navigation doesn't work
- **Solution**: Check route name matches exactly

**Issue**: Data not passed between screens
- **Solution**: Use `extra` parameter and cast correctly

**Issue**: Back button doesn't work
- **Solution**: Ensure using `context.push()` not `context.go()`

**Issue**: Error screen shows instead of intended screen
- **Solution**: Verify path spelling and route is registered

## Future Enhancements
- Add authentication guards (protected routes)
- Implement route transition animations
- Add route analytics/logging
- Support nested navigation
- Add route parameter validation

