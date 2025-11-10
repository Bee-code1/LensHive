import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

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
                  gradient: AppColors.primaryGradient,
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
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
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
                      child:                       ClipOval(
                        child: Center(
                          child: Text(
                            user?.fullName != null && user!.fullName.isNotEmpty
                                ? user.fullName.substring(0, 1).toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 40.r,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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
                    _buildSectionTitle(context, 'Account Settings', isDarkMode),
                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      context: context,
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
                      context: context,
                      icon: Icons.home_repair_service_outlined,
                      title: 'My Home Service',
                      subtitle: 'View and manage your bookings',
                      isDarkMode: isDarkMode,
                      onTap: () {
                        context.push('/home-service/my');
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      context: context,
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
                    _buildSectionTitle(context, 'App Settings', isDarkMode),
                    SizedBox(height: 12.r),

                    // Dark Mode Toggle
                    _buildThemeToggleCard(
                      context: context,
                      isDarkMode: isDarkMode,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                    ),

                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      context: context,
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
                      context: context,
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
                    _buildSectionTitle(context, 'Support', isDarkMode),
                    SizedBox(height: 12.r),

                    _buildSettingCard(
                      context: context,
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
                      context: context,
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
  Widget _buildSectionTitle(BuildContext context, String title, bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 8.r),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Setting Card Widget
  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
            // Icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.r,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Theme Toggle Card Widget
  Widget _buildThemeToggleCard({
    required BuildContext context,
    required bool isDarkMode,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.primary,
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15.r,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.r),
                Text(
                  isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.r,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

            // Toggle Switch
            Switch(
              value: isDarkMode,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
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
              context.go('/login');
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
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Logout',
          style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(dialogContext).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
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
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
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
              style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
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
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                fontSize: 14.r,
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.r),
            Text(
              'Your premium eyewear shopping destination',
              textAlign: TextAlign.center,
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                fontSize: 13.r,
                color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

