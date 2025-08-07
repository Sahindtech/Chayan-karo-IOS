import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Terms and conditions        FAQs',
          style: TextStyle(
            fontSize: 11.sp,
            color: Color(0xFF0C3998),
            letterSpacing: 0.55,
          ),
        ),
        SizedBox(height: 24.h),
        Text('You are yet to earn any scratch cards',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.9,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Starts referring to get surprises',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black.withOpacity(0.75),
          ),
        ),
        SizedBox(height: 8.h),
        Text('......................................................................................',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: 8.h),
        Text('Earn 100 coins on every successful referral',
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: 60.h),
      ],
    );
  }
}