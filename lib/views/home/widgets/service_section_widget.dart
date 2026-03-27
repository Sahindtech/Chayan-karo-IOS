import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../widgets/service_bottom_sheet.dart';
import '../../../models/home_models.dart';

class ServiceSectionWidget extends StatelessWidget {
  final String title;
  final double scaleFactor;

  const ServiceSectionWidget({
    super.key,
    required this.title,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = 170.w * scaleFactor;
        double cardHeight = 220.h * scaleFactor;
        double titleFontSize = 15.sp * scaleFactor;
        double itemTitleFont = 12.sp * scaleFactor;
        double itemSubtitleFont = 10.sp * scaleFactor;
        double paddingScale = scaleFactor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static title - no Obx needed
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * paddingScale),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: titleFontSize,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
            SizedBox(height: 12.h * paddingScale),

            // ✅ FIXED: Only wrap reactive content with Obx
            Obx(() {
              final homeController = Get.find<HomeController>();
              final goToServices = homeController.goToServices;

              // Handle loading state
              if (homeController.isLoading && goToServices.isEmpty) {
                return SizedBox(
                  height: cardHeight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6F00),
                    ),
                  ),
                );
              }

              // Handle empty state
              if (goToServices.isEmpty) {
                return SizedBox(
                  height: cardHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 48 * paddingScale,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8.h * paddingScale),
                        Text(
                          'No services available',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16 * paddingScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Build service content
              return SizedBox(
                height: cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 12 * paddingScale),
                  itemCount: goToServices.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w * paddingScale),
                  itemBuilder: (context, index) {
                    final item = goToServices[index];
                    
                    return GestureDetector(
                      onTap: () {
                        try {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ServiceBottomSheet(
                              title: item.title,
                              subtitle: item.subtitle,
                              images: item.images,
                            ),
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Unable to show service details',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Container(
                        width: cardWidth,
                        padding: EdgeInsets.all(8 * paddingScale),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12 * paddingScale),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x11000000),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Grid
                            SizedBox(
                              height: (cardHeight - 60 * paddingScale),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: item.images.length > 4 ? 4 : item.images.length,
                                padding: EdgeInsets.zero,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (_, i) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8 * paddingScale),
                                    child: Image.asset(
                                      item.images[i],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: const Color(0xFFFF6F00),
                                            size: 16.sp * paddingScale,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            SizedBox(height: 6.h * paddingScale),
                            
                            // Service Title
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: itemTitleFont,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            SizedBox(height: 4.h * paddingScale),
                            
                            // Service Subtitle
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: itemSubtitleFont,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
