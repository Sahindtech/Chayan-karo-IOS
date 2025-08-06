import 'package:flutter/material.dart';
import '../../../services/SalonMenServiceScreen.dart';

class SalonMenSection extends StatelessWidget {
  const SalonMenSection({super.key});

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
              "Salon - Men",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>SalonMenServiceScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "View All >",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 164,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _SalonMenTile(
                imagePath: 'assets/salon_men_haircut_beard.webp',
                label: 'Haircut & Beard Styling',
              ),
              _SalonMenTile(
                imagePath: 'assets/salon_men_haircolor_spa.webp',
                label: 'Hair Colour & Hair Spa',
              ),
              _SalonMenTile(
                imagePath: 'assets/salon_men_facial_cleanup.webp',
                label: 'Facial & Cleanup',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SalonMenTile extends StatelessWidget {
  final String imagePath;
  final String label;

  const _SalonMenTile({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144,
      height: 164,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD9BE), width: 1),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 144,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD9BE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
