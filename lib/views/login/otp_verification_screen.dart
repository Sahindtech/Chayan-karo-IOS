import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // <--- ADD THIS IMPORT AT THE TOP
import 'package:get/get.dart';
import '../../controllers/otp_controller.dart';
import '../../utils/test_extensions.dart'; // Adjust path if needed

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final OtpController controller = Get.put(OtpController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            // In your existing code:
leading: IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () {
    FocusScope.of(context).unfocus(); // Close keyboard gracefully
    Get.back(); // Then navigate
  },
).withId('otp_back_btn'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w * scaleFactor,
              vertical: 20.h * scaleFactor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h * scaleFactor),

                // Title
                Center(
                  child: Text(
                    "Enter verification code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp * scaleFactor,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 8.h * scaleFactor),

                // Subtitle with phone number
                Center(
                  child: Obx(() => Text(
                    "We have sent you a 4 digit verification code on +91 ${controller.phoneNumber}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp * scaleFactor,
                      fontFamily: 'SFProRegular',
                      color: Colors.black87,
                    ),
                  )),
                ),

                SizedBox(height: 32.h * scaleFactor),

                // OTP Input Fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w * scaleFactor),
                  child: _buildOtpFields(controller, scaleFactor),
                ),

                SizedBox(height: 16.h * scaleFactor),

                // --- ERROR CONTAINER REMOVED HERE ---
  // 1. Spacing after OTP fields
SizedBox(height: 16.h * scaleFactor),

// 2. Conditional Referral Field + Dynamic Bottom Spacing
Obx(() {
  if (controller.isExistingUser) {
    // If user exists, we only provide a small standard gap
    return SizedBox(height: 8.h * scaleFactor);
  }
  
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w * scaleFactor),
        child: TextField(
          controller: controller.referralController,
          style: TextStyle(fontSize: 16.sp * scaleFactor),
          decoration: InputDecoration(
            hintText: "Referral Code (Optional)",
            hintStyle: TextStyle(
              fontSize: 14.sp * scaleFactor, 
              color: Colors.grey,
              fontFamily: 'SFProRegular'
            ),
            prefixIcon: Icon(
              Icons.card_giftcard, 
              color: const Color(0xFFFF6F00),
              size: 20.w * scaleFactor,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.h * scaleFactor, 
              horizontal: 15.w * scaleFactor
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scaleFactor),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scaleFactor),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scaleFactor),
              borderSide: const BorderSide(color: Color(0xFFFF6F00)),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ),
      // ✨ Dynamic padding added BELOW the referral field
      SizedBox(height: 20.h * scaleFactor), 
    ],
  );
}),

                // Resend OTP / Timer
                Obx(() => !controller.canResend
                    ? Text(
                        "Resend available in ${controller.secondsRemaining} sec",
                        style: TextStyle(
                          fontSize: 13.sp * scaleFactor,
                          fontFamily: 'SFProRegular',
                          color: Colors.grey[600],
                        ),
                      )
                    : TextButton(
                        onPressed: controller.isLoading ? null : controller.resendOTP,
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontSize: 14.sp * scaleFactor,
                            fontFamily: 'SFProSemibold',
                            color: controller.isLoading ? Colors.grey : Color(0xFFFF6F00),
                          ),
                        ),
                      )).withId('otp_resend_btn'),

                Spacer(),

                // Verify Button
                Obx(() => ElevatedButton(
                  onPressed: controller.isButtonEnabled && !controller.isLoading
                      ? controller.verifyOTP
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isButtonEnabled && !controller.isLoading
                        ? Color(0xFFFF6F00)
                        : Colors.grey[300],
                    minimumSize: Size(double.infinity, 55.h * scaleFactor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r * scaleFactor),
                    ),
                  ),
                  child: controller.isLoading
                      ? SizedBox(
                          width: 20.w * scaleFactor,
                          height: 20.h * scaleFactor,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Verify & Login",
                          style: TextStyle(
                            fontSize: 16.sp * scaleFactor,
                            fontFamily: 'SFProSemibold',
                            color: controller.isButtonEnabled && !controller.isLoading
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                )).withId('otp_verify_btn'),

                SizedBox(height: 24.h * scaleFactor),
              ],
            ),
          ),
        );
      },
    );
  }

// 1. Create a static or persistent list of FocusNodes for the listeners 
// OR better yet, pass the TextField focusNode to the listener.

Widget _buildOtpFields(OtpController controller, double scaleFactor) {
  return GestureDetector(
    onTap: () {
      controller.otpFocusNode.requestFocus();
    },
    child: Stack(
      children: [
        // 🔥 HIDDEN TEXTFIELD
        Opacity(
          opacity: 0,
          child: TextField(
            controller: controller.otpController,
            focusNode: controller.otpFocusNode,
            keyboardType: TextInputType.number,
            autofocus: true,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),

        // 🎯 VISIBLE OTP BOXES
        Obx(() {
          final otp = controller.otp;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final isFilled = index < otp.length;
              final digit = isFilled ? otp[index] : '';

              return Container(
                width: (55.w * scaleFactor).roundToDouble(),
                height: (55.h * scaleFactor).roundToDouble(),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12.r * scaleFactor),
                  border: Border.all(
                    color: isFilled
                        ? const Color(0xFFFF6F00)
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  color: Colors.grey[50],
                ),
                child: Text(
                  digit,
                  style: TextStyle(
                    fontSize: 22.sp * scaleFactor,
                    fontFamily: 'SFProSemibold',
                    color: Colors.black,
                  ),
                ),
              );
            }),
          );
        }),
      ],
    ),
  );
}}