import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../data/repository/payment_repository.dart';


class PaymentController extends GetxController {
  // Lazy initialization - matches your app pattern
  PaymentRepository get _repository => PaymentRepository();
  
  late Razorpay _razorpay;
  
  final isLoading = false.obs;
  final selectedMethod = Rxn<String>();
  final errorMessage = ''.obs;
  final paymentCancelled = false.obs;


  double? bookingAmount;
  Map<String, dynamic>? bookingMetadata;
  String? currentOrderId;
  String? currentReceipt;


  // Razorpay credentials
  static const String _razorpayKeyId = 'rzp_test_RRgyDlYscS5byz'; // Replace with your key_id
  static const String _razorpayKeySecret = '0ttsMZqDUBC9mo82h6Vxdz7w'; // Not used in client side


  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }


  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  void setBookingDetails({
    required double amount,
    Map<String, dynamic>? metadata,
  }) {
    bookingAmount = amount;
    bookingMetadata = metadata;
  }


  void selectPaymentMethod(String method) {
    selectedMethod.value = method;
  }


  // NEW METHOD: Directly initiate payment without UI selection
  // This mimics the old behavior where a method was selected
  Future<void> initiatePaymentDirect() async {
    if (bookingAmount == null) {
      Get.snackbar('Error', 'Booking amount missing');
      Get.back(); // Go back if no amount
      return;
    }

    paymentCancelled.value = false;
    
    // Auto-select 'Card' as default (or could be 'GPay', 'PhonePe', etc.)
    // This ensures Razorpay shows all payment options
    selectedMethod.value = 'Card';
    
    await _processOnlinePayment();
  }


  // NEW METHOD: Cancel payment
  void cancelPayment() {
    paymentCancelled.value = true;
    print('🚫 Payment cancelled by user');
  }


  // Keep old method for backward compatibility
  Future<void> initiatePayment() async {
    if (selectedMethod.value == null) {
      Get.snackbar('Error', 'Please select a payment method');
      return;
    }


    if (bookingAmount == null) {
      Get.snackbar('Error', 'Booking amount missing');
      return;
    }


    // For Cash, just navigate to success
    if (selectedMethod.value == 'Cash') {
      _processCashPayment();
      return;
    }


    // For online payments, create order and open Razorpay
    await _processOnlinePayment();
  }


  Future<void> _processOnlinePayment() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';


      print('💳 Initiating Razorpay payment for amount: ₹$bookingAmount');


      // Create order on backend - returns parsed RazorpayOrderDetails
      final orderDetails = await _repository.createOrder(
        amount: bookingAmount!,
      );


      currentOrderId = orderDetails.id;
      currentReceipt = orderDetails.receipt;
      
      if (currentOrderId == null) {
        throw Exception('Order ID not received from backend');
      }


      print('✅ Order created: $currentOrderId');
      print('📄 Receipt: $currentReceipt');


      // Stop loading before opening Razorpay
      isLoading.value = false;


      // Open Razorpay checkout with your key_id
      // IMPORTANT: Don't restrict payment methods to show all options
      var options = {
        'key': _razorpayKeyId, // Use your Razorpay key_id
        'amount': orderDetails.amount ?? (bookingAmount! * 100).toInt(), // amount in paise
        'name': 'Chayan Karo',
        'order_id': currentOrderId,
        'description': 'Service Booking Payment',
        'prefill': {
          'contact': bookingMetadata?['phone'] ?? '',
          'email': bookingMetadata?['email'] ?? '',
        },
        'theme': {
          'color': '#E47830',
        },
        // Don't add 'method' restriction to show all payment options
      };


      print('🚀 Opening Razorpay checkout...');
      
      _razorpay.open(options);
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Payment error: ${e.toString()}');
      
      Get.snackbar(
        'Error',
        'Failed to create order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
      // Go back to previous screen on error
      Future.delayed(Duration(seconds: 2), () {
        if (Get.currentRoute == '/payment') {
          Get.back();
        }
      });
    } finally {
      isLoading.value = false;
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('✅ Payment successful!');
    print('   Payment ID: ${response.paymentId}');
    print('   Order ID: ${response.orderId}');
    print('   Signature: ${response.signature}');


    // Payment successful - navigate to success screen
    Get.offNamed('/payment-success', arguments: {
      'orderId': response.orderId,
      'paymentId': response.paymentId,
      'signature': response.signature,
      'receipt': currentReceipt,
      'amount': bookingAmount,
      'method': selectedMethod.value ?? 'Online Payment',
    });
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment failed!');
    print('   Code: ${response.code}');
    print('   Message: ${response.message}');

    String errorTitle = 'Payment Failed';
    String errorMessage = response.message ?? 'Something went wrong';
    
    if (response.code == 0) {
      errorTitle = 'Payment Cancelled';
      errorMessage = 'You cancelled the payment';
    } else if (response.code == 2) {
      errorTitle = 'Payment Timeout';
      errorMessage = 'Payment was not completed. Please try again.';
    }


    Get.snackbar(
      errorTitle,
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );

    // Go back to previous screen after showing error
    Future.delayed(Duration(seconds: 3), () {
      if (Get.currentRoute == '/payment') {
        Get.back();
      }
    });
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
    print('💼 External wallet selected: ${response.walletName}');


    Get.snackbar(
      'External Wallet',
      'Wallet: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  void _processCashPayment() {
    print('💵 Processing cash payment');


    // For cash, just navigate to success screen
    Get.offNamed('/payment-success', arguments: {
      'amount': bookingAmount,
      'method': 'Cash',
      'receipt': 'CASH_${DateTime.now().millisecondsSinceEpoch}',
    });
  }


  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
