import 'package:chayankaro/views/cart/cart_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonServiceScreen extends StatelessWidget {
  const SalonServiceScreen({super.key});

@override
Widget build(BuildContext context) {
  // Set status bar color to match header
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: const Color(0xFFFFEEE0), // Matches header background
    statusBarIconBrightness: Brightness.dark, // For dark icons
  ));

  return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 74.r), // 54 (header) + 20 (gap)
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 120.r + MediaQuery.of(context).viewPadding.bottom + 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                _buildTopBanner(),
                SizedBox(height: 12.h),
                _buildSalonInfoBlock(),
                SizedBox(height: 16.h),
                _buildDiscountCards(),
                SizedBox(height: 16.h),
                _buildCustomPackageSection(),
                SizedBox(height: 16.h),
                _buildCategoryGrid(),
                SizedBox(height: 16.h),
                _buildServiceCards(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),

        // Sticky header on top
        Positioned(
          top: 0.r,
          left: 0.r,
          right: 0.r,
          child: Container(
            color: const Color(0xFFFFEEE0),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: _buildHeader(context),
          ),
        ),

        // Bottom bar
        _buildBottomBar(),
      ],
    ),
  );
}


  Widget _buildHeader(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 48.h,
    decoration: BoxDecoration(
      color: const Color(0xFFFFEEE0),
      boxShadow: [
        BoxShadow(
          color: const Color(0x26000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          SizedBox(width: 8.w),
          Expanded(child: Text(
              "Salon for Women",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
            GestureDetector(
             onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()), // Replace with your actual cart screen class
              );
             },
             child: SvgPicture.asset(
  'assets/icons/cart.svg',
  width: 40.w,
  height: 40.h,
  color: Colors.black,
),
           ),
        ],
      ),
    ),
  );
}


  Widget _buildTopBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset(
            'assets/single_use_product.webp',
            width: double.infinity,
            height: 160.h,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 12.r,
            left: 12.r,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Single use products",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSalonInfoBlock() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Salon for Women",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.r), // Add padding to push it inward
              child: Row(
                children: [
                   SvgPicture.asset(
                    'assets/icons/warranty.svg',
                    width: 20.w,
                    height: 20.h,
                    color:Colors.black,
                  ),
                  SizedBox(width: 4.w),
                  Text('CK safe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
             SvgPicture.asset('assets/icons/star.svg', width: 18.w,height: 18.h, color: Colors.black),
            SizedBox(width: 6.w),
            Text("4.8 (23k)", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/tick.svg', color: Colors.black),
                  ),
            SizedBox(width: 6.w),
            Text("354 jobs completed", style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ],
    ),
  );
}


Widget _buildDiscountCards() {
  final List<Map<String, String>> offers = [
    {
      'icon': 'assets/icons/cash.svg',
      'title': 'Save 15% on every order',
      'subtitle': 'Get Plus now',
    },
    {
      'icon': 'assets/icons/card.svg',
      'title': 'CRED Pay',
      'subtitle': 'Upto Rs. 100 cashback',
    },
  ];

  return SizedBox(
    height: 100.h, // Increased to allow full text rendering
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Container(
          width: 240.w, // Gives extra space for text lines
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
               SvgPicture.asset(
                offer['icon']!,
                width: 28.w,
                height: 28.h,
                color: Colors.black, // This applies a black tint
              ),
              SizedBox(width: 12.w),
              Flexible( // Allows Column to expand based on content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      offer['title']!,
                      style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      softWrap: true,
                      maxLines: 2, // Let long titles wrap
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      offer['subtitle']!,
                      style: TextStyle(fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(width: 12.w),
      itemCount: offers.length,
    ),
  );
}



Widget _buildCustomPackageSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      height: 100.h, // Slightly increased to accommodate two lines of text
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE47830),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/package.svg',
                width: 58.w,
                height: 62.h,
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  SizedBox(
                    width: 205.67.w,
                    height: 26.46.h,
                    child: Text(
                      'Create a Customer Package',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 1.50.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: 156.31.w,
                    height: 26.46.h,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Specifically for your needs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.85.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, // Native forward arrow
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    ),
  );
}


Widget _buildCategoryGrid() {
  final categories = [
    {'title': 'Cleanup & Facials', 'image': 'assets/z2.webp'},
    {'title': 'Bleach & Detan', 'image': 'assets/s1.webp'},
    {'title': 'Waxing', 'image': 'assets/s2.webp'},
    {'title': 'Manicure', 'image': 'assets/s3.webp'},
    {'title': 'Massage', 'image': 'assets/s4.webp'},
    {'title': 'Pedicure', 'image': 'assets/s5.webp'},
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Categories",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFFFD9BE),
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33E47830),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item['title']!,
                      style: TextStyle(fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.3.h,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}


Widget _buildBottomBar() {
  return Positioned(
    bottom: 0.r,
    left: 0.r,
    right: 0.r,
    child: Builder(
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, (bottomPadding > 0 ? bottomPadding : 16) + 8),
          decoration: BoxDecoration(color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("2 items", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  SizedBox(height: 4.h),
                  Text("₹400",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFE47830),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Add to Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}


    
 Widget _buildServiceCards() {
  final Map<String, List<Map<String, String>>> groupedServices = {
    'Cleanup': [
      {
        'image': 'assets/z2.webp',
        'title': 'Cleanup',
        'price': '₹200',
        'rating': '4.76',
        'duration': '55 mins',
      },
      {
        'image': 'assets/z2.webp',
        'title': 'Cleanup',
        'price': '₹200',
        'rating': '4.76',
        'duration': '55 mins',
      },
    ],
    'Bleach & Detan': [
      {
        'image': 'assets/z1.webp',
        'title': 'Bleach',
        'price': '₹200',
        'rating': '4.76',
        'duration': '55 mins',
      },
      {
        'image': 'assets/s4.webp',
        'title': 'Detan',
        'price': '₹200',
        'rating': '4.76',
        'duration': '55 mins',
      },
    ],
    'Facial': [
      {
        'image': 'assets/s4.webp',
        'title': 'Facial Name 2',
        'price': '₹499',
        'originalPrice': '₹599',
        'rating': '4.76',
        'duration': '55 mins',
        'desc':
            '• 45 mins\n• For all skin types. Pinacolada mask.\n• 6-step process. Includes 10-min massage',
      },
      {
        'image': 'assets/s1.webp',
        'title': 'Facial Name 3',
        'price': '₹499',
        'originalPrice': '₹599',
        'rating': '4.76',
        'duration': '55 mins',
        'desc':
            '• 45 mins\n• For all skin types. Pinacolada mask.\n• 6-step process. Includes 10-min massage',
      },
    ],
  };

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedServices.entries.map((entry) {
        final String category = entry.key;
        final List<Map<String, String>> services = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category,
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.h),
            ...services.map((service) {
              if (category != 'Facial') {
                // Cleanup & Bleach & Detan with ADD button
                return Container(
                  margin: EdgeInsets.only(bottom: 16.r),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          service['image']!,
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service['title']!,
                                style: TextStyle(fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                 SvgPicture.asset('assets/icons/star.svg',
                                    width: 18.w,  color: Colors.black,),
                                SizedBox(width: 4.w),
                                Text(
                                  "${service['rating']} | ${service['duration']}",
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(service['price']!,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 14.sp)),
                          ],
                        ),
                      ),
                      Container(
                        width: 75.w,
                        height: 29.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0.r,
                              top: 0.r,
                              child: Container(
                                width: 75.w,
                                height: 29.h,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  shadows: [
                                    BoxShadow(
                                      color: const Color(0x33000000),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(left: 32.r,
                              top: 5.38.r,
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xFFE47830),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Positioned(left: 16.r,
                              top: 9.r,
                              child: SizedBox(
                                width: 12.w,
                                height: 12.h,
                                child: Icon(Icons.add,
                                    size: 12, color: Color(0xFFE47830)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Facial with title & add button in same row
                return Container(
                  margin: EdgeInsets.only(bottom: 16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.asset(
                          service['image']!,
                          width: double.infinity,
                          height: 180.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Add button in same row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(service['title']!,
                                    style: TextStyle(fontSize: 15.sp,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  width: 75.w,
                                  height: 29.h,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0.r,
                                        top: 0.r,
                                        child: Container(
                                          width: 75.w,
                                          height: 29.h,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            shadows: [
                                              BoxShadow(
                                                color: const Color(0x33000000),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(left: 32.r,
                                        top: 5.38.r,
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Color(0xFFE47830),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Positioned(left: 16.r,
                                        top: 9.r,
                                        child: SizedBox(
                                          width: 12.w,
                                          height: 12.h,
                                          child: Icon(Icons.add,
                                              size: 12,
                                              color: Color(0xFFE47830)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                 SvgPicture.asset('assets/icons/star.svg',
                                    width: 18.w,  color: Colors.black,),
                                SizedBox(width: 4.w),
                                Text(
                                  "${service['rating']} | ${service['duration']}",
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Text(service['price']!,
                                    style: TextStyle(fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(width: 6.w),
                                Text(service['originalPrice']!,
                                    style: TextStyle(fontSize: 14.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey)),
                              ],
                            ),
                            if (service['desc'] != null &&
                                service['desc']!.isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              Text(
                                service['desc']!,
                                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          ],
        );
      }).toList(),
    ),
  );
}



}