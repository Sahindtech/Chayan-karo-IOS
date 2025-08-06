import 'package:flutter/material.dart';
import '../../../services/HomeRepairsScreen.dart';

class AppliancesRepairsSection extends StatelessWidget {
  const AppliancesRepairsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> appliances = [
      {'title': 'Chimney', 'image': 'assets/chimney.webp'},
      {'title': 'Washing Machine', 'image': 'assets/washing_machine.webp'},
      {'title': 'Water Purifier', 'image': 'assets/water_purifier.webp'},
      {'title': 'Refrigerator', 'image': 'assets/refrigerator.webp'},
      {'title': 'Air Cooler', 'image': 'assets/air_cooler.webp'},
      {'title': 'Television', 'image': 'assets/television.webp'},
      {'title': 'AC Services and Repair', 'image': 'assets/ac_repair.webp'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Appliances & Repairs',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeRepairsScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'View All >',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFFE47830),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Matching AC style (no extra horizontal padding, spacing via margin)
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appliances.length,
            itemBuilder: (context, index) {
              final appliance = appliances[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                width: 191.11,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD9BE), width: 1),
                  image: DecorationImage(
                    image: AssetImage(appliance['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD9BE),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      appliance['title']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
