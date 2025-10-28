import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';

/// Registration Screen Widget with Riverpod State Management
/// This screen allows new users to create an account
/// Features: Full name, Email, Password input with validation
class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text editing controllers for input fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle registration button press
  /// Uses Riverpod auth provider to register user
  Future<void> _handleRegister() async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      // Get auth notifier from Riverpod
      final authNotifier = ref.read(authProvider.notifier);

      // Call register method
      final success = await authNotifier.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Get user from state
        final user = ref.read(currentUserProvider);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${user?.fullName ?? "User"}! Account created successfully.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to home screen
        context.go('/home');
      } else {
        // Get error message from state
        final errorMessage = ref.read(authErrorProvider);
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Validate full name
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  /// Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth loading state
    final isLoading = ref.watch(authLoadingProvider);
    
    // Get theme colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.r),
            child: Column(
              children: [
                // Top spacing
                
 SizedBox(height: 60.r),

                // LensHive Logo
                Image.asset(
                  'assets/images/lenshive_logo.png',
                  width: 135.r,
                  height: 90.r,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),

                

                // LensHive Text
                Text(
                  'LensHive',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : primaryColor,
                    fontSize: 23.r,
                  ),
                ),

                SizedBox(height: 70.r),

                // Card Container with Form
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.r),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name Input Field
                        TextFormField(
                          controller: _fullNameController,
                          keyboardType: TextInputType.name,
                          validator: _validateFullName,
                          style: TextStyle(
                            color: textColor
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: textColor.withOpacity(0.6),
                              size: 20.r,
                            ),
                            hintText: 'Full Name',
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 14.r,
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                             focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                width: 0.8,
                                color: primaryColor
                              )
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.r),

                        // Email Input Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          style: TextStyle(
                            color: textColor
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: textColor.withOpacity(0.6),
                              size: 20.r,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 14.r,
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            
                             focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                width: 0.8,
                                color: primaryColor
                              )
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.r),

                        // Password Input Field with visibility toggle
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: _validatePassword,
                          style: TextStyle(
                            color: textColor
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: textColor.withOpacity(0.6),
                              size: 20.r,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: textColor.withOpacity(0.6),
                                size: 20.r,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 14.r,
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                width: 0.8,
                                color: primaryColor
                              )
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.r),

                        // Confirm Password Input Field with visibility toggle
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          validator: _validateConfirmPassword,
                          style: TextStyle(
                            color: textColor
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: textColor.withOpacity(0.6),
                              size: 20.r,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: textColor.withOpacity(0.6),
                                size: 20.r,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 14.r,
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                             focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                width: 0.8,
                                color: primaryColor
                              )
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.r),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.r,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16.r,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 20.r),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14.r,
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate back to login screen
                                context.go('/login');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 14.r,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.r),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

