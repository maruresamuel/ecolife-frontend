import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

enum NotificationType {
  order,
  payment,
  product,
  system,
}

class NotificationProvider with ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  bool get hasUnread => unreadCount > 0;

  // Add notification
  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );
    
    _notifications.insert(0, notification);
    
    // Keep only last 50 notifications
    if (_notifications.length > 50) {
      _notifications.removeRange(50, _notifications.length);
    }
    
    notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Remove notification
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Clear all notifications
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // Get icon for notification type
  IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.product:
        return Icons.inventory_2;
      case NotificationType.system:
        return Icons.info;
    }
  }

  // Get color for notification type
  Color getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.product:
        return Colors.orange;
      case NotificationType.system:
        return Colors.purple;
    }
  }

  // Add order notification
  void notifyOrderCreated(String orderId) {
    addNotification(
      title: 'Order Placed',
      message: 'Your order #$orderId has been placed successfully',
      type: NotificationType.order,
    );
  }

  void notifyOrderStatusChanged(String orderId, String status) {
    addNotification(
      title: 'Order Update',
      message: 'Order #$orderId is now $status',
      type: NotificationType.order,
    );
  }

  // Add cart notifications
  void notifyItemAddedToCart(String productName) {
    addNotification(
      title: 'Added to Cart',
      message: '$productName has been added to your cart',
      type: NotificationType.product,
    );
  }

  // Add payment notifications
  void notifyPaymentReceived(double amount) {
    addNotification(
      title: 'Payment Received',
      message: 'KSH ${amount.toStringAsFixed(2)} has been added to your wallet',
      type: NotificationType.payment,
    );
  }

  void notifyWithdrawalProcessed(double amount) {
    addNotification(
      title: 'Withdrawal Processed',
      message: 'KSH ${amount.toStringAsFixed(2)} has been withdrawn',
      type: NotificationType.payment,
    );
  }

  // Add product notifications for vendors
  void notifyProductSold(String productName, int quantity) {
    addNotification(
      title: 'Product Sold',
      message: '$quantity x $productName has been sold',
      type: NotificationType.product,
    );
  }

  void notifyLowStock(String productName, int stock) {
    addNotification(
      title: 'Low Stock Alert',
      message: '$productName is running low (only $stock left)',
      type: NotificationType.product,
    );
  }
}
