import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ServiceBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> images;

  const ServiceBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 561.h, // Matches Figma bottom sheet height
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side:  BorderSide(
            width: 1.w,
            color: Color(0xE5E47830), // Figma orange stroke
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProSemibold',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style:  TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
                fontFamily: 'SFProRegular',
              ),
            ),
            SizedBox(height: 12.h),

            // One service per row - scrollable
            Expanded(
              child: ListView.separated(
                itemCount: images.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          images[index],
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Text(
                              'Grooming essentials',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFProSemibold',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 14.w,
                                  height: 14.h,
                                  color: Colors.black, 
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '4.87 (23k)',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'SFProRegular',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '3 items',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children:  [
                                Text(
                                  '₹499',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xFFFA9441),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFProBold',
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '₹599',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Add Button
                      Container(
                        margin: EdgeInsets.only(left: 8.r),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFA9441)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            // Add to cart or perform action
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Color(0xFFFA9441),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}