import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/test_extensions.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet detection
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet
            ? (constraints.maxWidth / 411).clamp(1.0, 1.5)
            : 1.0;

        // Calculate the effective padding we need at the bottom
        final double effectivePadding = bottomPadding > 0 ? bottomPadding : 8.h * scaleFactor;
        // The total height is the content height (70) + the safe area padding
        final double totalHeight = 70.h * scaleFactor + effectivePadding;

        return Container(
          // Removed padding here so the click area can extend to the edge
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEFD),
            border: Border(
              top: BorderSide(
                color: const Color(0xFFFA9441),
                width: 0.5.w * scaleFactor,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: SizedBox(
            height: totalHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures items fill vertical height
              children: [
                _buildNavItem('assets/icons/chayansathi.svg', 'Chayan Sathi', 0, scaleFactor, effectivePadding),
                _buildNavItem('assets/icons/bookings.svg', 'Bookings', 1, scaleFactor, effectivePadding),
                _buildCenterNavItem('assets/icons/chayankaro.jpg', 'Chayan Karo', 2, scaleFactor, effectivePadding),
                _buildNavItem('assets/icons/refer.svg', 'Referral', 3, scaleFactor, effectivePadding),
                _buildNavItem('assets/icons/profile.svg', 'Profile', 4, scaleFactor, effectivePadding),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index, double scaleFactor, double bottomPadding) {
    final bool isActive = selectedIndex == index;

    return Expanded( // Expanded ensures horizontal click area is maximized
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Color must be transparent (not null) to capture clicks in empty space
          color: Colors.transparent, 
          // Apply the padding INSIDE the click area
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorFiltered(
                colorFilter: isActive
                    ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                    : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                child: iconPath.endsWith('.svg')
                    ? SvgPicture.asset(
                        iconPath,
                        width: 36.w * scaleFactor,
                        height: 36.h * scaleFactor,
                        color: isActive ? null : Colors.black,
                      )
                    : Image.asset(
                        iconPath,
                        width: 36.w * scaleFactor,
                        height: 36.h * scaleFactor,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 2.h * scaleFactor),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8.sp * scaleFactor,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).withId('nav_${label.toLowerCase().replaceAll(' ', '_')}');
  }

  Widget _buildCenterNavItem(String iconPath, String label, int index, double scaleFactor, double bottomPadding) {
    // 1. Check if this tab is active
    final bool isActive = selectedIndex == index;
    // Your active orange color
    const Color activeColor = Color(0xFFFA9441);
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 34.h * scaleFactor,
                child: Center(
                  child: Container(
                    width: 20.8.w * scaleFactor,
                    height: 20.2.h * scaleFactor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2 * scaleFactor),
                      image: DecorationImage(
                        image: AssetImage(iconPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h * scaleFactor),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8.sp * scaleFactor,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
color: isActive ? activeColor : Colors.black,                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).withId('nav_center_home');
  }
}