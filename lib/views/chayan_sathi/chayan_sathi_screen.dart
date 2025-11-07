import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/saathi_controller.dart';
import '../../models/saathi_models.dart';

class ChayanSathiScreen extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final String locationId;
  final String? initialSlot;

  const ChayanSathiScreen({
    super.key,
    required this.categoryId,
    required this.serviceId,
    required this.locationId,
    this.initialSlot,
  });

  @override
  State<ChayanSathiScreen> createState() => _ChayanSathiScreenState();
}

class _ChayanSathiScreenState extends State<ChayanSathiScreen> {
  late final SaathiController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SaathiController>(); // registered in AppBinding
    
    // TODO: REMOVE THIS - Sample data for testing payment gateway
    _addSampleProviders();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProviders(
        categoryId: widget.categoryId,
        serviceId: widget.serviceId,
        locationId: widget.locationId,
      );
    });
  }

  // TODO: REMOVE THIS METHOD - Only for testing payment gateway
  void _addSampleProviders() {
    final sampleProviders = [
      SaathiItem(
        id: 'sample_1',
        name: 'Rajesh Kumar',
        rating: 4.8,
        jobsCompleted: 156,
        imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        description: 'Expert service provider with 5+ years experience',
      ),
      SaathiItem(
        id: 'sample_2',
        name: 'Priya Sharma',
        rating: 4.9,
        jobsCompleted: 203,
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        description: 'Professional and reliable service specialist',
      ),
      SaathiItem(
        id: 'sample_3',
        name: 'Amit Singh',
        rating: 4.7,
        jobsCompleted: 128,
        imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
        description: 'Certified professional with excellent track record',
      ),
      SaathiItem(
        id: 'sample_4',
        name: 'Sneha Patel',
        rating: 4.6,
        jobsCompleted: 95,
        imageUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
        description: 'Skilled provider with attention to detail',
      ),
      SaathiItem(
        id: 'sample_5',
        name: 'Vikram Mehta',
        rating: 4.9,
        jobsCompleted: 247,
        imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
        description: 'Top-rated professional in the area',
      ),
      SaathiItem(
        id: 'sample_6',
        name: 'Anjali Verma',
        rating: 4.8,
        jobsCompleted: 189,
        imageUrl: 'https://randomuser.me/api/portraits/women/32.jpg',
        description: 'Experienced and customer-focused provider',
      ),
    ];

    // Clear any existing data and add sample data
    controller.saathiList.clear();
    controller.saathiList.addAll(sampleProviders);
    controller.isLoading.value = false;
    controller.error.value = ''; // Clear any error
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;
      final list = controller.saathiList;

      return LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth > 600;
          final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                ChayanHeader(
                  title: 'Chayan Saathi',
                  onBack: () => Navigator.pop(context),
                ),

                if (isLoading && list.isEmpty)
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 28.w * scaleFactor,
                        height: 28.w * scaleFactor,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                else if (error.isNotEmpty && list.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Failed to load providers',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ),
                  )
                else if (list.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No providers available for this selection',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        16.h * scaleFactor,
                        16.h * scaleFactor,
                        16.h * scaleFactor,
                        90.h * scaleFactor,
                      ),
                      itemCount: list.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12 * scaleFactor,
                        mainAxisSpacing: 12 * scaleFactor,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final saathi = list[index];
                        return InkWell(
                          onTap: () => Navigator.pop(context, {
                            'id': saathi.id,
                            'name': saathi.name,
                            'rating': saathi.rating ?? 0.0,
                            'jobs': saathi.jobsCompleted ?? 0,
                            'image': saathi.imageUrl ?? '',
                            'description': saathi.description ?? '',
                          }),
                          child: _buildSaathiCard(saathi, scaleFactor),
                        );
                      },
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: controller.selectedIndex.value,
              onItemTapped: (index) => _onItemTapped(context, controller, index),
            ),
          );
        },
      );
    });
  }

  Widget _buildSaathiCard(SaathiItem saathi, double scaleFactor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15 * scaleFactor),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.h * scaleFactor),
            ),
            child: saathi.imageUrl != null && saathi.imageUrl!.isNotEmpty
                ? Image.network(
                    saathi.imageUrl!,
                    height: 140.h * scaleFactor,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140.h * scaleFactor,
                      color: const Color(0xFFF5F5F5),
                      alignment: Alignment.center,
                      child: Icon(Icons.person, size: 40 * scaleFactor, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 140.h * scaleFactor,
                    color: const Color(0xFFF5F5F5),
                    alignment: Alignment.center,
                    child: Icon(Icons.person, size: 40 * scaleFactor, color: Colors.grey),
                  ),
          ),
          SizedBox(height: 8.h * scaleFactor),

          // Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w * scaleFactor),
            child: Text(
              saathi.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'SFProSemibold',
                fontSize: 14.sp * scaleFactor,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 6.h * scaleFactor),

          // Jobs row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w * scaleFactor),
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(-2.w * scaleFactor, 0),
                  child: SvgPicture.asset(
                    'assets/icons/tick.svg',
                    width: 14.w * scaleFactor,
                    height: 14.h * scaleFactor,
                  ),
                ),
                SizedBox(width: 4.w * scaleFactor),
                Text(
                  '${saathi.jobsCompleted ?? 0} jobs completed',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 12.sp * scaleFactor,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h * scaleFactor),

          // Rating row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w * scaleFactor),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/star.svg',
                  width: 14.w * scaleFactor,
                  height: 14.h * scaleFactor,
                  color: Colors.black,
                ),
                SizedBox(width: 4.w * scaleFactor),
                Text(
                  '${(saathi.rating ?? 0.0).toStringAsFixed(1)}',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 12.sp * scaleFactor,
                    color: Colors.black,
                  ),
                ),
                Text(
                  ' (23k)', // placeholder
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 12.sp * scaleFactor,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, SaathiController controller, int index) {
    controller.onItemTapped(index);

    switch (index) {
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }
}
