import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LegalModal extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final String content;

  const LegalModal({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Limit height to 85% of screen height
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        // Rounded corners only at the top
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Hug content
        children: [
          
          /// 1. Grey Handle Bar (Better UX for bottom sheets)
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          SizedBox(height: 10.h),

          /// 2. Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontFamily: 'SFProSemibold',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          SizedBox(height: 8.h),

          /// 3. Last Updated
          Text(
            "Last Updated: $lastUpdated",
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'SFProRegular',
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 20.h),

          /// 4. Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'SFProRegular',
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// 5. OK Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'SFProSemibold',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Add safe area padding for iPhone home indicator
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 10.h),
        ],
      ),
    );
  }
}