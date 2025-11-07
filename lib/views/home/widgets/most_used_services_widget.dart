import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../all_most_used_services/all_most_used_services_screen.dart';
import './horizontal_service_scroll.dart';
//import './appliances_repairs_section.dart';
//import './salon_men_section.dart';
//import './ac_repair_section.dart';
//import './male_spa_section.dart';
//import './spa_women_section.dart';
import 'dynamic_home_sections.dart';
//import './saloon_women_section.dart';

class MostUsedServicesWidget extends StatelessWidget {
  final double scaleFactor;

  const MostUsedServicesWidget({
    Key? key,
    required this.scaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0 * scaleFactor),
      child: Column(
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
              Obx(() {
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
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFFFF6F00),
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Something went wrong',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16 * scaleFactor),
                    child: Text(
                      'View all >',
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

          // HorizontalServiceScroll - now with no extra padding
          const HorizontalServiceScroll(),

          // ✅ Consistent 24.h spacing after horizontal scroll
          SizedBox(height: 24.h * scaleFactor),

          // All subsequent sections with consistent 24.h spacing
          // const SaloonWomenSection(),
          // SizedBox(height: 24.h * scaleFactor),

          //const SpaWomenSection(),
                      DynamicHomeSections(),

          SizedBox(height: 24.h * scaleFactor),

          // const MaleSpaSection(),
          // SizedBox(height: 24.h * scaleFactor),

          // const SalonMenSection(),
        //  SizedBox(height: 24.h * scaleFactor),

         // const ACRepairSection(),
        //  SizedBox(height: 24.h * scaleFactor),

         // const AppliancesRepairsSection(),
         // SizedBox(height: 24.h * scaleFactor),
        ],
      ),
    );
  }
}
