import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/ACServicesScreen.dart';

class ACRepairSection extends StatelessWidget {
  const ACRepairSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('AC Repair',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ACServicesScreen(),
                  ),
                );
              },
              child: Padding(padding: EdgeInsets.only(right: 16.r),
                child: Text(
                  'View all >',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Scrollable Cards
        SizedBox(
          height: 200.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _ACRepairCard(
                imagePath: 'assets/ac_services.webp',
                title: 'AC Services',
              ),
              _ACRepairCard(
                imagePath: 'assets/ac_repair.webp',
                title: 'AC Repair & Gas Refill',
              ),
              _ACRepairCard(
                imagePath: 'assets/ac_installation.webp',
                title: 'AC Installation',
              ),
              _ACRepairCard(
                imagePath: 'assets/ac_uninstallation.webp',
                title: 'AC Uninstallation',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ACRepairCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const _ACRepairCard({
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.r),
      width: 144.w,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFFFD9BE), width: 1.w),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFFFD9BE),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}