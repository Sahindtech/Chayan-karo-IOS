import 'package:flutter/material.dart';
import '../../../services/MaleSpaScreen.dart';

class MaleSpaSection extends StatelessWidget {
  const MaleSpaSection({super.key});

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
              'Spa - Men',
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
                  MaterialPageRoute(builder: (_) => MaleSpaScreen()),
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
          height: 164, // Only image height now
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _maleSpaItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _maleSpaItems[index];
              return _MaleSpaCard(
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

final List<Map<String, String>> _maleSpaItems = [
  {
    'imagePath': 'assets/spa_men_swedish.webp',
    'label': 'Swedish Massage',
  },
  {
    'imagePath': 'assets/spa_men_backrelief.webp',
    'label': 'Back Relief',
  },
  {
    'imagePath': 'assets/spa_men_bodypolish.webp',
    'label': 'Body Polish',
  },
];

class _MaleSpaCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const _MaleSpaCard({
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
            style: const TextStyle(
              fontSize: 10,
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
