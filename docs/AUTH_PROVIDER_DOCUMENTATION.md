# auth_provider.dart Documentation

**File Path:** `lenshive/lib/providers/auth_provider.dart`

## Purpose
Manages authentication state throughout the LensHive app using Riverpod, handling login, registration, logout, and user session persistence.

## Key Concepts & Components

### 1. **State Management with Riverpod**
```dart
class AuthNotifier extends StateNotifier<AuthState>
```
- **StateNotifier**: Riverpod class for managing mutable state
- **Purpose**: Encapsulates authentication logic and state
- **Why Riverpod**: Type-safe, no context dependency, better testing
- **Learning**: StateNotifier is like a ViewModel in MVVM

### 2. **State Pattern**
```dart
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
}
```
- **Immutable state**: Can't modify directly, only replace
- **Why immutable**: Predictable state changes, easier debugging
- **State composition**: Multiple properties describe auth status

### 3. **Provider Pattern**
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>
```
- **What it is**: Global state accessible anywhere in app
- **No context needed**: Can be accessed without BuildContext
- **Automatic rebuilds**: Widgets rebuild when state changes

### 4. **Async State Management**
```dart
Future<bool> login(...) async {
  state = state.copyWith(isLoading: true);
  // ... async operations
  state = state.copyWith(isLoading: false);
}
```
- **Loading states**: Show loading UI during async operations
- **Error handling**: Capture and display errors
- **Return values**: Boolean indicates success/failure

## AuthState Class

```dart
class AuthState {
  final User? user;             // Current logged-in user (null if not logged in)
  final bool isLoading;         // True during login/register/logout
  final String? errorMessage;   // Error message from failed operations
  final bool isAuthenticated;   // Quick check if user is logged in
}
```

### State Properties

#### user (User?)
- **Type**: Nullable User object
- **null**: User not logged in
- **not null**: User is logged in
- **Usage**: Display user info, check permissions

#### isLoading (bool)
- **Type**: Boolean
- **true**: Operation in progress (login, register)
- **false**: No operation running
- **Usage**: Show loading spinners, disable buttons

#### errorMessage (String?)
- **Type**: Nullable String
- **null**: No error
- **not null**: Error occurred, contains error message
- **Usage**: Display error to user
- **Examples**: "Invalid email or password", "Network error"

#### isAuthenticated (bool)
- **Type**: Boolean
- **true**: User is logged in
- **false**: User not logged in
- **Usage**: Navigation guards, conditional rendering

### copyWith Method
```dart
AuthState copyWith({
  User? user,
  bool? isLoading,
  String? errorMessage,
  bool? isAuthenticated,
}) {
  return AuthState(
    user: user ?? this.user,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
  );
}
```

**Purpose**: Create new state with some fields updated

**Pattern**: Immutable update pattern

**Usage**:
```dart
state = state.copyWith(isLoading: true);
state = state.copyWith(user: newUser, isAuthenticated: true);
```

## AuthNotifier Class

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _checkLoginStatus();
  }
}
```

### Constructor Behavior
1. Calls super with initial AuthState (all fields default/empty)
2. Immediately calls `_checkLoginStatus()` to restore session
3. Checks SharedPreferences for saved user data
4. Updates state if user found

### Private Method: _checkLoginStatus()

```dart
Future<void> _checkLoginStatus() async {
  final isLoggedIn = await StorageService.isLoggedIn();
  if (isLoggedIn) {
    final user = await StorageService.getUser();
    if (user != null) {
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
      );
    }
  }
}
```

**Purpose**: Restore user session on app start

**Flow**:
1. Check SharedPreferences for login flag
2. If logged in, retrieve user data
3. Update state with user
4. App navigation will use this state

**When called**: 
- App startup (constructor)
- Never called again (unless provider is recreated)

### Public Method: login()

```dart
Future<bool> login({
  required String email,
  required String password,
  bool rememberMe = false,
}) async {
  // Set loading state
  state = state.copyWith(isLoading: true, errorMessage: null);

  try {
    // Call API service to login
    final user = await ApiService.login(
      email: email,
      password: password,
    );

    // Save user data to local storage
    await StorageService.saveUser(user);

    // Save email if remember me is enabled
    if (rememberMe) {
      await StorageService.saveEmail(email);
    } else {
      await StorageService.clearSavedEmail();
    }

    // Update state with user data
    state = state.copyWith(
      user: user,
      isLoading: false,
      isAuthenticated: true,
      errorMessage: null,
    );

    return true;
  } catch (e) {
    // Handle login error
    state = state.copyWith(
      isLoading: false,
      errorMessage: e.toString().replaceAll('Exception: ', ''),
    );
    return false;
  }
}
```

**Parameters**:
- `email`: User's email address
- `password`: User's password
- `rememberMe`: Save email for next login

**Return**: `true` if successful, `false` if failed

**Flow**:
1. Set `isLoading = true`, clear previous errors
2. Call `ApiService.login()` (sends HTTP request)
3. If successful:
   - Save user to SharedPreferences
   - Optionally save email for "Remember Me"
   - Update state with user data
   - Return true
4. If error:
   - Catch exception
   - Set error message
   - Set `isLoading = false`
   - Return false

**Usage in UI**:
```dart
final success = await ref.read(authProvider.notifier).login(
  email: email,
  password: password,
  rememberMe: true,
);

if (success) {
  context.go('/home');
} else {
  // Show error
}
```

### Public Method: register()

```dart
Future<bool> register({
  required String fullName,
  required String email,
  required String password,
}) async {
  state = state.copyWith(isLoading: true, errorMessage: null);

  try {
    final user = await ApiService.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    await StorageService.saveUser(user);

    state = state.copyWith(
      user: user,
      isLoading: false,
      isAuthenticated: true,
      errorMessage: null,
    );

    return true;
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: e.toString().replaceAll('Exception: ', ''),
    );
    return false;
  }
}
```

**Parameters**:
- `fullName`: User's full name
- `email`: User's email address
- `password`: User's password

**Return**: `true` if successful, `false` if failed

**Flow**: Similar to login, but creates new user account

**Differences from login**:
- No "Remember Me" option
- Calls `ApiService.register()` instead of login
- Creates new user in backend database

### Public Method: logout()

```dart
Future<void> logout() async {
  await StorageService.clearUserData();
  state = AuthState();
}
```

**Purpose**: Log out user and clear all data

**Flow**:
1. Clear all data from SharedPreferences
2. Reset state to initial (empty) AuthState
3. Navigation will redirect to login

**Usage**:
```dart
await ref.read(authProvider.notifier).logout();
context.go('/login');
```

### Public Method: refreshUser()

```dart
Future<void> refreshUser() async {
  if (state.user?.token != null) {
    try {
      final user = await ApiService.getProfile(state.user!.token!);
      state = state.copyWith(user: user);
      await StorageService.saveUser(user);
    } catch (e) {
      print('Error refreshing user: $e');
    }
  }
}
```

**Purpose**: Fetch latest user data from backend

**When to use**:
- After profile update
- Periodically to sync data
- After long periods of inactivity

**Error handling**: Silent failure (prints to console)

## Provider Definition

```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

**Type**: StateNotifierProvider
- **First type parameter**: AuthNotifier (the notifier class)
- **Second type parameter**: AuthState (the state class)
- **Constructor**: Creates new AuthNotifier instance

## Convenience Providers

These providers expose specific parts of auth state:

### currentUserProvider
```dart
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});
```
**Purpose**: Get current user

**Usage**:
```dart
final user = ref.watch(currentUserProvider);
if (user != null) {
  Text(user.fullName);
}
```

### authLoadingProvider
```dart
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
```
**Purpose**: Check if auth operation in progress

**Usage**:
```dart
final isLoading = ref.watch(authLoadingProvider);
if (isLoading) {
  CircularProgressIndicator();
}
```

### authErrorProvider
```dart
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).errorMessage;
});
```
**Purpose**: Get error message

**Usage**:
```dart
final error = ref.watch(authErrorProvider);
if (error != null) {
  Text(error, style: TextStyle(color: Colors.red));
}
```

### isAuthenticatedProvider
```dart
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
```
**Purpose**: Check if user is logged in

**Usage**:
```dart
final isAuthenticated = ref.watch(isAuthenticatedProvider);
if (isAuthenticated) {
  // Show authenticated content
}
```

## Data Flow

### Login Flow
```
1. User enters email/password in LoginScreen
2. User presses Login button
3. LoginScreen calls: ref.read(authProvider.notifier).login(...)
4. AuthNotifier.login() sets isLoading = true
5. ApiService.login() sends HTTP request to backend
6. Backend validates credentials
7. Backend returns {user, token}
8. ApiService parses response to User object
9. StorageService saves user to SharedPreferences
10. AuthNotifier updates state with user
11. LoginScreen watches authProvider, sees success
12. LoginScreen navigates to /home
13. All widgets watching authProvider rebuild
```

### Registration Flow
```
1. User fills registration form
2. User presses Register button
3. RegistrationScreen calls: ref.read(authProvider.notifier).register(...)
4. AuthNotifier.register() sets isLoading = true
5. ApiService.register() sends HTTP request
6. Backend creates new user
7. Backend returns {user, token}
8. User saved to SharedPreferences
9. State updated with new user
10. Navigate to /home
```

### Logout Flow
```
1. User presses Logout in ProfileScreen
2. ProfileScreen calls: ref.read(authProvider.notifier).logout()
3. StorageService.clearUserData() removes all data
4. AuthNotifier resets state to empty
5. SplashScreen/Guards detect no user
6. Navigate to /login
```

### App Startup Flow
```
1. App launches, main() runs
2. AuthNotifier constructor calls _checkLoginStatus()
3. Check SharedPreferences for user data
4. If found: Update state with user
5. If not found: State remains empty
6. SplashScreen checks isAuthenticated
7. Navigate to /home or /login based on auth status
```

## Integration Points

### With UI Screens

#### LoginScreen
```dart
// Watch loading state
final isLoading = ref.watch(authLoadingProvider);

// Login button
onPressed: isLoading ? null : () async {
  final success = await ref.read(authProvider.notifier).login(...);
  if (success) context.go('/home');
}

// Show errors
final error = ref.watch(authErrorProvider);
if (error != null) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

#### ProfileScreen
```dart
// Display user info
final user = ref.watch(currentUserProvider);
Text(user?.fullName ?? 'Guest');
Text(user?.email ?? '');

// Logout button
onPressed: () async {
  await ref.read(authProvider.notifier).logout();
  context.go('/login');
}
```

#### SplashScreen
```dart
// Check auth status
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (isAuthenticated) {
  context.go('/home');
} else {
  context.go('/login');
}
```

### With Services

#### StorageService
```dart
// Save user
await StorageService.saveUser(user);

// Get user
final user = await StorageService.getUser();

// Clear data
await StorageService.clearUserData();
```

#### ApiService
```dart
// Login
final user = await ApiService.login(email, password);

// Register
final user = await ApiService.register(fullName, email, password);

// Get profile
final user = await ApiService.getProfile(token);
```

## Common Patterns

### Checking Auth Status
```dart
// In any widget
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (isAuthenticated) {
  // Show authenticated content
} else {
  // Show login prompt
}
```

### Getting Current User
```dart
final user = ref.watch(currentUserProvider);

// Safe access
Text(user?.fullName ?? 'Guest');
Text(user?.email ?? 'Not logged in');
```

### Handling Loading States
```dart
final isLoading = ref.watch(authLoadingProvider);

ElevatedButton(
  onPressed: isLoading ? null : _handleLogin,
  child: isLoading 
    ? CircularProgressIndicator()
    : Text('Login'),
)
```

### Displaying Errors
```dart
ref.listen<AuthState>(authProvider, (previous, next) {
  if (next.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.errorMessage!)),
    );
  }
});
```

## Best Practices

### 1. Use ref.read() for actions
```dart
// ✅ Good - trigger action
ref.read(authProvider.notifier).login(...)

// ❌ Bad - causes unnecessary rebuilds
ref.watch(authProvider.notifier).login(...)
```

### 2. Use ref.watch() for state
```dart
// ✅ Good - rebuild on state changes
final user = ref.watch(currentUserProvider);

// ❌ Bad - won't rebuild
final user = ref.read(currentUserProvider);
```

### 3. Handle errors in UI
```dart
// ✅ Good
final success = await login(...);
if (!success) {
  showError(ref.read(authErrorProvider));
}

// ❌ Bad - ignores errors
await login(...);
```

### 4. Clear errors before new attempts
```dart
state = state.copyWith(errorMessage: null);
```

## Testing

### Unit Tests
```dart
test('login success updates state', () async {
  final container = ProviderContainer();
  final notifier = container.read(authProvider.notifier);
  
  await notifier.login(
    email: 'test@example.com',
    password: 'password',
  );
  
  final state = container.read(authProvider);
  expect(state.isAuthenticated, true);
  expect(state.user, isNotNull);
});

test('login failure sets error', () async {
  // Mock ApiService to throw error
  final notifier = AuthNotifier();
  
  final success = await notifier.login(
    email: 'invalid@example.com',
    password: 'wrong',
  );
  
  expect(success, false);
  expect(notifier.state.errorMessage, isNotNull);
});
```

## Common Issues & Solutions

**Issue**: User logged out after app restart
- **Solution**: Check if `_checkLoginStatus()` is called in constructor

**Issue**: State not updating in UI
- **Solution**: Use `ref.watch()` not `ref.read()` for displaying state

**Issue**: Multiple login requests
- **Solution**: Disable button while `isLoading` is true

**Issue**: Error persists after successful login
- **Solution**: Clear `errorMessage` when setting `isLoading = true`

## Security Considerations

### Token Storage
- Tokens stored in SharedPreferences (encrypted on iOS, protected on Android)
- Never log tokens
- Clear tokens on logout

### Password Handling
- Passwords never stored locally
- Only sent to backend via HTTPS
- Never logged or displayed

### Session Management
- Token expires after period (backend configured)
- Refresh token before expiry (future enhancement)
- Force logout on 401 responses

## Future Enhancements
- Add biometric authentication
- Implement refresh tokens
- Add session timeout
- Support social login (Google, Apple)
- Add two-factor authentication
- Implement account deletion
- Add password reset flow
- Track login history
- Support multiple devices
- Add offline mode support

## Related Files
- **login_screen.dart**: Uses login()
- **registration_screen.dart**: Uses register()
- **profile_screen.dart**: Uses logout(), displays user
- **splash_screen.dart**: Uses isAuthenticated
- **api_service.dart**: Backend communication
- **storage_service.dart**: Local persistence
- **user_model.dart**: User data structure

## Summary

The AuthProvider is the central hub for:
- ✅ Authentication state management
- ✅ Login/register/logout operations
- ✅ Session persistence
- ✅ Error handling
- ✅ Loading states
- ✅ User data access

It provides a clean, reactive way to manage authentication throughout the LensHive application using Riverpod's powerful state management capabilities.

