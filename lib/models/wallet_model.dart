class WalletModel {
  final String userId;
  final double balance;
  final double pendingBalance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.userId,
    required this.balance,
    required this.pendingBalance,
    this.currency = 'KSH',
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['user'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      pendingBalance: (json['pendingBalance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'KSH',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
