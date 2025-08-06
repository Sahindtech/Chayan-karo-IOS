import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/location_popup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String _phoneNumber = "";
  List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _phoneNumber = args;
    }
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _loginWithOtp() {
    String otp = _otpControllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // TODO: Replace this with real login logic
Navigator.pushReplacementNamed(context, '/home');    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the 4-digit OTP")),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Container(
          width: 55,
          height: 55,
          child: TextField(
            controller: _otpControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'SFProSemibold',
              color: Colors.black,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF6F00), width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Enter verification code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                "We have sent you a 4 digit verification code on +91 $_phoneNumber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFProRegular',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildOtpFields(),
            ),
            SizedBox(height: 16),
            if (!_canResend)
              Text(
                "Resend available in $_secondsRemaining sec",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'SFProRegular',
                  color: Colors.grey[600],
                ),
              )
            else
              TextButton(
                onPressed: () {
                  _startTimer();
                  // TODO: Resend OTP logic
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontFamily: 'SFProSemibold',
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ),
            Spacer(),
            ElevatedButton(
              onPressed: _loginWithOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6F00),
                minimumSize: Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFProSemibold',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
