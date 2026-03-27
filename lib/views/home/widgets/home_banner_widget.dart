import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/banner_controller.dart';
//import '../../../controllers/profile_controller.dart';
import '../../../services/universal_service_screen.dart';
import '../../../controllers/category_controller.dart';

class HomeBannerWidget extends StatefulWidget {
  final double scaleFactor;
  final double horizontalPadding;

  const HomeBannerWidget({
    super.key,
    required this.scaleFactor,
    required this.horizontalPadding,
  });

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bannerController = Get.find<BannerController>();
   // final profileController = Get.find<ProfileController>();

    return Obx(() {
      if (bannerController.isLoading.value) return _buildShimmerLoading();
      if (bannerController.banners.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: bannerController.banners.length,
            options: CarouselOptions(
              // Using auto-height or a generous base height to ensure full text visibility
              height: 145.h * widget.scaleFactor, 
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              enlargeCenterPage: false,
              onPageChanged: (index, _) => setState(() => _currentIndex = index),
            ),
            itemBuilder: (context, index, _) {
              final banner = bannerController.banners[index];
              // final customer = profileController.customer;
              // String userName = (customer?.fullName != null && customer!.fullName.isNotEmpty) 
              //     ? customer.fullName.trim().split(' ').first 
              //     : 'Customer';

              return _buildBannerContent(
    title: banner.description ?? "Special Offer",
    subtitle: banner.serviceCategory?.name ?? banner.category?.name ?? "View Details",
    imageUrl: banner.bannerUrl ?? "",
    scaleFactor: widget.scaleFactor,
    onTap: () {
      // 1. Get the category ID from the banner
      final String? targetCategoryId = banner.category?.id;
      final String? targetServiceCatId = banner.serviceCategory?.id;

      if (targetCategoryId != null) {
        // 2. Find the REAL Category object from your main CategoryController
        // This avoids the "Type Mismatch" because we find the correct type by ID
        final categoryController = Get.find<CategoryController>();
        final realCategory = categoryController.filteredCategories.firstWhereOrNull(
          (cat) => cat.categoryId == targetCategoryId
        );

        if (realCategory != null) {
          Get.to(() => CategoryServiceScreen(
            category: realCategory,
            scrollToServiceCategoryId: targetServiceCatId,
          ));
        }
      }
    },
  );
            },
          ),
          SizedBox(height: 12.h),
          _buildDotsIndicator(bannerController.banners.length),
        ],
      );
    });
  }

Widget _buildBannerContent({
  required String title,
  required String subtitle,
  required String imageUrl,
  required double scaleFactor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Container(
        // The banner itself remains scalable based on text length
        constraints: BoxConstraints(minHeight: 135.h * scaleFactor),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r * scaleFactor),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9248), Color(0xFFFF6F00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6F00).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          // Use crossAxisAlignment.center to keep image centered 
          // while text expands the banner height
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Side: Full Text Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20.w * scaleFactor,
                  16.h * scaleFactor,
                  12.w * scaleFactor,
                  16.h * scaleFactor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp * scaleFactor,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 12.h * scaleFactor),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              subtitle.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp * scaleFactor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward_ios, size: 9.sp, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Side: Fixed-Size Image Card with Subtle Border
            Container(
              // Fixed dimensions: Image stays same size even if banner grows
              width: 105.w * scaleFactor,
              height: 115.h * scaleFactor,
              margin: EdgeInsets.only(right: 12.w * scaleFactor, left: 4.w * scaleFactor),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r * scaleFactor),
                // SUBTLE BORDER
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(-1, 2),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.5.r * scaleFactor), // Slightly less than parent for border
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fill,
                  // PROFESSIONAL PLACEHOLDER (Shimmer Effect)
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey[400],
                      size: 28.sp,
                    ),
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
  Widget _buildDotsIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        bool isSelected = _currentIndex == i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          width: isSelected ? 20.w : 7.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? const Color(0xFFFF6F00) : const Color(0xFFFF6F00).withOpacity(0.15),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 135.h * widget.scaleFactor,
        margin: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      ),
    );
  }
}