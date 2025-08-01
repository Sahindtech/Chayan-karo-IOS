import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FemaleSpaScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
  // Set status bar color to match header
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: const Color(0xFFFFEEE0), // Matches header background
    statusBarIconBrightness: Brightness.dark, // For dark icons
  ));

  return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // match bottom nav height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add top padding equal to status bar height manually
              Container(
                color: const Color(0xFFFFEEE0),
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: _buildHeader(context),
              ),
              const SizedBox(height: 12),
              _buildTopBanner(),
              const SizedBox(height: 12),
              _buildSalonInfoBlock(),
              const SizedBox(height: 16),
              _buildDiscountCards(),
              const SizedBox(height: 16),
              _buildCustomPackageSection(),
              const SizedBox(height: 16),
              _buildCategoryGrid(),
              const SizedBox(height: 16),
              _buildServiceCards(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    ),
  );
}

  Widget _buildHeader(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 48,
    decoration: BoxDecoration(
      color: const Color(0xFFFFEEE0),
      boxShadow: [
        BoxShadow(
          color: const Color(0x26000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Spa for Women",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Image(
            image: AssetImage('assets/icons/cart.png'),
            width: 32,
            height: 32,
            color: Colors.black,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildTopBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset(
            'assets/single_use_product.jpg',
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Single use products",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSalonInfoBlock() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Spa for Women",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12), // Add padding to push it inward
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/warranty.png',
                    width: 16,
                    height: 16,
                    color:Colors.black,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'CK safe',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text("4.8 (23k)", style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Image.asset('assets/icons/star.png', width: 18, color: Colors.black),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text("354 jobs completed", style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Image.asset('assets/icons/tick.png', width: 18, color: Colors.black),
          ],
        ),
      ],
    ),
  );
}


Widget _buildDiscountCards() {
  final List<Map<String, String>> offers = [
    {
      'icon': 'assets/icons/cash.png',
      'title': 'Save 15% on every order',
      'subtitle': 'Get Plus now',
    },
    {
      'icon': 'assets/icons/card.png',
      'title': 'CRED Pay',
      'subtitle': 'Upto Rs. 100 cashback',
    },
  ];

  return SizedBox(
    height: 100, // Increased to allow full text rendering
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Container(
          width: 240, // Gives extra space for text lines
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Image.asset(
                offer['icon']!,
                width: 28,
                height: 28,
                color: Colors.black, // This applies a black tint
              ),
              const SizedBox(width: 12),
              Flexible( // Allows Column to expand based on content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      offer['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      softWrap: true,
                      maxLines: 2, // Let long titles wrap
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer['subtitle']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemCount: offers.length,
    ),
  );
}



Widget _buildCustomPackageSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      height: 100, // Slightly increased to accommodate two lines of text
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE47830),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/package.svg',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    width: 205.67,
                    height: 26.46,
                    child: Text(
                      'Create a Customer Package',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: 156.31,
                    height: 26.46,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Specifically for your needs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.85,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios, // Native forward arrow
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    ),
  );
}


Widget _buildCategoryGrid() {
  final categories = [
    {'title': 'Full Body Massage', 'image': 'assets/z2.png'},
    {'title': 'Head & Shoulder Massage', 'image': 'assets/s1.jpg'},
    {'title': 'Body Polishing', 'image': 'assets/s2.png'},
    {'title': 'Aromatherapy', 'image': 'assets/s3.png'},
    {'title': 'Scrub & Wraps', 'image': 'assets/s4.jpg'},
    {'title': 'Relaxing Foot Spa', 'image': 'assets/s5.png'},
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categories",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFFFD9BE),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33E47830),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}


Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("2 items", style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 4),
                Text("₹400",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE47830),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

    
 Widget _buildServiceCards() {
 final Map<String, List<Map<String, String>>> groupedServices = {
  'Full Body Massage': [
    {
      'image': 'assets/z2.png',
      'title': 'Swedish Massage',
      'price': '₹899',
      'rating': '4.85',
      'duration': '60 mins',
    },
    {
      'image': 'assets/z2.png',
      'title': 'Deep Tissue Massage',
      'price': '₹999',
      'rating': '4.88',
      'duration': '75 mins',
    },
  ],
  'Head & Shoulder Massage': [
    {
      'image': 'assets/s1.jpg',
      'title': 'Ayurvedic Head Massage',
      'price': '₹399',
      'rating': '4.76',
      'duration': '30 mins',
    },
    {
      'image': 'assets/s1.jpg',
      'title': 'Shoulder De-stress Massage',
      'price': '₹449',
      'rating': '4.78',
      'duration': '35 mins',
    },
  ],
  'Body Polishing': [
    {
      'image': 'assets/s2.png',
      'title': 'Full Body Scrub',
      'price': '₹999',
      'rating': '4.82',
      'duration': '60 mins',
    },
    {
      'image': 'assets/s2.png',
      'title': 'Glow Polishing Treatment',
      'price': '₹1099',
      'rating': '4.80',
      'duration': '70 mins',
    },
  ],
  'Aromatherapy': [
    {
      'image': 'assets/s3.png',
      'title': 'Lavender Bliss Massage',
      'price': '₹849',
      'rating': '4.79',
      'originalPrice': '₹599',
      'duration': '60 mins',
      'desc': '• Aromatic oils\n• Relaxes body and mind\n• Good for sleep',
    },
    {
      'image': 'assets/s3.png',
      'title': 'Rose Aroma Ritual',
      'price': '₹899',
      'originalPrice': '₹599',
      'rating': '4.82',
      'duration': '65 mins',
      'desc': '• Floral oil infusion\n• Uplifting mood\n• Skin softening',
    },
  ],
};

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedServices.entries.map((entry) {
        final String category = entry.key;
        final List<Map<String, String>> services = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...services.map((service) {
              if (!category.toLowerCase().contains('aromatherapy')) {
                // Cleanup & Bleach & Detan with ADD button
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          service['image']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service['title']!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Image.asset('assets/icons/star.png',
                                    width: 18,  color: Colors.black,),
                                const SizedBox(width: 4),
                                Text(
                                  "${service['rating']} | ${service['duration']}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(service['price']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 29,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 75,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  shadows: [
                                    BoxShadow(
                                      color: const Color(0x33000000),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 32,
                              top: 5.38,
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xFFE47830),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 16,
                              top: 9,
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: Icon(Icons.add,
                                    size: 12, color: Color(0xFFE47830)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Facial with title & add button in same row
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.asset(
                          service['image']!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Add button in same row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(service['title']!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  width: 75,
                                  height: 29,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 75,
                                          height: 29,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            shadows: [
                                              BoxShadow(
                                                color: const Color(0x33000000),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 32,
                                        top: 5.38,
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Color(0xFFE47830),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 16,
                                        top: 9,
                                        child: SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: Icon(Icons.add,
                                              size: 12,
                                              color: Color(0xFFE47830)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Image.asset('assets/icons/star.png',
                                    width: 18,  color: Colors.black,),
                                const SizedBox(width: 4),
                                Text(
                                  "${service['rating']} | ${service['duration']}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(service['price']!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                const SizedBox(width: 6),
                                Text(service['originalPrice']!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey)),
                              ],
                            ),
                            if (service['desc'] != null &&
                                service['desc']!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                service['desc']!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          ],
        );
      }).toList(),
    ),
  );
}
}