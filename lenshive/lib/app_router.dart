import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/splash_screen.dart';
import '../features/quiz/steps/step1_who.dart';
import '../features/quiz/steps/step2_screen_work_reflections.dart';
import '../features/quiz/steps/step3_sunlight_auto_night_sensitivity.dart';
import '../features/quiz/steps/step4_lifestyle_thickness_handling.dart';
import '../features/quiz/steps/step5_comfort_budget_notes.dart';
import '../features/quiz/result/recommendation_screen.dart';

/// App Router Configuration
/// Defines all routes for the LensHive application including the questionnaire wizard
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Existing app routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    
    // Questionnaire wizard routes
    GoRoute(
      path: '/quiz/step1',
      builder: (context, state) => const Step1Who(),
    ),
    GoRoute(
      path: '/quiz/step2',
      builder: (context, state) => const Step2ScreenWorkReflections(),
    ),
    GoRoute(
      path: '/quiz/step3',
      builder: (context, state) => const Step3SunlightAutoNightSensitivity(),
    ),
    GoRoute(
      path: '/quiz/step4',
      builder: (context, state) => const Step4LifestyleThicknessHandling(),
    ),
    GoRoute(
      path: '/quiz/step5',
      builder: (context, state) => const Step5ComfortBudgetNotes(),
    ),
    GoRoute(
      path: '/quiz/result',
      builder: (context, state) => const RecommendationScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: Colors.red,
          ),
          SizedBox(height: 16.r),
          Text(
            'Page not found',
            style: TextStyle(
              fontSize: 18.r,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.r),
          Text(
            'The page you\'re looking for doesn\'t exist.',
            style: TextStyle(
              fontSize: 14.r,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24.r),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
