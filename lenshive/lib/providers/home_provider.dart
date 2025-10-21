import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

/// Home State
/// Holds the current state of the home screen
class HomeState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;
  final String searchQuery;

  HomeState({
    this.products = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = 'Men',
    this.searchQuery = '',
  });

  HomeState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return HomeState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Home Notifier
/// Manages home screen state and provides methods for product operations
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    // Load products when initialized
    loadProducts();
  }

  /// Load products from API (simulated for now)
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock product data - Replace with actual API call
      final products = _getMockProducts();

      // Filter products based on selected category
      final filtered = _filterProducts(
        products,
        state.selectedCategory,
        state.searchQuery,
      );

      state = state.copyWith(
        products: products,
        filteredProducts: filtered,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Change selected category
  void changeCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Apply filters to products
  void _applyFilters() {
    final filtered = _filterProducts(
      state.products,
      state.selectedCategory,
      state.searchQuery,
    );
    state = state.copyWith(filteredProducts: filtered);
  }

  /// Filter products by category and search query
  List<Product> _filterProducts(
    List<Product> products,
    String category,
    String query,
  ) {
    var filtered = products;

    // Filter by category
    filtered = filtered
        .where((product) =>
            product.category?.toLowerCase() == category.toLowerCase())
        .toList();

    // Filter by search query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.brand?.toLowerCase().contains(query.toLowerCase()) ==
                  true)
          .toList();
    }

    return filtered;
  }

  /// Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  /// Mock product data - Replace with actual API call
  List<Product> _getMockProducts() {
    return [
      // Men's products
      Product(
        id: '1',
        name: 'Stylish Eyewear',
        price: 12500,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
        category: 'Men',
        brand: 'Ray-Ban',
        description: 'Classic stylish eyewear for men',
        isAvailable: true,
        stock: 10,
        rating: 4.8,
        reviewCount: 1300,
        isBestseller: false,
        isNew: false,
      ),
      Product(
        id: '2',
        name: 'Modern Frames',
        price: 9999,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=400',
        category: 'Men',
        brand: 'Oakley',
        description: 'Modern frames for everyday use',
        isAvailable: true,
        stock: 15,
        rating: 4.5,
        reviewCount: 890,
        isBestseller: false,
        isNew: false,
      ),
      Product(
        id: '3',
        name: 'Classic Aviators',
        price: 14999,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
        category: 'Men',
        brand: 'Ray-Ban',
        description: 'Timeless aviator sunglasses',
        isAvailable: true,
        stock: 8,
        rating: 4.8,
        reviewCount: 1300,
        isBestseller: true,
        isNew: false,
      ),
      Product(
        id: '4',
        name: 'Retro Round Fra...',
        price: 18500,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=400',
        category: 'Men',
        brand: 'Oakley',
        description: 'Retro round frame glasses',
        isAvailable: true,
        stock: 12,
        rating: 4.7,
        reviewCount: 980,
        isBestseller: false,
        isNew: false,
      ),
      Product(
        id: '5',
        name: 'Sporty Wraparound',
        price: 22000,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1577803645773-f96470509666?w=400',
        category: 'Men',
        brand: 'Persol',
        description: 'Perfect for outdoor activities',
        isAvailable: true,
        stock: 20,
        rating: 4.9,
        reviewCount: 2300,
        isBestseller: false,
        isNew: true,
      ),
      Product(
        id: '6',
        name: 'Elegant Cat-Eye',
        price: 35000,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=400',
        category: 'Men',
        brand: 'Gucci',
        description: 'Elegant and sophisticated',
        isAvailable: true,
        stock: 25,
        rating: 4.6,
        reviewCount: 940,
        isBestseller: false,
        isNew: false,
      ),

      // Women's products
      Product(
        id: '7',
        name: 'Elegant Cat Eye',
        price: 35000,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=400',
        category: 'Women',
        brand: 'Gucci',
        description: 'Elegant cat eye frames',
        isAvailable: true,
        stock: 10,
        rating: 4.6,
        reviewCount: 940,
        isBestseller: false,
        isNew: false,
      ),
      Product(
        id: '8',
        name: 'Oversized Glamour',
        price: 28000,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
        category: 'Women',
        brand: 'Chanel',
        description: 'Glamorous oversized sunglasses',
        isAvailable: true,
        stock: 8,
        rating: 4.7,
        reviewCount: 1150,
        isBestseller: true,
        isNew: false,
      ),
      Product(
        id: '9',
        name: 'Butterfly Frames',
        price: 24500,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=400',
        category: 'Women',
        brand: 'Prada',
        description: 'Stylish butterfly frames',
        isAvailable: true,
        stock: 12,
        rating: 4.5,
        reviewCount: 876,
        isBestseller: false,
        isNew: false,
      ),
      Product(
        id: '10',
        name: 'Rose Gold Collection',
        price: 32000,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
        category: 'Women',
        brand: 'Dior',
        description: 'Rose gold metallic frames',
        isAvailable: true,
        stock: 6,
        rating: 4.8,
        reviewCount: 1420,
        isBestseller: true,
        isNew: false,
      ),

      // Kids' products
      Product(
        id: '11',
        name: 'Colorful Kids Frame',
        price: 8500,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1577803645773-f96470509666?w=400',
        category: 'Kids',
        brand: 'KidVision',
        description: 'Fun and colorful frames for kids',
        isAvailable: true,
        stock: 30,
        rating: 4.7,
        reviewCount: 456,
        isBestseller: false,
        isNew: true,
      ),
      Product(
        id: '12',
        name: 'Flexible Sports Kids',
        price: 9500,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=400',
        category: 'Kids',
        brand: 'SafeVision',
        description: 'Durable and flexible for active kids',
        isAvailable: true,
        stock: 25,
        rating: 4.9,
        reviewCount: 678,
        isBestseller: true,
        isNew: false,
      ),
    ];
  }
}

/// Home Provider
/// Provides access to HomeNotifier and HomeState
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

/// Convenience providers for specific home state properties

/// Provider for products list
final productsProvider = Provider<List<Product>>((ref) {
  return ref.watch(homeProvider).filteredProducts;
});

/// Provider for loading state
final homeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(homeProvider).isLoading;
});

/// Provider for selected category
final selectedCategoryProvider = Provider<String>((ref) {
  return ref.watch(homeProvider).selectedCategory;
});

/// Provider for cart item count (mock for now)
final cartItemCountProvider = Provider<int>((ref) {
  // This will be replaced with actual cart state
  return 2;
});

