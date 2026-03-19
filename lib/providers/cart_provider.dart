import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  
  CartItem({
    required this.product,
    this.quantity = 1,
  });
  
  double get total => product.price * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.length;
  
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);
  
  bool get isEmpty => _items.isEmpty;
  
  bool get isNotEmpty => _items.isNotEmpty;
  
  // Initialize cart from storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(AppConstants.storageKeyCart);
      
      if (cartData != null) {
        final List<dynamic> jsonData = json.decode(cartData);
        _items.clear();
        _items.addAll(
          jsonData.map((item) => CartItem.fromJson(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
  
  // Save cart to storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(AppConstants.storageKeyCart, cartData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }
  
  // Add item to cart
  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    _saveCart();
    notifyListeners();
  }
  
  // Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }
  
  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    
    if (index >= 0) {
      _items[index].quantity = quantity;
      _saveCart();
      notifyListeners();
    }
  }
  
  // Increment quantity
  void incrementQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    
    if (index >= 0) {
      _items[index].quantity++;
      _saveCart();
      notifyListeners();
    }
  }
  
  // Decrement quantity
  void decrementQuantity(String productId) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        _saveCart();
        notifyListeners();
      } else {
        removeItem(productId);
      }
    }
  }
  
  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
  
  // Get quantity of product in cart
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: ProductModel(
        id: '',
        name: '',
        description: '',
        price: 0,
        stock: 0,
        category: '',
        vendorId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ), quantity: 0),
    );
    return item.quantity;
  }
  
  // Clear cart
  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }
}
