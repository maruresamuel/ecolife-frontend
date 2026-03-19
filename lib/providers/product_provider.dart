import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<ProductModel> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  
  // Filters
  String? _selectedCategory;
  String? _searchQuery;
  double? _minPrice;
  double? _maxPrice;
  
  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  
  // Fetch products
  Future<void> fetchProducts({
    bool refresh = false,
  }) async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      _error = null;
      if (refresh) _products = [];
      notifyListeners();
      
      _products = await _productService.getProducts(
        category: _selectedCategory,
        search: _searchQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      _categories = await _productService.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }
  
  // Set category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    fetchProducts(refresh: true);
  }
  
  // Set search query
  void setSearchQuery(String? query) {
    _searchQuery = query;
    fetchProducts(refresh: true);
  }
  
  // Set price range
  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    fetchProducts(refresh: true);
  }
  
  // Clear filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = null;
    _minPrice = null;
    _maxPrice = null;
    fetchProducts(refresh: true);
  }
  
  // Get product by ID
  Future<ProductModel?> getProduct(String id) async {
    try {
      return await _productService.getProduct(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  // Create product (Vendor)
  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String unit,
    XFile? imageFile,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final product = await _productService.createProduct(
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        unit: unit,
        imageFile: imageFile,
      );
      
      _products.insert(0, product);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update product (Vendor)
  Future<bool> updateProduct(
    String id, {
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? unit,
    XFile? imageFile,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final product = await _productService.updateProduct(
        id,
        name: name,
        description: description,
        price: price,
        stock: stock,
        category: category,
        unit: unit,
        imageFile: imageFile,
      );
      
      final index = _products.indexWhere((p) => p.id == id);
      if (index >= 0) {
        _products[index] = product;
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
  
  // Delete product (Vendor)
  Future<bool> deleteProduct(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch vendor products
  Future<void> fetchVendorProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _products = await _productService.getVendorProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
