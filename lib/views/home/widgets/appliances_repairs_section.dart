import 'package:flutter/material.dart';
import '../../../services/HomeRepairsScreen.dart';

class AppliancesRepairsSection extends StatelessWidget {
  const AppliancesRepairsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> appliances = [
      {'title': 'Chimney', 'image': 'assets/chimney.png'},
      {'title': 'Washing Machine', 'image': 'assets/washing_machine.png'},
      {'title': 'Water Purifier', 'image': 'assets/water_purifier.jpg'},
      {'title': 'Refrigerator', 'image': 'assets/refrigerator.jpg'},
      {'title': 'Air Cooler', 'image': 'assets/air_cooler.jpg'},
      {'title': 'Television', 'image': 'assets/television.jpg'},
      {'title': 'AC Services and Repair', 'image': 'assets/ac_repair.png'},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // prevents overflow
      child: Column(
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
                      builder: (_) =>  HomeRepairsScreen(),
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

          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appliances.length,
              itemBuilder: (context, index) {
                final appliance = appliances[index];
                return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 0,
                    right: 12,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          appliance['image']!,
                          width: 191.11,
                          height: 260,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 191.11,
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
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
