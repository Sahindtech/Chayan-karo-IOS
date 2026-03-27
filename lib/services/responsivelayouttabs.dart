import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable wrapper to scale any screen for tablets and large screens,
/// while keeping phone UI unchanged.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Size designSize;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 420,
    this.designSize = const Size(360, 800),
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // If tablet, center phone-width UI and use all available height
        if (constraints.maxWidth > maxWidth) {
          return Center(
            child: Container(
              width: maxWidth,
              height: constraints.maxHeight,
              color: Colors.white,
              child: child,
            ),
          );
        }
        // On phones, use full width
        return child;
      },
    );
  }
}
