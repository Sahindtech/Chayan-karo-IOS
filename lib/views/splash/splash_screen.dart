import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../data/local/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // ✨ Navigate after GIF animation completes
    Future.delayed(const Duration(milliseconds: 4200), () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await _navigateToCorrectScreen();
        }
      });
    });
  }

  // ✨ Simplified navigation logic: auth + onboarding only
  Future<void> _navigateToCorrectScreen() async {
    try {
      final database = Get.find<AppDatabase>();

      final bool isLoggedIn = await database.isUserLoggedIn();
      final bool isSessionValid = await database.isSessionValid();
      final bool hasSeenOnboarding = await database.hasSeenOnboarding();

      print('🔐 Splash: Auth Check - isLoggedIn=$isLoggedIn, sessionValid=$isSessionValid, hasSeenOnboarding=$hasSeenOnboarding');

      // 1️⃣ New or logged-out user
      if (!isLoggedIn || !isSessionValid) {
        if (isLoggedIn && !isSessionValid) {
          print('⚠️ Splash: Session expired - clearing auth data');
          await database.clearAuthData();
        }

        if (hasSeenOnboarding) {
          print('👀 Splash: User has seen onboarding - redirecting to login');
          Get.offAllNamed('/login');
          return;
        } else {
          print('🆕 Splash: New user - showing onboarding');
          Get.offAllNamed('/onboarding');
          return;
        }
      }

      // 2️⃣ Auth valid → go home (location check happens after login/OTP flow)
      final userData = await database.getCurrentUser();
      print('✅ Splash: Auth OK → User: ${userData['name']}');
      Get.offAllNamed('/home');

    } catch (e, stack) {
      print('❌ Splash: Fatal error determining route: $e');
      print(stack);
      // Fallback to onboarding on error
      Get.offAllNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/chayankaro_logo.gif',
            width: screenWidth * 0.8.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
