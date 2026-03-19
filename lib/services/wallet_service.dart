import 'api_service.dart';

class WalletService {
  final ApiService _apiService = ApiService();

  // Get wallet balance
  Future<Map<String, dynamic>> getBalance() async {
    final response = await _apiService.get('/wallet/balance');
    return response['data'];
  }

  // Deposit money
  Future<Map<String, dynamic>> deposit({
    required double amount,
    required String phoneNumber,
  }) async {
    final body = {
      'amount': amount,
      'phoneNumber': phoneNumber,
    };
    
    final response = await _apiService.post('/wallet/deposit', body);
    return response['data'];
  }

  // Request refund (Customer)
  Future<Map<String, dynamic>> requestRefund({
    required String orderId,
    required double amount,
    String? reason,
  }) async {
    final body = {
      'orderId': orderId,
      'amount': amount,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    };
    
    final response = await _apiService.post('/wallet/refund-request', body);
    return response['data'];
  }

  // Withdraw money (Vendor)
  Future<Map<String, dynamic>> withdraw({
    required double amount,
    required String withdrawalMethod,
    String? accountDetails,
  }) async {
    final body = {
      'amount': amount,
      'withdrawalMethod': withdrawalMethod,
      if (accountDetails != null && accountDetails.isNotEmpty)
        'accountDetails': accountDetails,
    };
    
    final response = await _apiService.post('/wallet/withdraw', body);
    return response['data'];
  }

  // Refund customer (Vendor)
  Future<Map<String, dynamic>> refundCustomer({
    required String orderId,
    required String customerId,
    required double amount,
  }) async {
    final body = {
      'orderId': orderId,
      'customerId': customerId,
      'amount': amount,
    };
    
    final response = await _apiService.post('/wallet/refund-customer', body);
    return response['data'];
  }

  // Get transactions
  Future<List<Map<String, dynamic>>> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiService.get('/wallet/transactions?page=$page&limit=$limit');
    final transactionsData = response['data'];
    return List<Map<String, dynamic>>.from(transactionsData['transactions'] ?? []);
  }
}
