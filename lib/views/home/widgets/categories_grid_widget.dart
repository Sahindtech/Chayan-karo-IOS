import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/category_controller.dart';
import '../../../models/category_models.dart';
import '../../../services/universal_service_screen.dart';

class CategoriesGridWidget extends StatelessWidget {
  final double scaleFactor;
  final double horizontalPadding;

  const CategoriesGridWidget({
    Key? key,
    required this.scaleFactor,
    required this.horizontalPadding,
  }) : super(key: key);

  void _navigateToCategory(Category category) {
    Get.to(() => CategoryServiceScreen(category: category));
  }

  // Helper method to check if URL is an SVG
  bool _isSvgUrl(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  // Helper method to build category icon (supports both SVG and raster images)
  Widget _buildCategoryIcon(String imgUrl, double scaleFactor) {
    final double width = 40.w * scaleFactor;
    final double height = 40.h * scaleFactor;
    final bool isSvg = _isSvgUrl(imgUrl);

    if (isSvg) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SvgPicture.network(
          imgUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00).withOpacity(0.1), // brand color
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    } else {
      // Use CachedNetworkImage for proper caching
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00).withOpacity(0.1), // brand color
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          errorWidget: (context, url, error) => _buildErrorPlaceholder(width, height, scaleFactor),
          fadeInDuration: const Duration(milliseconds: 220),
          fadeOutDuration: const Duration(milliseconds: 80),
        ),
      );
    }
  }

  // Helper method to build error placeholder
  Widget _buildErrorPlaceholder(double width, double height, double scaleFactor) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6F00).withOpacity(0.1), // brand color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.category,
        color: const Color(0xFFFF6F00),
        size: 24.sp * scaleFactor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categoryController = Get.find<CategoryController>();
      final categories = categoryController.filteredCategories;

      // Show loading state
      if (categoryController.isLoading && categories.isEmpty) {
        return Container(
          height: 200.h * scaleFactor,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6F00),
            ),
          ),
        );
      }

      // Show error state
      if (categoryController.hasError && categories.isEmpty) {
        return Container(
          height: 200.h * scaleFactor,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Failed to load categories',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => categoryController.retry(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F00),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Show empty state
      if (categories.isEmpty) {
        return Container(
          height: 200.h * scaleFactor,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: const Center(
            child: Text(
              'No categories available',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      // Display categories grid
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 14.h * scaleFactor,
            crossAxisSpacing: 12.w * scaleFactor,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (_, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () => _navigateToCategory(category),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w * scaleFactor,
                      color: const Color(0xFFFFD9BE),
                    ),
                    borderRadius: BorderRadius.circular(10 * scaleFactor),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0xFFF2C4A5),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category icon - supports both SVG and raster images
                      _buildCategoryIcon(category.imgLink, scaleFactor),
                      SizedBox(height: 6.h * scaleFactor),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w * scaleFactor,
                        ),
                        child: Text(
                          category.categoryName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9.sp * scaleFactor,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
