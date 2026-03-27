import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/chayan_header.dart';
import '../home/home_screen.dart';

class AboutChaynkaroServicesScreen extends StatelessWidget {
  const AboutChaynkaroServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEDE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Header
                ChayanHeader(
                  title: 'About Chayan Karo',
                      onBack: () => Navigator.pop(context),
                ),

                // Company Logo - Only Logo image displayed, takes large space and acts as box
                Positioned(
                  top: 131.r * scaleFactor,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      width: 180.w * scaleFactor,  // Increased width
                      height: 180.w * scaleFactor, // Increased height
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Content
                Positioned.fill(
                  top: 330.r * scaleFactor, // Adjusted top to give space for bigger logo
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Overview
                        _buildSection(
                          title: 'Who We Are',
                          content: 'Chayan Karo India Private Limited is a home services technology platform that connects customers with verified service professionals. We bring trust, transparency, and quality to the fragmented home services sector in India.',
                          icon: 'assets/icons/mission.svg',
                          scaleFactor: scaleFactor,
                        ),

                        _buildSection(
                          title: 'Our Services',
                          content: 'We offer a comprehensive range of services including:\n• AC servicing, repair & installation\n• Beauty & salon services at home\n• Pest control solutions\n• Carpentry work\n• Home repair services\n• Spa treatments at home',
                          icon: 'assets/icons/services.svg',
                          scaleFactor: scaleFactor,
                        ),

                        _buildSection(
                          title: 'Our Mission',
                          content: 'We integrate traditional Indian values of hospitality, cleanliness, and professionalism with modern technology. Our platform empowers customers to choose their preferred professional based on skill, pricing, and ratings.',
                          icon: 'assets/icons/vision.svg',
                          scaleFactor: scaleFactor,
                        ),

                        _buildSection(
                          title: 'Why Choose Chayan Karo',
                          content: '• App-based booking system\n• AI-powered professional matchmaking\n• Real-time service tracking\n• Transparent pricing\n• Rigorous background verification\n• Skilled & certified professionals\n• Premium affordable services\n• Available across Lucknow',
                          icon: 'assets/icons/star.svg',
                          scaleFactor: scaleFactor,
                        ),

                        _buildSection(
                          title: 'Our Values',
                          content: 'We promote dignity of labor, support economic empowerment of skilled workers, and ensure high-quality service delivery. Chayan Karo is not just a service provider — it\'s a trust platform for homes and a growth engine for India\'s skilled workforce.',
                          icon: 'assets/icons/values.svg',
                          scaleFactor: scaleFactor,
                        ),

                        // Contact Information
                        _buildContactSection(context, scaleFactor),

                        SizedBox(height: 100.h * scaleFactor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required String icon,
    required double scaleFactor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.w * scaleFactor,
              height: 40.w * scaleFactor,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDE0),
                borderRadius: BorderRadius.circular(10 * scaleFactor),
              ),
              child: Center(
                child: Icon(
                  _getIconForTitle(title),
                  size: 20 * scaleFactor,
                  color: const Color(0xFFE47830),
                ),
              ),
            ),
            SizedBox(width: 12.w * scaleFactor),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 18.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF161616),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h * scaleFactor),
        Padding(
          padding: EdgeInsets.only(left: 52.w * scaleFactor),
          child: Text(
            content,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp * scaleFactor,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h * scaleFactor),
        Container(
          height: 1.h * scaleFactor,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 24.h * scaleFactor),
      ],
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Who We Are':
        return Icons.business;
      case 'Our Services':
        return Icons.home_repair_service;
      case 'Our Mission':
        return Icons.rocket_launch;
      case 'Why Choose Chayan Karo':
        return Icons.star;
      case 'Our Values':
        return Icons.favorite;
      default:
        return Icons.business_center;
    }
  }

  Widget _buildContactSection(BuildContext context,double scaleFactor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.w * scaleFactor,
              height: 40.w * scaleFactor,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDE0),
                borderRadius: BorderRadius.circular(10 * scaleFactor),
              ),
              child: Center(
                child: Icon(
                  Icons.contact_mail,
                  size: 20 * scaleFactor,
                  color: const Color(0xFFE47830),
                ),
              ),
            ),
            SizedBox(width: 12.w * scaleFactor),
            Text(
              'Get In Touch',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 18.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF161616),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h * scaleFactor),
        Padding(
          padding: EdgeInsets.only(left: 52.w * scaleFactor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactItem(
                icon: Icons.phone,
                label: 'WhatsApp',
                value: '+91 8299217231',
                scaleFactor: scaleFactor,
              ),
              SizedBox(height: 12.h * scaleFactor),
              _buildContactItem(
                icon: Icons.phone,
                label: 'Phone',
                value: '+91 8188887384',
                scaleFactor: scaleFactor,
              ),
              SizedBox(height: 12.h * scaleFactor),
              _buildContactItem(
                icon: Icons.location_on,
                label: 'Address',
                value: '610/003 Keshavnagar, Sitapur Road, Lucknow, UP 226020',
                scaleFactor: scaleFactor,
              ),
              SizedBox(height: 12.h * scaleFactor),
              _buildContactItem(
                icon: Icons.language,
                label: 'Website',
                value: 'chayankaro.com',
                scaleFactor: scaleFactor,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h * scaleFactor),
        SizedBox(
          width: double.infinity,
          height: 47.h * scaleFactor,
          child: ElevatedButton(
            onPressed: () {Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
);
},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE47830),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10 * scaleFactor),
              ),
            ),
            child: Text(
              'Book Service Now',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16.sp * scaleFactor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required double scaleFactor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16 * scaleFactor,
          color: const Color(0xFFE47830),
        ),
        SizedBox(width: 8.w * scaleFactor),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp * scaleFactor,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF161616),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
