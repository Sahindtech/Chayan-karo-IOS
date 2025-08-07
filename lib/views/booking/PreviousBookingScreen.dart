import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PreviousBookingScreen extends StatelessWidget {
  const PreviousBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChayanHeader(
                title: 'Previous Booking',
                onBackTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '19th Nov, Saturday',
                  style: TextStyle(
                    color: Color(0xFF161616),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _bookingCard(
                imageAsset: 'assets/ac_services.webp',
                title: 'AC Service',
                duration: '1 hrs',
                details: 'Includes general cleaning',
              ),
              SizedBox(height: 16.h),
              _bookingCard(
                imageAsset: 'assets/ac_installation.webp',
                title: 'AC Installation',
                duration: '30 mins',
                details: 'Includes lorem',
              ),
              SizedBox(height: 24.h),
              _billingSection(),
              SizedBox(height: 24.h),
              _addressSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingCard({
    required String imageAsset,
    required String title,
    required String duration,
    required String details,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 132.h,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.w, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              margin: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 20.r, bottom: 20.r, right: 12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Color(0xFF161616),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _bulletDot(),
                        SizedBox(width: 6.w),
                        Text(
                          duration,
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        _bulletDot(),
                        SizedBox(width: 6.w),
                        Text(
                          details,
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletDot() {
    return Container(
      width: 4.w,
      height: 4.h,
      decoration: const ShapeDecoration(
        color: Color(0xFF757575),
        shape: OvalBorder(),
      ),
    );
  }

  Widget _billingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.w, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Billing Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
            _billingRow('Item Total', '₹699'),
            _billingRow('Item Discount', '-₹50', color: Color(0xFF52B46B)),
            _billingRow('Service Fee', '₹50'),
            _billingRow('Grand Total', '₹749', isBold: true),
            Container(
              height: 47.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment mode',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp)),
                  Text('Paytm UPI',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          fontSize: 14.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: color ?? const Color(0xFF161616),
              )),
        ],
      ),
    );
  }

  Widget _addressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.w, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/home.svg', width: 20.w, height: 20.h,  color: Colors.black,),
                SizedBox(width: 8.w),
                Text('Home',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: 8.h),
            Text('Plot no.209, Kavuri Hills, Madhapur, Telangana 500033, Ph: +91234567890',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF757575),
                height: 1.5.h,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset('assets/icons/calendar.svg', width: 18.w, height: 18.h,  color: Colors.black,),
                SizedBox(width: 6.w),
                Text('Sat, Apr 09 - 07:30 PM',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF757575),
                      fontFamily: 'SF Pro Display',
                    )),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset('assets/icons/user.svg', width: 20.w, height: 20.h,  color: Colors.black,),
                SizedBox(width: 6.w),
                 Text('Sumit Gupta, (180+ work), 4.5 rating',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF757575),
                      fontFamily: 'SF Pro Display',
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}