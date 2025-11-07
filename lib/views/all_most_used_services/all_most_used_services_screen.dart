import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/common_top_bar.dart';

class AllMostUsedServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? mostUsedServicesFromHome;

  const AllMostUsedServicesScreen({
    super.key,
    this.mostUsedServicesFromHome, // optional
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/chayan-sathi');
        break;
      case 1:
        Get.offAllNamed('/bookings');
        break;
      case 2:
        Get.back();
        break;
      case 3:
        Get.offAllNamed('/rewards');
        break;
      case 4:
        Get.offAllNamed('/profile');
        break;
      default:
        Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ If no data is passed from horizontal widget, show default list
    final List<Map<String, dynamic>> mostUsedServices =
        mostUsedServicesFromHome ??
            [
                  {
        "title": "Hair Keratin Treatment",
        "image": "assets/x1.jpg",
        "rating": "4.8 (2.3k)",
        "newPrice": 499,
        "oldPrice": 599,
      },
      {
        "title": "Hair Trimming",
        "image": "assets/x2.jpg",
        "rating": "4.7 (1.8k)",
        "newPrice": 699,
        "oldPrice": 899,
      },
      {
        "title": "Full Body Bleach-Oxylife",
        "image": "assets/x3.jpg",
        "rating": "4.6 (1.2k)",
        "newPrice": 399,
        "oldPrice": 499,
      },
      {
        "title": "Chest Bleach-O3+",
        "image": "assets/x4.jpg",
        "rating": "4.9 (3.1k)",
        "newPrice": 299,
        "oldPrice": 399,
      },
      {
        "title": "Deep Tissue Massage-Back",
        "image": "assets/x5.jpg",
        "rating": "4.5 (900)",
        "newPrice": 549,
        "oldPrice": 699,
      },
      {
        "title": "Swedish Massage-Full Body",
        "image": "assets/x6.jpg",
        "rating": "4.4 (750)",
        "newPrice": 799,
        "oldPrice": 999,
      },
            ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        double gridSpacing = isTablet ? 20.w : 16.w;
        double gridPadding = isTablet ? 24.w : 16.w;
        double titleFontSize = isTablet ? 16.sp : 14.sp;
        double ratingFontSize = isTablet ? 14.sp : 12.sp;
        double oldPriceFontSize = isTablet ? 14.sp : 12.sp;
        double newPriceFontSize = isTablet ? 16.sp : 14.sp;
        double imageHeight = isTablet ? 140.h : 110.h;
        double cardRadius = isTablet ? 16 : 12;
        double starSize = isTablet ? 16.h : 14.h;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                const CommonTopBar(
                  title: 'Most Used Services',
                  showShareIcon: true,
                ),
                SizedBox(height: 12.h * scaleFactor),

                if (mostUsedServices.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No services available',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: gridPadding),
                      child: GridView.builder(
                        itemCount: mostUsedServices.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          mainAxisSpacing: gridSpacing,
                          crossAxisSpacing: gridSpacing,
                          childAspectRatio: isTablet ? 0.75 : 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final service = mostUsedServices[index];
                          return GestureDetector(
                            onTap: () {
                              Get.snackbar(
                                'Service Selected',
                                '${service["title"]} tapped',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFFFF6F00),
                                colorText: Colors.white,
                                duration: const Duration(seconds: 1),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(cardRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(cardRadius),
                                    ),
                                    child: Image.asset(
                                      service["image"],
                                      width: double.infinity,
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        color: Colors.grey[200],
                                        height: imageHeight,
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.r * scaleFactor),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            service["title"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: titleFontSize,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/star.svg',
                                                    height: starSize,
                                                    width: starSize,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.amber,
                                                            BlendMode.srcIn),
                                                    placeholderBuilder: (_) =>
                                                        Icon(
                                                      Icons.star,
                                                      size: starSize,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '4.8 (23k)',
                                                    style: TextStyle(
                                                      fontSize: ratingFontSize,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h * scaleFactor),
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹${service["oldPrice"]}',
                                                    style: TextStyle(
                                                      fontSize: oldPriceFontSize,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.black38,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    '₹${service["newPrice"]}',
                                                    style: TextStyle(
                                                      fontSize: newPriceFontSize,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          const Color(0xFFFF6F00),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 2,
            onItemTapped: (index) => _onItemTapped(context, index),
          ),
        );
      },
    );
  }
}
