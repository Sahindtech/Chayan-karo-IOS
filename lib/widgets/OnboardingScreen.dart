import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
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

  final List<Widget> _titles = [
    Text(
      'We Provide Professional Home services at a very friendly price',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF1A1D1F),
        fontSize: 28,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        height: 1.43,
      ),
    ),
    Text(
      'Easy Service booking & Scheduling',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF1A1D1F),
        fontSize: 28,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        height: 1.43,
      ),
    ),
    Text(
      'Get Beauty parlor at your home & other Personal Grooming needs',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF1A1D1F),
        fontSize: 28,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        height: 1.43,
      ),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    // Circular background with image
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 328,
                            width: 328,
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F4FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            height: 287,
                            width: 287,
                            decoration: BoxDecoration(
                              color: Color(0xFFE5EAFF),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                _images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _titles[index], // Injected custom title
                  ],
                ),
              );
            },
          ),

          // Skip Button
          Positioned(
            top: 50,
            right: 24,
            child: GestureDetector(
              onTap: _skip,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFE6EAFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SFProSemibold',
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls wrapped with SafeArea
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: SafeArea(
    minimum: const EdgeInsets.only(bottom: 28), // adds spacing inside SafeArea
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Arrow Button
        GestureDetector(
          onTap: _nextPage,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF6F00),
            ),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 28),
          ),
        ),
        SizedBox(height: 12),
        // Page Dots
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
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index ? Color(0xFFFF6F00) : Colors.grey.shade300,
      ),
    );
  }
}
