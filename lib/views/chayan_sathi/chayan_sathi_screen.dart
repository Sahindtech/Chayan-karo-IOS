import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart';
import '../rewards/rewards_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';

class ChayanSathiScreen extends StatelessWidget {
  final List<Map<String, dynamic>> saathiList = [
    {
      "name": "Anita Kumari",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi1.png",
    },
    {
      "name": "Ansh Kumar",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi2.png",
    },
    {
      "name": "Sunil Kumar",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi3.png",
    },
    {
      "name": "Anita Kumari",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi1.png",
    },
    {
      "name": "Sunil Kumar",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi3.png",
    },
    {
      "name": "Anita Kumari",
      "rating": "4.8",
      "jobs": "354",
      "image": "assets/saathi1.png",
    },
  ];

  final int _selectedIndex = 0;

  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RewardsScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ Use the shared ChayanHeader
          ChayanHeader(
            title: 'Chayan Saathi',
            onBackTap: () => Navigator.pop(context),
          ),


          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90), // top padding moved here
              itemCount: saathiList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final saathi = saathiList[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          saathi["image"],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        saathi["name"],
                        style: const TextStyle(
                          fontFamily: 'SFProSemibold',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ✅ Tick icon line (jobs completed) comes FIRST
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/tick.png',
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${saathi["jobs"]} jobs completed",
                            style: const TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // ✅ Star icon (rating) comes SECOND
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/star.png',
                            width: 14,
                            height: 14,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${saathi["rating"]}",
                            style: const TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            " (23k)",
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
