import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/most_used_service_controller.dart';
import '../../all_most_used_services/all_most_used_services_screen.dart';

class HorizontalServiceScroll extends StatelessWidget {
  const HorizontalServiceScroll({super.key});

  bool _isSvgUrl(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  // ✅ UPDATED: Shows genuine rating. If null/0, shows "0.0" or actual value.
  String _getRatingText(double? rating) {
    double finalRating = rating ?? 0.0;
    if (finalRating == 0.0) {
      return "New";
    }
    return finalRating.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MostUsedServiceController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        // UI Constants
        final double imageWidth = 117.w * scaleFactor;
        final double imageHeight = 116.h * scaleFactor;
        final double titleFontSize = 12.sp * scaleFactor;
        final double priceFontSize = 12.sp * scaleFactor;
        final double oldPriceFontSize = 10.sp * scaleFactor;
        final double ratingFontSize = 10.sp * scaleFactor;
        final double starSize = 14.h * scaleFactor;

        // Calculated Height
        final double contentHeight = imageHeight +
            8.h * scaleFactor +
            (titleFontSize * 1.33 * 2) +
            4.h * scaleFactor +
            (ratingFontSize * 1.2) +
            4.h * scaleFactor +
            (priceFontSize * 1.2) +
            5.h * scaleFactor;

        return Obx(() {
          // 1. Loading State -> Show Shimmer
          if (controller.isLoading.value) {
            return _buildShimmerLoading(scaleFactor, imageWidth, imageHeight, contentHeight);
          }

          // 2. Empty State
          if (controller.mostUsedServices.isEmpty) {
            return const SizedBox.shrink();
          }

          final services = controller.mostUsedServices;

          return SizedBox(
            height: contentHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: services.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
              itemBuilder: (context, index) {
                final service = services[index];

                // Price Logic
                final double currentPrice = service.price ?? 0;
                final double discount = service.discountPercentage ?? 0;
                double originalPriceVal;
                if (discount > 0) {
                  originalPriceVal = currentPrice / ((100 - discount) / 100);
                } else {
                  originalPriceVal = currentPrice * 1.25;
                }
                final int finalOldPrice = originalPriceVal.toInt();
                
                // Get Real Rating
                final String ratingText = _getRatingText(service.averageRating);

                return GestureDetector(
                  onTap: () => Get.to(() => const AllMostUsedServicesScreen()),
                  child: SizedBox(
                    width: imageWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * scaleFactor),
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
                            child: _buildServiceImage(service.imgLink ?? "", scaleFactor),
                          ),
                        ),
                        
                        SizedBox(height: 8.h * scaleFactor),
                        
                        // Title
                        SizedBox(
                          width: imageWidth,
                          child: Text(
                            service.name ?? "Service Name",
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Colors.black,
                              height: 1.33,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        SizedBox(height: 4.h * scaleFactor),
                        
                        // Rating
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/star.svg',
                              height: starSize,
                              width: starSize,
                              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                              placeholderBuilder: (_) => Icon(Icons.star, size: starSize, color: Colors.amber),
                            ),
                            SizedBox(width: 4.w * scaleFactor),
                            Expanded(
                              child: Text(
                                ratingText, // Shows real API value
                                style: TextStyle(
                                  fontSize: ratingFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF757575),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 4.h * scaleFactor),
                        
                        // Price
                        Row(
                          children: [
                            Text(
                              "₹${currentPrice.toInt()}",
                              style: TextStyle(
                                fontSize: priceFontSize,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFA9441),
                              ),
                            ),
                            SizedBox(width: 6.w * scaleFactor),
                            Text(
                              "₹$finalOldPrice",
                              style: TextStyle(
                                fontSize: oldPriceFontSize,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFFB0B0B0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  Widget _buildServiceImage(String imgUrl, double scaleFactor) {
    if (imgUrl.isEmpty) return Container(color: Colors.grey.shade200);
    if (_isSvgUrl(imgUrl)) {
      return SvgPicture.network(imgUrl, fit: BoxFit.cover);
    } else {
      return CachedNetworkImage(
        imageUrl: imgUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.cleaning_services, color: const Color(0xFFFF6F00), size: 32.sp * scaleFactor),
        ),
      );
    }
  }

  // ✅ NEW: Premium Shimmer Loading
  Widget _buildShimmerLoading(double scaleFactor, double width, double height, double containerHeight) {
    return SizedBox(
      height: containerHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // Disable scroll while loading
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
        itemBuilder: (context, index) {
          return SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                ShimmerSkeleton(
                  width: width,
                  height: height,
                  borderRadius: 10 * scaleFactor,
                ),
                SizedBox(height: 8.h * scaleFactor),
                // Title Line 1
                ShimmerSkeleton(width: width, height: 12.h * scaleFactor),
                SizedBox(height: 4.h * scaleFactor),
                // Title Line 2 (Shorter)
                ShimmerSkeleton(width: width * 0.7, height: 12.h * scaleFactor),
                SizedBox(height: 8.h * scaleFactor),
                // Rating Line
                ShimmerSkeleton(width: width * 0.4, height: 10.h * scaleFactor),
                SizedBox(height: 8.h * scaleFactor),
                // Price Line
                ShimmerSkeleton(width: width * 0.6, height: 12.h * scaleFactor),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ✅ NEW: Reusable Shimmer Skeleton Widget
class ShimmerSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFFAFAFA),
                Color(0xFFEEEEEE),
              ],
              stops: [
                0.1,
                0.3 + (_animation.value * 0.3), // Move the highlight
                0.6,
              ],
              transform: GradientRotation(_animation.value), // Adding rotation for dynamic effect
            ),
          ),
        );
      },
    );
  }
}