import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFFFFEEE0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isTablet = constraints.maxWidth > 600;
          double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
            body: Stack(
              children: [
                Container(
                  height: 140.h * scaleFactor,
                  width: double.infinity,
                  color: const Color(0xFFFFEEE0),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h * scaleFactor),
                      ChayanHeader(
                        title: 'Refer a Friend',
                        onBack: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 16.r * scaleFactor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFE47830), Color(0xFFFF6E00)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20.h * scaleFactor,
                                    horizontal: 16.h * scaleFactor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Invite your friends to try\nChayan Karo services',
                                                  style: TextStyle(
                                                    fontSize: 18.sp * scaleFactor,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 6.h * scaleFactor),
                                                Text(
                                                  'Share the app with friends and let them explore our services.',
                                                  style: TextStyle(
                                                    fontSize: 13.sp * scaleFactor,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10.w * scaleFactor),
                                          SvgPicture.asset(
                                            'assets/icons/Gift.svg',
                                            width: 80.w * scaleFactor,
                                            height: 80.h * scaleFactor,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h * scaleFactor),
                                      Center(
                                        child: Text(
                                          'Refer via',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp * scaleFactor,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.h * scaleFactor),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          _socialIcon(
                                            FontAwesomeIcons.whatsapp,
                                            'Whatsapp',
                                            const Color(0xFF25D366),
                                            scaleFactor,
                                          ),
                                          _socialIcon(
                                            FontAwesomeIcons.facebookMessenger,
                                            'Messenger',
                                            const Color(0xFF0084FF),
                                            scaleFactor,
                                          ),
                                          _socialIcon(
                                            Icons.copy,
                                            'Copy Link',
                                            Colors.black87,
                                            scaleFactor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24.h * scaleFactor),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16.r * scaleFactor),
                                    decoration: BoxDecoration(
                                      color: const Color(0x66FF9437),
                                      borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'How it works?',
                                          style: TextStyle(
                                            fontSize: 18.sp * scaleFactor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 16.h * scaleFactor),
                                        Text(
                                          '1. Share your referral link with friends',
                                          style: TextStyle(fontSize: 14.sp * scaleFactor),
                                        ),
                                        SizedBox(height: 8.h * scaleFactor),
                                        Text(
                                          '2. Your friends download and explore the app',
                                          style: TextStyle(fontSize: 14.sp * scaleFactor),
                                        ),
                                        SizedBox(height: 8.h * scaleFactor),
                                        Text(
                                          '3. Enjoy helping your friends discover Chayan Karo services!',
                                          style: TextStyle(fontSize: 14.sp * scaleFactor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h * scaleFactor),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Start referring your friends today!',
                                        style: TextStyle(
                                          fontSize: 17.sp * scaleFactor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4.h * scaleFactor),
                                      Opacity(
                                        opacity: 0.75,
                                        child: Text(
                                          'Spread the word and help your friends.',
                                          style: TextStyle(fontSize: 13.sp * scaleFactor),
                                        ),
                                      ),
                                      SizedBox(height: 8.h * scaleFactor),
                                      Text(
                                        '......................................................................................',
                                        style: TextStyle(
                                          fontSize: 12.sp * scaleFactor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8.h * scaleFactor),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 60.h * scaleFactor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label, Color color, double scaleFactor) {
    return Column(
      children: [
        Container(
          width: 54.w * scaleFactor,
          height: 54.h * scaleFactor,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24 * scaleFactor),
          ),
        ),
        SizedBox(height: 8.h * scaleFactor),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.black),
        ),
      ],
    );
  }
}
