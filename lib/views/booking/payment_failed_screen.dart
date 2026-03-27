import 'package:chayankaro/views/home/home_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String? message;     // Optional error message to display
  final String? orderId;     // Optional Razorpay order id
  final String? paymentId;   // Optional Razorpay payment id

  const PaymentFailedScreen({
    super.key,
    this.message,
    this.orderId,
    this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scale = isTablet ? constraints.maxWidth / 411 : 1.0;

      final String titleText = 'Payment Failed';
      final String descText = (message != null && message!.trim().isNotEmpty)
          ? message!
          : 'The payment could not be completed. Please try again.';

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w * scale),
                  child: Column(
                    children: [
                      SizedBox(height: 60.h * scale),

                      // Red tick icon built in code (no external asset)
                      Container(
                        width: 100.w * scale,
                        height: 100.w * scale,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFEAEA),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.cancel_rounded,
                            size: 64.w * scale,
                            color: const Color(0xFFD92D20), // red
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h * scale),

                      Text(
                        titleText,
                        style: TextStyle(
                          color: const Color(0xFFD92D20),
                          fontSize: 20.sp * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      // Optional IDs for debugging/support context
                      if ((orderId ?? '').isNotEmpty || (paymentId ?? '').isNotEmpty) ...[
                        SizedBox(height: 8.h * scale),
                        Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: 6.h * scale,
                          spacing: 8.w * scale,
                          children: [
                            if ((orderId ?? '').isNotEmpty)
                              _pill('Order: $orderId', scale),
                            if ((paymentId ?? '').isNotEmpty)
                              _pill('Payment: $paymentId', scale),
                          ],
                        ),
                      ],

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h * scale),
                        child: Text(
                          descText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF161616),
                            fontSize: 16.sp * scale,
                          ),
                        ),
                      ),

                      // Suggestion text
                      Text(
                        'No money was deducted. You may try again or choose another payment method.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp * scale,
                          color: const Color(0xFF757575),
                        ),
                      ),

                      SizedBox(height: 16.h * scale),
                    ],
                  ),
                ),
              ),

              // Fixed bottom button area
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w * scale, 8.h * scale, 16.w * scale, 16.h * scale),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 47.h * scale,
                        child: ElevatedButton(
                          onPressed: () {
                            // Return to booking screen so user can retry
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE47830),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10 * scale),
                            ),
                          ),
                          child: Text(
                            'Go to Home',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16.sp * scale,
                              color: Colors.white,
                              letterSpacing: 0.32,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h * scale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _pill(String text, double scale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w * scale, vertical: 6.h * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: const Color(0xFFFAD4D4)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp * scale, color: const Color(0xFFD92D20)),
      ),
    );
  }
}
