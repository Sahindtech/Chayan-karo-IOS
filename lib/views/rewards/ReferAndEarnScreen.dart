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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChayanSathiScreen()));
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
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        body: Stack(
          children: [
            Container(
              height: 140.h,
              width: double.infinity,
              color: const Color(0xFFFFEEE0),
            ),
            SafeArea(
  child: Column( // ✅ this is required for Expanded to work
    children: [
      SizedBox(height: 10.h),
      ChayanHeader(
        title: 'Refer & Earn',
        onBackTap: () => Navigator.pop(context),
      ),
      Expanded( // ✅ legal inside Column
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16.r),
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
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text(
                                            'Refer and get FREE\nServices',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            'Invite your friends to try Chayan Karo services. They get instant 100 coins off. You win 100 coins once they take a service.',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    SvgPicture.asset(
                                      'assets/icons/Gift.svg',
                                      width: 80.w,
                                      height: 80.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Center(
                                  child: Text(
                                    'Refer via',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _socialIcon(FontAwesomeIcons.whatsapp, 'Whatsapp', Color(0xFF25D366)),
                                    _socialIcon(FontAwesomeIcons.facebookMessenger, 'Messenger', Color(0xFF0084FF)),
                                    _socialIcon(Icons.copy, 'Copy Link', Colors.black87),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: const Color(0x66FF9437),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How it works?',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text('1. Invite your friends & get rewarded', style: TextStyle(fontSize: 14.sp)),
                                  SizedBox(height: 8.h),
                                  Text('2. They get 100 coins on their first service', style: TextStyle(fontSize: 14.sp)),
                                  SizedBox(height: 8.h),
                                  Text('3. You get 100 coins once their service is completed', style: TextStyle(fontSize: 14.sp)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Center(
  child: Column(
    children: [
       Text(
        'You are yet to earn any scratch cards',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      SizedBox(height: 4.h),
      Opacity(
        opacity: 0.75,
        child: Text(
          'Start referring to get surprises',
          style: TextStyle(fontSize: 13.sp),
        ),
      ),
      SizedBox(height: 8.h),
       Text(
        '......................................................................................',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/gifty.svg',
            width: 37.w,
            height: 37.h,
          ),
          SizedBox(width: 6.w),
         Text(
            'Earn 100 coins on every successful referral',
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    ],
  ),
),

                          SizedBox(height: 60.h),
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
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 54.w,
          height: 54.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.black),
        ),
      ],
    );
  }
}