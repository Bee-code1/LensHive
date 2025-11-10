# Routing & Navigation Guide

## Navigation Structure

### 🏠 Bottom Navigation (5 Tabs)
Routes that display the bottom nav bar:
- `/home` - Home tab (existing HomeScreen)
- `/customize` - Customize tab (new placeholder)
- `/my-orders` - My Orders tab (new placeholder)
- `/lens-match` - LensMatch AI tab (new placeholder)
- `/profile` - Profile tab (existing ProfileScreen)
- `/cart` - Cart screen (with bottom nav)

### 📱 Full Screen Routes (No Bottom Nav)
User routes without bottom nav:
- `/` - Splash screen
- `/login` - Login screen
- `/register` - Registration screen
- `/checkout` - Checkout screen
- `/product/:id` - Product detail
- `/quiz/*` - Quiz flow (step1, step2, step3, result)

### 🔧 Admin Routes (No Bottom Nav)
Admin-only routes without bottom nav:
- `/admin/home-service` - Booking list
- `/admin/home-service/:id` - Booking detail

## Route Navigation Examples

### Declarative Navigation
```dart
// Navigate to cart
context.go('/cart');

// Navigate to checkout
context.go('/checkout');

// Navigate to admin booking detail
context.go('/admin/home-service/BK-1001');

// Navigate to tab
context.go('/home');
context.go('/customize');
context.go('/my-orders');
context.go('/lens-match');
context.go('/profile');
```

### Named Routes
```dart
// Using named routes
context.goNamed('cart');
context.goNamed('checkout');
context.goNamed('admin_home_service');
context.goNamed(
  'admin_booking_detail',
  pathParameters: {'id': 'BK-1001'},
);
```

### Push Navigation (Modal/Stack)
```dart
// Push over current page
context.push('/checkout');

// Push named route
context.pushNamed('checkout');
```

## Bottom Nav Implementation

The `BottomNavScaffold` wraps routes with bottom navigation using `ShellRoute`:
- Automatically shows/hides based on route
- Persists state across tab switches
- Uses `NoTransitionPage` for smooth tab switching
- Includes safe area padding
- 12px gap reserved above tab bar for sticky footers

## Screen Features

### ✅ All Screens Include:
- AppBar with consistent styling
- SafeArea for notch/padding handling
- 12px spacing for sticky footer compatibility
- Stitch design tokens (colors, spacing, radii)
- Material 3 theming

### 📋 Placeholder Screens Created:
1. **CartScreen** - Empty cart state with icon
2. **CheckoutStubScreen** - Order summary card with CTA
3. **CustomizeScreen** - Customization placeholder
4. **MyOrdersScreen** - Empty orders state
5. **LensMatchScreen** - AI quiz entry point
6. **BookingListScreen** - Admin service bookings with stats
7. **BookingDetailScreen** - Booking details with actions

## Design Patterns

### Safe Area + Footer Gap
```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        // Content
        Spacer(),
        // Footer button
        ElevatedButton(...),
        SizedBox(height: 12), // Gap for bottom nav
      ],
    ),
  ),
)
```

### Tab Navigation
The bottom nav automatically handles:
- Active/inactive icon states
- Route-based selection
- No transition animations between tabs
- Proper z-index layering

### Admin Routes
Admin routes are separate from the ShellRoute, ensuring:
- No bottom nav interference
- Full screen real estate
- Independent navigation stack
- Easy role-based access control (to be added)

## Route Flow Examples

### User Shopping Flow
```
/home → /product/:id → /cart → /checkout
```

### Admin Service Flow
```
/admin/home-service → /admin/home-service/:id
```

### Tab Switching
```
/home ↔ /customize ↔ /my-orders ↔ /lens-match ↔ /profile
(Bottom nav visible, no page transitions)
```

## Future Enhancements
- [ ] Add cart item count badge
- [ ] Add deep linking support
- [ ] Add route guards for authentication
- [ ] Add role-based access for admin routes
- [ ] Add analytics tracking per route
- [ ] Add pull-to-refresh on list screens
- [ ] Add skeleton loaders for async data

