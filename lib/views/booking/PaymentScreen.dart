// PaymentScreen: ensure we always supply phone/email to controller
import './PaymentSuccess.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/payment_controller.dart';
import '../../controllers/profile_controller.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentController controller;

  final RxString _statusText = 'Creating order...'.obs;
  final RxBool _blockBack = false.obs;

  String _toE164(String raw) {
    final trimmed = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('+')) return trimmed;
    if (RegExp(r'^[0-9]{10}$').hasMatch(trimmed)) return '+91$trimmed';
    return trimmed;
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<PaymentController>();

    final args = Get.arguments as Map<String, dynamic>?;
    
    // 1. EXTRACT AND PASS BOOKING CARD TO CONTROLLER
    if (args != null) {
      controller.setBookingDetails(
        amount: (args['amount'] ?? 0.0) * 1.0,
        metadata: args['metadata'] as Map<String, dynamic>?,
        bookingId: args['bookingId'] as String?,
        // Pass the bookingCard here so the controller can store it
        // and pass it to the success screen later.
        bookingCard: args['bookingCard'] as Map<String, dynamic>?, 
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.bookingAmount == null || controller.bookingAmount == 0) {
        Get.snackbar('Error', 'Booking amount missing');
        Get.back();
        return;
      }
      if ((controller.bookingId ?? '').isEmpty) {
        Get.snackbar('Error', 'Booking ID missing');
        Get.back();
        return;
      }

      _blockBack.value = true;
      _statusText.value = 'Creating order...';

      ever(controller.isLoading, (bool loading) {
        if (!loading) _statusText.value = 'Opening payment gateway...';
      });

      // 1) Try ProfileController
      final profile = Get.find<ProfileController>();
      final fromProfilePhone = profile.userPhone; // may be '' initially
      final fromProfileEmail = profile.customer?.emailId ?? '';

      // 2) Try booking metadata fallback from args
      final argsMeta = (args?['metadata'] as Map?) ?? {};
      final fromArgsPhone = (argsMeta['phone'] as String?) ?? '';
      final fromArgsEmail = (argsMeta['email'] as String?) ?? '';

      // 3) Pick first non-empty and normalize
      final chosenPhone = [
        fromProfilePhone,
        fromArgsPhone,
      ].firstWhere((v) => (v.toString().trim().isNotEmpty), orElse: () => '');
      final chosenEmail = [
        fromProfileEmail,
        fromArgsEmail,
      ].firstWhere((v) => (v.toString().trim().isNotEmpty), orElse: () => '');

      final contact = _toE164(chosenPhone);
      final email = chosenEmail.trim();

      // 4) Send to controller; it will merge again with internal fallback
      controller.setPrefill(contact: contact, email: email);

      await controller.initiatePaymentDirect();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _blockBack.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFFFFEEE0),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Obx(() {
        final isLoading = controller.isLoading.value;
        return WillPopScope(
          onWillPop: () async => !_blockBack.value,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      ChayanHeader(
                        title: 'Payment',
                        onBack: () {
                          if (_blockBack.value) return;
                          try {
                            controller.cancelPayment();
                          } catch (_) {
                            controller.paymentCancelled.value = true;
                          }
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Obx(() {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE47830)),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  _statusText.value,
                                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                if (isLoading)
                                  Text(
                                    'Please wait...',
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading || _blockBack.value)
                    AnimatedOpacity(
                      opacity: 0.35,
                      duration: const Duration(milliseconds: 200),
                      child: Container(color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}