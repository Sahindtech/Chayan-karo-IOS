import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Full-width Search Bar with TextField
              Container(
                height: 42.h,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: const Color(0x9BE47830)),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.72),
                          fontSize: 13.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        cursorColor: Colors.black,
                        autofocus: true, // keyboard opens on screen open
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Look For Services',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.72),
                            fontSize: 13.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36.h),

              Text(
                'Trending searches',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20.h),

              Wrap(
                alignment: WrapAlignment.start,
                spacing: 12.w,
                runSpacing: 12.h,
                children: _buildSearchTags(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSearchTags() {
    final List<String> tags = [
      'Professional Cleaning',
      'Electricians',
      'Cleaning',
      'Professional Cleaning',
      'Professional Cleaning',
    ];

    return tags.map((text) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/trend.svg',
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.72),
                fontSize: 13.sp,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
