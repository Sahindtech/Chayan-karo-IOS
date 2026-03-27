import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

// --- Imports ---
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import '../../widgets/three_dot_loader.dart'; 
import './widgets/bouncy_card.dart'; 

// --- Controllers & Models ---
import '../../controllers/booked_saathi_controller.dart'; 
import '../../controllers/saathi_controller.dart'; 
import '../../models/booked_saathi_model.dart'; 
import '../../models/saathi_models.dart'; 

// --- Screens ---
import 'chayan_sathi_rating_screen.dart'; 
import './saathi_service_screen.dart';

class PreviousChayanSathiScreen extends StatefulWidget {
  const PreviousChayanSathiScreen({super.key});

  @override
  State<PreviousChayanSathiScreen> createState() =>
      _PreviousChayanSathiScreenState();
}

class _PreviousChayanSathiScreenState extends State<PreviousChayanSathiScreen> {
  final BookedSaathiController listController = Get.put(BookedSaathiController());
  final SaathiController lockController = Get.put(SaathiController());

  // Local state for immediate UI updates
  final RxSet<String> locallyUnlockedIds = <String>{}.obs;

  @override
  Widget build(BuildContext context) {
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

              Expanded(
                child: Obx(() {
                  final isLoading = listController.isLoading.value;
                  final list = listController.saathiList;
                  final lastLockedId = lockController.lastLockedProviderId.value;

                  // ✅ LOGIC FIX: 
                  // 1. If we just unlocked it locally -> Unlocked
                  // 2. If it's saved in SharedPrefs -> Unlocked
                  // 3. If API says !isLocked -> Unlocked
                  bool isProviderInteractable(BookedSaathiItem p) {
                    if (locallyUnlockedIds.contains(p.id)) return true;
                    if (p.id == lastLockedId) return true;
                    if (!p.isLocked) return true; 
                    return false; // Actually locked by someone else
                  }

                  if (isLoading) {
                    return Center(
                      child: ThreeDotLoader(
                        size: 14.w * scaleFactor,
                        color: const Color(0xFFE47830),
                      ),
                    );
                  }

                  if (list.isEmpty) {
                    return _buildEmptyState(context, scaleFactor);
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(16.h * scaleFactor),
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12 * scaleFactor,
                      mainAxisSpacing: 12 * scaleFactor,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (context, index) {
                      final saathi = list[index];
                      final isInteractable = isProviderInteractable(saathi);

                      // ✅ Pass 'isInteractable' so we know if it's visually enabled
                      return Opacity(
                        opacity: isInteractable ? 1.0 : 0.4,
                        child: _buildLockableCard(saathi, scaleFactor, isInteractable),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 0, 
            onItemTapped: (index) => _onItemTapped(context, index),
          ),
        );
      },
    );
  }

  Widget _buildLockableCard(BookedSaathiItem provider, double scaleFactor, bool isInteractable) {
    return Obx(() {
      final isLocking = lockController.lockingProviderId.value == provider.id;

      return BouncyCard(
        // If it is NOT interactable (locked by others), disable tap.
        // If it IS interactable (free OR owned by us), allow tap.
        onTap: (!isInteractable || isLocking)
            ? null
            : () async {
                await _handleLockAndNavigate(provider);
              },
        child: Stack(
          children: [
            _buildSaathiCardUI(provider, scaleFactor),

            if (isLocking)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15 * scaleFactor),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 22.w * scaleFactor,
                    height: 22.w * scaleFactor,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFE47830),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Future<void> _handleLockAndNavigate(BookedSaathiItem provider) async {
    // ✅ CHECK: Do we already own this lock?
    final bool isAlreadyMine = locallyUnlockedIds.contains(provider.id) ||
        lockController.lastLockedProviderId.value == provider.id;

    // ✅ SHORT-CIRCUIT: If we own it, navigate IMMEDIATELY. Skip API.
    if (isAlreadyMine) {
      _navigateToService(provider);
      return; 
    }

    // If not ours, we must lock it via API
    final saathiItem = _mapToSaathiItem(provider);

    // Inject into controller list so helper methods work
    if (!lockController.saathiList.any((e) => e.id == saathiItem.id)) {
      lockController.saathiList.add(saathiItem);
    }

    // Call API
    final res = await lockController.lockOnTap(
      provider.id,
      bookingDate: DateTime.now(),
    );

    if (res != null && res.isSuccess) {
      // ✅ Update Local State on success
      locallyUnlockedIds.add(provider.id);
      _navigateToService(provider);
    } else {
      if (lockController.error.value.isNotEmpty) {
         Get.snackbar('Lock Failed', lockController.error.value, 
           backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    
    lockController.lockingProviderId.value = '';
  }

  // Helper to keep navigation consistent
  void _navigateToService(BookedSaathiItem provider) {
    Get.to(() => SaathiServiceScreen(
      providerData: provider,
      isRebooking: true, 
    ));
  }

  // --- UI Components ---

  Widget _buildSaathiCardUI(BookedSaathiItem saathi, double scaleFactor) {
    final bool hasNetImage =
        saathi.imgLink != null && saathi.imgLink!.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15 * scaleFactor),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.h * scaleFactor),
            ),
            child: hasNetImage
                ? Image.network(
                    saathi.imgLink!,
                    height: 140.h * scaleFactor,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(scaleFactor),
                  )
                : _buildPlaceholder(scaleFactor),
          ),

          SizedBox(height: 8.h * scaleFactor),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w * scaleFactor),
            child: Text(
              saathi.fullName,
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
                Expanded(
                  child: Text(
                    "${saathi.totalReview} jobs completed",
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 12.sp * scaleFactor,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h * scaleFactor),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star.svg',
                      width: 14.w * scaleFactor,
                      height: 14.h * scaleFactor,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4.w * scaleFactor),
                    Text(
                      saathi.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 12.sp * scaleFactor,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () {
                    final mappedItem = _mapToSaathiItem(saathi);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChayanSathiRatingScreen(saathi: mappedItem),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/review.svg',
                    height: 24.h * scaleFactor,
                    width: 24.w * scaleFactor,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h * scaleFactor),
        ],
      ),
    );
  }

  SaathiItem _mapToSaathiItem(BookedSaathiItem booked) {
    return SaathiItem(
      id: booked.id,
      name: booked.fullName,
      rating: booked.averageRating.toDouble(),
      jobsCompleted: booked.totalReview,
      imageUrl: booked.imgLink,
      isLocked: booked.isLocked, 
      mobileNo: booked.mobileNo,
      description: "",
    );
  }

  Widget _buildPlaceholder(double scaleFactor) {
    return Container(
      height: 140.h * scaleFactor,
      width: double.infinity,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Icon(Icons.person, color: Colors.grey, size: 40 * scaleFactor),
    );
  }

  Widget _buildEmptyState(BuildContext context, double scaleFactor) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.75.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 110.w * scaleFactor,
              height: 110.h * scaleFactor,
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/chayansathi.svg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.h * scaleFactor),
            Text(
              'No Service Providers Found',
              style: TextStyle(
                fontSize: 20.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30.h * scaleFactor),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 175.w * scaleFactor,
                height: 45.h * scaleFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                  border: Border.all(color: const Color(0xFFE47830), width: 2),
                ),
                alignment: Alignment.center,
                child: Text('Go Back', style: TextStyle(color: const Color(0xFFE47830), fontWeight: FontWeight.w500, fontSize: 16.sp * scaleFactor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
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