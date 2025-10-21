import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// API Service for Backend Communication
/// Handles all HTTP requests to the LensHive backend API
class ApiService {
  // Base URL for API - Update this with your actual backend URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API endpoints
  static const String loginEndpoint = '/auth/login/';
  static const String registerEndpoint = '/auth/register/';

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
}

