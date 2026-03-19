import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  String? _token;
  
  // Get token
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.storageKeyToken);
    return _token;
  }
  
  // Set token
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeyToken, token);
  }
  
  // Clear token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storageKeyToken);
  }
  
  // Get headers
  Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (withAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // GET Request
  Future<dynamic> get(String endpoint, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);
      
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(Duration(seconds: AppConstants.apiTimeout));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST Request
  Future<dynamic> post(
    String endpoint,
    dynamic body, {
    bool withAuth = true,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      ).timeout(Duration(seconds: AppConstants.apiTimeout));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // PUT Request
  Future<dynamic> put(
    String endpoint,
    dynamic body, {
    bool withAuth = true,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);
      
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      ).timeout(Duration(seconds: AppConstants.apiTimeout));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // DELETE Request
  Future<dynamic> delete(String endpoint, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);
      
      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(Duration(seconds: AppConstants.apiTimeout));
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST Multipart (for file uploads)
  Future<dynamic> postMultipart(
    String endpoint,
    Map<String, String> fields,
    String fileField,
    XFile imageFile,
  ) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final token = await getToken();
      
      final request = http.MultipartRequest('POST', url);
      
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add file - works for both web and mobile
      final bytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        fileField,
        bytes,
        filename: imageFile.name,
      );
      request.files.add(multipartFile);
      
      final streamedResponse = await request.send()
          .timeout(Duration(seconds: AppConstants.apiTimeout));
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Handle Response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'An error occurred';
      throw ApiException(statusCode, errorMessage);
    }
  }
  
  // Handle Error
  String _handleError(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Network error. Please check your connection.';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  
  ApiException(this.statusCode, this.message);
  
  @override
  String toString() => message;
}
