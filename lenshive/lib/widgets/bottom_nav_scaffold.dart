import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design/tokens.dart';

/// Bottom Navigation Scaffold with 5 tabs
/// SINGLE SOURCE OF TRUTH for bottom navigation
/// Shows: Home, Customize, My Orders, Bookings, Account
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
    
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: DesignTokens.spaceSm,
            bottom: DesignTokens.spaceXs,
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => _onItemTapped(context, index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: DesignTokens.primary,
            unselectedItemColor: DesignTokens.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tune_outlined),
                activeIcon: Icon(Icons.tune),
                label: 'Customize',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'My Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_outlined),
                activeIcon: Icon(Icons.event),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

