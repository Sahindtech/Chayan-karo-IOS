import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.only(top: 64, bottom: 16),
            child: Center(
              child: Container(
  width: 340,
  height: 240,
  alignment: Alignment.center, // Optional: to center the SVG
  child: SvgPicture.asset(
    "assets/icons/logo.svg",
    fit: BoxFit.contain,
    width: 340,
    height: 240,
  ),
),
            ),
          ),

          // Patch for smooth transition
          Container(
            width: double.infinity,
            height: 16,
            color: const Color(0xFFF2F4FF),
          ),

          // Expanded section with scrollable content + fixed bottom section
          Expanded(
            child: Stack(
              children: [
                // Scrollable content
                Padding(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    children: [
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(
                          fontFamily: 'SFProRegular',
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Enter your 10-digit number",
                          prefixIcon: Container(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "+91",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFProSemibold',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: const Color(0xFF79747E),
                                ),
                              ],
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF79747E)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6F00),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "An OTP will be sent on given phone number for verification.\nStandard message and data rates apply.",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          height: 1.5,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom fixed section
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled ? _continueToOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonEnabled
                                  ? const Color(0xFFFF6F00)
                                  : const Color(0xFFE6EAFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Get Verification OTP",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SFProSemibold',
                                color: _isButtonEnabled
                                    ? Colors.white
                                    : const Color(0xFF757575),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "By Continuing, You agree to our T&C and Privacy Policy",
                          style: TextStyle(
                            fontSize: 10,
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
