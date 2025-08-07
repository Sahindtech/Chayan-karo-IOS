import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ReviewSubmittedPopup extends StatelessWidget {
  final VoidCallback onOkay;

  const ReviewSubmittedPopup({super.key, required this.onOkay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Card
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 50.r),
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Review Submitted',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Thank You For your Feedback. Your Review has been Sent To the App Successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: 166.w,
                  height: 47.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE47830),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onOkay,
                    child: Text('Okay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Top Circle
          Positioned(
            left: 0.r,
            right: 0.r,
            top: 0.r,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFC3FFD2),
                    ),
                  ),
SvgPicture.asset(
  'assets/icons/gtick.svg',
  width: 90.w,
  height: 100.h,
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}