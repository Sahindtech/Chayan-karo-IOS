import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0x66FF9437),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How it works?',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '• Invite your friends & get rewarded',
            style: TextStyle(fontSize: 15.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '• They get 100 coins on their first service',
            style: TextStyle(fontSize: 15.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '• You get 100 coins once their service is completed',
            style: TextStyle(fontSize: 15.sp),
          ),
        ],
      ),
    );
  }
}