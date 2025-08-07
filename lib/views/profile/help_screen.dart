import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/chayan_header.dart';


class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<HelpTopic> topics = [
    HelpTopic(
      title: 'Account',
      iconPath: 'assets/icons/profile.svg',
      content: '...',
    ),
    HelpTopic(
      title: 'Getting started with Chayan Karo',
      iconPath: 'assets/icons/about.svg',
      content: '...',
    ),
    HelpTopic(
      title: 'Payment & Chayan Coin',
      iconPath: 'assets/icons/coins.svg',
      content: '...',
    ),
    HelpTopic(
      title: 'Chayan Safety',
      iconPath: 'assets/icons/chayansafety.svg',
      content: '...',
    ),
    HelpTopic(
      title: 'Claim Warranty',
      iconPath: 'assets/icons/warranty.svg',
      content: '...',
    ),
  ];

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://chayankaro.com');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ Custom Header used across screens
          ChayanHeader(
            title: 'Help',
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
               Text(
                  'All Topics',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.24,
                  ),
                ),
                SizedBox(height: 30.h),
                ...topics.map((topic) => HelpExpansionTile(topic: topic, launchUrl: _launchUrl)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HelpTopic {
  final String title;
  final String iconPath;
  final String content;

  HelpTopic({
    required this.title,
    required this.iconPath,
    required this.content,
  });
}

class HelpExpansionTile extends StatelessWidget {
  final HelpTopic topic;
  final VoidCallback launchUrl;

  const HelpExpansionTile({Key? key, required this.topic, required this.launchUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: SvgPicture.asset(
          topic.iconPath,
          height: 26.h,
          width: 26.w,
        ),
      ),
      title: Text(
        topic.title,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0.r, right: 4.0.r, bottom: 16.0.r),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SF Pro',
                height: 1.5.h,
                color: Colors.black87,
              ),
              children: [
                const TextSpan(text: 'At '),
                TextSpan(
                  text: 'chayankaro.com',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = launchUrl,
                ),
                const TextSpan(
                  text:
                      ', booking a service is simple, transparent, and stress-free. We empower you to choose exactly what you need – with the right professional – at your convenience. Enjoy trusted services, seamless booking, and complete peace of mind, all from the comfort of your home.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}