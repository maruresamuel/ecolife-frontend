class OrderItemModel {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String vendorId;
  
  OrderItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.vendorId,
  });
  
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product'] is String
          ? json['product']
          : json['product']?['_id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      vendorId: json['vendor'] is String
          ? json['vendor']
          : json['vendor']?['_id'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'vendor': vendorId,
    };
  }
  
  double get subtotal => quantity * price;
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status;
  final Map<String, dynamic> shippingAddress;
  final String phone;
  final String? notes;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.phone,
    this.notes,
    this.paymentStatus = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse shippingAddress - can be String or Map
    Map<String, dynamic> addressMap;
    if (json['shippingAddress'] is String) {
      addressMap = {
        'address': json['shippingAddress'],
        'phone': json['phone'] ?? '',
        'name': 'Customer',
      };
    } else if (json['shippingAddress'] is Map) {
      addressMap = Map<String, dynamic>.from(json['shippingAddress']);
    } else {
      addressMap = {'address': '', 'phone': '', 'name': ''};
    }
    
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] is String
          ? json['user']
          : json['user']?['_id'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      shippingAddress: addressMap,
      phone: json['phone'] ?? '',
      notes: json['notes'],
      paymentStatus: json['paymentStatus'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'shippingAddress': shippingAddress['address'] ?? shippingAddress.toString(),
      'phone': phone,
      'notes': notes,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItemModel>? items,
    double? totalAmount,
    String? status,
    Map<String, dynamic>? shippingAddress,
    String? phone,
    String? notes,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get canBeCancelled => isPending || isProcessing;
}
