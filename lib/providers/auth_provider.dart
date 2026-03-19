import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get isVendor => _user?.isVendor ?? false;
  bool get isCustomer => _user?.isCustomer ?? false;
  
  // Initialize - Check if user is logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        _user = await _authService.getStoredUser();
        _isAuthenticated = _user != null;
        
        // Fetch fresh user data (with timeout)
        if (_user != null) {
          try {
            final freshUser = await _authService.getCurrentUser()
                .timeout(const Duration(seconds: 5));
            _user = freshUser;
          } catch (e) {
            // If fetching fails, keep stored user data
            print('Failed to fetch fresh user data: $e');
          }
        }
      }
    } catch (e) {
      _error = e.toString();
      print('Auth initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        address: address,
      );
      
      // auth_service.register now returns the 'data' object directly
      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
        _isAuthenticated = true;
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final response = await _authService.login(
        email: email,
        password: password,
      );
      
      // auth_service.login now returns the 'data' object directly
      if (response['user'] != null) {
        _user = UserModel.fromJson(response['user']);
        _isAuthenticated = true;
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update Profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _user = await _authService.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Change Password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }
  
  // Clear Error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
