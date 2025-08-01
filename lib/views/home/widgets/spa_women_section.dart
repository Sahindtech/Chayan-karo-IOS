import 'package:flutter/material.dart';
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
            const Text(
              'Spa - Women',
              style: TextStyle(
                fontSize: 16,
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
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'View all >',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Scroll Cards
        SizedBox(
          height: 186, // 164 + 22
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
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
    'imagePath': 'assets/spa_massage.png',
    'label': 'Full Body Massage',
  },
  {
    'imagePath': 'assets/spa_scrub.png',
    'label': 'Body Scrub',
  },
  {
    'imagePath': 'assets/spa_steam.png',
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
      width: 144,
      height: 164,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD9BE), width: 1),
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 144,
              height: 164,
              fit: BoxFit.cover,
            ),
          ),

          // Label at bottom inside image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD9BE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
