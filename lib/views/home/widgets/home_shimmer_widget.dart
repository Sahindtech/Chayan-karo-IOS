import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 60.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerShimmer(),
          SizedBox(height: 16.h),
          _categoryGridShimmer(),
          SizedBox(height: 20.h),
          _bannerShimmer(),
          SizedBox(height: 24.h),
          _servicesSectionShimmer(),
        ],
      ),
    );
  }

  Widget _headerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _categoryGridShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        itemCount: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: const Color(0xFFFFEDE0),
          highlightColor: const Color(0xFFFFD9BE),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 140.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _servicesSectionShimmer() {
    return Column(
      children: List.generate(3, (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFFFEDE0),
            highlightColor: const Color(0xFFFFD9BE),
            child: Container(
              height: 180.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
