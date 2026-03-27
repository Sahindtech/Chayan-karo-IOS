import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).size.width >= 600
        ? MediaQuery.of(context).size.width / 411
        : 1.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w * scaleFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ensure you have an appropriate SVG asset, or use an Icon
            SvgPicture.asset(
              "assets/icons/no_internet.svg", // Replace with your asset path
              width: 150.w * scaleFactor,
              height: 150.h * scaleFactor,
              placeholderBuilder: (_) => Icon(
                Icons.wifi_off_rounded,
                size: 100 * scaleFactor,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24.h * scaleFactor),
            Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 20.sp * scaleFactor,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 12.h * scaleFactor),
            Text(
              "Please check your internet connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp * scaleFactor,
                color: Colors.grey[600],
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h * scaleFactor),
            SizedBox(
              width: 160.w * scaleFactor,
              height: 48.h * scaleFactor,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE47830),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                ),
                child: Text(
                  "Retry",
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}