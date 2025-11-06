import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import '../features/quiz/steps/quiz_step1_basics.dart';
import '../features/quiz/steps/quiz_step2_usage.dart';
import '../features/quiz/steps/quiz_step3_preferences.dart';
import '../features/quiz/result/new_recommendation_screen.dart';
import '../features/quiz/models/questionnaire_models.dart';
import '../models/product_model.dart';

/// GoRouter configuration for app navigation
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false, // Disable debug logs for cleaner output
  routes: [
    // Splash Screen - Always shown first on app start
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Authentication Routes
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
    
    // Home Screen
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    
    // Profile Screen
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    
    // Product Detail Screen
    GoRoute(
      path: '/product/:id',
      name: 'product_detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),
    
    // Quiz Routes - Simplified 3-step process
    GoRoute(
      path: '/quiz',
      redirect: (context, state) => '/quiz/step1', // Redirect to first step
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

