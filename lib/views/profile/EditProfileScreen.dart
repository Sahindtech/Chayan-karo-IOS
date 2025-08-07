import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              top: 131.r,
              left: 0.r,
              right: 0.r,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(62),
                        image: DecorationImage(image: AssetImage('assets/userprofile.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.r,
                      bottom: 0.r,
                      child: Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE47830),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(child: Icon(
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
              top: 260.r,
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
  minimum: EdgeInsets.only(bottom: 16.r),
  child: SizedBox(
    width: double.infinity,
    height: 47.h,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE47830),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child:  Text(
        'Save changes',
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.32,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

                    SizedBox(height: 20.h),
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
          style:  TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
            height: 1.83.h,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style:  TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161616),
                ),
              ),
            ),
           SvgPicture.asset(
              'assets/icons/check.svg',
              width: 18.w,
              height: 18.h,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 2.h,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}