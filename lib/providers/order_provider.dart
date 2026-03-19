import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<OrderModel> _orders = [];
  List<OrderModel> _vendorOrders = [];
  bool _isLoading = false;
  String? _error;
  
  List<OrderModel> get orders => _orders;
  List<OrderModel> get vendorOrders => _vendorOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Customer statistics
  int get totalOrders => _orders.length;
  int get pendingOrders => _orders.where((o) => o.status == 'pending').length;
  int get deliveredOrders => _orders.where((o) => o.status == 'delivered').length;
  int get cancelledOrders => _orders.where((o) => o.status == 'cancelled').length;
  double get totalSpent => _orders
      .where((o) => o.status != 'cancelled')
      .fold(0.0, (sum, order) => sum + order.totalAmount);
  
  // Vendor statistics
  int get vendorTotalOrders => _vendorOrders.length;
  int get vendorPendingOrders => _vendorOrders.where((o) => o.status == 'pending').length;
  int get vendorProcessingOrders => _vendorOrders.where((o) => o.status == 'processing').length;
  int get vendorShippedOrders => _vendorOrders.where((o) => o.status == 'shipped').length;
  int get vendorDeliveredOrders => _vendorOrders.where((o) => o.status == 'delivered').length;
  double get vendorTotalRevenue => _vendorOrders
      .where((o) => o.status == 'delivered')
      .fold(0.0, (sum, order) => sum + order.totalAmount);
  double get vendorPendingRevenue => _vendorOrders
      .where((o) => o.status == 'pending' || o.status == 'processing')
      .fold(0.0, (sum, order) => sum + order.totalAmount);
  
  // Fetch customer orders
  Future<void> fetchOrders({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _orders = await _orderService.getOrders(status: status);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch vendor orders
  Future<void> fetchVendorOrders({String? status}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _vendorOrders = await _orderService.getVendorOrders(status: status);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _vendorOrders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update order status (vendor)
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final updatedOrder = await _orderService.updateOrderStatus(orderId, status);
      
      // Update local list
      final index = _vendorOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _vendorOrders[index] = updatedOrder;
      }
      
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Cancel order (customer)
  Future<bool> cancelOrder(String orderId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final updatedOrder = await _orderService.cancelOrder(orderId);
      
      // Update local list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }
      
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get recent orders (last 5)
  List<OrderModel> get recentOrders {
    final sorted = List<OrderModel>.from(_orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }
  
  // Get recent vendor orders (last 5)
  List<OrderModel> get recentVendorOrders {
    final sorted = List<OrderModel>.from(_vendorOrders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
