import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../widgets/chayan_header.dart';
import 'cancel_booking_screen.dart';
import 'showReschedulePopup.dart';
import 'Helpscreen.dart';
import 'EmergencyScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';



class UpcomingBookingScreen extends StatelessWidget {
  const UpcomingBookingScreen({super.key});

@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xFFFFEEE0),
      statusBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            ChayanHeader(title: 'Upcoming Booking', onBackTap: () {}),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Date + Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('22nd', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp)),
                            Text('Nov, Tuesday', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp)),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen()));
                              },
                              child: _actionButton('Help', 'assets/icons/help.svg', const Color(0xFFE47830)),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyScreen()));
                              },
                              child: _actionButton('Emergency', 'assets/icons/emergency.svg', const Color(0xFFFF3300)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Service Cards
                    _bookingCard('assets/facial.webp', 'Diamond Facial', '2 hrs', 'Includes lorem ipsum'),
                    SizedBox(height: 16.h),
                    _bookingCard('assets/cleanup.webp', 'Cleanup', '30 mins', 'Includes lorem'),

                    SizedBox(height: 20.h),

                    // Billing
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFF3F3F3), width: 2.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Billing Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                          SizedBox(height: 16.h),
                          _billingRow('Item Total', '₹699'),
                          _billingRow('Item Discount', '-₹50', valueColor: const Color(0xFF52B46B)),
                          _billingRow('Service Fee', '₹50'),
                          Divider(height: 30.h),
                          _billingRow('Grand Total', '₹749', isBold: true),
                          SizedBox(height: 16.h),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                Text('Payment mode', style: TextStyle(fontSize: 14.sp)),
                                Text('Paytm UPI', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Address Section
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFF3F3F3), width: 2.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow('assets/icons/home.svg', 'Home'),
                          SizedBox(height: 4.h),
                          Padding(padding: EdgeInsets.only(left: 32.r),
                            child: Text(
                              'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033, Ph: +91234567890',
                              style: TextStyle(fontSize: 12.sp, color: Color(0xFF757575), height: 1.5.h),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _infoRow('assets/icons/calendar.svg', 'Sat, Apr 09 - 07:30 PM'),
                          SizedBox(height: 12.h),
                          _infoRow('assets/icons/user.svg', 'Sumit Gupta, (180+ work), 4.5 rating'),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Buttons
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CancelBookingScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showReschedulePopup(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE47830),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Reschedule', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _actionButton(String label, String iconPath, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    height: 28.h,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: SvgPicture.asset(iconPath, width: 16.w, height: 16.h),
        ),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}


 Widget _bookingCard(String imagePath, String title, String duration, String subtitle) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFF3F3F3), width: 2.w),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(imagePath, width: 100.w, height: 100.h, fit: BoxFit.cover),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                _detailRow(duration),
                SizedBox(height: 4.h),
                if (subtitle.isNotEmpty) _detailRow(subtitle),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _billingRow(String label, String value, {Color valueColor = Colors.black, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400, color: valueColor)),
        ],
      ),
    );
  }

  Widget _infoRow(String iconPath, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: SvgPicture.asset(iconPath, width: 20.w, height: 20.h),
      ),
      SizedBox(width: 8.w),
      Expanded(child: Text(text, style: TextStyle(fontSize: 12.sp, color: Color(0xFF757575)))),
    ],
  );
}

Widget _detailRow(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _dot(),
      SizedBox(width: 6.w),
      Expanded(
        child: Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: Color(0xFF757575)),
        ),
      ),
    ],
  );
}

Widget _dot() {
  return Container(
    width: 4.w,
    height: 4.h,
    decoration: const BoxDecoration(
      color: Color(0xFF757575),
      shape: BoxShape.circle,
    ),
  );
}



}