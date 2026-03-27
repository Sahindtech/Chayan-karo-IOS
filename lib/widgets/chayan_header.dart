import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class ChayanHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const ChayanHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFEEE0); // Peach color
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet detection
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: backgroundColor,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: Column(
            children: [
              Container(height: statusBarHeight, color: backgroundColor),
              Container(
                height: 56.h * scaleFactor,
                color: backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 12.w * scaleFactor),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack ?? () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20 * scaleFactor,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12.w * scaleFactor),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp * scaleFactor,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 32.w * scaleFactor),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
