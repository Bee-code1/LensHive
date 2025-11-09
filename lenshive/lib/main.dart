import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_theme.dart';
import 'providers/theme_provider.dart';
import 'config/router_config.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Debug: Verify console is working
  print('🔴 ==========================================');
  print('🔴 MAIN FUNCTION CALLED - CONSOLE IS WORKING');
  print('🔴 ==========================================');
  
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
        return MaterialApp.router(
          title: 'LensHive',
          debugShowCheckedModeBanner: false,
      
          // Light theme configuration using AppTheme
          theme: AppTheme.lightTheme,
      
          // Dark theme configuration using AppTheme
          darkTheme: AppTheme.darkTheme,
      
          // Use theme mode from provider
          themeMode: themeMode,
      
          // Router configuration
          routerConfig: appRouter,
        );
      },
    );
  }
}