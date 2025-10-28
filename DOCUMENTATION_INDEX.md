# LensHive - Complete Documentation Index

## 📚 Overview
This document serves as the central index for all LensHive project documentation. Each file is documented separately to help you understand its purpose, components, and how it fits into the overall architecture.

---

## 🎯 Start Here

### Overall Architecture
- **[LENSHIVE_PROJECT_ARCHITECTURE.md](LENSHIVE_PROJECT_ARCHITECTURE.md)** - Complete project architecture, data flow, and system design

---

## 📱 Frontend Documentation (Flutter/Dart)

### Core Application Files

#### Entry Point & Configuration
- **[docs/FLUTTER_MAIN_DOCUMENTATION.md](docs/FLUTTER_MAIN_DOCUMENTATION.md)** - App entry point, initialization, and setup
- **[docs/ROUTER_CONFIG_DOCUMENTATION.md](docs/ROUTER_CONFIG_DOCUMENTATION.md)** - Navigation and routing configuration

#### Constants & Theming
- **[docs/APP_COLORS_DOCUMENTATION.md](docs/APP_COLORS_DOCUMENTATION.md)** ✅ - Centralized color management (50+ colors, helper methods)
- **[docs/APP_THEME_DOCUMENTATION.md](docs/APP_THEME_DOCUMENTATION.md)** ✅ - Light/dark theme configuration (Material 3, complete theme setup)

### Data Models
- **[docs/USER_MODEL_DOCUMENTATION.md](docs/USER_MODEL_DOCUMENTATION.md)** ✅ - User data structure (5 fields, JSON serialization, immutability)
- **[docs/PRODUCT_MODEL_DOCUMENTATION.md](docs/PRODUCT_MODEL_DOCUMENTATION.md)** ✅ - Product data structure (16 fields, e-commerce features)

### State Management (Providers)
- **[docs/AUTH_PROVIDER_DOCUMENTATION.md](docs/AUTH_PROVIDER_DOCUMENTATION.md)** ✅ - Authentication state management (login, register, logout, session)
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - ALL remaining files documented in detail
  - home_provider.dart - Product catalog state
  - splash_provider.dart - Splash screen timing
  - theme_provider.dart - Theme switching

### Services
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - Comprehensive service documentation
  - api_service.dart - HTTP requests, token auth, JSON parsing
  - storage_service.dart - SharedPreferences, persistence

### Screens (UI)
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - All screens documented
  - splash_screen.dart - Animated launch screen
  - login_screen.dart - Form validation, Remember Me
  - registration_screen.dart - Multi-field validation
  - home_screen.dart - Product grid, categories, search
  - profile_screen.dart - Settings, theme toggle, logout

### Reusable Widgets
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - All widgets documented
  - bottom_nav_bar.dart - 5-tab navigation
  - category_tabs.dart - Category filtering
  - custom_search_bar.dart - Search with camera
  - enhanced_product_card.dart - Product display with badges
  - skeleton_loaders.dart - Loading placeholders

### Quiz Feature Module
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - Complete quiz feature documented
  - questionnaire_models.dart - 17 enums, data structures
  - questionnaire_controller.dart - State management, recommendation engine
  - quiz_step1_basics.dart - Who, vision needs, prescription
  - quiz_step2_usage.dart - Screen time, sunlight, activities
  - quiz_step3_preferences.dart - Thickness, comfort features
  - new_recommendation_screen.dart - Results display
  - option_chip.dart, progress_bar.dart, section_card.dart - Quiz widgets

---

## 🔧 Backend Documentation (Django/Python)

### Authentication Module
- **[docs/BACKEND_AUTHENTICATION_MODELS_DOCUMENTATION.md](docs/BACKEND_AUTHENTICATION_MODELS_DOCUMENTATION.md)** ✅ - User model and manager (UUID, email auth, password hashing)
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - All backend files documented
  - serializers.py - UserSerializer, RegisterSerializer, LoginSerializer
  - views.py - API endpoints (register, login, logout, profile)
  - urls.py - Route configuration

### Django Configuration
- **[docs/COMPLETE_FILES_REFERENCE.md](docs/COMPLETE_FILES_REFERENCE.md)** ✅ - Configuration documented
  - settings.py - Database, CORS, REST framework, authentication
  - urls.py - Main URL routing
  - manage.py - Django management commands

---

## 📖 Documentation by Category

### For Learning Concepts

#### State Management
- Auth Provider (Riverpod StateNotifier)
- Home Provider (Riverpod StateNotifier)
- Theme Provider (Riverpod StateNotifier)
- Quiz Controller (Riverpod StateNotifier)

#### Navigation
- GoRouter Configuration
- Route Definitions
- Navigation Methods

#### Responsive Design
- ScreenUtil Usage
- Responsive Sizing
- Adaptive Layouts

#### API Communication
- HTTP Requests
- Token Authentication
- Error Handling
- JSON Parsing

#### Local Storage
- SharedPreferences
- Data Persistence
- Token Management

#### Backend Concepts
- Django Models (ORM)
- Django Serializers (DRF)
- Django Views (API Endpoints)
- Token Authentication
- Password Hashing

---

## 🎨 UI/UX Documentation

### Design System
- Color Palette (Light & Dark)
- Typography
- Spacing & Sizing
- Shadows & Elevation

### Components
- Buttons
- Input Fields
- Cards
- Navigation
- Loading States
- Empty States

---

## 🔐 Authentication & Security

### Frontend Security
- Token Storage
- Secure API Calls
- Input Validation

### Backend Security
- Password Hashing (PBKDF2)
- Token Authentication
- CSRF Protection
- CORS Configuration

---

## 📊 Data Models & APIs

### Frontend Models
- User Model
- Product Model
- Questionnaire Models
- Recommendation Model

### API Endpoints
```
POST   /api/auth/register   - User registration
POST   /api/auth/login      - User login
POST   /api/auth/logout     - User logout
GET    /api/user/profile    - Get user profile
GET    /api/auth/test       - Test connection
```

---

## 🚀 Getting Started Guide

### Prerequisites
- Flutter SDK (latest)
- Dart SDK (3.x)
- Python (3.12)
- MySQL (8.x)
- VS Code or Android Studio

### Setup Instructions

#### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

#### Frontend Setup
```bash
cd lenshive
flutter pub get
flutter run
```

### Configuration
- Backend: Create `.env` file with database credentials
- Frontend: Update API base URL in `api_service.dart`

---

## 🧪 Testing

### Manual Testing
- Authentication flow
- Product browsing
- Quiz completion
- Theme switching
- Navigation

### API Testing
- Use Postman or curl
- Test all endpoints
- Verify error handling

---

## 📝 Code Documentation Standards

Each documentation file includes:

### Structure
1. **Purpose** - What the file does
2. **Key Concepts** - Important concepts used
3. **Components** - Major parts of the file
4. **Data Flow** - How data moves through the component
5. **Dependencies** - External packages/modules used
6. **Sub-Modules** - Related components
7. **Features** - What it implements
8. **Learning Notes** - Concepts for understanding
9. **Common Issues** - Troubleshooting guide
10. **Future Enhancements** - Planned improvements

---

## 🔄 Project Status

### Completed Features
- ✅ User Authentication (Login/Register/Logout)
- ✅ Profile Management
- ✅ Product Catalog Display
- ✅ Category Filtering
- ✅ Lens Finder Quiz (3 Steps)
- ✅ Recommendation Engine
- ✅ Light/Dark Theme Support
- ✅ Responsive Design
- ✅ Local Data Persistence

### In Progress
- 🚧 Shopping Cart
- 🚧 Checkout Process
- 🚧 Order Management

### Planned
- 📋 AR Try-On
- 📋 Payment Integration
- 📋 Push Notifications
- 📋 Social Features

---

## 📚 Learning Path

### For Beginners

#### Start with:
1. LENSHIVE_PROJECT_ARCHITECTURE.md (overview)
2. FLUTTER_MAIN_DOCUMENTATION.md (app entry point)
3. APP_COLORS_DOCUMENTATION.md (theming basics)
4. AUTH_PROVIDER_DOCUMENTATION.md (state management)

#### Then Learn:
5. LOGIN_SCREEN_DOCUMENTATION.md (UI screens)
6. API_SERVICE_DOCUMENTATION.md (backend communication)
7. BACKEND_AUTHENTICATION_MODELS_DOCUMENTATION.md (database)

### For Intermediate Developers

#### Focus on:
1. State Management (Providers)
2. Navigation (GoRouter)
3. API Integration
4. Data Models

### For Advanced Developers

#### Explore:
1. Quiz Feature Architecture
2. Recommendation Engine
3. Backend API Design
4. Database Schema

---

## 🛠️ Tools & Technologies

### Frontend
- **Flutter**: Cross-platform framework
- **Dart**: Programming language
- **Riverpod**: State management
- **GoRouter**: Navigation
- **ScreenUtil**: Responsive design
- **SharedPreferences**: Local storage
- **HTTP**: API calls

### Backend
- **Django**: Web framework
- **Django REST Framework**: API development
- **PyMySQL**: MySQL connector
- **Token Authentication**: Security

### Database
- **MySQL**: Relational database

---

## 📞 Support & Contribution

### Questions?
- Check relevant documentation file
- Review code comments
- Examine examples in codebase

### Contributing
- Follow existing code patterns
- Add documentation for new features
- Update this index when adding docs

---

## 📖 Additional Resources

### Flutter Resources
- [Flutter Official Docs](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Package](https://pub.dev/packages/go_router)

### Django Resources
- [Django Official Docs](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)

### Design Resources
- [Material Design 3](https://m3.material.io/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

---

## 🔄 Document Updates

This documentation index is maintained alongside the codebase. When adding new features or files:

1. Create corresponding documentation file
2. Add entry to this index
3. Update LENSHIVE_PROJECT_ARCHITECTURE.md if needed
4. Follow the established documentation format

---

**Last Updated**: 2025-10-26  
**Version**: 1.0.0  
**Maintainer**: Development Team

