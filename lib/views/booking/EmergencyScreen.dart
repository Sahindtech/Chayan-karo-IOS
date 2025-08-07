import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header stays at top
          ChayanHeader(title: 'Emergency', onBackTap: () {}),
          
          // Main content below header
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: "Need assistance?"
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Need assistance?',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro',
                        letterSpacing: 0.2,
                        color: Color(0xFF161616),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Call for support button
                  Padding(
                    padding: EdgeInsets.only(left: 16.r),
                    child: Container(
                      width: 148.w,
                      height: 33.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 6.w),
                          SvgPicture.asset('assets/icons/help.svg',
                              height: 20.h, width: 20.w, color: Colors.black),
                          SizedBox(width: 10.w),
                          Text('Call For Support',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro',
                              letterSpacing: 0.14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Container(height: 6.h, color: Color(0x7FD9D9D9)),

                  Padding(padding: EdgeInsets.only(left: 16.r, top: 20.r),
                    child: Text(
                      'Local emergency contacts',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro',
                        color: Color(0xFF161616),
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/emergency.svg',
                    label: 'All emergencies',
                    number: 'Call 112',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/police.svg',
                    label: 'Police',
                    number: 'Call 100',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/med.svg',
                    label: 'Medical',
                    number: 'Call 101',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/fire.svg',
                    label: 'Fire',
                    number: 'Call 102',
                  ),
                  _buildDivider(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyRow({
    required String iconAsset,
    required String label,
    required String number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Row(
        children: [
          SvgPicture.asset(iconAsset, width: 25.w, height: 25.h, color: Colors.black),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                letterSpacing: 0.13,
              ),
            ),
          ),
          Text(
            number,
            style: TextStyle(fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro',
              letterSpacing: 0.13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Opacity(
      opacity: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 1.h,
          color: const Color(0xFFD9D9D9),
        ),
      ),
    );
  }
}