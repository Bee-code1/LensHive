import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../providers/home_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_tabs.dart';
import '../widgets/enhanced_product_card.dart';
import '../widgets/skeleton_loaders.dart';
import '../constants/app_colors.dart';
import '../features/home_service/ui/nav_helpers.dart';

/// Home Screen - Main screen with product catalog
/// Note: Navigation is handled by BottomNavScaffold, this screen only displays content
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final cartItemCount = ref.watch(cartItemCountProvider);
    
    return _buildHomeContent(homeState, homeNotifier, cartItemCount);
  }

  Widget _buildHomeContent(HomeState homeState, HomeNotifier homeNotifier, int cartItemCount) {
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
                      width: 50.r,
                      height: 60.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8.r),
                    Text(
                      'LensHive',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        fontSize: 17.r,
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
                          key: const Key('appbar_cart_button'),
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Theme.of(context).iconTheme.color,
                            size: 26.r,
                          ),
                          onPressed: () {
                            context.push('/cart');
                          },
                        ),
                        if (cartItemCount > 0)
                          Positioned(
                            key: const Key('appbar_cart_badge'),
                            right: 6.r,
                            top: 6.r,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.r,
                                vertical: 2.r,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 1.r,
                                ),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 18.r,
                                minHeight: 18.r,
                              ),
                              child: Center(
                                child: Text(
                                  cartItemCount > 99 ? '99+' : '$cartItemCount',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
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

              // Quiz Banner - Find Your Perfect Lens
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.push('/quiz/step1'),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.primaryDarkMode
                                  : AppColors.primary,
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.primaryDarkMode.withOpacity(0.8)
                                  : AppColors.primaryLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(18.r),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.quiz_rounded,
                                  color: AppColors.white,
                                  size: 28.r,
                                ),
                              ),
                              SizedBox(width: 16.r),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Find Your Perfect Lens',
                                      style: TextStyle(
                                        fontSize: 17.r,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.r),
                                    Text(
                                      '3 quick questions • Personalized results',
                                      style: TextStyle(
                                        fontSize: 13.r,
                                        color: AppColors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.white,
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Home Service CTA Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => goToNewHomeService(context),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.cardDark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.home_repair_service_outlined,
                                color: AppColors.primary,
                                size: 28.r,
                              ),
                            ),
                            SizedBox(width: 16.r),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Book Home Service',
                                    style: TextStyle(
                                      fontSize: 17.r,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  SizedBox(height: 4.r),
                                  Text(
                                    'Eye tests, fittings & repairs at your doorstep',
                                    style: TextStyle(
                                      fontSize: 13.r,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white.withOpacity(0.7)
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.5)
                                  : AppColors.textSecondaryLight,
                              size: 18.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.r),

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
                              mainAxisExtent: 280.r,  // Reduced height for more compact cards
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product =
                                    homeState.filteredProducts[index];
                                return EnhancedProductCard(
                                  product: product,
                                  onTap: () {
                                    // Navigate to product detail screen
                                    context.push(
                                      '/product/${product.id}',
                                      extra: product,
                                    );
                                  },
                                  onTryOn: () {
                                    // Navigate to AR try-on screen
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('AR Try-On feature coming soon!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  onAddToCart: () {
                                    // Add to cart action
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} added to cart'),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Theme.of(context).colorScheme.secondary,
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
