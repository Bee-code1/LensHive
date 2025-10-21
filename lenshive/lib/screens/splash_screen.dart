import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/splash_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

/// Splash screen with responsive design and floating icons
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for floating icons
  late AnimationController _floatController;
  late Animation<double> _iconsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload image with proper caching as soon as context is available
    precacheImage(
      const AssetImage('assets/images/lenshive_logo.png'),
      context,
      size: Size(300.r, 200.r), // Pre-cache at higher resolution
    );
  }

  void _setupAnimations() {
    // Float animation controller for floating icons
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Icons fade-in animation
    _iconsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  /// Get background color based on theme brightness
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get text color based on theme brightness
  Color _getTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1F2937);
  }

  /// Get accent color for fallback icon
  Color _getAccentColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Get icon color based on theme brightness
  Color _getIconColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? Colors.white.withOpacity(0.15)
        : Colors.black.withOpacity(0.15);
  }

  /// Build a floating icon with animation
  Widget _buildFloatingIcon({
    required IconData icon,
    double? left,
    double? right,
    required double top,
    required double delay,
    required BuildContext context,
  }) {
    return Positioned(
      left: left?.r,
      right: right?.r,
      top: top.r,
      child: FadeTransition(
        opacity: _iconsFadeAnimation,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final offsetValue =
                math.sin((_floatController.value * 2 * math.pi) + delay);
            return Transform.translate(
              offset: Offset(0, offsetValue * 15.r),
              child: child,
            );
          },
          child: Icon(
            icon,
            size: 32.r,
            color: _getIconColor(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch authentication state
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // Listen to splash state changes
    ref.listen<SplashState>(splashProvider, (previous, next) {
      if (next == SplashState.completed) {
        // Navigate based on authentication status
        if (isAuthenticated) {
          // User is logged in, go to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          // User is not logged in, go to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      }
    });

    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final accentColor = _getAccentColor(context);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            // Floating shopping icons
            _buildFloatingIcon(
              icon: Icons.shopping_bag_outlined,
              left: 30,
              top: 100,
              delay: 0,
              context: context,
            ),
            _buildFloatingIcon(
              icon: Icons.auto_awesome,
              right: 30,
              top: 120,
              delay: math.pi / 2,
              context: context,
            ),
            _buildFloatingIcon(
              icon: Icons.bolt_outlined,
              left: 40,
              top: 1.sh - 200.r,
              delay: math.pi,
              context: context,
            ),
            _buildFloatingIcon(
              icon: Icons.inventory_2_outlined,
              right: 30,
              top: 1.sh - 180.r,
              delay: math.pi * 1.5,
              context: context,
            ),

            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo - static, responsive size with high quality rendering
                    Image.asset(
                      'assets/images/lenshive_logo.png',
                      width: 150.r,
                      height: 100.r,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true, // Prevents flickering during loading
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if logo is not found
                        return Container(
                          width: 120.r,
                          height: 120.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 60.r,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),

                    

                    // App name - static, responsive text
                    Text(
                      'LensHive',
                      style: TextStyle(
                        fontSize: 32.r,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
