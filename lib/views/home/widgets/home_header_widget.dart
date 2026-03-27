// lib/views/home/widgets/home_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/test_extensions.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../cart/cart_screen.dart';
import '../../../services/SearchScreen.dart';

class HomeHeaderWidget extends StatelessWidget {
  final double scaleFactor;
  final double horizontalPadding;

  const HomeHeaderWidget({
    super.key,
    required this.scaleFactor,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFEEE0),
      statusBarIconBrightness: Brightness.dark,
    ));

    final lc = Get.find<LocationController>();

    return Container(
      color: const Color(0xFFFFEEE0),
      padding: EdgeInsets.only(bottom: 16.r * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + Cart Row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12.h * scaleFactor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // === LOCATION SECTION ===
                Expanded(
                  // 1. Align prevents the click area from stretching to the right
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent, // Ensures the gap between icon/text is clickable
                      onTap: () async {
                        final selected = await Get.toNamed('/choice', arguments: 'home_header');
                        if (selected != null) {
                          try {
                            Get.find<HomeController>().update();
                          } catch (_) {}
                        }
                      },
                      child: Row(
                        // 2. MainAxisSize.min ensures the Row only takes the width of the content
                        mainAxisSize: MainAxisSize.min,
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
                          
                          // 3. Flexible allows truncation but doesn't force full width like Expanded
                          Flexible(
                            fit: FlexFit.loose,
                            child: Obx(() {
                              final cached = lc.cachedLocation.value;

                              String displayLabel;
                              String displayAddress;

                              if (cached == null || cached.address.isEmpty) {
                                displayLabel = "Select Location";
                                displayAddress = "Tap here to choose address";
                              } else {
                                displayLabel = cached.label; 
                                displayAddress = cached.address;
                              }

                              String formattedCity = '';
                              if (displayAddress.contains(',')) {
                                final parts = displayAddress.split(',');
                                formattedCity = parts.last.trim();
                                if (formattedCity.length < 3) {
                                   formattedCity = displayAddress; 
                                }
                              } else {
                                formattedCity = displayAddress.trim();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min, // Keep label compact
                                    children: [
                                      Text(
                                        displayLabel.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12.sp * scaleFactor,
                                          fontWeight: FontWeight.w700, 
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
                                  SizedBox(height: 2.h * scaleFactor),
                                  Text(
                                    formattedCity,
                                    style: TextStyle(
                                      fontSize: 11.sp * scaleFactor,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ).withId('home_header_location_selector'),
                  ),
                ),

                SizedBox(width: 12.w * scaleFactor),

                // === CART SECTION ===
                Obx(() {
                  final cartController = Get.put(CartController());
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
                  ).withId('home_header_cart_btn');
                }),
              ],
            ),
          ),

          // === SEARCH BAR ===
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
          ).withId('home_header_search_bar'),
        ],
      ),
    );
  }
}