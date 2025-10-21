import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

/// Profile Screen
/// Professional profile screen with user info, theme switching, and logout
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Profile Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32.r, horizontal: 24.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0A83BC),
                      Color(0xFF4A90E2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Center(
                          child: Text(
                            user?.fullName != null && user!.fullName.isNotEmpty
                                ? user.fullName.substring(0, 1).toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 40.r,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0A83BC),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.r),

                    // User Name
                    Text(
                      user?.fullName ?? 'User',
                      style: TextStyle(
                        fontSize: 24.r,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 8.r),

                    // User Email
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14.r,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.r),

              // Settings Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Column(
                  children: [
                    // Account Settings Section
                    _buildSectionTitle('Account Settings', isDarkMode),
                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Navigate to edit profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Profile - Coming Soon')),
                        );
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Navigate to change password
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change Password - Coming Soon')),
                        );
                      },
                    ),

                    SizedBox(height: 24.r),

                    // App Settings Section
                    _buildSectionTitle('App Settings', isDarkMode),
                    SizedBox(height: 12.r),

                    // Dark Mode Toggle
                    _buildThemeToggleCard(
                      isDarkMode: isDarkMode,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'Manage your notifications',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Navigate to notifications settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifications - Coming Soon')),
                        );
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Navigate to language settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language Settings - Coming Soon')),
                        );
                      },
                    ),

                    SizedBox(height: 24.r),

                    // Support Section
                    _buildSectionTitle('Support', isDarkMode),
                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help with the app',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Navigate to help
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Help & Support - Coming Soon')),
                        );
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and information',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        // Show about dialog
                        _showAboutDialog(context, isDarkMode);
                      },
                    ),

                    SizedBox(height: 32.r),

                    // Logout Button
                    _buildLogoutButton(context, ref, isDarkMode),

                    SizedBox(height: 32.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      
    );
  }

  /// Section Title Widget
  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 8.r),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  /// Setting Card Widget
  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: const Color(0xFF0A83BC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0A83BC),
                size: 24.r,
              ),
            ),

            SizedBox(width: 16.r),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.r,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.r,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: isDarkMode ? Colors.white.withOpacity(0.4) : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  /// Theme Toggle Card Widget
  Widget _buildThemeToggleCard({
    required bool isDarkMode,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: const Color(0xFF0A83BC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: const Color(0xFF0A83BC),
              size: 24.r,
            ),
          ),

          SizedBox(width: 16.r),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 15.r,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.grey[900],
                  ),
                ),
                SizedBox(height: 4.r),
                Text(
                  isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
                  style: TextStyle(
                    fontSize: 13.r,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Toggle Switch
          Switch(
            value: isDarkMode,
            onChanged: onChanged,
            activeColor: const Color(0xFF0A83BC),
          ),
        ],
      ),
    );
  }

  /// Logout Button Widget
  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 56.r,
      child: ElevatedButton(
        onPressed: () async {
          // Show confirmation dialog
          final confirmed = await _showLogoutConfirmation(context, isDarkMode);
          
          if (confirmed == true) {
            // Logout
            await ref.read(authProvider.notifier).logout();
            
            // Navigate to login screen
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 20.r,
            ),
            SizedBox(width: 12.r),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Logout Confirmation Dialog
  Future<bool?> _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Show About Dialog
  void _showAboutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Column(
          children: [
            Image.asset(
              'assets/images/lenshive_logo.png',
              width: 60.r,
              height: 60.r,
            ),
            SizedBox(height: 16.r),
            Text(
              'LensHive',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.grey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                fontSize: 14.r,
              ),
            ),
            SizedBox(height: 12.r),
            Text(
              'Your premium eyewear shopping destination',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.grey[700],
                fontSize: 13.r,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

