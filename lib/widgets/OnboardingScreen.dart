import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../data/local/database.dart'; // Import for database access



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});



  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}



class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false; // Add loading state



  // Same image for all slides
  final String _image = "assets/onboard1.png";



  // Updated content for each slide
  final List<String> _titles = [
    'Professional home services at your doorstep',
    'Choose your own service provider',
    'Book your service in just a few taps',
  ];



  void _nextPage() {
    if (_currentPage < _titles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _completeOnboarding();
    }
  }



  void _skip() {
    _completeOnboarding();
  }



  // Complete onboarding with database integration (NO SNACKBARS)
  Future<void> _completeOnboarding() async {
    if (_isLoading) return; // Prevent multiple taps
    
    setState(() {
      _isLoading = true;
    });



    try {
      // Get database instance
      final database = Get.find<AppDatabase>();
      
      // Mark onboarding as completed
      await database.markOnboardingComplete();
      
      print('✅ Onboarding completed successfully');
      
      // Navigate to login screen silently (NO SNACKBAR)
      Get.offAllNamed('/login');
      
    } catch (e) {
      print('❌ Error completing onboarding: $e');
      
      // Navigate anyway on error (NO ERROR SNACKBAR)
      Get.offAllNamed('/login');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;



        if (!isTabletDevice) {
          // Phone UI
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 80.h),
                    // Static image - stays in place
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          _image,
                          width: 0.95.sw,
                          height: 0.6.sh,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Negative margin to pull text up
                    Transform.translate(
                      offset: Offset(0, -20.h),
                      child: SizedBox(
                        height: 120.h,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _titles.length,
                          onPageChanged: (index) => setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),



                // Skip Button with loading state
                Positioned(
                  top: 50.h,
                  right: 24.w,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _skip,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: _isLoading 
                            ? const Color(0xFFE6EAFF).withOpacity(0.5)
                            : const Color(0xFFE6EAFF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFFFF6F00),
                                ),
                              ),
                            )
                          : Text(
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



                // Bottom Controls with loading state
                Positioned(
                  bottom: 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: SafeArea(
                    minimum: EdgeInsets.only(bottom: 28.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _isLoading ? null : _nextPage,
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isLoading 
                                  ? const Color(0xFFFF6F00).withOpacity(0.5)
                                  : const Color(0xFFFF6F00),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 28.sp,
                                    height: 28.sp,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    _currentPage == _titles.length - 1
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _titles.length,
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
        } else {
          // Tablet UI with scaling applied
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 60.h * scaleFactor),
                    // Static image - stays in place
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r * scaleFactor),
                        child: Image.asset(
                          _image,
                          width: 0.75.sw * scaleFactor,
                          height: 0.6.sh * scaleFactor,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Negative margin to pull text up
                    Transform.translate(
                      offset: Offset(0, -30.h * scaleFactor),
                      child: SizedBox(
                        height: 140.h * scaleFactor,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _titles.length,
                          onPageChanged: (index) => setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
                              child: Text(
                                _titles[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF1A1D1F),
                                  fontSize: 34.sp * scaleFactor,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 1.43,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),



                // Skip Button - Scaled for tablets with loading state
                Positioned(
                  top: 50.h * scaleFactor,
                  right: 24.w * scaleFactor,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _skip,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w * scaleFactor,
                        vertical: 8.h * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: _isLoading 
                            ? const Color(0xFFE6EAFF).withOpacity(0.5)
                            : const Color(0xFFE6EAFF),
                        borderRadius: BorderRadius.circular(20.r * scaleFactor),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 16.w * scaleFactor,
                              height: 16.h * scaleFactor,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFFFF6F00),
                                ),
                              ),
                            )
                          : Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 14.sp * scaleFactor,
                                fontFamily: 'SFProSemibold',
                                color: const Color(0xFFFF6F00),
                              ),
                            ),
                    ),
                  ),
                ),



                // Bottom Controls - Scaled for tablets with loading state
                Positioned(
                  bottom: 0.h,
                  left: 0.w,
                  right: 0.w,
                  child: SafeArea(
                    minimum: EdgeInsets.only(bottom: 28.h * scaleFactor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _isLoading ? null : _nextPage,
                          child: Container(
                            padding: EdgeInsets.all(16.r * scaleFactor),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isLoading 
                                  ? const Color(0xFFFF6F00).withOpacity(0.5)
                                  : const Color(0xFFFF6F00),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 28.sp * scaleFactor,
                                    height: 28.sp * scaleFactor,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    _currentPage == _titles.length - 1
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 28.sp * scaleFactor,
                                  ),
                          ),
                        ),
                        SizedBox(height: 12.h * scaleFactor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _titles.length,
                            (index) => buildDot(index, scaleFactor),
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
      },
    );
  }



  Widget buildDot(int index, [double scaleFactor = 1.0]) {
    return Container(
      height: 8.h * scaleFactor,
      width: _currentPage == index ? 24.w * scaleFactor : 8.w * scaleFactor,
      margin: EdgeInsets.symmetric(horizontal: 4.w * scaleFactor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r * scaleFactor),
        color: _currentPage == index
            ? const Color(0xFFFF6F00)
            : Colors.grey.shade300,
      ),
    );
  }
}
