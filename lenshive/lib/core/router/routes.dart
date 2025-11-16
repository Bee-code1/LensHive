/// Route constants for the application
/// Centralized route paths to avoid typos and enable easy refactoring
class Routes {
  Routes._(); // Private constructor to prevent instantiation

  // ==================== Auth Routes ====================
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // ==================== Main Tab Routes (With Bottom Nav) ====================
  static const String home = '/home';
  static const String customize = '/customize';
  static const String myOrders = '/my-orders';
  static const String bookings = '/bookings';
  static const String account = '/account';
  static const String profile = '/profile'; // Alias for account

  // ==================== Home Service Routes (With Bottom Nav) ====================
  static const String homeServiceNew = '/home-service/new';
  static const String homeServiceMy = '/home-service/my';

  // ==================== Other Routes (No Bottom Nav) ====================
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String productDetail = '/product/:id';

  // Quiz Routes
  static const String quiz = '/quiz';
  static const String quizStep1 = '/quiz/step1';
  static const String quizStep2 = '/quiz/step2';
  static const String quizStep3 = '/quiz/step3';
  static const String quizResult = '/quiz/result';

  // Home Service Detail (Full Screen)
  static const String homeServiceDetail = '/home-service/:id';

  // ==================== Admin Routes (No Bottom Nav) ====================
  static const String adminHomeService = '/admin/home-service';
  static const String adminBookingDetail = '/admin/home-service/:id';

  // ==================== Helper Methods ====================

  /// Build product detail route with product ID
  static String productDetailRoute(String productId) => '/product/$productId';

  /// Build home service detail route with booking ID
  static String homeServiceDetailRoute(String bookingId) =>
      '/home-service/$bookingId';

  /// Build admin booking detail route with booking ID
  static String adminBookingDetailRoute(String bookingId) =>
      '/admin/home-service/$bookingId';
}

