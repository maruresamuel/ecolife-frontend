import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();
  
  // Create order
  Future<OrderModel> createOrder({
    required List<OrderItemModel> items,
    required String shippingAddress,
    required String phone,
    String? notes,
  }) async {
    final body = {
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress,
      'phone': phone,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    
    final response = await _apiService.post('/orders', body);
    // Backend returns { success: true, data: { order: {...} } }
    final orderData = response['data'];
    final orderJson = orderData is Map && orderData.containsKey('order')
        ? orderData['order']
        : orderData;
    return OrderModel.fromJson(orderJson);
  }
  
  // Get all orders (for current user)
  Future<List<OrderModel>> getOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    String endpoint = '/orders?page=$page&limit=$limit';
    
    if (status != null && status.isNotEmpty) {
      endpoint += '&status=$status';
    }
    
    final response = await _apiService.get(endpoint);
    
    // Backend returns { success: true, data: { orders: [...] } }
    final ordersData = response['data'];
    final ordersList = ordersData is Map && ordersData.containsKey('orders')
        ? ordersData['orders']
        : ordersData;
    
    final orders = (ordersList as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
    
    return orders;
  }
  
  // Get order by ID
  Future<OrderModel> getOrder(String id) async {
    final response = await _apiService.get('/orders/$id');
    // Backend returns { success: true, data: { order: {...} } }
    final orderData = response['data'];
    final orderJson = orderData is Map && orderData.containsKey('order')
        ? orderData['order']
        : orderData;
    return OrderModel.fromJson(orderJson);
  }
  
  // Cancel order (Customer)
  Future<OrderModel> cancelOrder(String id) async {
    final response = await _apiService.put('/orders/$id/cancel', {});
    // Backend returns { success: true, data: { order: {...} } }
    final orderData = response['data'];
    final orderJson = orderData is Map && orderData.containsKey('order')
        ? orderData['order']
        : orderData;
    return OrderModel.fromJson(orderJson);
  }
  
  // Update order status (Vendor)
  Future<OrderModel> updateOrderStatus(String id, String status) async {
    final body = {'status': status};
    final response = await _apiService.put('/orders/$id/status', body);
    // Backend returns { success: true, data: { order: {...} } }
    final orderData = response['data'];
    final orderJson = orderData is Map && orderData.containsKey('order')
        ? orderData['order']
        : orderData;
    return OrderModel.fromJson(orderJson);
  }
  
  // Get vendor orders
  Future<List<OrderModel>> getVendorOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    String endpoint = '/vendor/orders?page=$page&limit=$limit';
    
    if (status != null && status.isNotEmpty) {
      endpoint += '&status=$status';
    }
    
    final response = await _apiService.get(endpoint);
    
    // Backend returns { success: true, data: { orders: [...] } }
    final ordersData = response['data'];
    final ordersList = ordersData is Map && ordersData.containsKey('orders')
        ? ordersData['orders']
        : ordersData;
    
    final orders = (ordersList as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
    
    return orders;
  }
}
