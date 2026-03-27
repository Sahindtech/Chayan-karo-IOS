import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/most_used_service_controller.dart'; // Import this
import '../../all_most_used_services/all_most_used_services_screen.dart';
import './horizontal_service_scroll.dart';
import 'dynamic_home_sections.dart';

class MostUsedServicesWidget extends StatelessWidget {
  final double scaleFactor;

  const MostUsedServicesWidget({
    super.key,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller to check data length
    final controller = Get.put(MostUsedServiceController());

    return Padding(
      padding: EdgeInsets.only(left: 12.0 * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // ---------------------------------------------------------
          // PART 1: Most Used Services (Title + Horizontal List)
          // Wrapped in Obx to HIDE ONLY THIS PART if empty
          // ---------------------------------------------------------
          Obx(() {
            // Logic: If not loading AND list is empty -> Hide Title and List
            if (!controller.isLoading.value && controller.mostUsedServices.isEmpty) {
              return const SizedBox.shrink();
            }

            // Otherwise, show Title and Horizontal List
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Title and 'View all >' button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most used services',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp * scaleFactor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                    Builder(builder: (context) {
                      // Keeping your HomeController logic for the button
                      final homeController = Get.find<HomeController>();
                      return GestureDetector(
                        onTap: () {
                          try {
                            if (homeController.mostUsedServices.isNotEmpty) {
                              Get.to(() => const AllMostUsedServicesScreen());
                            } else {
                              Get.snackbar(
                                'No Services',
                                'No services available at the moment',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: const Color(0xFFFF6F00),
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Something went wrong',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16 * scaleFactor),
                          child: Text(
                            'View all ',
                            style: TextStyle(
                              color: homeController.mostUsedServices.isNotEmpty
                                  ? const Color(0xFFFA9441)
                                  : const Color(0xFFFA9441).withOpacity(0.5),
                              fontSize: 14.sp * scaleFactor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                SizedBox(height: 12.h * scaleFactor),

                // Horizontal Scroll List
                const HorizontalServiceScroll(),

                // Spacing after the list
                SizedBox(height: 24.h * scaleFactor),
              ],
            );
          }),

          // ---------------------------------------------------------
          // PART 2: Dynamic Sections
          // OUTSIDE the Obx check, so it ALWAYS shows
          // ---------------------------------------------------------
          const DynamicHomeSections(),
          
        ],
      ),
    );
  }
}