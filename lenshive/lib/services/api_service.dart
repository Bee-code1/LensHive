import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/product_model.dart';

/// API Service for Backend Communication
/// Handles all HTTP requests to the LensHive backend API
class ApiService {
  // Base URL for API - Update this with your actual backend URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API endpoints
  static const String loginEndpoint = '/auth/login/';
  static const String registerEndpoint = '/auth/register/';
  static const String productsEndpoint = '/products/';

  /// Login user with email and password
  /// Returns User object if successful, throws exception if failed
  static Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$loginEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extract user data and token from response
        final userData = data['user'] ?? data;
        final token = data['token'] ?? '';
        
        // Create user object with token
        final user = User.fromJson(userData);
        return user.copyWith(token: token);
      } else {
        // Parse error message from response
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server');
    }
  }

  /// Register new user
  /// Returns User object if successful, throws exception if failed
  static Future<User> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$registerEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Extract user data and token from response
        final userData = data['user'] ?? data;
        final token = data['token'] ?? '';
        
        // Create user object with token
        final user = User.fromJson(userData);
        return user.copyWith(token: token);
      } else {
        // Parse error message from response
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server');
    }
  }

  /// Get user profile
  /// Requires authentication token
  static Future<User> getProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'] ?? data;
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server');
    }
  }

  /// Get all products
  /// Returns list of Product objects, throws exception if failed
  static Future<List<Product>> getProducts() async {
    try {
      final url = Uri.parse('$baseUrl$productsEndpoint');
      
      // Debug: Print the URL being called
      print('🔵 Calling Products API: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      // Debug: Print response status
      print('🔵 Products API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        // Debug: Print raw response
        print('API Response: ${data.length} products received');
        
        // Extract base URL for media files (remove /api from baseUrl)
        final mediaBaseUrl = baseUrl.replaceAll('/api', '');
        
        // Convert each product JSON to Product object
        final products = data.map((json) {
          // Convert image URL from relative to absolute if needed
          final productJson = Map<String, dynamic>.from(json);
          
          // Handle primary_image
          if (productJson['primary_image'] != null && 
              productJson['primary_image'].toString().isNotEmpty) {
            final imageUrl = productJson['primary_image'].toString();
            // If it's a relative URL (starts with /), convert to absolute
            if (imageUrl.startsWith('/')) {
              productJson['primary_image'] = '$mediaBaseUrl$imageUrl';
            }
          } else {
            // Set a placeholder image if no image is available
            productJson['primary_image'] = '';
          }
          
          // Handle images array - convert relative URLs to absolute
          if (productJson['images'] != null && productJson['images'] is List) {
            final imagesList = productJson['images'] as List;
            productJson['images'] = imagesList.map((img) {
              if (img is Map) {
                final imgMap = Map<String, dynamic>.from(img);
                if (imgMap['image_url'] != null) {
                  final imageUrl = imgMap['image_url'].toString();
                  if (imageUrl.startsWith('/')) {
                    imgMap['image_url'] = '$mediaBaseUrl$imageUrl';
                  }
                }
                return imgMap;
              }
              return img;
            }).toList();
          }
          
          // Debug: Print product details
          print('Product: ${productJson['name']} - Category: ${productJson['category']} - Available: ${productJson['is_available']} - Images: ${productJson['images']?.length ?? 0}');
          
          return Product.fromJson(productJson);
        }).toList();
        
        return products;
      } else {
        final errorBody = response.body;
        print('🔴 API Error: Status ${response.statusCode}, Body: $errorBody');
        throw Exception('Failed to fetch products: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      // Debug: Print the full error
      print('🔴 Products API Error: $e');
      print('🔴 Error Type: ${e.runtimeType}');
      if (e is http.ClientException) {
        print('🔴 Client Exception Details: ${e.message}');
      }
      
      // Handle network errors or parsing errors
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: Unable to connect to server - $e');
    }
  }
}

