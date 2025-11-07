import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'upcoming_booking_screen.dart';
import 'PreviousBookingScreen.dart';
import 'feedback_screen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 1;
  bool showUpcoming = true;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  Widget buildTabBar(double scaleFactor) {
    return Container(
      color: const Color(0xFFFFEDE0),
      padding: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 12.h * scaleFactor),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() => showUpcoming = true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w500,
                      color: showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                    ),
                  ),
                  if (showUpcoming)
                    Container(
                      margin: EdgeInsets.only(top: 4.r * scaleFactor),
                      width: 76.w * scaleFactor,
                      height: 4.h * scaleFactor,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE47830),
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => showUpcoming = false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w400,
                      color: !showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                    ),
                  ),
                  if (!showUpcoming)
                    Container(
                      margin: EdgeInsets.only(top: 4.r * scaleFactor),
                      width: 72.w * scaleFactor,
                      height: 4.h * scaleFactor,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE47830),
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterChips(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 12.h * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['Warranty', 'Cancelled', 'Delivered'].map((label) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h * scaleFactor, vertical: 5.h * scaleFactor),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x66FF9437)),
              borderRadius: BorderRadius.circular(10 * scaleFactor),
              color: Colors.white,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPinBoxes(String pin, double scaleFactor) {
    return Row(
      children: pin.split('').map((digit) {
        return Container(
          margin: EdgeInsets.only(left: 4.r * scaleFactor),
          width: 20.w * scaleFactor,
          height: 22.h * scaleFactor,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(4 * scaleFactor),
          ),
          child: Text(
            digit,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp * scaleFactor,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildUpcomingCard(double scaleFactor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UpcomingBookingScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 10.h * scaleFactor),
        padding: EdgeInsets.all(16.r * scaleFactor),
        decoration: BoxDecoration(
          color: const Color(0xFFECEEFF),
          borderRadius: BorderRadius.circular(16 * scaleFactor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salon for Woman',
                  style: TextStyle(
                    fontSize: 20.sp * scaleFactor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: const Color(0xFF161616),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Your PIN',
                      style: TextStyle(
                        fontSize: 10.sp * scaleFactor,
                        color: const Color(0xFF161616),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h * scaleFactor),
                    buildPinBoxes("3333", scaleFactor),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h * scaleFactor),
            Text('• Diamond Facial', style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF555555))),
            SizedBox(height: 2.h * scaleFactor),
            Text('• Cleanup', style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF555555))),
            SizedBox(height: 12.h * scaleFactor),
            Text('Booking scheduled', style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.w600)),
            SizedBox(height: 4.h * scaleFactor),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '22nd Nov, Tuesday / ', style: TextStyle(fontSize: 13.sp * scaleFactor)),
                  TextSpan(text: '07:30 PM', style: TextStyle(fontSize: 10.sp * scaleFactor)),
                ],
              ),
            ),
            SizedBox(height: 4.h * scaleFactor),
            Text(
              'When Your Chayan sathi arrives share your PIN',
              style: TextStyle(fontSize: 8.sp * scaleFactor, color: Colors.black.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreviousCard(double scaleFactor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 10.h * scaleFactor),
      padding: EdgeInsets.all(16.r * scaleFactor),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16 * scaleFactor),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('19th Nov, Saturday', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp * scaleFactor)),
            Text('AC service', style: TextStyle(color: Colors.black54, fontSize: 14.sp * scaleFactor)),
          ]),
          SizedBox(height: 8.h * scaleFactor),
          Row(children: [
            Text('• General service', style: TextStyle(color: Colors.black54, fontSize: 12.sp * scaleFactor)),
            Icon(Icons.arrow_drop_down, size: 16 * scaleFactor, color: Colors.black54),
          ]),
          SizedBox(height: 12.h * scaleFactor),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE47830),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scaleFactor)),
                padding: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 8.h * scaleFactor),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
              },
              child: Text('Share Feedback', style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.white)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PreviousBookingScreen()));
              },
              child: Text('View details',
                  style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFFE47830))),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            buildTabBar(scaleFactor),
            Divider(height: 1.h * scaleFactor, color: const Color(0xFFEBEBEB)),
            if (showUpcoming) buildFilterChips(scaleFactor),
            Expanded(
              child: ListView(
                children: showUpcoming
                    ? [buildUpcomingCard(scaleFactor), buildUpcomingCard(scaleFactor)]
                    : [buildPreviousCard(scaleFactor)],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      );
    });
  }
}
