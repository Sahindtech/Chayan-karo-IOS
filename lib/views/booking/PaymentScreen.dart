import './PaymentSuccess.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/payment_controller.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});


  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}


class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentController controller;


  @override
  void initState() {
    super.initState();
    controller = Get.find<PaymentController>();
    
    // Get booking details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      controller.setBookingDetails(
        amount: args['amount'] ?? 0.0,
        metadata: args['metadata'],
      );
    }

    // Directly initiate payment when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initiatePaymentDirect();
    });
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFFFFEEE0),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(() {
              final isLoading = controller.isLoading.value;
              
              return Stack(
                children: [
                  Column(
                    children: [
                      ChayanHeader(
                        title: 'Payment',
                        onBack: () {
                          // Cancel any ongoing payment
                          controller.cancelPayment();
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading) ...[
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE47830)),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  'Initializing payment...',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ] else ...[
                                Icon(
                                  Icons.payment,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Payment gateway loading...',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE47830)),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
