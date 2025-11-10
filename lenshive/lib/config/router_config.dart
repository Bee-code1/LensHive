import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/router/routes.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/customize_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/admin/booking_list_screen.dart';
import '../screens/admin/booking_detail_screen.dart';
import '../features/quiz/steps/quiz_step1_basics.dart';
import '../features/quiz/steps/quiz_step2_usage.dart';
import '../features/quiz/steps/quiz_step3_preferences.dart';
import '../features/quiz/result/new_recommendation_screen.dart';
import '../features/quiz/models/questionnaire_models.dart';
import '../features/home_service_user/ui/home_service_request_screen.dart';
import '../features/home_service_user/ui/my_home_service_bookings_screen.dart';
import '../features/home_service_user/ui/home_service_booking_detail_screen.dart';
import '../models/product_model.dart';
import '../widgets/bottom_nav_scaffold.dart';

/// GoRouter configuration for app navigation
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    // ==================== Splash & Auth (No Bottom Nav) ====================
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    
    // ==================== User Routes (With Bottom Nav) ====================
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavScaffold(child: child);
      },
      routes: [
        // Home tab
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const HomeScreen(),
          ),
        ),
        
        // Customize tab
        GoRoute(
          path: '/customize',
          name: 'customize',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const CustomizeScreen(),
          ),
        ),
        
        // My Orders tab
        GoRoute(
          path: '/my-orders',
          name: 'my_orders',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const MyOrdersScreen(),
          ),
        ),
        
        // Bookings tab (Home Service Bookings)
        GoRoute(
          path: Routes.bookings,
          name: 'bookings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyHomeServiceBookingsScreen(),
          ),
        ),
        
        // Account tab (formerly Profile)
        GoRoute(
          path: Routes.account,
          name: 'account',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
        
        // Profile alias (backward compatibility)
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
        
        // Home Service - New Booking Form (with bottom nav)
        GoRoute(
          path: Routes.homeServiceNew,
          name: 'home_service_new',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeServiceRequestScreen(),
          ),
        ),
        
        // Home Service - My Bookings List (with bottom nav)
        GoRoute(
          path: Routes.homeServiceMy,
          name: 'home_service_my',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyHomeServiceBookingsScreen(),
          ),
        ),
      ],
    ),
    
    // ==================== Other User Routes (No Bottom Nav) ====================
    
    // Cart (full screen, no bottom nav)
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    
    // Checkout (full screen, no bottom nav)
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutStubScreen(),
    ),
    
    // Product Detail (full screen, no bottom nav)
    GoRoute(
      path: '/product/:id',
      name: 'product_detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),
    
    // Quiz Routes (full screen, no bottom nav)
    GoRoute(
      path: '/quiz',
      redirect: (context, state) => '/quiz/step1',
    ),
    GoRoute(
      path: '/quiz/step1',
      name: 'quiz_step1',
      builder: (context, state) => const QuizStep1Basics(),
    ),
    GoRoute(
      path: '/quiz/step2',
      name: 'quiz_step2',
      builder: (context, state) => const QuizStep2Usage(),
    ),
    GoRoute(
      path: '/quiz/step3',
      name: 'quiz_step3',
      builder: (context, state) => const QuizStep3Preferences(),
    ),
    GoRoute(
      path: '/quiz/result',
      name: 'quiz_result',
      builder: (context, state) {
        final recommendation = state.extra as RecommendationData?;
        return NewRecommendationScreen(recommendation: recommendation);
      },
    ),
    
    // ==================== User Home Service Routes (No Bottom Nav) ====================
    
    // Home Service Booking Detail (no bottom nav - full screen for detail view)
    GoRoute(
      path: Routes.homeServiceDetail,
      name: 'home_service_booking_detail',
      builder: (context, state) {
        final bookingId = state.pathParameters['id']!;
        return HomeServiceBookingDetailScreen(bookingId: bookingId);
      },
    ),
    
    // ==================== Admin Routes (No Bottom Nav) ====================
    
    // Admin Home Service - Booking List
    GoRoute(
      path: '/admin/home-service',
      name: 'admin_home_service',
      builder: (context, state) => const BookingListScreen(),
    ),
    
    // Admin Home Service - Booking Detail
    GoRoute(
      path: '/admin/home-service/:id',
      name: 'admin_booking_detail',
      builder: (context, state) {
        final bookingId = state.pathParameters['id']!;
        return BookingDetailScreen(bookingId: bookingId);
      },
    ),
  ],
  
  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
