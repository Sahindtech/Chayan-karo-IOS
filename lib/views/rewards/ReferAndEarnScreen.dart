import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart'; // Adjust path
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final int _selectedIndex = 3;
  final ProfileController _profileController = Get.find<ProfileController>();
  String get _referralCode => _profileController.customer?.referralCode ?? "CHAYAN10";

  // Constants
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.chayankaroindia.app';

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BookingScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen()),
        );
        break;
    }
  }
  String get _referMessage =>
      'Hi! I use the Chayan Karo app for home services like cleaning and salon.\n\n'
      'Download now: $_playStoreUrl\n\n'
      'Use my Referral Code: $_referralCode to get started!';
      Future<void> _copyReferralCode() async {
    await Clipboard.setData(ClipboardData(text: _referralCode));
    _showSnack('Referral code copied!');
  }
  // WhatsApp: open chat chooser with prefilled message
  Future<void> _openWhatsApp() async {
    final encodedText = Uri.encodeComponent(_referMessage);

    // api.whatsapp.com works well on most devices
    final uri = Uri.parse('https://api.whatsapp.com/send?text=$encodedText');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnack('Unable to open WhatsApp');
    }
  }

  // Instagram: use system share sheet, user picks Instagram / Instagram DM
  Future<void> _openInstagram() async {
    try {
      await Share.share(
        _referMessage,
        subject: 'Try Chayan Karo for home services',
      );
      // On most Android devices user will see Instagram & Instagram DM
    } catch (e) {
      _showSnack('Unable to share right now');
    }
  }

  // Copy Play Store link only
  Future<void> _copyPlayStoreLink() async {
    await Clipboard.setData(const ClipboardData(text: _playStoreUrl));
    _showSnack('Link copied to clipboard');
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    
    // 1. Clear any currently displaying or queued snackbars immediately
    ScaffoldMessenger.of(context).clearSnackBars();
    
    // 2. Show the new one
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2), // Optional: Keep duration short
        //behavior: SnackBarBehavior.floating, // Optional: Makes it look more like a toast
      ),
    );
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _socialIcon(
                                            icon: FontAwesomeIcons.whatsapp,
                                            label: 'WhatsApp',
                                            color: const Color(0xFF25D366),
                                            scaleFactor: scaleFactor,
                                            onTap: _openWhatsApp,
                                          ),
                                          _socialIcon(
                                            icon: FontAwesomeIcons.instagram,
                                            label: 'Instagram',
                                            color: const Color(0xFFE4405F),
                                            scaleFactor: scaleFactor,
                                            onTap: _openInstagram,
                                          ),
                                          _socialIcon(
                                            icon: Icons.copy,
                                            label: 'Copy Link',
                                            color: Colors.black87,
                                            scaleFactor: scaleFactor,
                                            onTap: _copyPlayStoreLink,
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
    padding: EdgeInsets.all(20.r * scaleFactor),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r * scaleFactor),
      border: Border.all(color: const Color(0xFFFF6E00), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    ),
    child: Column(
      children: [
        Text(
          'Your Referral Code',
          style: TextStyle(
            fontSize: 14.sp * scaleFactor,
            color: Colors.grey[600],
            fontFamily: 'SFProRegular',
          ),
        ),
        SizedBox(height: 10.h * scaleFactor),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _referralCode,
              style: TextStyle(
                fontSize: 24.sp * scaleFactor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: const Color(0xFFFF6E00),
              ),
            ),
            SizedBox(width: 15.w * scaleFactor),
            IconButton(
              onPressed: _copyReferralCode,
              icon: Icon(Icons.copy, color: Colors.grey[700]),
              tooltip: 'Copy Code',
            ),
          ],
        ),
      ],
    ),
  ),
),
SizedBox(height: 24.h * scaleFactor),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w * scaleFactor),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16.r * scaleFactor),
                                    decoration: BoxDecoration(
                                      color: const Color(0x66FF9437),
                                      borderRadius:
                                          BorderRadius.circular(10.r * scaleFactor),
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
                                          '1. Tap on WhatsApp or Instagram to share your referral message.',
                                          style: TextStyle(
                                              fontSize: 14.sp * scaleFactor),
                                        ),
                                        SizedBox(height: 8.h * scaleFactor),
                                        Text(
                                          '2. Select the friends you want to send it to and share the message.',
                                          style: TextStyle(
                                              fontSize: 14.sp * scaleFactor),
                                        ),
                                        SizedBox(height: 8.h * scaleFactor),
                                        Text(
                                          '3. Your friends download the app and start booking services.',
                                          style: TextStyle(
                                              fontSize: 14.sp * scaleFactor),
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
                                          'Spread the word and help them discover easy home services.',
                                          style: TextStyle(
                                              fontSize: 13.sp * scaleFactor),
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

  Widget _socialIcon({
    required IconData icon,
    required String label,
    required Color color,
    required double scaleFactor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(27.r * scaleFactor),
      child: Column(
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
            style: TextStyle(
              fontSize: 12.sp * scaleFactor,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
