import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

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
    print('🟡 HomeNotifier constructor called');
    // Load products when initialized
    // Use unawaited to avoid blocking, but errors will be caught in loadProducts
    loadProducts().catchError((error) {
      print('🔴 Error in loadProducts (from constructor): $error');
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    });
  }

  /// Load products from API
  Future<void> loadProducts() async {
    print('🟢 loadProducts() called');
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print('🟢 About to call ApiService.getProducts()');
      // Fetch products from API
      final products = await ApiService.getProducts();
      print('🟢 ApiService.getProducts() completed successfully');
      
      // Debug: Print products count
      print('API returned ${products.length} products');

      // Filter products based on selected category and availability
      // Only show available products
      final availableProducts = products.where((p) => p.isAvailable).toList();
      
      // Debug: Print available products count
      print('Available products: ${availableProducts.length}');

      // Filter products based on selected category
      final filtered = _filterProducts(
        availableProducts,
        state.selectedCategory,
        state.searchQuery,
      );
      
      // Debug: Print filtered products count
      print('Filtered products for category "${state.selectedCategory}": ${filtered.length}');

      state = state.copyWith(
        products: availableProducts,
        filteredProducts: filtered,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      // Debug: Print error
      print('Error loading products: $e');
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

    // Filter by category - only if category is not null/empty
    if (category.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.category != null &&
              product.category!.toLowerCase() == category.toLowerCase())
          .toList();
    }

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
}

/// Home Provider
/// Provides access to HomeNotifier and HomeState
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  print('🟡 homeProvider creating HomeNotifier');
  final notifier = HomeNotifier();
  print('🟡 homeProvider HomeNotifier created');
  return notifier;
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

