class TransactionModel {
  final String id;
  final String userId;
  final String type; // deposit, withdrawal, refund, payment, earning
  final double amount;
  final String status; // pending, completed, failed, processing
  final String method; // mpesa, card, bank, wallet
  final String? reference;
  final String? mpesaReceiptNumber;
  final String? phoneNumber;
  final String? description;
  final String? relatedOrderId;
  final String? refundedToId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    this.method = 'mpesa',
    this.reference,
    this.mpesaReceiptNumber,
    this.phoneNumber,
    this.description,
    this.relatedOrderId,
    this.refundedToId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      type: json['type'] ?? 'deposit',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      method: json['method'] ?? 'mpesa',
      reference: json['reference'],
      mpesaReceiptNumber: json['mpesaReceiptNumber'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      relatedOrderId: json['relatedOrder'] is Map 
          ? json['relatedOrder']['_id'] 
          : json['relatedOrder'],
      refundedToId: json['refundedTo'] is Map 
          ? json['refundedTo']['_id'] 
          : json['refundedTo'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'type': type,
      'amount': amount,
      'status': status,
      'method': method,
      'reference': reference,
      'mpesaReceiptNumber': mpesaReceiptNumber,
      'phoneNumber': phoneNumber,
      'description': description,
      'relatedOrder': relatedOrderId,
      'refundedTo': refundedToId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isDeposit => type == 'deposit' || type == 'earning';
  bool get isWithdrawal => type == 'withdrawal' || type == 'payment';
  bool get isPending => status == 'pending' || status == 'processing';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
}
