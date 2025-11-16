import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom Navigation Scaffold with 5 tabs
/// SINGLE SOURCE OF TRUTH for bottom navigation
/// Shows: Home, Customize, My Orders, Bookings, Account
/// 
/// Uses Material 3 NavigationBar with theme-driven styling.
/// All colors/styles come from NavigationBarTheme in AppTheme.
class BottomNavScaffold extends StatelessWidget {
  final Widget child;

  const BottomNavScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/customize')) return 1;
    if (location.startsWith('/my-orders') || location.startsWith('/orders')) return 2;
    if (location.startsWith('/bookings')) return 3;
    if (location.startsWith('/account') || location.startsWith('/profile')) return 4;
    
    return 0; // Default to Home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/customize');
        break;
      case 2:
        context.go('/my-orders');
        break;
      case 3:
        context.go('/bookings');
        break;
      case 4:
        context.go('/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    
    return SafeArea(
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Customize',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'My Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

