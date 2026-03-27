import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'views/splash/splash_screen.dart';
import 'widgets/OnboardingScreen.dart';
import 'views/login/login_screen.dart';
import 'views/login/otp_verification_screen.dart';
import 'views/home/home_screen.dart';
import 'views/cart/cart_screen.dart';
import 'widgets/location_popup_screen.dart';
import 'views/profile/profile_screen.dart';
import 'widgets/choose_location_sheet.dart';
import 'widgets/service_area_info_screen.dart';
import 'views/booking/PaymentSuccess.dart';
import 'views/booking/payment_failed_screen.dart';
import 'views/booking/feedback_screen.dart';
import 'views/profile/EditProfileScreen.dart';

// Services & Dependencies
import 'services/notification_service.dart';
import 'di/app_binding.dart';
import 'data/local/database.dart';
import 'data/repository/category_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  

  // Lock to portrait
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // FIX 1: Start the app IMMEDIATELY so it paints the screen.
  runApp(ChayanKaroApp());

  // FIX 2: Run this in the background AFTER runApp so it doesn't block the UI
  NotificationService().init(); 
}

// =======================================================
// APP ROOT
// =======================================================
class ChayanKaroApp extends StatelessWidget {
   ChayanKaroApp({super.key});
  
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    // FIX 3: Removed the LayoutBuilder hack. 
    // ScreenUtil is smart enough to handle physical sizes inside its own builder.
    // Since you are locked to Portrait, we enforce the 390x844 base design size.
    return ScreenUtilInit(
      designSize: const Size(390, 844), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey, // ✅ ADD THIS
          debugShowCheckedModeBanner: false,
          title: "ChayanKaro",

          // FIX 4: Ensured widget isn't null before wrapping in MediaQuery
          builder: (context, widget) {
            if (widget == null) return const SizedBox.shrink();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0), // Samsung fix
              ),
              child: widget,
            );
          },

          theme: ThemeData(
            useMaterial3: false,
            fontFamily: "SFPro",
            scaffoldBackgroundColor: Colors.white,
          ),

          initialBinding: AppBinding(),
          initialRoute: '/', // <-- Ensure OnboardingScreen uses a Scaffold!

          getPages: [
            GetPage(name: '/', page: () => const SplashScreen()),
            GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(name: '/otp', page: () => const OtpVerificationScreen()),
            GetPage(name: '/home', page: () => const HomeScreen()),
            GetPage(name: '/profile', page: () => const ProfileScreen()),
            GetPage(name: '/cart', page: () => CartScreen()),
            GetPage(name: '/location_popup', page: () => const LocationPopupScreen()),
            GetPage(name: '/choice', page: () => const ChooseLocationSheet()),
            GetPage(name: '/service_area_info', page: () => const ServiceAreaInfoScreen()),
            GetPage(name: '/payment-success', page: () => const PaymentSuccessScreen()),
            GetPage(name: '/payment-failed', page: () => const PaymentFailedScreen()),
            GetPage(name: '/feedback_screen', page: () => const FeedbackScreen()),
            GetPage(
              name: '/edit-profile',
              page: () => EditProfileScreen(customer: Get.arguments),
            ),
          ],

          unknownRoute: GetPage(
            name: '/notfound',
            page: () => Scaffold(
              appBar: AppBar(title: const Text("Page Not Found")),
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/'),
                  child: const Text("Go Home"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}