import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';



// Screens
import '../all_most_used_services/all_most_used_services_screen.dart';
import '/widgets/service_bottom_sheet.dart';
import '../cart/cart_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../booking/booking_screen.dart';
import '../rewards/rewards_screen.dart';
import '../profile/profile_screen.dart';
import '../../services/saloonservicescreen.dart';
import '../../services/SalonMenServiceScreen.dart';
import '../../services/HairSkinScreen.dart';
import '../../services/MaleSpaScreen.dart';
import '../../services/ACServicesScreen.dart';
import '../../services/CleaningScreen.dart';
import '../../services/HomeRepairsScreen.dart';
import '../../services/FemaleSpaScreen.dart';
// Modular sections
import '../home/widgets/appliances_repairs_section.dart';
import '../home/widgets/salon_men_section.dart';
import '../home/widgets/ac_repair_section.dart';
import '../home/widgets/male_spa_section.dart';
import '../home/widgets/spa_women_section.dart';
import '../home/widgets/saloon_women_section.dart';
import '../home/widgets/horizontal_service_scroll.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  String address = 'Fetching location...';
  String locationLabel = 'Home'; // ✅ Declare this

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      locationLabel = prefs.getString('location_label') ?? 'Home';
      address = prefs.getString('location_address') ?? 'Not Available';
    });
  }
  Widget _buildLocationInfo() {
  String cityOnly = '';
  if (address.contains(',')) {
    cityOnly = address.split(',').last.trim();
  } else {
    cityOnly = address.trim();
  }

  return Text(
    '$locationLabel\n$cityOnly',
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );
}

  final List<Map<String, String>> categories = [
    {'title': 'Female Saloon', 'icon': 'assets/icons/female_saloon.png'},
    {'title': 'Female Spa', 'icon': 'assets/icons/female_spa.png'},
    {'title': 'Male Saloon', 'icon': 'assets/icons/male_saloon.png'},
    {'title': 'Male Spa', 'icon': 'assets/icons/male_spa.png'},
    {'title': 'Hair & Skin', 'icon': 'assets/icons/hair_skin.png'},
    {'title': 'Home Repairs', 'icon': 'assets/icons/home_repairs.png'},
    {'title': 'Cleaning', 'icon': 'assets/icons/cleaning.png'},
    {'title': 'AC Services', 'icon': 'assets/icons/ac_service.png'},
  ];

  final List<Map<String, dynamic>> goToServices = [
    {
      'title': 'Beauty & Wellness (Men)',
      'subtitle': '10 services',
      'images': ['assets/m1.jpg', 'assets/m2.jpg', 'assets/m3.jpg', 'assets/m4.jpg'],
    },
    {
      'title': 'Appliance and Repair',
      'subtitle': '4 services',
      'images': ['assets/a1.jpg', 'assets/a2.jpg', 'assets/a3.jpg', 'assets/a4.jpg'],
    },
    {
      'title': 'Carpenter & Plumber',
      'subtitle': '2 services',
      'images': ['assets/c1.png', 'assets/c2.png', 'assets/c3.png', 'assets/c4.png'],
    },
  ];

  final List<Map<String, String>> mostUsedServices = [
    {'image': 'assets/z1.png', 'title': 'Window AC frame Installation'},
    {'image': 'assets/z2.png', 'title': 'Women Salon Services'},
    {'image': 'assets/z3.png', 'title': 'Home Deep Cleaning'},
    {'image': 'assets/z4.png', 'title': 'Spa for Men'},
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChayanSathiScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => RewardsScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

@override
Widget build(BuildContext context) {
  // Set status bar color to match the top peach section
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFFFFEEE0),
    statusBarIconBrightness: Brightness.dark,
  ));

  return Scaffold(
    backgroundColor: const Color(0xFFFDFDFD), // White background for rest

    body: SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 70,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🍑 Peach background only for header
            Container(
              color: const Color(0xFFFFEEE0),
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location + Cart
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/homy.png',
                              width: 40,
                              height: 40,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            _buildLocationInfo()

                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CartScreen()),
                          ),
                          child: Image.asset(
                            'assets/icons/cart.png',
                            width: 40,
                            height: 40,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for services',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF8F6F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔲 Categories Grid + everything else
            Container(
              color: const Color(0xFFFDFDFD), // Explicit white background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📦 Categories
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (_, index) {
                        final cat = categories[index];
                        return GestureDetector(
                          onTap: () {
                            if (cat['title'] == 'Female Saloon') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SalonServiceScreen()));
      } else if (cat['title'] == 'Male Saloon') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SalonMenServiceScreen()));
      } else if (cat['title'] == 'Female Spa') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FemaleSpaScreen()));
      } else if (cat['title'] == 'Male Spa') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MaleSpaScreen()));
      } else if (cat['title'] == 'Hair & Skin') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HairSkinScreen()));
      } else if (cat['title'] == 'Home Repairs') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeRepairsScreen()));
      } else if (cat['title'] == 'Cleaning') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CleaningScreen()));
      } else if (cat['title'] == 'AC Services') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ACServicesScreen()));
      }
    },
                          child: Container(
                            width: 70,
                            height: 85,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFFFD9BE)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0xFFF2C4A5),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(cat['icon']!, width: 45, height: 45),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 56,
                                    child: Text(
                                      cat['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 8,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 2.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🎯 Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8F39), Color(0xFFFF6F00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Let’s make a package just\nfor you, Manvi!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Salon for women",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward,
                                          size: 16, color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/banner_woman.png',
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildServiceSection('Your go-to services', goToServices),
                  const SizedBox(height: 24),
                  _buildMostUsedServices(mostUsedServices),
                ],
              ),
            ),
          ],
        ),
      ),
    ),

    bottomNavigationBar: CustomBottomNavBar(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    ),
  );
}



  Widget _buildServiceSection(String title, List<Map<String, dynamic>> data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
       child: Text(
  title,
  style: const TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    height: 1.33,
  ),
),

      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 12),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final item = data[index];
            return GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ServiceBottomSheet(
                  title: item['title'],
                  subtitle: item['subtitle'],
                  images: List<String>.from(item['images']),
                ),
              ),
              child: Container(
                width: 170,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (_, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item['images'][i],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}


Widget _buildMostUsedServices(List<Map<String, String>> services) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Updated Title TextStyle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Most used services',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.33,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllMostUsedServicesScreen(
                      mostUsedServices: mostUsedServices,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'View all >',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HorizontalServiceScroll(services: services),
        const SizedBox(height: 24),
        const SaloonWomenSection(),
        const SizedBox(height: 24),
        const SpaWomenSection(),
        const SizedBox(height: 24),
        const MaleSpaSection(),
        const SizedBox(height: 24),
        const SalonMenSection(),
        const SizedBox(height: 24),
        const ACRepairSection(),
        const SizedBox(height: 24),
        const AppliancesRepairsSection(),
        const SizedBox(height: 24),
      ],
    ),
  );
}


}
