import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/FemaleSpaScreen.dart';

class SpaWomenSection extends StatelessWidget {
  const SpaWomenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Spa - Women',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FemaleSpaScreen()),
                );
              },
              child: Padding(padding: EdgeInsets.only(right: 16.r),
                child: Text(
                  'View all >',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Horizontal Scroll Cards
        SizedBox(
          height: 186.h, // 164 + 22
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = _items[index];
              return _SpaWomenCard(
                imagePath: item['imagePath']!,
                label: item['label']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

final List<Map<String, String>> _items = [
  {
    'imagePath': 'assets/spa_massage.webp',
    'label': 'Full Body Massage',
  },
  {
    'imagePath': 'assets/spa_scrub.webp',
    'label': 'Body Scrub',
  },
  {
    'imagePath': 'assets/spa_steam.webp',
    'label': 'Steam Therapy',
  },
];

class _SpaWomenCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const _SpaWomenCard({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144.w,
      height: 164.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFFFD9BE), width: 1.w),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFFFD9BE),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}