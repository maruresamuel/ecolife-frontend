import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  
  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    String? address,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      if (address != null) 'address': address,
    };
    
    final response = await _apiService.post('/auth/register', body, withAuth: false);
    
    // Save token and user data
    final data = response['data'];
    if (data != null && data['token'] != null) {
      await _apiService.setToken(data['token']);
      await _saveUserData(data['user']);
    }
    
    return data ?? response;
  }
  
  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };
    
    final response = await _apiService.post('/auth/login', body, withAuth: false);
    
    // Save token and user data
    final data = response['data'];
    if (data != null && data['token'] != null) {
      await _apiService.setToken(data['token']);
      await _saveUserData(data['user']);
    }
    
    return data ?? response;
  }
  
  // Get Current User
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get('/auth/me');
    final data = response['data'] ?? response;
    return UserModel.fromJson(data['user'] ?? data);
  }
  
  // Update Profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    final body = {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
    
    final response = await _apiService.put('/auth/profile', body);
    final data = response['data'] ?? response;
    final user = UserModel.fromJson(data['user'] ?? data);
    await _saveUserData(data['user'] ?? data);
    return user;
  }
  
  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
    
    await _apiService.put('/auth/password', body);
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.clearToken();
    await _clearUserData();
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }
  
  // Get stored user data
  Future<UserModel?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AppConstants.storageKeyUser);
    if (userData != null) {
      return UserModel.fromJson(json.decode(userData));
    }
    return null;
  }
  
  // Save user data locally
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeyUser, json.encode(userData));
    await prefs.setString(AppConstants.storageKeyRole, userData['role'] ?? 'customer');
  }
  
  // Clear user data
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storageKeyUser);
    await prefs.remove(AppConstants.storageKeyRole);
  }
}
