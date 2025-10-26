# LENSHIVE - Complete Project Architecture Documentation

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Frontend Architecture (Flutter)](#frontend-architecture-flutter)
5. [Backend Architecture (Django)](#backend-architecture-django)
6. [Database Schema](#database-schema)
7. [API Communication](#api-communication)
8. [State Management](#state-management)
9. [Navigation Flow](#navigation-flow)
10. [Authentication System](#authentication-system)
11. [Feature Modules](#feature-modules)
12. [Data Flow Diagrams](#data-flow-diagrams)

---

## Project Overview

**LensHive** is a modern eyewear e-commerce mobile application that helps users find the perfect lenses through an intelligent quiz system and browse products with advanced features like AR try-on and personalized recommendations.

### Key Features
- ✅ User Authentication (Login/Register)
- ✅ Product Catalog with Categories
- ✅ Intelligent Lens Finder Quiz (3 steps)
- ✅ Light/Dark Theme Support
- ✅ Responsive Design
- ✅ Profile Management
- 🚧 AR Try-On (Planned)
- 🚧 Shopping Cart (Planned)
- 🚧 Order Management (Planned)

---

## Technology Stack

### Frontend (Mobile App)
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | Latest | Cross-platform mobile framework |
| **Dart** | 3.x | Programming language |
| **Riverpod** | Latest | State management |
| **GoRouter** | Latest | Navigation/routing |
| **ScreenUtil** | Latest | Responsive design |
| **SharedPreferences** | Latest | Local storage |
| **HTTP** | Latest | API communication |

### Backend (API Server)
| Technology | Version | Purpose |
|------------|---------|---------|
| **Django** | 5.2.7 | Web framework |
| **Python** | 3.12 | Programming language |
| **Django REST Framework** | 3.16.1 | API development |
| **PyMySQL** | 1.1.0 | MySQL connector |
| **django-cors-headers** | 4.9.0 | CORS handling |

### Database
| Technology | Purpose |
|------------|---------|
| **MySQL** | Primary database (user data, products) |

### Development Tools
- **Git**: Version control
- **VS Code/Android Studio**: IDEs
- **Postman**: API testing

---

## Project Structure

```
LENSHIVE/
├── lenshive/                    # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── config/             # Configuration
│   │   │   └── router_config.dart
│   │   ├── constants/          # App constants
│   │   │   ├── app_colors.dart
│   │   │   └── app_theme.dart
│   │   ├── models/             # Data models
│   │   │   ├── user_model.dart
│   │   │   └── product_model.dart
│   │   ├── providers/          # State management
│   │   │   ├── auth_provider.dart
│   │   │   ├── home_provider.dart
│   │   │   ├── theme_provider.dart
│   │   │   └── splash_provider.dart
│   │   ├── services/           # API & Storage services
│   │   │   ├── api_service.dart
│   │   │   └── storage_service.dart
│   │   ├── screens/            # UI screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── registration_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── widgets/            # Reusable widgets
│   │   │   ├── bottom_nav_bar.dart
│   │   │   ├── category_tabs.dart
│   │   │   ├── custom_search_bar.dart
│   │   │   ├── enhanced_product_card.dart
│   │   │   └── skeleton_loaders.dart
│   │   └── features/           # Feature modules
│   │       └── quiz/
│   │           ├── models/
│   │           ├── state/
│   │           ├── steps/
│   │           ├── result/
│   │           └── widgets/
│   ├── assets/
│   │   └── images/
│   │       └── lenshive_logo.png
│   └── pubspec.yaml            # Flutter dependencies
│
├── backend/                     # Django Backend
│   ├── authentication/          # Auth app
│   │   ├── models.py           # User model
│   │   ├── serializers.py      # API serializers
│   │   ├── views.py            # API endpoints
│   │   └── urls.py             # Auth routes
│   ├── lenshive_backend/        # Project settings
│   │   ├── settings.py         # Django configuration
│   │   └── urls.py             # Main URL config
│   ├── manage.py               # Django CLI
│   └── requirements.txt        # Python dependencies
│
├── docs/                        # Documentation
└── README.md                    # Project README
```

---

## Frontend Architecture (Flutter)

### Architecture Pattern: MVVM (Model-View-ViewModel)

```
┌─────────────────────────────────────────┐
│              View Layer                 │
│  (Screens & Widgets - UI Components)    │
└──────────────┬──────────────────────────┘
               │ User Interactions
               ▼
┌─────────────────────────────────────────┐
│          ViewModel Layer                │
│  (Providers - State Management)         │
│  • AuthProvider                         │
│  • HomeProvider                         │
│  • ThemeProvider                        │
│  • QuizController                       │
└──────────────┬──────────────────────────┘
               │ Business Logic
               ▼
┌─────────────────────────────────────────┐
│           Model Layer                   │
│  (Data Models & Services)               │
│  • User Model                           │
│  • Product Model                        │
│  • ApiService                           │
│  • StorageService                       │
└─────────────────────────────────────────┘
```

### Key Components

#### 1. **Entry Point (main.dart)**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}
```
- Initializes Flutter
- Wraps app in ProviderScope for Riverpod
- Sets up responsive design with ScreenUtil

#### 2. **State Management (Riverpod)**
- **Why Riverpod**: Type-safe, compile-time safe, no context dependency
- **Provider Types**:
  - `StateNotifierProvider`: For mutable state (auth, home, theme)
  - `Provider`: For computed/derived state
  - `FutureProvider`: For async data

#### 3. **Navigation (GoRouter)**
- Declarative routing
- URL-based navigation
- Deep linking support
- Type-safe route parameters

#### 4. **Responsive Design (ScreenUtil)**
- Base design: iPhone 13 Pro (375x812)
- Scales UI proportionally across devices
- Usage: `16.r` for responsive size, `1.sw` for screen width

---

## Backend Architecture (Django)

### Architecture Pattern: MVT (Model-View-Template)
*Note: We use Django REST Framework, so "Template" becomes JSON responses*

```
┌─────────────────────────────────────────┐
│          API Layer (Views)              │
│  • register()                           │
│  • login()                              │
│  • logout()                             │
│  • get_profile()                        │
└──────────────┬──────────────────────────┘
               │ Request/Response
               ▼
┌─────────────────────────────────────────┐
│       Serialization Layer               │
│  • UserSerializer                       │
│  • RegisterSerializer                   │
│  • LoginSerializer                      │
└──────────────┬──────────────────────────┘
               │ Data Validation
               ▼
┌─────────────────────────────────────────┐
│          Model Layer (ORM)              │
│  • User (custom model)                  │
│  • Token (auth tokens)                  │
└─────────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│            Database                     │
│  MySQL (lenshive_db)                    │
└─────────────────────────────────────────┘
```

### API Endpoints

| Method | Endpoint | Purpose | Auth Required |
|--------|----------|---------|---------------|
| POST | `/api/auth/register` | User registration | No |
| POST | `/api/auth/login` | User login | No |
| POST | `/api/auth/logout` | User logout | Yes |
| GET | `/api/user/profile` | Get user profile | Yes |
| GET | `/api/auth/test` | Test connection | No |

---

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id              CHAR(36) PRIMARY KEY,      -- UUID
    full_name       VARCHAR(255) NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    password        VARCHAR(128) NOT NULL,     -- Hashed
    is_active       BOOLEAN DEFAULT TRUE,
    is_admin        BOOLEAN DEFAULT FALSE,
    is_staff        BOOLEAN DEFAULT FALSE,
    is_superuser    BOOLEAN DEFAULT FALSE,
    created_at      DATETIME NOT NULL,
    updated_at      DATETIME NOT NULL,
    INDEX idx_email (email)
);
```

### Auth Tokens Table (Django's built-in)
```sql
CREATE TABLE authtoken_token (
    key         VARCHAR(40) PRIMARY KEY,
    user_id     CHAR(36) NOT NULL,
    created     DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## API Communication

### Request-Response Flow

```
┌──────────────┐      HTTP Request       ┌──────────────┐
│              │  ──────────────────────> │              │
│   Flutter    │                          │    Django    │
│   Frontend   │  <──────────────────────  │   Backend    │
│              │      JSON Response       │              │
└──────────────┘                          └──────────────┘
       │                                          │
       │                                          │
  ┌────▼────┐                               ┌────▼────┐
  │ Storage │                               │  MySQL  │
  │ (Local) │                               │   (DB)  │
  └─────────┘                               └─────────┘
```

### Authentication Flow

#### Registration
```
1. User enters: fullName, email, password
2. Flutter → POST /api/auth/register
3. Django validates data
4. Django hashes password (PBKDF2)
5. Django saves user to database
6. Django generates auth token
7. Django → Returns {user, token}
8. Flutter saves token & user to local storage
9. Flutter navigates to home screen
```

#### Login
```
1. User enters: email, password
2. Flutter → POST /api/auth/login
3. Django queries user by email
4. Django checks password hash
5. If valid: Django generates/retrieves token
6. Django → Returns {user, token}
7. Flutter saves token & user to local storage
8. Flutter navigates to home screen
```

#### Authenticated Requests
```
1. Flutter reads token from local storage
2. Flutter adds header: "Authorization: Token <token>"
3. Flutter → API request with auth header
4. Django validates token
5. Django processes request
6. Django → Returns response
```

### API Service (Flutter)

```dart
class ApiService {
  static const baseUrl = 'http://localhost:8000/api';
  
  static Future<User> login({email, password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    // Parse response and return User
  }
}
```

---

## State Management

### Riverpod Architecture

```dart
// 1. State Class
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
}

// 2. StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  Future<bool> login({email, password}) {
    // Update state during login process
  }
}

// 3. Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// 4. Usage in Widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // UI based on authState
  }
}
```

### State Flow

```
User Action
    ↓
Widget calls Provider Method
    ↓
Provider updates State
    ↓
Notifies all Listeners
    ↓
Widgets Rebuild with new State
```

---

## Navigation Flow

```
App Launch
    ↓
Splash Screen (6s animation)
    ↓
Check Auth Status
    ├─→ Logged In → Home Screen
    └─→ Not Logged In → Login Screen
              │
              ├─→ Register → Registration Screen → Home
              └─→ Login → Home Screen
                              │
                              ├─→ Browse Products
                              ├─→ Start Quiz → 3-Step Quiz → Results
                              ├─→ Profile → Settings/Logout
                              ├─→ Cart (Planned)
                              └─→ Orders (Planned)
```

### Route Definitions (GoRouter)

```dart
GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => RegistrationScreen()),
    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
    GoRoute(path: '/quiz/step1', builder: (_, __) => QuizStep1()),
    GoRoute(path: '/quiz/step2', builder: (_, __) => QuizStep2()),
    GoRoute(path: '/quiz/step3', builder: (_, __) => QuizStep3()),
    GoRoute(path: '/quiz/result', builder: (_, __) => ResultScreen()),
  ],
)
```

---

## Authentication System

### Frontend (Flutter)

#### Storage Service
```dart
class StorageService {
  // Save user data
  static Future<bool> saveUser(User user);
  
  // Get user data
  static Future<User?> getUser();
  
  // Save token
  static Future<bool> saveToken(String token);
  
  // Check if logged in
  static Future<bool> isLoggedIn();
  
  // Clear all data (logout)
  static Future<bool> clearUserData();
}
```

#### Auth Provider
```dart
class AuthNotifier {
  // Login
  Future<bool> login({email, password});
  
  // Register
  Future<bool> register({fullName, email, password});
  
  // Logout
  Future<void> logout();
  
  // Refresh user data
  Future<void> refreshUser();
}
```

### Backend (Django)

#### User Model
- Custom user with email as username
- UUID primary key
- Password hashing with PBKDF2
- Token-based authentication

#### Authentication Views
```python
@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    # Validate data
    # Create user
    # Generate token
    # Return user + token

@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    # Validate credentials
    # Get/create token
    # Return user + token

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout(request):
    # Delete user token
    # Return success
```

---

## Feature Modules

### 1. Quiz Feature (Lens Finder)

#### Purpose
Help users find the perfect lenses through a 3-step questionnaire.

#### Structure
```
features/quiz/
├── models/
│   └── questionnaire_models.dart  # Data models & enums
├── state/
│   └── questionnaire_controller.dart  # State management
├── steps/
│   ├── quiz_step1_basics.dart        # Basic info
│   ├── quiz_step2_usage.dart         # Usage patterns
│   └── quiz_step3_preferences.dart   # Preferences
├── result/
│   └── new_recommendation_screen.dart  # Results
└── widgets/
    ├── option_chip.dart      # Selection chips
    ├── progress_bar.dart     # Progress indicator
    └── section_card.dart     # Question cards
```

#### Quiz Flow
```
Step 1: Basics
• Who will wear the glasses?
• Vision needs (far/near/both)
• Prescription strength

Step 2: Usage
• Daily screen time (slider)
• Time in sunlight
• Main activities (multi-select)

Step 3: Preferences
• Lens thickness preference
• Comfort features (multi-select)

Results
• Recommendation engine analyzes answers
• Shows personalized lens recommendation
• Displays benefits and features
```

#### Recommendation Engine
```dart
RecommendationData generateRecommendation() {
  // Rule-based engine
  if (preferAutoOutdoor || sunlightTime > 2hrs) 
    return AdaptiveLenses;
  
  if (screenTime >= 5hrs || reduceEyeStrain)
    return AntiReflectiveLenses;
  
  if (lightThin || powerStrength > moderate)
    return ThinLightLenses;
  
  if (roughUse || sports)
    return ImpactResistantLenses;
  
  return StandardLenses;
}
```

### 2. Product Catalog

#### Features
- Category tabs (Men, Women, Kids)
- Search bar with camera icon
- Product grid with images
- Badges (Bestseller, New)
- Ratings & reviews
- Try-On button (AR feature planned)
- Add to cart button

#### Data Structure
```dart
class Product {
  String id;
  String name;
  double price;
  String imageUrl;
  String category;
  String brand;
  double rating;
  int reviewCount;
  bool isBestseller;
  bool isNew;
}
```

### 3. Profile Management

#### Features
- User information display
- Theme toggle (light/dark)
- Settings options
- Logout functionality
- Profile edit (planned)
- Password change (planned)

---

## Data Flow Diagrams

### User Registration Flow
```
┌─────────────┐
│ User enters │
│  fullName   │
│    email    │
│  password   │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ Flutter Form    │
│ Validation      │
│ • Email format  │
│ • Password len  │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐        POST Request         ┌──────────────┐
│  AuthProvider   │ ───────────────────────────> │    Django    │
│  register()     │                              │   Backend    │
└─────────────────┘                              └──────┬───────┘
       │                                                 │
       │                                                 ▼
       │                                         ┌──────────────┐
       │                                         │  Serializer  │
       │                                         │  Validation  │
       │                                         └──────┬───────┘
       │                                                 │
       │                                                 ▼
       │                                         ┌──────────────┐
       │                                         │ UserManager  │
       │                                         │ create_user()│
       │                                         └──────┬───────┘
       │                                                 │
       │                                                 ▼
       │                                         ┌──────────────┐
       │                                         │  Hash pass   │
       │                                         │  Save to DB  │
       │                                         │ Create token │
       │                                         └──────┬───────┘
       │                                                 │
       │        {user, token}                           │
       │ <───────────────────────────────────────────────┘
       │
       ▼
┌─────────────────┐
│ StorageService  │
│  saveUser()     │
│  saveToken()    │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│   Navigate to   │
│   Home Screen   │
└─────────────────┘
```

### Product Loading Flow
```
┌─────────────┐
│ HomeScreen  │
│  mounted    │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  HomeProvider   │
│  loadProducts() │
└──────┬──────────┘
       │
       ├─→ Set isLoading = true
       │
       ├─→ API Call (currently mock)
       │   await Future.delayed(2s)
       │   getMockProducts()
       │
       ├─→ Filter by category
       │
       ├─→ Set products & filteredProducts
       │
       └─→ Set isLoading = false
              │
              ▼
       ┌─────────────────┐
       │ HomeScreen      │
       │  rebuilds with  │
       │    products     │
       └─────────────────┘
```

### Theme Toggle Flow
```
┌─────────────┐
│    User     │
│   toggles   │
│   switch    │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ ThemeProvider   │
│  toggleTheme()  │
└──────┬──────────┘
       │
       ├─→ Get current theme
       ├─→ Switch to opposite
       ├─→ Save to SharedPreferences
       └─→ Update state
              │
              ▼
       ┌─────────────────┐
       │  main.dart      │
       │  watches        │
       │  themeProvider  │
       └──────┬──────────┘
              │
              ▼
       ┌─────────────────┐
       │  MaterialApp    │
       │   rebuilds      │
       │  with new theme │
       └─────────────────┘
              │
              ▼
       ┌─────────────────┐
       │  All widgets    │
       │   rebuild with  │
       │   new colors    │
       └─────────────────┘
```

---

## Key Learning Concepts

### Flutter Concepts Used

1. **Widget Tree**: Everything is a widget
2. **State Management**: Riverpod for reactive updates
3. **Responsive Design**: ScreenUtil for multiple screen sizes
4. **Navigation**: GoRouter for declarative routing
5. **Async Programming**: Future, async/await for API calls
6. **Local Storage**: SharedPreferences for persistence

### Django Concepts Used

1. **MVT Pattern**: Model-View-Template (REST = JSON)
2. **ORM**: Object-Relational Mapping for database
3. **Serializers**: Data validation and transformation
4. **Authentication**: Token-based auth
5. **Middleware**: CORS, security, sessions
6. **Migrations**: Database schema management

### Dart Concepts

1. **Null Safety**: `?`, `!`, `??` operators
2. **Async/Await**: Asynchronous programming
3. **Classes**: Object-oriented programming
4. **Enums**: Type-safe constants
5. **Extensions**: Add methods to existing types
6. **Generics**: Type-safe collections

### Python Concepts

1. **Decorators**: `@api_view`, `@permission_classes`
2. **Class Inheritance**: `AbstractBaseUser`, `BaseUserManager`
3. **Type Hints**: Modern Python typing
4. **Context Managers**: `with` statement
5. **List Comprehensions**: Pythonic iterations

---

## Development Workflow

### Starting the Application

#### Backend
```bash
# Navigate to backend
cd backend

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Run migrations
python manage.py migrate

# Start server
python manage.py runserver
# Backend runs on http://localhost:8000
```

#### Frontend
```bash
# Navigate to frontend
cd lenshive

# Get dependencies
flutter pub get

# Run app
flutter run
# Or use VS Code/Android Studio Run button
```

### Testing API
```bash
# Test backend connection
curl http://localhost:8000/api/auth/test

# Test registration
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test User","email":"test@example.com","password":"test123"}'
```

---

## Security Considerations

### Frontend
- Tokens stored in SharedPreferences (encrypted storage)
- Passwords never stored locally
- HTTPS for production API calls
- Input validation before API calls

### Backend
- Password hashing (PBKDF2 with 390K iterations)
- CSRF protection enabled
- Token authentication
- Email normalization
- SQL injection prevention (Django ORM)
- XSS protection (Django middleware)

---

## Performance Optimizations

### Frontend
- Image caching
- Lazy loading for product lists
- Skeleton loaders during data fetch
- Debouncing for search input
- Responsive images with proper sizing

### Backend
- Database indexing on email field
- Query optimization with select_related
- Token caching
- Response compression (planned)

---

## Future Roadmap

### Phase 1 (Current)
- ✅ User Authentication
- ✅ Product Catalog
- ✅ Lens Finder Quiz
- ✅ Theme Support

### Phase 2 (Next)
- 🚧 Shopping Cart
- 🚧 Checkout Process
- 🚧 Order History
- 🚧 Product Detail Page

### Phase 3 (Planned)
- 📋 AR Try-On Feature
- 📋 Payment Integration
- 📋 Push Notifications
- 📋 Social Sharing

### Phase 4 (Future)
- 📋 AI-powered recommendations
- 📋 Virtual Assistant
- 📋 Loyalty Program
- 📋 Multi-language support

---

## Conclusion

LensHive is built with modern, scalable architecture using Flutter for cross-platform mobile development and Django REST Framework for a robust backend API. The project follows MVVM pattern on the frontend and MVT pattern on the backend, with clear separation of concerns and maintainable code structure.

The application demonstrates best practices in:
- State management
- API communication
- Authentication
- Responsive design
- Theme management
- Code organization

For detailed documentation of individual files, please refer to the `docs/` folder.

---

## Contact & Support

For questions or contributions:
- Review individual file documentation in `/docs` folder
- Check code comments for implementation details
- Follow coding standards defined in each module

