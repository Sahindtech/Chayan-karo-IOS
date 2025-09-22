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

// Import GetX DI setup
import 'di/app_binding.dart';

// Import for testing and authentication
import 'data/local/database.dart';
import 'data/repository/home_repository.dart';
import 'views/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetX dependencies
  await initializeDependencies();
  
  // Determine initial route based on authentication state
  final String initialRoute = await _determineInitialRoute();
  
  // 🧪 QUICK DEPENDENCY TEST - Remove after testing
  print('🔍 Testing GetX dependencies...');
  
  try {
    // Test 1: Check if GetX can resolve dependencies
    final database = Get.find<AppDatabase>();
    final repository = Get.find<HomeRepository>();
    print('✅ GetX Dependencies resolved successfully');
    
    // Test 2: Quick database test
    await database.clearCategories(); // Clear old data
    final categories = await repository.getCategories();
    print('✅ Repository loaded ${categories.length} categories');
    
    // Test 3: Check if data was actually saved to database
    final localCategories = await database.getAllCategories();
    print('✅ Database contains ${localCategories.length} categories');
    
    // Test 4: Show first category details
    if (categories.isNotEmpty) {
      print('📝 Sample category: "${categories.first.title}" - ${categories.first.icon}');
    }
    
    // Test 5: Test services as well
    final services = await repository.getMostUsedServices();
    print('✅ Repository loaded ${services.length} most used services');
    
    print('🎉 All GetX tests passed! Dependencies are working correctly.');
    
  } catch (e) {
    print('❌ GetX Test failed: $e');
    print('Stack trace: ${StackTrace.current}');
  }
  // END TEST CODE
  
  runApp(ChayanKaroApp(initialRoute: initialRoute));
}

// NEW: Determine initial route based on authentication state
Future<String> _determineInitialRoute() async {
  try {
    final database = Get.find<AppDatabase>();
    
    // Check authentication state
    final isLoggedIn = await database.isUserLoggedIn();
    final isSessionValid = await database.isSessionValid();
    final hasSeenOnboarding = await database.hasSeenOnboarding();
    
    print('🔐 Auth Check: isLoggedIn=$isLoggedIn, sessionValid=$isSessionValid, hasSeenOnboarding=$hasSeenOnboarding');
    
    // If logged in and session is valid, go to home
    if (isLoggedIn && isSessionValid) {
      final userData = await database.getCurrentUser();
      print('✅ User is logged in: ${userData['name']} - redirecting to home');
      return '/home';
    }
    
    // If session expired but was logged in, clear auth data
    if (isLoggedIn && !isSessionValid) {
      print('⚠️ Session expired - clearing auth data');
      await database.clearAuthData();
    }
    
    // If user has seen onboarding, go to login
    if (hasSeenOnboarding) {
      print('👀 User has seen onboarding - redirecting to login');
      return '/login';
    } else {
      print('🆕 New user - showing onboarding');
      return '/onboarding';
    }
  } catch (e) {
    print('❌ Error checking auth state: $e');
    // Fallback to splash screen on error
    return '/';
  }
}

// Initialize dependencies function
Future<void> initializeDependencies() async {
  print('🚀 Initializing GetX dependencies...');
  
  // Initialize core dependencies first
  AppBinding().dependencies();
  
  print('✅ GetX dependencies initialized successfully');
}

class ChayanKaroApp extends StatelessWidget {
  final String initialRoute;
  
  const ChayanKaroApp({super.key, required this.initialRoute});

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
            // GetX binding for dependency injection
            initialBinding: AppBinding(),
            
            // Use dynamic initial route based on auth state
            initialRoute: initialRoute,
            
            // GetX route management
            getPages: [
              GetPage(
                name: '/',
                page: () => SplashScreen(),
              ),
              GetPage(
                name: '/onboarding',
                page: () => const OnboardingScreen(),
              ),
              GetPage(
                name: '/login',
                page: () => const LoginScreen(), // Fixed: Added const
                binding: AppBinding(), // Ensure dependencies are available
              ),
              GetPage(
                name: '/otp',
                page: () => const OtpVerificationScreen(), // Fixed: Added const
                binding: AppBinding(), // Ensure dependencies are available
              ),
              GetPage(
                name: '/home',
                page: () => const HomeScreen(),
                binding: AppBinding(), // Ensure dependencies are available
              ),
              GetPage(
                name: '/profile',
                page: () => const ProfileScreen(),
                binding: AppBinding(),
),
              GetPage(
                name: '/cart',
                page: () => CartScreen(),
                binding: AppBinding(), // Ensure dependencies are available
              ),
            ],
            
            // Fallback for unknown routes
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

class DesignSizeHelper {
  static Size getDesignSize(MediaQueryData mediaQuery) {
    final size = mediaQuery.size;
    final diagonalDp = sqrt(pow(size.width, 2) + pow(size.height, 2));

    final bool isTablet =
        diagonalDp >= 1100 || size.shortestSide >= 500;

    final bool isLargeTablet = isTablet && max(size.width, size.height) >= 1400;
    final bool isLandscape = size.width > size.height;

    const phoneSize = Size(390, 844);

    if (!isTablet) {
      return phoneSize;
    }

    if (isLargeTablet) {
      return isLandscape ? const Size(1366, 1024) : const Size(1024, 1366);
    } else {
      return isLandscape ? const Size(960, 600) : const Size(600, 960);
    }
  }

  static void logDeviceInfo(MediaQueryData mediaQuery) {
    final size = mediaQuery.size;
    final diagonalDp = sqrt(pow(size.width, 2) + pow(size.height, 2));
    final bool isTablet =
        diagonalDp >= 1100 || size.shortestSide >= 500;
    final bool isLargeTablet = isTablet && max(size.width, size.height) >= 1400;

    debugPrint(
      '[Device Check] widthDp: ${size.width}, heightDp: ${size.height}, '
      'diagonalDp: ${diagonalDp.toStringAsFixed(2)}, '
      'isTablet: $isTablet, isLargeTablet: $isLargeTablet',
    );
  }
}
