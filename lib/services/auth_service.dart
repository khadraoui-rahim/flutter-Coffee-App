import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../config/api_config.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user';

  // Register a new user
  Future<AuthResponse> register(String email, String password) async {
    try {
      print('🔵 [AUTH] Starting registration for: $email');
      print('🔵 [AUTH] Password length: ${password.length}');

      final requestBody = {'email': email, 'password': password};
      print('🔵 [AUTH] Request body: $requestBody');

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/register');
      print('🔵 [AUTH] Sending POST to: $uri');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      print('🔵 [AUTH] Response status: ${response.statusCode}');
      print('🔵 [AUTH] Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('✅ [AUTH] Registration successful');
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        await _saveAuthData(authResponse);
        print('✅ [AUTH] Auth data saved');
        return authResponse;
      } else if (response.statusCode == 409) {
        print('❌ [AUTH] Email already exists');
        throw Exception('Email already exists');
      } else if (response.statusCode == 400) {
        final errorBody = json.decode(response.body);
        print('❌ [AUTH] Bad request: $errorBody');
        final errorMessage =
            errorBody['error'] ?? errorBody['message'] ?? 'Invalid input data';
        throw Exception(errorMessage);
      } else {
        print(
          '❌ [AUTH] Registration failed with status: ${response.statusCode}',
        );
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [AUTH] Exception during registration: $e');
      if (e is Exception) rethrow;
      throw Exception('Error during registration: $e');
    }
  }

  // Login a user
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('🔵 [AUTH] Starting login for: $email');

      final requestBody = {'email': email, 'password': password};
      print('🔵 [AUTH] Request body: $requestBody');

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/login');
      print('🔵 [AUTH] Sending POST to: $uri');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      print('🔵 [AUTH] Response status: ${response.statusCode}');
      print('🔵 [AUTH] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [AUTH] Login successful');
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        await _saveAuthData(authResponse);
        print('✅ [AUTH] Auth data saved');
        return authResponse;
      } else if (response.statusCode == 401) {
        print('❌ [AUTH] Invalid credentials');
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 400) {
        final errorBody = json.decode(response.body);
        print('❌ [AUTH] Bad request: $errorBody');
        final errorMessage =
            errorBody['error'] ?? errorBody['message'] ?? 'Invalid input data';
        throw Exception(errorMessage);
      } else {
        print('❌ [AUTH] Login failed with status: ${response.statusCode}');
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [AUTH] Exception during login: $e');
      if (e is Exception) rethrow;
      throw Exception('Error during login: $e');
    }
  }

  // Refresh access token
  Future<AuthResponse> refreshToken() async {
    try {
      print('🔵 [AUTH] Starting token refresh');
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        print('❌ [AUTH] No refresh token available');
        throw Exception('No refresh token available');
      }

      print(
        '🔵 [AUTH] Refresh token found: ${refreshToken.substring(0, 20)}...',
      );

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConfig.timeout);

      print('🔵 [AUTH] Refresh response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ [AUTH] Token refresh successful');
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        await _saveAuthData(authResponse);
        return authResponse;
      } else {
        print('❌ [AUTH] Token refresh failed: ${response.statusCode}');
        throw Exception('Token refresh failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [AUTH] Exception during token refresh: $e');
      await logout(); // Clear invalid tokens
      if (e is Exception) rethrow;
      throw Exception('Error refreshing token: $e');
    }
  }

  // Get current user information
  Future<User> getCurrentUser() async {
    try {
      print('🔵 [AUTH] Getting current user');
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        print('❌ [AUTH] No access token available');
        throw Exception('No access token available');
      }

      print('🔵 [AUTH] Access token found: ${accessToken.substring(0, 20)}...');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiConfig.timeout);

      print('🔵 [AUTH] Get user response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ [AUTH] User retrieved successfully');
        return User.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        print('⚠️ [AUTH] Token expired, attempting refresh');
        // Try to refresh token
        await refreshToken();
        return getCurrentUser(); // Retry with new token
      } else {
        print('❌ [AUTH] Failed to get user: ${response.statusCode}');
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [AUTH] Exception getting current user: $e');
      if (e is Exception) rethrow;
      throw Exception('Error getting current user: $e');
    }
  }

  // Save authentication data to local storage
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    print('🔵 [AUTH] Saving auth data to local storage');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, authResponse.accessToken);
    await prefs.setString(_refreshTokenKey, authResponse.refreshToken);
    await prefs.setString(_userKey, json.encode(authResponse.user.toJson()));
    print(
      '✅ [AUTH] Access token saved: ${authResponse.accessToken.substring(0, 20)}...',
    );
    print(
      '✅ [AUTH] Refresh token saved: ${authResponse.refreshToken.substring(0, 20)}...',
    );
    print('✅ [AUTH] User saved: ${authResponse.user.email}');
  }

  // Get access token from local storage
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    if (token != null) {
      print('🔵 [AUTH] Retrieved access token from storage');
    }
    return token;
  }

  // Get refresh token from local storage
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_refreshTokenKey);
    if (token != null) {
      print('🔵 [AUTH] Retrieved refresh token from storage');
    }
    return token;
  }

  // Get stored user from local storage
  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      print('🔵 [AUTH] Retrieved user from storage');
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final isLoggedIn = accessToken != null;
    print('🔵 [AUTH] Is logged in: $isLoggedIn');
    return isLoggedIn;
  }

  // Logout user
  Future<void> logout() async {
    print('🔵 [AUTH] Logging out user');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    print('✅ [AUTH] User logged out, tokens cleared');
  }
}
