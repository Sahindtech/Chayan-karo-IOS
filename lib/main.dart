// lib/main.dart - USING SPLASH SCREEN PROPERLY
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'views/splash/splash_screen.dart';
import 'widgets/OnboardingScreen.dart';
import 'views/login/login_screen.dart';
import 'views/login/otp_verification_screen.dart';
import 'views/home/home_screen.dart';
import 'views/cart/cart_screen.dart';
import 'widgets/location_popup_screen.dart';
import 'views/profile/profile_screen.dart';
import 'widgets/choose_location_sheet.dart';

// GetX dependency injection
import 'di/app_binding.dart';

// Database + repositories
import 'data/local/database.dart';
import 'data/repository/category_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX dependencies
  await initializeDependencies();

  // ✨ ALWAYS START WITH SPLASH - Let splash screen handle routing
  runApp(const ChayanKaroApp());
}

// ==========================================================
// INITIALIZE DEPENDENCIES
// ==========================================================
Future<void> initializeDependencies() async {
  print('🚀 Initializing GetX dependencies...');
  AppBinding().dependencies();
  print('✅ GetX dependencies initialized successfully');

  // Optional quick tests
  try {
    final database = Get.find<AppDatabase>();
    final categoryRepo = CategoryRepository();
    print('✅ Database & Repository check passed.');

    final stats = await database.getDatabaseStats();
    print('📊 Database stats: $stats');
  } catch (e) {
    print('⚠️ Dependency test failed: $e');
  }
}

// ==========================================================
// APP ENTRY WIDGET
// ==========================================================
class ChayanKaroApp extends StatelessWidget {
  const ChayanKaroApp({super.key});

  static const bool kEnableDeviceLogs = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final mediaQuery = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        );

        final designSize = DesignSizeHelper.getDesignSize(mediaQuery);

        if (kEnableDeviceLogs) {
          DesignSizeHelper.logDeviceInfo(mediaQuery);
        }

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ChayanKaro',
            theme: ThemeData(
              fontFamily: 'SFPro',
              primaryColor: const Color(0xFFFF6F00),
              scaffoldBackgroundColor: Colors.white,
            ),
            initialBinding: AppBinding(),
            initialRoute: '/', // ✨ Always start with splash screen
            getPages: [
              GetPage(name: '/', page: () => const SplashScreen()), // ✨ Your animated splash
              GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
              GetPage(name: '/login', page: () => const LoginScreen(), binding: AppBinding()),
              GetPage(name: '/otp', page: () => const OtpVerificationScreen(), binding: AppBinding()),
              GetPage(name: '/home', page: () => const HomeScreen(), binding: AppBinding()),
              GetPage(name: '/profile', page: () => const ProfileScreen(), binding: AppBinding()),
              GetPage(name: '/cart', page: () => CartScreen(), binding: AppBinding()),
              GetPage(name: '/location_popup', page: () => const LocationPopupScreen(), binding: AppBinding()),
              GetPage(name: '/choice', page: () => const ChooseLocationSheet(), binding: AppBinding()),
            ],
            unknownRoute: GetPage(
              name: '/notfound',
              page: () => Scaffold(
                appBar: AppBar(title: const Text('Page Not Found')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Page Not Found'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed('/'),
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================================
// DEVICE SIZE HELPER (UNCHANGED)
// ==========================================================
class DesignSizeHelper {
  static Size getDesignSize(MediaQueryData mediaQuery) {
    final size = mediaQuery.size;
    final diagonalDp = sqrt(pow(size.width, 2) + pow(size.height, 2));
    final bool isTablet = diagonalDp >= 1100 || size.shortestSide >= 500;
    final bool isLargeTablet = isTablet && max(size.width, size.height) >= 1400;
    final bool isLandscape = size.width > size.height;

    const phoneSize = Size(390, 844);

    if (!isTablet) return phoneSize;

    if (isLargeTablet) {
      return isLandscape ? const Size(1366, 1024) : const Size(1024, 1366);
    } else {
      return isLandscape ? const Size(960, 600) : const Size(600, 960);
    }
  }

  static void logDeviceInfo(MediaQueryData mediaQuery) {
    final size = mediaQuery.size;
    final diagonalDp = sqrt(pow(size.width, 2) + pow(size.height, 2));
    final bool isTablet = diagonalDp >= 1100 || size.shortestSide >= 500;
    final bool isLargeTablet = isTablet && max(size.width, size.height) >= 1400;

    debugPrint(
      '[Device Check] widthDp: ${size.width}, heightDp: ${size.height}, '
      'diagonalDp: ${diagonalDp.toStringAsFixed(2)}, '
      'isTablet: $isTablet, isLargeTablet: $isLargeTablet',
    );
  }
}
