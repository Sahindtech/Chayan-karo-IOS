import 'package:chayankaro/views/booking/PaymentScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chayankaro/views/booking/Summaryscreen.dart';
import 'package:chayankaro/views/rewards/ReferAndEarnScreen.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../rewards/rewards_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../profile/EditProfileScreen.dart';
import '../profile/manage_address_screen.dart';
import '../profile/help_screen.dart';
import '../profile/rating_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/chayan_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;

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
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RewardsScreen()));
        break;
      case 4:
        break;
    }
  }

Widget buildQuickAction(String label, String iconAssetPath) {
  return Container(
    width: 97.w,
    height: 100.h,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.w,
          color: const Color(0xB5E47830),
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: const ShapeDecoration(
              shape: OvalBorder(),
            ),
            child: SvgPicture.asset(
              iconAssetPath,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 36.h, // Allocate enough vertical space for 2 lines
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF161616),
                fontSize: 12.sp, // Slightly reduced to prevent cutoff
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget buildListItem(String iconPath, String label, {VoidCallback? onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
    leading: SvgPicture.asset(
      iconPath,
      width: 20.w,
      height: 20.h,
      color: Colors.black,
    ),
    title: Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
    ),
    trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
    onTap: onTap,
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ChayanHeader(title: 'Profile', onBackTap: () {  },),
          Expanded(
            child: ListView(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                SizedBox(height: 24.h),
                Row(
                  children: [
                    CircleAvatar(radius: 40,
                      backgroundImage: AssetImage('assets/userprofile.webp'),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          'Ayush Srivastav (LALA)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '+91 7355640235',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF161616),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Opacity(
                          opacity: 0.55,
                          child: Text(
                            '9.9 Rating',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF161616),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE47830),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
               Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen())),
  child: buildQuickAction("My Bookings", 'assets/icons/bookings.svg'),
),
GestureDetector(
  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardsScreen())),
  child: buildQuickAction("My Chayan Coins", 'assets/icons/coins.svg'),
),
GestureDetector(
  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
  child: buildQuickAction("Help & Support", 'assets/icons/help.svg'),
),

  ],
),

                SizedBox(height: 24.h),
                const Divider(color: Color(0xFFEBEBEB)),
                buildListItem('assets/icons/location.svg', "Manage Address", onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAddressScreen()));
}),
buildListItem('assets/icons/refer.svg', "Refer & Earn", onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferAndEarnScreen()));
}),
buildListItem('assets/icons/rate.svg', "Rate us", onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (_) => RatingScreen()));
}),
buildListItem('assets/icons/about.svg', "About Chayan karo Services", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                }),
buildListItem('assets/icons/settings.svg', "Settings", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SummaryScreen()));
                }),
buildListItem('assets/icons/logout.svg', "Logout"),

                SizedBox(height: 20.h),
                Container(
  padding: EdgeInsets.all(20.r),
  decoration: BoxDecoration(
    color: const Color(0xFFFFEDE0),
    borderRadius: BorderRadius.circular(12.r),
  ),
  child: Row(
    children: [
      // Expanded text column first
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              'Refer & earn 100 coins',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Get 100 coins when your friend completes their first booking',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 16.w),
      // Move the gift icon to the right
      SvgPicture.asset(
        'assets/icons/gifty.svg',
        height: 57.h,
        width: 57.w,
      ),
    ],
  ),
),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}