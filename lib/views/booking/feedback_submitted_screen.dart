import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home_screen.dart';
import '../../widgets/chayan_header.dart';

class FeedbackSubmittedScreen extends StatelessWidget {
  const FeedbackSubmittedScreen({super.key});

  // Social links
  final String instagramUrl = 'https://www.instagram.com/chayankaro?igsh=MWZyOHVhNHV0ZmNrZw==';
  final String facebookUrl = 'https://www.facebook.com/profile.php?id=61575011660245';
  final String youtubeUrl = 'https://youtube.com/@chayankaroindia?si=WT0Ga2xEr6hUSsVg';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ChayanHeader(
              title: 'Feedback',
              onBackTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 40),
            SvgPicture.asset(
              'assets/icons/feedtick.svg',
              semanticsLabel: 'Feedback Tick',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            const Text(
              'Feedback Submitted',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank You! Your Feedback has been\nsubmitted Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE47830)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Go Back',
                style: TextStyle(
                  color: Color(0xFFE47830),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(
                    iconPath: 'assets/icons/insta.svg',
                    onTap: () => _launchUrl(instagramUrl),
                  ),
                  const SizedBox(width: 24),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/fb.svg',
                    onTap: () => _launchUrl(facebookUrl),
                  ),
                  const SizedBox(width: 24),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/youtube.svg',
                    onTap: () => _launchUrl(youtubeUrl),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Our Social Links',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(iconPath, width: 35),
    );
  }
}
