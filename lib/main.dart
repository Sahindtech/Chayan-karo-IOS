import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/splash/splash_screen.dart';
import 'widgets/OnboardingScreen.dart';
import 'views/login/login_screen.dart';
import 'views/login/otp_verification_screen.dart';
import 'views/home/home_screen.dart';

void main() {
  runApp(const ChayanKaroApp());
}

class ChayanKaroApp extends StatelessWidget {
  const ChayanKaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Match your Figma design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ChayanKaro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'SFPro',
            primaryColor: const Color(0xFFFF6F00),
            scaffoldBackgroundColor: Colors.white,
          ),
          builder: (context, widget) {
            // This ensures text doesn't auto-scale and distort layout
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/onboarding': (context) => OnboardingScreen(),
            '/login': (context) => LoginScreen(),
            '/otp': (context) => OtpVerificationScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
