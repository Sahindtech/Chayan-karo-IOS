import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

 @override
Widget build(BuildContext context) {
  final bottomPadding = MediaQuery.of(context).padding.bottom;

  return Container(
    padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFEFD),
      border: const Border(
        top: BorderSide(
          color: Color(0xFFFA9441),
          width: 0.5,
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
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
  _buildNavItem('assets/icons/chayansathi.svg', 'Chayan Sathi', 0),
  _buildNavItem('assets/icons/bookings.svg', 'Bookings', 1),
  _buildCenterNavItem('assets/icons/chayankaro.jpg', 'Chayan Karo', 2),
  _buildNavItem('assets/icons/rewards.svg', 'Rewards', 3),
  _buildNavItem('assets/icons/profile.svg', 'Profile', 4),
],

      ),
    ),
  );
}


 Widget _buildNavItem(String iconPath, String label, int index) {
  final bool isActive = selectedIndex == index;

  return GestureDetector(
    onTap: () => onItemTapped(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter: isActive
              ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
              : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          child: iconPath.endsWith('.svg')
              ? SvgPicture.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  color: isActive ? null : Colors.black,
                )
              : Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            height: 2,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}


 Widget _buildCenterNavItem(String iconPath, String label, int index) {
  final bool isActive = selectedIndex == index;

  return GestureDetector(
    onTap: () => onItemTapped(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: Container(
              width: 24.45,
              height: 23.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                image: DecorationImage(
                  image: AssetImage(iconPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            height: 2,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

}
