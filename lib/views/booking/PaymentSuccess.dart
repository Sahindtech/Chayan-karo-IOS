import 'package:chayankaro/views/booking/booking_successful_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            // Orange check circle
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE6EAFF),
              ),
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE47830),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
            ),

            SizedBox(height: 20.h),
             Text(
              'Great',
              style: TextStyle(
                color: Color(0xFFE47830),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 6.h),
            Text('Payment Success',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF161616),
              ),
            ),
            SizedBox(height: 32.h),

            // Payment Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow('Payment Mode', 'UPI'),
                  SizedBox(height: 16.h),
                  _infoRow('Total Amount', '₹749'),
                  SizedBox(height: 16.h),
                  _infoRow('Pay Date', 'Apr 10, 2022'),
                  SizedBox(height: 16.h),
                  _infoRow('Pay Time', '10:45 am'),
                  SizedBox(height: 24.h),
                  const Divider(thickness: 2, color: Color(0xFFF3F3F3)),
                  SizedBox(height: 16.h),
                   Text(
                    'Total Pay',
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹749',
                    style: TextStyle(
                      color: Color(0xFFE47830),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Done Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 47.h,
                child: ElevatedButton(
                  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingSuccessfulScreen(),
    ),
  );
},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE47830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Done',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                      fontFamily: 'SF Pro Display',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:  TextStyle(
            color: Color(0xFF757575),
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF161616),
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}