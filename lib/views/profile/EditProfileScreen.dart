import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/chayan_header.dart'; // Make sure this is the correct path
import 'package:flutter_svg/flutter_svg.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFFFFEDE0), // Status bar background
        statusBarIconBrightness: Brightness.dark, // Status bar icons
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ✅ Chayan Header
            ChayanHeader(title: 'Edit Profile', onBackTap: () {  },),

            // Profile image with edit icon
            Positioned(
              top: 131,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(62),
                        image: const DecorationImage(
                          image: AssetImage('assets/userprofile.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE47830),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form content
            Positioned.fill(
              top: 260,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profileField(label: 'Full Name', value: 'Ayush Srivastav (LALA)'),
                    profileField(label: 'Email', value: 'ayushsrivastav047@gmail.com'),
                    profileField(label: 'Mobile Number', value: '+91 7355640235'),
                    profileField(label: 'Gender', value: 'Male'),

                   Spacer(),

SafeArea(
  minimum: const EdgeInsets.only(bottom: 16),
  child: SizedBox(
    width: double.infinity,
    height: 47,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE47830),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Save changes',
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.32,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
            height: 1.83,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161616),
                ),
              ),
            ),
           SvgPicture.asset(
              'assets/icons/check.svg',
              width: 18,
              height: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 2,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
