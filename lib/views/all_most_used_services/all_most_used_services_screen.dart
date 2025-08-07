import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/common_top_bar.dart'; // ✅ new import
import 'package:flutter_svg/flutter_svg.dart';


class AllMostUsedServicesScreen extends StatelessWidget {
  final List<Map<String, String>> mostUsedServices;

  const AllMostUsedServicesScreen({super.key, required this.mostUsedServices});

  void _onItemTapped(BuildContext context, int index) {
    Navigator.pop(context); // replace with proper navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CommonTopBar(
              title: 'Most used services',
              showShareIcon: true,
            ),
            SizedBox(height: 12.h),

            // Grid of Services
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: mostUsedServices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final service = mostUsedServices[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              service['image']!,
                              width: double.infinity,
                              height: 110.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['title'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/star.svg',
                                      height: 14.h,
                                      width: 14.w,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '4.8 (23k)',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children:  [
                                    Text(
                                      '₹799',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      '₹499',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}