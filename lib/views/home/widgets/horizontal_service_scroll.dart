import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HorizontalServiceScroll extends StatelessWidget {
  final List<Map<String, String>> services;

  const HorizontalServiceScroll({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 16.r),
        itemCount: services.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final service = services[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with fixed 117x116 dimensions
                Container(
                  width: 117.w,
                  height: 116.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(service['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 117.w,
                  child: Text(
                    service['title']!,
                    style: TextStyle(fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Colors.black,
                      height: 1.33.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star.svg',
                      height: 14.h,
                      width: 14.w,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "4.8 (23k)",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      "₹499",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFA9441),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "₹599",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}