import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/home_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_tabs.dart';
import '../widgets/enhanced_product_card.dart';
import '../widgets/skeleton_loaders.dart';
import '../widgets/bottom_nav_bar.dart';
import 'profile_screen.dart';

/// Home Screen - Main screen with product catalog
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final cartItemCount = ref.watch(cartItemCountProvider);
    
  // (theme check removed — use Theme.of(context) inline where needed)

    // Function to get the current screen based on index
    Widget getScreen(int index) {
      switch (index) {
        case 0:
          return _buildHomeScreen(homeState, homeNotifier, cartItemCount);
        case 1:
          return Center(child: Text('Customize Screen (Coming Soon)'));
        case 2:
          return Center(child: Text('My Orders Screen (Coming Soon)'));
        case 3:
          return Center(child: Text('Bookings Screen (Coming Soon)'));
        case 4:
          return const ProfileScreen();
        default:
          return _buildHomeScreen(homeState, homeNotifier, cartItemCount);
      }
    }
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getScreen(_currentNavIndex),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeScreen(HomeState homeState, HomeNotifier homeNotifier, int cartItemCount) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => homeNotifier.refreshProducts(),
        child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  children: [
                    // LensHive Logo Image
                    Image.asset(
                      'assets/images/lenshive_logo.png',
                      width: 32.r,
                      height: 32.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.r),
                    Text(
                      'LensHive',
                      style: TextStyle(
                        color: const Color(0xFF0A83BC),
                        fontSize: 20.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  // Shopping Cart Icon with Badge
                  Padding(
                    padding: EdgeInsets.only(right: 8.r),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Theme.of(context).iconTheme.color,
                            size: 26.r,
                          ),
                          onPressed: () {
                            // Navigate to cart
                          },
                        ),
                        if (cartItemCount > 0)
                          Positioned(
                            right: 6.r,
                            top: 6.r,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.r,
                                vertical: 2.r,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A90E2),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFFF5F5F5),
                                  width: 2,
                                ),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 20.r,
                                minHeight: 20.r,
                              ),
                              child: Center(
                                child: Text(
                                  cartItemCount > 99 ? '99+' : '$cartItemCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.r,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: homeState.isLoading
                    ? const SkeletonSearchBar()
                    : CustomSearchBar(
                        onTap: () {
                          // Navigate to search screen
                        },
                        onCameraPressed: () {
                          // Handle image upload for AI search
                        },
                      ),
              ),

              // Category Tabs
              SliverToBoxAdapter(
                child: homeState.isLoading
                    ? const SkeletonCategoryTabs()
                    : CategoryTabs(
                        selectedCategory: homeState.selectedCategory,
                        onCategoryChanged: (category) {
                          homeNotifier.changeCategory(category);
                        },
                      ),
              ),

              // Section Title - "Recommended for you"
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 8.r,
                  ),
                  child: Text(
                    'Recommended for you',
                style: TextStyle(
                      fontSize: 16.r,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),

              // Product Grid
              homeState.isLoading
                  ? SliverToBoxAdapter(
                      child: SkeletonProductGrid(itemCount: 6),
                    )
                  : homeState.filteredProducts.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64.r,
                                  color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                                ),
                                SizedBox(height: 16.r),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    fontSize: 16.r,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 12.r,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.r,
                              mainAxisSpacing: 12.r,
                              childAspectRatio: 0.7,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product =
                                    homeState.filteredProducts[index];
                                return EnhancedProductCard(
                                  product: product,
                                  onTap: () {
                                    // Navigate to product detail screen
                                  },
                                  onTryOn: () {
                                    // Navigate to AR try-on screen
                                  },
                                  onAddToCart: () {
                                    // Add to cart action
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} added to cart'),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: homeState.filteredProducts.length,
                            ),
                          ),
                        ),

              // Bottom spacing for navigation bar
              SliverToBoxAdapter(
                child: SizedBox(height: 80.r),
              ),
            ],
          ),
        ),
      
    );
  }
}
