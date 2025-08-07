import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _isButtonEnabled = _phoneController.text.length == 10;
      });
    });
  }

  void _continueToOtp() {
    Navigator.pushNamed(context, '/otp', arguments: _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with logo
            Container(
              width: double.infinity,
              color: const Color(0xFFF2F4FF),
              padding: EdgeInsets.only(top: 64.h, bottom: 16.h),
              child: Center(
                child: SizedBox(
                  width: 340.w,
                  height: 240.h,
                  child: SvgPicture.asset(
                    "assets/icons/logo.svg",
                    fit: BoxFit.contain,
                    width: 340.w,
                    height: 240.h,
                  ),
                ),
              ),
            ),

            // Patch for smooth transition
            Container(
              width: double.infinity,
              height: 16.h,
              color: const Color(0xFFF2F4FF),
            ),

            // Expanded section with scrollable content + fixed bottom section
            Expanded(
              child: Stack(
                children: [
                  // Scrollable content
                  Padding(
                    padding: EdgeInsets.only(bottom: 120.h),
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      children: [
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: TextStyle(
                            fontFamily: 'SFProRegular',
                            fontSize: 16.sp,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter your 10-digit number",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 12.w, right: 8.w),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "+91",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProSemibold',
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 1.w,
                                    height: 28.h,
                                    color: const Color(0xFF79747E),
                                  ),
                                ],
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Color(0xFF79747E)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: Color(0xFFFF6F00),
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "An OTP will be sent on given phone number for verification.\nStandard message and data rates apply.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            height: 1.5,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom fixed section
                  Positioned(
                    bottom: 0.h,
                    left: 0.w,
                    right: 0.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: _isButtonEnabled ? _continueToOtp : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isButtonEnabled
                                    ? const Color(0xFFFF6F00)
                                    : const Color(0xFFE6EAFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Get Verification OTP",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'SFProSemibold',
                                  color: _isButtonEnabled
                                      ? Colors.white
                                      : const Color(0xFF757575),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "By Continuing, You agree to our T&C and Privacy Policy",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'SFProRegular',
                              color: Colors.black.withOpacity(0.8),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
