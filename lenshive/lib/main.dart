import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wrap the app with ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode from provider
    final themeMode = ref.watch(themeProvider);

    // Initialize ScreenUtil for responsive design
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 Pro size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'LensHive',
          debugShowCheckedModeBanner: false,
      
          // Light theme configuration using AppTheme
          theme: AppTheme.lightTheme,
      
<<<<<<< HEAD
          // Dark theme configuration - Professional & Elegant
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF64B5F6), // Lighter blue for better contrast
              secondary: const Color(0xFF81D4FA), // Light blue accent
              surface: const Color(0xFF202124), // Dark background
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white.withOpacity(0.87),
              error: const Color(0xFFEF5350),
              tertiary: const Color(0xFF80DEEA), // Accent color for highlights
            ),
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            cardColor: const Color(0xFF202124),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xFF121212),
            ),
          ),
=======
          // Dark theme configuration using AppTheme
          darkTheme: AppTheme.darkTheme,
>>>>>>> 6c7878c48db6bd00a3c26ebf8397671bf2e9ec8d
      
          // Use theme mode from provider
          themeMode: themeMode,
      
          // Start with splash screen
          home: const SplashScreen()
        );
      },
    );
  }
}
