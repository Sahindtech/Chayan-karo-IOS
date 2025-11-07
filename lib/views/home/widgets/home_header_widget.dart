// lib/views/home/widgets/home_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../cart/cart_screen.dart';
import '../../../services/SearchScreen.dart';

class HomeHeaderWidget extends StatelessWidget {
  final double scaleFactor;
  final double horizontalPadding;

  const HomeHeaderWidget({
    Key? key,
    required this.scaleFactor,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFEEE0),
      statusBarIconBrightness: Brightness.dark,
    ));

    final lc = Get.find<LocationController>(); // observe location

    return Container(
      color: const Color(0xFFFFEEE0),
      padding: EdgeInsets.only(bottom: 16.r * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + Cart
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12.h * scaleFactor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Location Section
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/homy.svg',
                        width: 40.w * scaleFactor,
                        height: 40.h * scaleFactor,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        placeholderBuilder: (_) => Icon(
                          Icons.home,
                          size: 40.w * scaleFactor,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w * scaleFactor),
                      Expanded(
                        child: Obx(() {
                          final homeController = Get.find<HomeController>();

                          if (homeController.isLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60.w * scaleFactor,
                                    height: 12.h * scaleFactor,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(height: 4.h * scaleFactor),
                                  Container(
                                    width: 100.w * scaleFactor,
                                    height: 10.h * scaleFactor,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Prefer LocationController.cachedLocation when set,
                          // else fall back to HomeController existing fields.
                          final cached = lc.cachedLocation.value;
                          final label = cached?.label ?? homeController.locationLabel;
                          final fullAddress = cached?.address ?? homeController.address;

                          String cityOnly = '';
                          if (fullAddress.contains(',')) {
                            cityOnly = fullAddress.split(',').last.trim();
                          } else {
                            cityOnly = fullAddress.trim();
                          }

                          return GestureDetector(
                            onTap: () async {
                              // Open the new Zepto-like selector and wait for result
                              final selected = await Get.toNamed('/choice', arguments: 'home_header');
                              // No manual set needed; ChooseLocationSheet already
                              // sets default and updates lc.cachedLocation.
                              // Trigger a rebuild of any HomeController text if you mirror it:
                              if (selected != null) {
                                // Optional: update HomeController fields for legacy code paths
                               // homeController.locationLabel = cached?.label ?? homeController.locationLabel;
                               // homeController.address = cached?.address ?? homeController.address;
                                homeController.update(); // if using GetBuilder in some places
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 12.sp * scaleFactor,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFFFF6F00),
                                            ),
                                          ),
                                          SizedBox(width: 4.w * scaleFactor),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 16.sp * scaleFactor,
                                            color: const Color(0xFFFF6F00),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        cityOnly,
                                        style: TextStyle(
                                          fontSize: 11.sp * scaleFactor,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w * scaleFactor),

                // Cart
                Obx(() {
                  final cartController = Get.find<CartController>();
                  return GestureDetector(
                    onTap: () => Get.to(() => CartScreen()),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/cart.svg',
                          width: 40.w * scaleFactor,
                          height: 40.h * scaleFactor,
                          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          placeholderBuilder: (_) => Icon(
                            Icons.shopping_cart,
                            size: 40.w * scaleFactor,
                            color: Colors.black,
                          ),
                        ),
                        if (cartController.cartItemCount > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: EdgeInsets.all(4.r * scaleFactor),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              constraints: BoxConstraints(
                                minWidth: 18.r * scaleFactor,
                                minHeight: 18.r * scaleFactor,
                              ),
                              child: Center(
                                child: Text(
                                  '${cartController.cartItemCount}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Search bar
          GestureDetector(
            onTap: () => Get.to(() => SearchScreen()),
            child: AbsorbPointer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  height: 48.h * scaleFactor,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F2),
                    borderRadius: BorderRadius.circular(12.r * scaleFactor),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w * scaleFactor),
                        child: Icon(
                          Icons.search,
                          size: 20.r * scaleFactor,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Search for services',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
