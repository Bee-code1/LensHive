# Bottom Navigation Fix - File Changes Diff

## Summary of Changes

**Total Files Modified**: 4  
**Files Deleted**: 0 (1 marked for future cleanup)  
**New Files**: 0  

---

## 1. `lib/widgets/bottom_nav_scaffold.dart`

### Changes Made
✅ Updated tab labels: LensMatch → Bookings, Profile → Account  
✅ Updated tab icons: auto_awesome → event  
✅ Updated route mapping for tabs 4 & 5  
✅ Added route detection for /bookings and /account  

### Diff
```diff
/// Bottom Navigation Scaffold with 5 tabs
-/// Shows: Home, Customize, My Orders, LensMatch, Profile
+/// SINGLE SOURCE OF TRUTH for bottom navigation
+/// Shows: Home, Customize, My Orders, Bookings, Account

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/customize')) return 1;
-   if (location.startsWith('/my-orders')) return 2;
+   if (location.startsWith('/my-orders') || location.startsWith('/orders')) return 2;
-   if (location.startsWith('/lens-match')) return 3;
+   if (location.startsWith('/bookings')) return 3;
-   if (location.startsWith('/profile')) return 4;
+   if (location.startsWith('/account') || location.startsWith('/profile')) return 4;
    
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
-       context.go('/lens-match');
+       context.go('/bookings');
        break;
      case 4:
-       context.go('/profile');
+       context.go('/account');
        break;
    }
  }

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
-     icon: Icon(Icons.receipt_long_outlined),
+     icon: Icon(Icons.shopping_bag_outlined),
-     activeIcon: Icon(Icons.receipt_long),
+     activeIcon: Icon(Icons.shopping_bag),
      label: 'My Orders',
    ),
    BottomNavigationBarItem(
-     icon: Icon(Icons.auto_awesome_outlined),
+     icon: Icon(Icons.event_outlined),
-     activeIcon: Icon(Icons.auto_awesome),
+     activeIcon: Icon(Icons.event),
-     label: 'LensMatch',
+     label: 'Bookings',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
-     label: 'Profile',
+     label: 'Account',
    ),
  ],
```

---

## 2. `lib/screens/home_screen.dart`

### Changes Made
❌ Removed duplicate navigation logic  
❌ Removed CustomBottomNavBar usage  
❌ Removed Scaffold wrapper with bottomNavigationBar  
❌ Removed state management for tab index  
✅ Simplified to content-only screen  
✅ Added documentation comment  

### Diff
```diff
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:go_router/go_router.dart';
  import '../providers/home_provider.dart';
  import '../widgets/custom_search_bar.dart';
  import '../widgets/category_tabs.dart';
  import '../widgets/enhanced_product_card.dart';
  import '../widgets/skeleton_loaders.dart';
- import '../widgets/bottom_nav_bar.dart';
  import '../constants/app_colors.dart';
- import 'profile_screen.dart';

  /// Home Screen - Main screen with product catalog
+ /// Note: Navigation is handled by BottomNavScaffold, this screen only displays content
  class HomeScreen extends ConsumerStatefulWidget {
    const HomeScreen({super.key});

    @override
    ConsumerState<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends ConsumerState<HomeScreen> {
-   int _currentNavIndex = 0;
-
    @override
    void initState() {
      super.initState();
      print('🟡 HomeScreen initState() called');
      // Ensure products are loaded when screen initializes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('🟡 HomeScreen postFrameCallback - calling loadProducts');
        ref.read(homeProvider.notifier).loadProducts();
      });
    }

    @override
    Widget build(BuildContext context) {
      print('🟡 HomeScreen build() called');
      final homeState = ref.watch(homeProvider);
      print('🟡 HomeScreen - homeState.isLoading: ${homeState.isLoading}');
      print('🟡 HomeScreen - homeState.filteredProducts.length: ${homeState.filteredProducts.length}');
      print('🟡 HomeScreen - homeState.errorMessage: ${homeState.errorMessage}');
      final homeNotifier = ref.read(homeProvider.notifier);
      final cartItemCount = ref.watch(cartItemCountProvider);
      
-     // Function to get the current screen based on index
-     Widget getScreen(int index) {
-       switch (index) {
-         case 0:
-           return _buildHomeScreen(homeState, homeNotifier, cartItemCount);
-         case 1:
-           return Center(child: Text('Customize Screen (Coming Soon)'));
-         case 2:
-           return Center(child: Text('My Orders Screen (Coming Soon)'));
-         case 3:
-           return Center(child: Text('Bookings Screen (Coming Soon)'));
-         case 4:
-           return const ProfileScreen();
-         default:
-           return _buildHomeScreen(homeState, homeNotifier, cartItemCount);
-       }
-     }
-     
-     return Scaffold(
-       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
-       body: getScreen(_currentNavIndex),
-       bottomNavigationBar: CustomBottomNavBar(
-         currentIndex: _currentNavIndex,
-         onTap: (index) {
-           setState(() {
-             _currentNavIndex = index;
-           });
-         },
-       ),
-     );
+     return _buildHomeContent(homeState, homeNotifier, cartItemCount);
    }

-   Widget _buildHomeScreen(HomeState homeState, HomeNotifier homeNotifier, int cartItemCount) {
+   Widget _buildHomeContent(HomeState homeState, HomeNotifier homeNotifier, int cartItemCount) {
      return SafeArea(
        child: RefreshIndicator(
          onRefresh: () => homeNotifier.refreshProducts(),
          child: CustomScrollView(
            // ... rest of content unchanged
```

---

## 3. `lib/config/router_config.dart`

### Changes Made
❌ Removed /lens-match route  
✅ Added /bookings route (using LensMatchScreen temporarily)  
✅ Added /account route (primary)  
✅ Kept /profile route (backward compatibility)  

### Diff
```diff
        // My Orders tab
        GoRoute(
          path: '/my-orders',
          name: 'my_orders',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const MyOrdersScreen(),
          ),
        ),
        
-       // LensMatch tab
+       // Bookings tab (Home Service Bookings)
        GoRoute(
-         path: '/lens-match',
+         path: '/bookings',
-         name: 'lens_match',
+         name: 'bookings',
          pageBuilder: (context, state) => NoTransitionPage(
-           child: const LensMatchScreen(),
+           child: const LensMatchScreen(), // TODO: Replace with BookingsScreen
          ),
        ),
        
-       // Profile tab
+       // Account tab (formerly Profile)
        GoRoute(
+         path: '/account',
+         name: 'account',
+         pageBuilder: (context, state) => NoTransitionPage(
+           child: const ProfileScreen(),
+         ),
+       ),
+       
+       // Profile alias (backward compatibility)
+       GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const ProfileScreen(),
          ),
        ),
```

---

## 4. `lib/screens/lens_match_screen.dart`

### Changes Made
✅ Updated for Bookings tab usage  
✅ Changed title: "LensMatch" → "Bookings"  
✅ Changed icon: auto_awesome → event  
✅ Updated text content  
✅ Added TODO note  

### Diff
```diff
  /// LensMatch Screen - Placeholder
+ /// NOTE: Currently used for Bookings tab until proper BookingsScreen is created
  class LensMatchScreen extends StatelessWidget {
    const LensMatchScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
-         title: const Text('LensMatch'),
+         title: const Text('Bookings'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(DesignTokens.spaceLg),
                  decoration: BoxDecoration(
-                   gradient: DesignTokens.premiumGradient,
+                   color: DesignTokens.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
-                 child: const Icon(
+                 child: Icon(
-                   Icons.auto_awesome,
+                   Icons.event,
                    size: 48,
-                   color: Colors.white,
+                   color: DesignTokens.primary,
                  ),
                ),
                SizedBox(height: DesignTokens.spaceLg),
                Text(
-                 'LensMatch AI',
+                 'Bookings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: DesignTokens.spaceSm),
                Text(
-                 'Find your perfect lenses',
+                 'Your home service bookings will appear here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: DesignTokens.textSecondary,
                  ),
+                 textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceXl),
                ElevatedButton(
-                 onPressed: () {},
+                 onPressed: () {
+                   // TODO: Navigate to booking creation
+                 },
-                 child: const Text('Start Quiz'),
+                 child: const Text('Book Home Service'),
                ),
```

---

## 5. Files NOT Changed (Already Correct)

### `lib/screens/customize_screen.dart`
✅ Already has Scaffold with appBar, NO bottomNavigationBar  
✅ No changes needed  

### `lib/screens/my_orders_screen.dart`
✅ Already has Scaffold with appBar, NO bottomNavigationBar  
✅ No changes needed  

### `lib/screens/profile_screen.dart`
✅ Already returns SafeArea with content only, NO Scaffold wrapper  
✅ No changes needed  

---

## 6. Files for Future Cleanup

### `lib/widgets/bottom_nav_bar.dart`
⚠️ **Deprecated** - No longer used  
📝 **Action**: Can be safely deleted  
🔗 **Reason**: Replaced by `bottom_nav_scaffold.dart`  

**Current Usage**: NONE (HomeScreen no longer imports or uses it)

---

## Quick Reference

### Routes Updated
| Old Route | New Route | Status |
|-----------|-----------|--------|
| `/home` | `/home` | ✅ Unchanged |
| `/customize` | `/customize` | ✅ Unchanged |
| `/my-orders` | `/my-orders` | ✅ Unchanged |
| `/lens-match` | `/bookings` | ⚠️ Replaced |
| `/profile` | `/account` | ✅ Renamed (alias kept) |

### Tab Labels Updated
| Old Label | New Label | Icon Change |
|-----------|-----------|-------------|
| Home | Home | ✅ No change |
| Customize | Customize | ✅ No change |
| My Orders | My Orders | ✅ Icon changed (receipt → shopping_bag) |
| LensMatch | Bookings | ✅ Icon changed (auto_awesome → event) |
| Profile | Account | ✅ No icon change |

---

## Testing Commands

```bash
# Analyze modified files
flutter analyze --no-fatal-infos \
  lib/widgets/bottom_nav_scaffold.dart \
  lib/screens/home_screen.dart \
  lib/screens/lens_match_screen.dart \
  lib/config/router_config.dart

# Run the app
flutter run -d chrome --web-port=8080

# Navigate and test
# 1. Open app at /home
# 2. Verify only ONE bottom nav appears
# 3. Tap each tab (Home, Customize, My Orders, Bookings, Account)
# 4. Navigate to /cart and verify bottom nav is hidden
# 5. Navigate back to /home and verify bottom nav reappears
```

---

**Summary**: Fixed duplicate bottom navigation by establishing `bottom_nav_scaffold.dart` as single source of truth, removing navigation logic from `home_screen.dart`, and updating tab configuration to match requirements (LensMatch → Bookings, Profile → Account).

**Result**: ✅ Clean, single bottom navigation | ✅ 0 linter errors | ✅ Ready for testing

