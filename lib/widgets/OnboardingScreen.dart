import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "assets/onboard1.webp",
    "assets/onboard2.webp",
    "assets/onboard3.webp",
  ];

  final List<String> _titles = [
    'We Provide Professional Home services at a very friendly price',
    'Easy Service booking & Scheduling',
    'Get Beauty parlor at your home & other Personal Grooming needs',
  ];

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizes based on screen width
    double outerCircleSize = 0.8.sw; // 80% of screen width
    double innerCircleSize = 0.7.sw; // 70% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: outerCircleSize,
                            width: outerCircleSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            height: innerCircleSize,
                            width: innerCircleSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5EAFF),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                _images[index],
                                width: innerCircleSize,
                                height: innerCircleSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      _titles[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF1A1D1F),
                        fontSize: 28.sp,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w700,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Skip Button
          Positioned(
            top: 50.h,
            right: 24.w,
            child: GestureDetector(
              onTap: _skip,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EAFF),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'SFProSemibold',
                    color: const Color(0xFFFF6F00),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 28.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF6F00),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _images.length,
                      (index) => buildDot(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 8.h,
      width: _currentPage == index ? 24.w : 8.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: _currentPage == index
            ? const Color(0xFFFF6F00)
            : Colors.grey.shade300,
      ),
    );
  }
}
