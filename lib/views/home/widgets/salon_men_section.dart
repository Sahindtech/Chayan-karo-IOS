import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../services/SalonMenServiceScreen.dart';

class SalonMenSection extends StatelessWidget {
  const SalonMenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        double titleFontSize = 16.sp * scaleFactor;
        double viewAllFontSize = 14.sp * scaleFactor;
        double cardWidth = 144.w * scaleFactor;
        double cardHeight = 164.h * scaleFactor;
        double labelHeight = 22.h * scaleFactor;
        double labelFontSize = 10.sp * scaleFactor;
        double spacing = 12.r * scaleFactor;

        // Static data with service IDs
        final salonMenServices = [
          {
            'imagePath': 'assets/salon_men_haircut_beard.webp',
            'label': 'Haircut & Beard Styling',
            'serviceId': 'beard_trim_shape'
          },
          {
            'imagePath': 'assets/salon_men_haircolor_spa.webp',
            'label': 'Hair Colour & Hair Spa',
            'serviceId': 'classic_haircut'
          },
          {
            'imagePath': 'assets/salon_men_facial_cleanup.webp',
            'label': 'Facial & Cleanup',
            'serviceId': 'charcoal_facial'
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ FIXED: Static title row - no Obx needed for static content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Salon - Men",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const SalonMenServiceScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.r * scaleFactor),
                    child: Text(
                      "View All >",
                      style: TextStyle(
                        color: const Color(0xFFFA9441),
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                        fontSize: viewAllFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h * scaleFactor),

            // ✅ FIXED: Static content - no Obx needed since using static data
            SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w * scaleFactor),
                itemCount: salonMenServices.length,
                separatorBuilder: (_, __) => SizedBox(width: spacing),
                itemBuilder: (context, index) {
                  final item = salonMenServices[index];
                  return _SalonMenTile(
                    imagePath: item['imagePath']!,
                    label: item['label']!,
                    serviceId: item['serviceId']!,
                    width: cardWidth,
                    height: cardHeight,
                    labelHeight: labelHeight,
                    labelFontSize: labelFontSize,
                    scaleFactor: scaleFactor,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SalonMenTile extends StatelessWidget {
  final String imagePath;
  final String label;
  final String serviceId;
  final double width;
  final double height;
  final double labelHeight;
  final double labelFontSize;
  final double scaleFactor;

  const _SalonMenTile({
    required this.imagePath,
    required this.label,
    required this.serviceId,
    required this.width,
    required this.height,
    required this.labelHeight,
    required this.labelFontSize,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          // ✅ FIXED: Using arguments instead of named parameter
                    Get.to(() => SalonMenServiceScreen(scrollToServiceId: serviceId));

        } catch (e) {
          Get.snackbar(
            'Error',
            'Unable to open salon service',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 * scaleFactor),
          border: Border.all(
            color: const Color(0xFFFFD9BE),
            width: 1.w * scaleFactor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10 * scaleFactor),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'salon_men_$serviceId',
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.content_cut,
                        color: const Color(0xFFFF6F00),
                        size: 32.sp * scaleFactor,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: labelHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD9BE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10 * scaleFactor),
                      bottomRight: Radius.circular(10 * scaleFactor),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w * scaleFactor),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
