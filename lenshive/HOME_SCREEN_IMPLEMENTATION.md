# Home Screen Implementation Documentation

## Overview
This document describes the implementation of the LensHive home screen with skeleton loading, reusable widgets, and Riverpod state management.

## Files Created

### 1. Models
- **`lib/models/product_model.dart`**
  - Product model representing eyewear products
  - Includes: id, name, price, currency, imageUrl, category, brand, description, availability, stock, colors, sizes
  - Methods: `fromJson()`, `toJson()`, `copyWith()`, `formattedPrice` getter

### 2. Providers
- **`lib/providers/home_provider.dart`**
  - `HomeState`: Holds products, filtered products, loading state, selected category, search query
  - `HomeNotifier`: Manages home screen state with methods:
    - `loadProducts()`: Fetches products (currently using mock data)
    - `changeCategory()`: Filters products by category
    - `updateSearchQuery()`: Filters products by search text
    - `refreshProducts()`: Refreshes product list
  - Convenience providers:
    - `homeProvider`: Main state notifier provider
    - `productsProvider`: Filtered products list
    - `homeLoadingProvider`: Loading state
    - `selectedCategoryProvider`: Current category
    - `cartItemCountProvider`: Cart item count (mock)

### 3. Reusable Widgets

#### `lib/widgets/custom_search_bar.dart`
- Search bar with image upload capability
- Features:
  - Search icon
  - Camera icon for image-based search (AI feature)
  - Customizable hint text
  - onTap, onCameraPressed callbacks
  - TextEditingController support

#### `lib/widgets/category_tabs.dart`
- Horizontal category tabs (Men, Women, Kids)
- Features:
  - Active/inactive states with different styling
  - Customizable categories list
  - onCategoryChanged callback
  - Blue theme for selected, grey for unselected

#### `lib/widgets/product_card.dart`
- Product display card
- Features:
  - Product image with loading/error handling
  - "Try On" button overlay (AR feature)
  - Product name and formatted price
  - onTap and onTryOn callbacks
  - Responsive design with rounded corners

#### `lib/widgets/skeleton_loaders.dart`
- Skeleton loading components using shimmer effect
- Components:
  - `SkeletonShimmer`: Base shimmer wrapper
  - `SkeletonBox`: Basic rectangular placeholder
  - `SkeletonProductCard`: Product card skeleton
  - `SkeletonProductGrid`: Grid of skeleton cards
  - `SkeletonSearchBar`: Search bar skeleton
  - `SkeletonCategoryTabs`: Category tabs skeleton

#### `lib/widgets/bottom_nav_bar.dart`
- Custom bottom navigation bar
- Features:
  - 5 navigation items: Home, Customize, My Order, Bookings, Account
  - Active/inactive states with icons and colors
  - Smooth transitions
  - currentIndex and onTap parameters

### 4. Screens
- **`lib/screens/home_screen.dart`**
  - Main home screen implementation
  - Components:
    - Custom app bar with logo and cart icon (with badge)
    - Search bar with camera icon
    - Category tabs (Men/Women/Kids)
    - "Recommended for you" section
    - Product grid (2 columns)
    - Bottom navigation bar
    - Pull-to-refresh functionality
    - Skeleton loading states
    - Empty state handling

## UI Features Matching Design

### Header
✅ LensHive logo with gradient icon
✅ Shopping cart with notification badge

### Search
✅ Search bar with "Search frames, brands or upload an image" placeholder
✅ Camera icon for image upload (AI-based search - UC_03)

### Categories
✅ Men, Women, Kids tabs with active state (blue background)

### Products
✅ Grid layout (2 columns)
✅ Product images
✅ "Try On" button on each product (AR feature - UC_04)
✅ Product name and price
✅ PKR currency format with proper number formatting

### Bottom Navigation
✅ Home (active by default)
✅ Customize (UC_08 - Custom frame design)
✅ My Order (UC_06, UC_13 - Orders & Cart)
✅ Bookings (UC_07 - Home service)
✅ Account (UC_01, UC_02 - Registration & Login)

## State Management

### Using Riverpod
- `ConsumerStatefulWidget` for home screen
- `ref.watch()` to listen to state changes
- `ref.read()` to access notifier methods
- Automatic UI updates when state changes

### Loading States
- Initial load: Shows skeleton loaders
- Category change: Instant filter (no loading)
- Pull to refresh: Reloads products
- Empty state: Shows "No products found" message

## Dependencies Added

```yaml
shimmer: ^3.0.0  # For skeleton loading animation
```

## Mock Data
Currently using mock product data in `home_provider.dart`:
- 6 Men's products
- 4 Women's products
- 2 Kids' products

**To integrate with backend:**
Replace `_getMockProducts()` method in `HomeNotifier` with actual API calls using `ApiService`.

## Responsive Design
All widgets use `flutter_screenutil` for responsive sizing:
- `.w` for width
- `.h` for height
- `.sp` for font size
- `.r` for border radius

Base design size: 375x812 (iPhone 13 Pro)

## Color Scheme
- Primary Blue: `#0A83BC`
- Accent Pink: `#EC4899`
- Background: White
- Text: Grey shades
- Active states: Primary blue
- Inactive states: Grey

## Next Steps
1. Integrate with backend API for real product data
2. Implement navigation to product detail screen
3. Implement AR try-on functionality
4. Implement AI-based image search
5. Create remaining screens (Customize, My Order, Bookings, Account)
6. Add cart functionality
7. Implement product detail screen
8. Add filtering and sorting options

## Usage Example

```dart
// Navigate to home screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const HomeScreen(),
  ),
);
```

## Testing
To test the home screen:
1. Run `flutter pub get` to install dependencies
2. Update splash screen or main navigation to show `HomeScreen`
3. The screen will show skeleton loaders for 2 seconds (simulated API delay)
4. Products will appear in a grid
5. Try switching categories (Men/Women/Kids)
6. Pull down to refresh

## Accessibility
- Semantic labels on interactive elements
- Proper contrast ratios
- Touch target sizes meet accessibility guidelines (48x48 dp minimum)

## Performance
- Lazy loading with GridView builder
- Image caching with network images
- Efficient state management with Riverpod
- Skeleton loaders for perceived performance

