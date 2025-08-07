import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/home_screen.dart';


class BookingCancelledScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            SvgPicture.asset(
                 'assets/icons/cancel.svg',
                  width: 100.w,
                  semanticsLabel: 'Red X icon',), // Red X icon
            SizedBox(height: 16.h),
            Text(
              'Booking Cancelled !',
              style: TextStyle(
                color: Color(0xFFF54343),
                fontSize: 20.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Dear John Kevin you have successfully cancelled your booking of on date ',
                      style: TextStyle(
                        color: Color(0xFF161616),
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: '12 Dec',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: Color(0xFF161616),
                      ),
                    ),
                    TextSpan(
                      text: '. We hope to serve you better :)',
                      style: TextStyle(
                        color: Color(0xFF161616),
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 132.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFF3F3F3), width: 2.w),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/cleanup.webp',
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Diamond Facial',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            color: Color(0xFF161616),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            _dot(),
                            SizedBox(width: 6.w),
                            Text(
                              '1 hr',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xFF757575),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            _dot(),
                            SizedBox(width: 6.w),
                            Text(
                              'Includes dummy info',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xFF757575),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 47.h,
                child: ElevatedButton(
onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
    (route) => false,
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE47830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Go back',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 16.sp,
                      color: Colors.white,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 4.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Color(0xFF757575),
        shape: BoxShape.circle,
      ),
    );
  }
}