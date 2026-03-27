import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';


import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart'; // ✅ Import the reusable header

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final int _selectedIndex = 3;

void _onItemTapped(BuildContext context, int index) {
    if (index == 3) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RewardsScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  void _launchChayanKaro() async {
    const url = 'https://chayankaro.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

@override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFFEEE0), // Match your header bg
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Header under the status bar
              Container(
                width: double.infinity,
                color: const Color(0xFFFFEEE0),
                child: SafeArea(
                  bottom: false,
                  child: ChayanHeader(title: 'Chayan Coins', onBack: () {}),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 90.r * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h * scaleFactor),

                      /// --- Refer & Earn Section ---
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ReferAndEarnScreen()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                          child: Container(
                            padding: EdgeInsets.all(16.r * scaleFactor),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0C7),
                              borderRadius: BorderRadius.circular(12 * scaleFactor),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Refer & earn 100 coins',
                                        style: TextStyle(
                                          fontSize: 15.sp * scaleFactor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 8.h * scaleFactor),
                                      Text(
                                        'Get 100 coins when your friend completes their first booking',
                                        style: TextStyle(fontSize: 12.sp * scaleFactor),
                                      ),
                                      SizedBox(height: 8.h * scaleFactor),
                                      Text(
                                        'Refer now',
                                        style: TextStyle(
                                          fontSize: 14.sp * scaleFactor,
                                          color: const Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w * scaleFactor),
                                SvgPicture.asset(
                                  'assets/icons/gifty.svg',
                                  height: 40.h * scaleFactor,
                                  width: 40.w * scaleFactor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h * scaleFactor),

                      /// --- Coin Balance Section ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/coins.svg',
                              height: 30.h * scaleFactor,
                              width: 30.w * scaleFactor,
                            ),
                            SizedBox(width: 10.w * scaleFactor),
                            Text(
                              'Chayan Coins',
                              style: TextStyle(
                                fontSize: 24.sp * scaleFactor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.h * scaleFactor,
                                vertical: 6.h * scaleFactor,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x2BFF9437),
                                borderRadius: BorderRadius.circular(6 * scaleFactor),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Text(
                                '100',
                                style: TextStyle(
                                  color: const Color(0xFFE47830),
                                  fontSize: 20.sp * scaleFactor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h * scaleFactor),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                        child: Text(
                          'Formely Chayan Coins. Applicable on all services',
                          style: TextStyle(fontSize: 16.sp * scaleFactor),
                        ),
                      ),

                      SizedBox(height: 40.h * scaleFactor),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text(
                            'Have a Question?',
                            style: TextStyle(
                              fontSize: 20.sp * scaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            GestureDetector(
                              onTap: _launchChayanKaro,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 12.r * scaleFactor),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'At ',
                                    children: [
                                      TextSpan(
                                        text: 'chayankaro.com',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      const TextSpan(
                                        text:
                                            ', booking a service is simple, transparent, and stress-free. We empower you to choose exactly what you need - with the right professional - at your convenience. Enjoy trusted services, seamless booking, and complete peace of mind, all from the comfort of your home.',
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14.sp * scaleFactor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.h * scaleFactor,
                          vertical: 12.h * scaleFactor,
                        ),
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                        child: Text(
                          'Wallet Activity',
                          style: TextStyle(fontSize: 20.sp * scaleFactor),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.h * scaleFactor,
                          vertical: 12.h * scaleFactor,
                        ),
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3, // Hardcoded 3
        onItemTapped: (index) => _onItemTapped(context, index), // Correct call
      ),
        ),
      );
    },
  );
}

}