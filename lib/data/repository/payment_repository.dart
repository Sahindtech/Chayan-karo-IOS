import 'package:meta/meta.dart';
import 'package:get/get.dart';
import '../remote/api_service.dart';
import '../remote/network_client.dart';
import '../local/database.dart';
import '../../models/payment_models.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

@immutable
class PaymentRepository {
  PaymentRepository();

  ApiService get _api => NetworkClient().apiService; // use singleton
  AppDatabase get _database => Get.find<AppDatabase>(); // Get database like ProfileRepository

  final _uuid = const Uuid();
  final _random = Random.secure();

  /// Create order on backend
  Future<RazorpayOrderDetails> createOrder({
    required double amount,
  }) async {
    try {
      final receipt = _generateUniqueReceipt();

      // Get token from database (same as ProfileRepository)
      final token = await _database.getAuthToken();
      
      print('🔍 Payment Repository Debug:');
      print('   Token retrieved: ${token?.substring(0, 20) ?? 'null'}...');
      print('   Token length: ${token?.length ?? 0}');
      print('   Receipt: $receipt (${receipt.length} chars)');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found. Please login again.');
      }

      print('📤 Creating order using ApiService...');

      final request = CreateOrderRequest(
        amount: amount,
        receipt: receipt,
      );

      // Pass token with Bearer prefix (same as ProfileRepository)
      final response = await _api.createOrder(
        'Bearer $token',
        request,
      );

      print('📥 Order API Response Type: ${response.type}');

      // Parse the nested result string
      final orderDetails = response.getOrderDetails();
      
      if (orderDetails == null) {
        throw Exception('Failed to parse order details');
      }

      print('✅ Order created successfully:');
      print('   Order ID: ${orderDetails.id}');
      print('   Amount: ${orderDetails.amount}');
      print('   Receipt: ${orderDetails.receipt}');

      return orderDetails;
    } catch (e) {
      print('❌ PaymentRepository Error: $e');
      throw Exception('Error creating order: $e');
    }
  }

  /// Generate unique receipt ID (max 40 characters for Razorpay)
  /// Format: RCPT_timestamp_random (exactly 30 chars)
  String _generateUniqueReceipt() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = _generateRandomString(8);
    
    // Format: RCPT_1762265749049_a4f9e2b1
    // Length: 5 + 13 + 1 + 8 = 27 characters (well under 40 limit)
    final receipt = 'RCPT_${timestamp}_$randomSuffix';
    
    return receipt;
  }

  /// Generate random alphanumeric string
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[_random.nextInt(chars.length)]).join();
  }
}
