# Complete LensHive Files Reference

This document provides detailed descriptions of every code file in the LensHive project, organized by category.

---

## 📁 Frontend Files (Flutter/Dart)

### Core Configuration (lib/config/)

#### router_config.dart ✅ [Full Doc Available](ROUTER_CONFIG_DOCUMENTATION.md)
- **Purpose**: GoRouter configuration for app navigation
- **Routes**: 10 routes (splash, login, register, home, profile, quiz steps, results)
- **Features**: Deep linking, error handling, route parameters
- **Key Concept**: Declarative routing vs imperative Navigator

---

### Constants (lib/constants/)

#### app_colors.dart ✅ [Full Doc Available](APP_COLORS_DOCUMENTATION.md)
- **Purpose**: Centralized color palette for light/dark themes
- **Colors**: 50+ color constants
- **Features**: Helper methods for theme-aware colors
- **Categories**: Primary, secondary, background, text, status, badges
- **Key Concept**: Color roles in Material Design 3

####app_theme.dart ✅ [Full Doc Available](APP_THEME_DOCUMENTATION.md)
- **Purpose**: Complete Material Design 3 theme configuration
- **Themes**: Light and dark theme definitions
- **Components**: AppBar, Card, Button, TextField, Icon themes
- **Key Concept**: ThemeData, ColorScheme, Material 3 migration

---

### Data Models (lib/models/)

#### user_model.dart ✅ [Full Doc Available](USER_MODEL_DOCUMENTATION.md)
- **Purpose**: User data structure
- **Fields**: id, fullName, email, token, createdAt
- **Methods**: fromJson, toJson, copyWith, ==, hashCode
- **Key Concepts**: Immutability, JSON serialization, null safety

#### product_model.dart ✅ [Full Doc Available](PRODUCT_MODEL_DOCUMENTATION.md)
- **Purpose**: Product data structure for eyewear catalog
- **Fields**: 16 fields (id, name, price, imageUrl, category, brand, etc.)
- **Methods**: fromJson, toJson, copyWith, formattedPrice getter
- **Key Concepts**: E-commerce data modeling, computed properties

---

### State Management (lib/providers/)

#### auth_provider.dart ✅ [Full Doc Available](AUTH_PROVIDER_DOCUMENTATION.md)
- **Purpose**: Authentication state management
- **State**: AuthState (user, isLoading, errorMessage, isAuthenticated)
- **Methods**: login(), register(), logout(), refreshUser()
- **Providers**: authProvider, currentUserProvider, authLoadingProvider
- **Key Concepts**: StateNotifier, Riverpod, async state management

#### home_provider.dart
- **Purpose**: Home screen state management
- **State**: HomeState with products list, filtered products, loading states
- **Fields**:
  ```dart
  final List<Product> products;
  final List<Product> filteredProducts;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;
  final String searchQuery;
  ```
- **Methods**:
  - `loadProducts()`: Fetch products from API (currently mock data)
  - `changeCategory(String)`: Filter by category (Men/Women/Kids)
  - `updateSearchQuery(String)`: Filter by search text
  - `refreshProducts()`: Reload product list
- **Mock Data**: 12 sample products (6 Men, 4 Women, 2 Kids)
- **Filtering Logic**: Filters by category AND search query
- **Key Concepts**: List filtering, state composition, mock data patterns

#### splash_provider.dart
- **Purpose**: Splash screen state management
- **State**: SplashState enum (loading, completed)
- **Behavior**:
  - Delays 6 seconds on splash screen
  - Automatically transitions to completed state
  - SplashScreen listens and navigates based on auth status
- **Implementation**:
  ```dart
  enum SplashState { loading, completed }
  
  class SplashNotifier extends StateNotifier<SplashState> {
    SplashNotifier() : super(SplashState.loading) {
      _initializeSplash();
    }
    
    Future<void> _initializeSplash() async {
      await Future.delayed(const Duration(seconds: 6));
      if (mounted) state = SplashState.completed;
    }
  }
  ```
- **Key Concepts**: Enum states, timed transitions, mounted check

#### theme_provider.dart
- **Purpose**: Theme mode state management
- **State**: ThemeMode (light, dark, system)
- **Methods**:
  - `toggleTheme()`: Switch between light and dark
  - `setThemeMode(ThemeMode)`: Set specific theme
  - `_loadThemeMode()`: Load saved theme from SharedPreferences
- **Persistence**: Saves theme choice to SharedPreferences
- **Storage Key**: 'theme_mode'
- **Values**: 'light', 'dark', 'system'
- **Default**: ThemeMode.light
- **Provider**: isDarkModeProvider for quick check
- **Key Concepts**: Persistent state, SharedPreferences, theme switching

---

### Services (lib/services/)

#### api_service.dart
- **Purpose**: Backend API communication layer
- **Base URL**: 'http://localhost:8000/api'
- **Endpoints**:
  - `POST /auth/login` → login()
  - `POST /auth/register` → register()
  - `GET /user/profile` → getProfile()
- **Methods**:
  - `login(email, password)`: Returns User with token
  - `register(fullName, email, password)`: Returns User with token
  - `getProfile(token)`: Returns User data
- **Error Handling**: Throws exceptions with error messages
- **JSON Parsing**: Converts backend responses to User objects
- **Headers**: Content-Type: application/json, Authorization: Bearer token
- **Key Concepts**: HTTP requests, JSON parsing, token authentication

#### storage_service.dart
- **Purpose**: Local data persistence with SharedPreferences
- **Storage Keys**:
  - 'user': User JSON string
  - 'token': Auth token string
  - 'saved_email': Remembered email for login
  - 'is_logged_in': Boolean flag
- **Methods**:
  - `saveUser(User)`: Save user data
  - `getUser()`: Retrieve user data
  - `getToken()`: Get auth token
  - `isLoggedIn()`: Check login status
  - `saveEmail(String)`: Save email for "Remember Me"
  - `getSavedEmail()`: Get saved email
  - `clearSavedEmail()`: Remove saved email
  - `clearUserData()`: Clear all auth data (logout)
  - `clearAll()`: Clear entire storage
- **Data Format**: JSON strings (using jsonEncode/jsonDecode)
- **Key Concepts**: Persistent storage, key-value store, session management

---

### UI Screens (lib/screens/)

#### splash_screen.dart
- **Purpose**: App launch screen with animations
- **Features**:
  - LensHive logo display
  - Floating animated icons (shopping bag, auto_awesome, bolt, inventory)
  - 6-second delay
  - Checks auth status
  - Navigates to /home (if authenticated) or /login
- **Animations**:
  - Float animation using `AnimationController`
  - Sine wave movement for icons
  - Fade-in effect for icons
  - Uses `SingleTickerProviderStateMixin`
- **Responsive**: Uses ScreenUtil for scaling
- **Theme-aware**: Different colors for light/dark modes
- **Image Caching**: Precaches logo for smooth display
- **Key Concepts**: Animations, navigation guards, precaching

#### login_screen.dart
- **Purpose**: User login interface
- **Form Fields**:
  - Email (email validation)
  - Password (min 6 chars, visibility toggle)
- **Features**:
  - Form validation
  - Password show/hide toggle
  - "Remember Me" functionality (saves email)
  - Loading state (disables button, shows spinner)
  - Error display via SnackBar
  - Link to registration screen
  - "Forgot Password" link (placeholder)
- **Validation**:
  - Email regex: `r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'`
  - Password: Minimum 6 characters
- **State Management**: Uses AuthProvider
- **Navigation**: context.go('/home') on success
- **Key Concepts**: Form validation, async button handling, user feedback

#### registration_screen.dart
- **Purpose**: New user registration interface
- **Form Fields**:
  - Full Name (min 3 chars)
  - Email (email validation)
  - Password (min 6 chars, visibility toggle)
  - Confirm Password (must match password)
- **Features**:
  - Multi-field validation
  - Password matching check
  - Password visibility toggles (separate for each field)
  - Loading state
  - Error display
  - Link back to login screen
- **Validation**:
  - Full name: min 3 characters
  - Email: valid email format
  - Password: min 6 characters
  - Confirm: must match password field
- **Success Flow**: Auto-login after registration
- **Key Concepts**: Multi-step validation, password confirmation, auto-login

#### home_screen.dart
- **Purpose**: Main product catalog screen
- **Layout**: CustomScrollView with SliverAppBar
- **Components**:
  - App bar with logo and cart icon (badge shows count)
  - Search bar with camera icon (AI search placeholder)
  - Quiz banner ("Find Your Perfect Lens" - gradient button)
  - Category tabs (Men, Women, Kids)
  - Section title ("Recommended for you")
  - Product grid (2 columns, responsive)
  - Pull-to-refresh
- **Bottom Navigation**: 5 tabs (Home, Customize, Orders, Bookings, Account)
- **State**: Watches HomeProvider for products and loading
- **Empty State**: Shows icon and "No products found" message
- **Loading**: Shows skeleton loaders during data fetch
- **Product Card Actions**:
  - onTap: Navigate to detail (placeholder)
  - onTryOn: AR try-on (placeholder)
  - onAddToCart: Add to cart (shows SnackBar)
- **Key Concepts**: CustomScrollView, Sliver widgets, grid layouts, pull-to-refresh

#### profile_screen.dart
- **Purpose**: User profile and settings
- **Header Section**:
  - Avatar with initial letter
  - User's full name
  - User's email
  - Gradient background
- **Settings Sections**:
  1. **Account Settings**:
     - Edit Profile (placeholder)
     - Change Password (placeholder)
  2. **App Settings**:
     - Dark Mode toggle (functional)
     - Notifications (placeholder)
     - Language (placeholder)
  3. **Support**:
     - Help & Support (placeholder)
     - About (shows app info dialog)
- **Logout Button**: Red button with confirmation dialog
- **Card Design**: Each setting is a card with icon, title, subtitle
- **Theme Integration**: Watches theme provider, shows current mode
- **Key Concepts**: Confirmation dialogs, settings UI, profile display

---

### Reusable Widgets (lib/widgets/)

#### bottom_nav_bar.dart
- **Purpose**: Bottom navigation bar (5 tabs)
- **Tabs**:
  1. Home (home icon)
  2. Customize (tune icon)
  3. My Order (shopping bag icon)
  4. Bookings (calendar icon)
  5. Account (person icon)
- **Features**:
  - Active/inactive states
  - Theme-aware colors
  - Responsive sizing
  - Icon transitions (outlined → filled)
- **Height**: 60.r responsive pixels
- **Shadow**: Top shadow for elevation
- **Key Concepts**: Tab navigation, icon states, theme integration

#### category_tabs.dart
- **Purpose**: Horizontal category selector
- **Categories**: Men, Women, Kids (configurable)
- **Features**:
  - Pill-shaped buttons
  - Selected state (filled background, bold text)
  - Unselected state (outline, normal text)
  - Theme-aware colors
  - Responsive sizing
- **Behavior**: Calls onCategoryChanged callback
- **Layout**: Horizontal row with spacing
- **Key Concepts**: Selection UI, callback patterns, theme-aware styling

#### custom_search_bar.dart
- **Purpose**: Search bar with image upload feature
- **Components**:
  - Search icon (left)
  - TextField for text input
  - Camera icon (right) for image search
- **Placeholder**: "Search frames, brands or upload an image"
- **Features**:
  - Rounded corners (25.r)
  - Theme-aware background
  - Optional onTap (for navigation to search screen)
  - Optional controller for text input
  - Optional onChanged callback
- **Read-only mode**: When onTap is provided
- **Design**: Filled TextField with transparent background
- **Key Concepts**: Compound widgets, optional callbacks, theme integration

#### enhanced_product_card.dart
- **Purpose**: Product display card with badges and actions
- **Layout**:
  - Product image (220.r height, network image)
  - Badges (Bestseller: green, New: red) - top-left overlay
  - "Try On" button (bottom-center overlay)
  - Product details section:
    - Product name
    - Brand name (uppercase, primary color)
    - Price (formatted with currency)
    - Cart icon button
- **Image Handling**:
  - Network image with loading/error states
  - Placeholder if image fails
  - Rounded top corners
- **Badges**: Conditional rendering based on isBestseller/isNew
- **Actions**:
  - onTap: Navigate to detail
  - onTryOn: AR feature
  - onAddToCart: Add to cart
- **Responsive**: All sizes use .r for scaling
- **Theme**: Adapts to light/dark mode
- **Key Concepts**: Overlay positioning, conditional rendering, network images

#### skeleton_loaders.dart
- **Purpose**: Loading placeholders during data fetch
- **Package**: Uses `shimmer` package
- **Components**:
  - `SkeletonShimmer`: Base wrapper with shimmer effect
  - `SkeletonBox`: Basic rectangular placeholder
  - `SkeletonProductCard`: Product card placeholder
  - `SkeletonProductGrid`: Grid of skeleton cards
  - `SkeletonSearchBar`: Search bar placeholder
  - `SkeletonCategoryTabs`: Category tabs placeholder
- **Shimmer Colors**:
  - Light mode: grey[300] to grey[100]
  - Dark mode: grey[800] to grey[700]
- **Usage**: Show while loading data, replace with actual content when ready
- **Key Concepts**: Skeleton screens, shimmer effects, loading states

---

### Quiz Feature (lib/features/quiz/)

#### models/questionnaire_models.dart
- **Purpose**: Data models for lens recommendation quiz
- **Enums** (17 total):
  - Step 1: WhoFor, CurrentGlasses, VisionNeed, PowerStrength
  - Step 2: WorkSetting, ReflectionBother
  - Step 3: SunlightTime, PreferAutoOutdoor, NightDriving, LightSensitivity
  - Step 4: Activity, RoughUse, LensWeightPref, Handling
  - Step 5: Comfort
- **Main Class**: QuestionnaireAnswer
  - Contains all quiz responses (18 fields)
  - Methods: copyWith, toJson, fromJson, ==, hashCode
- **Recommendation Class**: RecommendationData
  - title, blurb, bullets, notice, goodToKnow
  - Used for displaying results
- **Key Concepts**: Enum types, comprehensive data modeling, type safety

#### state/questionnaire_controller.dart
- **Purpose**: Quiz state management
- **State**: QuestionnaireState (answer, isLoading, errorMessage)
- **Controller**: QuestionnaireController extends StateNotifier
- **Methods** (23 update methods):
  - updateWhoFor, updateVisionNeed, updatePowerStrength
  - updateScreenTimeHours, updateWorkSetting, updateReflectionBother
  - updateSunlightTime, updatePreferAutoOutdoor, updateNightDriving
  - updateLightSensitivity, updateActivities, updateRoughUse
  - updateLensWeightPref, updateHandling, updateComforts
  - updateBudgetPKR, updateAdditionalNotes
- **Validation**: isStepValid(step) - checks if step is complete
- **Persistence**: Auto-saves to SharedPreferences after each update
- **Recommendation Engine**: generateRecommendation() - rule-based system
- **Rules**:
  1. Adaptive Day-Night: if preferAuto OR sunlight > 2hrs
  2. Anti-Reflective: if screenTime >= 5hrs OR reduceEyeStrain
  3. Thin & Light: if lightThin OR power moderate/strong
  4. Impact-Resistant: if roughUse OR sports
  5. Default: Standard Clear Lenses
- **Key Concepts**: Complex state management, rule-based engines, persistence

#### steps/quiz_step1_basics.dart
- **Purpose**: Quiz step 1 - Basic information
- **Questions**:
  1. Who will wear these glasses? (myself, child/teen, senior)
  2. What do you mainly need to see clearly? (far, near, both)
  3. How strong is your prescription? (don't know, mild, moderate, strong)
- **Layout**:
  - Progress bar (1/3)
  - Title and subtitle
  - SectionCard for each question
  - OptionChips for selections
  - Next button (bottom)
- **Validation**: All 3 questions must be answered
- **Navigation**: Push to /quiz/step2 when valid
- **Key Concepts**: Form wizard, progress indication, validation gates

#### steps/quiz_step2_usage.dart
- **Purpose**: Quiz step 2 - Usage patterns
- **Questions**:
  1. Daily screen time (slider 0-12 hours)
  2. Time in bright sunlight (< 30min, 30-120min, 2-4hrs, 4+ hrs)
  3. Main activities (multi-select: office, sports, outdoor work, gaming, travel)
- **Layout**:
  - Progress bar (2/3)
  - Screen time slider with value display
  - OptionChips for selections
  - Multi-select chips for activities
  - Back and Next buttons
- **Validation**: All questions answered, at least one activity selected
- **Multi-select**: Toggle pattern for activities
- **Key Concepts**: Sliders, multi-select, back navigation

#### steps/quiz_step3_preferences.dart
- **Purpose**: Quiz step 3 - Preferences and comfort
- **Questions**:
  1. Lens thickness preference (thin & light, standard)
  2. What features matter most? (multi-select: reduce eye strain, reduce glare, clear in sunlight, scratch resistant, very lightweight)
- **Layout**:
  - Progress bar (3/3)
  - SectionCards
  - Multi-select chips for comfort features
  - Back and "Get Results" buttons
- **Validation**: Thickness selected, at least one comfort feature
- **Action**: Generates recommendation and navigates to result screen
- **Key Concepts**: Multi-select, final validation, results generation

#### result/new_recommendation_screen.dart
- **Purpose**: Display personalized lens recommendation
- **Layout**: CustomScrollView with SliverAppBar
- **Components**:
  - Success checkmark icon (green)
  - Recommendation title (large, bold)
  - Description (centered paragraph)
  - Key Benefits card (with checkmarks)
  - What You'll Notice card (bullet points)
  - Good to Know card (info icon, blue background)
  - "Browse Recommended Products" button (bottom)
- **Data**: RecommendationData object passed via route extras
- **Design**: Professional cards with icons, spacing, colors
- **Navigation**: "Close" returns to home, button navigates to home
- **Key Concepts**: Result presentation, card layouts, professional UI

#### widgets/option_chip.dart
- **Purpose**: Selectable chip widget for quiz options
- **Modes**: Single-select (radio) and multi-select (checkbox)
- **States**: Selected (filled) and unselected (outlined)
- **Components**:
  - Selection indicator (radio circle or checkbox)
  - Label text
  - Touch target (min 44.r height)
- **Colors**: Theme-aware (primary when selected)
- **Design**: Rounded pill shape (24.r border radius)
- **Key Concepts**: Custom selection widgets, accessibility (touch targets)

#### widgets/progress_bar.dart
- **Purpose**: Show progress through quiz steps
- **Display**: "1/3", "2/3", "3/3" text + visual bar
- **Components**:
  - Text indicator (current/total)
  - Optional title
  - Progress bar (filled portion in primary color)
- **Calculation**: progress = currentStep / totalSteps
- **Height**: 6.r
- **Colors**: Primary color for filled, border color for unfilled
- **Key Concepts**: Progress indication, fractional sizing

#### widgets/section_card.dart
- **Purpose**: Wrapper card for quiz question sections
- **Features**:
  - Consistent padding (20.r)
  - Rounded corners (16.r)
  - Shadow for elevation
  - Border for definition
  - Theme-aware colors
- **Customization**: Optional padding and margin overrides
- **Usage**: Wraps each question group in quiz steps
- **Key Concepts**: Container components, consistent styling

---

## 🔧 Backend Files (Django/Python)

### Authentication Module (backend/authentication/)

#### models.py ✅ [Full Doc Available](BACKEND_AUTHENTICATION_MODELS_DOCUMENTATION.md)
- **Purpose**: Custom User model and manager
- **User Model**:
  - Fields: id (UUID), full_name, email, passwords, flags, timestamps
  - Methods: has_perm, has_module_perms, __str__
- **UserManager**:
  - Methods: create_user, create_superuser
  - Email normalization
  - Password hashing
- **Key Concepts**: AbstractBaseUser, PermissionsMixin, custom auth

#### serializers.py
- **Purpose**: API data validation and serialization
- **Serializers**:
  1. **UserSerializer**: Public user data (id, full_name, email, created_at)
  2. **RegisterSerializer**: 
     - Fields: fullName/full_name (flexible), email, password
     - Validation: Email uniqueness, password min 6 chars
     - create(): Calls UserManager.create_user
  3. **LoginSerializer**:
     - Fields: email, password
     - validate(): Checks credentials, returns user
- **camelCase Support**: Accepts both fullName and full_name
- **Key Concepts**: DRF serializers, validation, flexible field names

#### views.py
- **Purpose**: API endpoint handlers
- **Endpoints**:
  1. **register** (POST, AllowAny):
     - Input: {fullName, email, password}
     - Process: Validate, create user, generate token
     - Output: {message, user, token}
     - Status: 201 Created (success), 400 Bad Request (error)
  2. **login** (POST, AllowAny):
     - Input: {email, password}
     - Process: Validate credentials, get/create token
     - Output: {message, user, token}
     - Status: 200 OK (success), 400 Bad Request (error)
  3. **logout** (POST, IsAuthenticated):
     - Process: Delete user's token
     - Output: {message}
     - Status: 200 OK
  4. **get_profile** (GET, IsAuthenticated):
     - Headers: Authorization: Token <token>
     - Output: {user}
     - Status: 200 OK
  5. **test_connection** (GET, AllowAny):
     - Output: {message, status}
     - Purpose: Health check
- **Token Auth**: Uses DRF Token Authentication
- **Error Handling**: Returns detailed error messages
- **Key Concepts**: API views, decorators, token auth

#### urls.py
- **Purpose**: Authentication route configuration
- **Routes**:
  - `api/auth/register` → register view
  - `api/auth/login` → login view
  - `api/auth/logout` → logout view
  - `api/auth/test` → test_connection view
- **Pattern**: Function-based views with url patterns
- **Key Concepts**: URL routing, path function

### Django Configuration (backend/lenshive_backend/)

#### settings.py
- **Purpose**: Django project configuration
- **Key Settings**:
  - **SECRET_KEY**: From .env (security)
  - **DEBUG**: From .env (dev/prod)
  - **ALLOWED_HOSTS**: ['*'] for development
  - **INSTALLED_APPS**:
    - Django default apps
    - rest_framework, rest_framework.authtoken
    - corsheaders
    - authentication (custom app)
  - **MIDDLEWARE**:
    - CorsMiddleware (must be early in list)
    - Security, CSRF, Session, Auth middleware
  - **DATABASE**:
    - Engine: django.db.backends.mysql
    - Credentials from .env (DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT)
    - Default port: 3307
  - **AUTH_USER_MODEL**: 'authentication.User' (custom user)
  - **REST_FRAMEWORK**:
    - TokenAuthentication
    - AllowAny default permission
  - **CORS**:
    - ALLOW_ALL_ORIGINS: True (dev only!)
    - ALLOW_CREDENTIALS: True
    - Allow all methods and standard headers
- **PyMySQL**: Installed as MySQLdb replacement
- **Key Concepts**: Django settings, environment variables, security config

#### urls.py
- **Purpose**: Main URL configuration
- **Routes**:
  - `api/auth/` → includes authentication.urls
  - `api/user/profile` → get_profile view
- **Pattern**: Include function for modular routing
- **Note**: Admin panel commented out
- **Key Concepts**: URL include, modular routing

#### wsgi.py
- **Purpose**: WSGI entry point for production
- **Content**: Standard Django WSGI application
- **Usage**: Used by production servers (Gunicorn, uWSGI)

#### asgi.py
- **Purpose**: ASGI entry point for async support
- **Content**: Standard Django ASGI application
- **Usage**: For async views, WebSockets (future)

### Backend Management

#### manage.py
- **Purpose**: Django management script
- **Usage**: `python manage.py <command>`
- **Common Commands**:
  - `runserver`: Start development server
  - `migrate`: Apply database migrations
  - `makemigrations`: Create migrations
  - `createsuperuser`: Create admin user
  - `shell`: Python shell with Django loaded

#### requirements.txt
- **Purpose**: Python dependencies
- **Packages**:
  - Django==5.2.7
  - djangorestframework==3.16.1
  - django-cors-headers==4.9.0
  - PyMySQL==1.1.0
  - python-decouple==3.8
  - pytz==2025.2
  - asgiref, sqlparse (Django dependencies)
- **Installation**: `pip install -r requirements.txt`

---

## 📊 Key Concepts Summary

### Frontend Concepts

1. **State Management (Riverpod)**
   - StateNotifier: Mutable state container
   - Provider: Exposes state to widgets
   - ref.watch: Rebuild on state change
   - ref.read: One-time read (for actions)

2. **Navigation (GoRouter)**
   - Path-based routing
   - Named routes
   - Route parameters (pathParameters, extras)
   - Navigation methods (go, push, pop)

3. **Responsive Design (ScreenUtil)**
   - .r suffix: Responsive size
   - .sw/.sh: Screen width/height percentages
   - Base design: 375x812 (iPhone 13 Pro)

4. **Async Programming**
   - Future: Single async value
   - async/await: Sequential async code
   - Try-catch: Error handling

5. **JSON Serialization**
   - fromJson: JSON → Dart object
   - toJson: Dart object → JSON
   - jsonEncode/jsonDecode: String ↔ Map

6. **Null Safety**
   - Type?: Nullable type
   - Type!: Assert non-null
   - ??: Null coalescing
   - ?.: Safe navigation

### Backend Concepts

1. **Django ORM**
   - Models: Database tables as classes
   - QuerySets: Database queries
   - Migrations: Schema changes

2. **DRF (Django REST Framework)**
   - Serializers: Data validation/transformation
   - ViewSets/APIView: Request handlers
   - Token Authentication: Stateless auth

3. **HTTP Methods**
   - GET: Retrieve data
   - POST: Create data
   - PUT/PATCH: Update data
   - DELETE: Remove data

4. **Status Codes**
   - 200 OK: Success
   - 201 Created: Resource created
   - 400 Bad Request: Client error
   - 401 Unauthorized: Auth required
   - 404 Not Found: Resource missing
   - 500 Server Error: Backend error

---

## 🎯 Integration Map

```
User Action
    ↓
UI Screen (Widget)
    ↓
Provider (StateNotifier)
    ↓
Service (API/Storage)
    ↓
Backend API (Django View)
    ↓
Serializer (Validation)
    ↓
Model (Database)
    ↓
MySQL Database
```

**Example: User Login**
```
1. LoginScreen: User enters credentials
2. LoginScreen: Calls ref.read(authProvider.notifier).login()
3. AuthProvider: Sets isLoading = true
4. AuthProvider: Calls ApiService.login()
5. ApiService: POST http://localhost:8000/api/auth/login
6. Django views.py: login() function
7. LoginSerializer: Validates credentials
8. User model: Checks password hash
9. Token model: Creates/retrieves token
10. Response: {user, token}
11. ApiService: Parses to User object
12. AuthProvider: Updates state with user
13. StorageService: Saves to SharedPreferences
14. LoginScreen: Watches state, sees success
15. LoginScreen: Navigates to /home
```

---

## 📚 Learning Resources

### Flutter/Dart
- **Official Docs**: https://docs.flutter.dev/
- **Riverpod**: https://riverpod.dev/
- **GoRouter**: https://pub.dev/packages/go_router
- **Dart Lang**: https://dart.dev/

### Django/Python
- **Django**: https://docs.djangoproject.com/
- **DRF**: https://www.django-rest-framework.org/
- **Python**: https://docs.python.org/

### Design
- **Material 3**: https://m3.material.io/
- **Flutter Widgets**: https://docs.flutter.dev/ui/widgets

---

## 🔍 Quick Reference

### Find User Data
- Model: `user_model.dart`
- Provider: `auth_provider.dart`
- API: `ApiService.login()`
- Backend: `authentication/models.py`

### Find Products
- Model: `product_model.dart`
- Provider: `home_provider.dart`
- Display: `enhanced_product_card.dart`
- Screen: `home_screen.dart`

### Find Quiz Logic
- Models: `quiz/models/questionnaire_models.dart`
- Controller: `quiz/state/questionnaire_controller.dart`
- Steps: `quiz/steps/quiz_step*.dart`
- Results: `quiz/result/new_recommendation_screen.dart`

### Find Theme System
- Colors: `constants/app_colors.dart`
- Theme: `constants/app_theme.dart`
- Provider: `providers/theme_provider.dart`
- Toggle: Profile screen

### Find Navigation
- Config: `config/router_config.dart`
- Usage: `context.go('/path')` in screens

---

This document serves as a comprehensive reference for every file in the LensHive project. For detailed documentation on specific files, refer to the individual documentation files in the `/docs` folder.

