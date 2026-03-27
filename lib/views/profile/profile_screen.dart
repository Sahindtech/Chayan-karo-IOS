import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:io'; // <--- Required for FileImage
// Screens
import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:chayankaro/views/profile/aboutscreen.dart';
import '/views/booking/PaymentScreen.dart';
import '/views/rewards/ReferAndEarnScreen.dart';
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../profile/EditProfileScreen.dart';
import '../profile/manage_address_screen.dart';
import '../profile/help_screen.dart';
import '../profile/rating_screen.dart';
import '../../utils/test_extensions.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/category_controller.dart';
import 'financial_details_screen.dart';

// Widgets & Controllers
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../data/local/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedIndex = 4;
  bool _isLoggingOut = false;
  
  // Profile Controller Dependency
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    // Initialize or Find the Controller
    _profileController = Get.put(ProfileController());
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 4) return;
    switch (index) {
      case 0:
        Get.offAll(() => PreviousChayanSathiScreen());
        break;
      case 1:
        Get.offAll(() => BookingScreen());
        break;
      case 2:
        Get.offAll(() => HomeScreen());
        break;
      case 3:
        Get.offAll(() => ReferAndEarnScreen());
        break;
      case 4:
        break;
    }
  }

  // UPDATED: User profile widget using imageUrl and default "Chayan Customer"
Widget _buildUserProfile(double scaleFactor) {
    return Obx(() {
      // 1. Loading State
      if (_profileController.isLoading && _profileController.customer == null) {
        return Row(
          children: [
            CircleAvatar(
              radius: 40 * scaleFactor,
              backgroundColor: Colors.grey[300],
              child: const CircularProgressIndicator(
                color: Color(0xFFE47830),
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 16.w * scaleFactor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150.w * scaleFactor,
                  height: 16.h * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8.h * scaleFactor),
                Container(
                  width: 120.w * scaleFactor,
                  height: 12.h * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        );
      }

      // 2. Error State
      if (_profileController.errorMessage.isNotEmpty && _profileController.customer == null) {
        return Row(
          children: [
            CircleAvatar(
              radius: 40 * scaleFactor,
              backgroundImage: const AssetImage('assets/userprofile.webp'),
            ),
            SizedBox(width: 16.w * scaleFactor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Failed to load profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp * scaleFactor,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 4.h * scaleFactor),
                  GestureDetector(
                    onTap: _profileController.refreshProfile,
                    child: Text(
                      'Tap to retry',
                      style: TextStyle(
                        fontSize: 12.sp * scaleFactor,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE47830),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      // 3. Success State
      final customer = _profileController.customer;

      // Name Logic
      String userName = 'Chayan Customer';
      if (customer?.fullName != null && customer!.fullName.isNotEmpty && customer.fullName != 'User') {
        userName = customer.fullName;
      }

      // Phone Logic
      final userPhone = customer?.mobileNo ?? '';

      return GestureDetector(
        // UPDATED: Using Named route with arguments
        onTap: () async{
         await Get.toNamed('/edit-profile', arguments: _profileController.customer);
         // 2. Force wake-up (Fixes the bug on low-end devices)
    if (mounted) {
      setState(() {}); 
    }
        },
        behavior: HitTestBehavior.opaque, // Ensures the empty space is clickable
        child: Row(
          children: [
          Obx(() { 
        // We nest a small Obx here to listen to 'localImage' and 'imageVersion'
        
        ImageProvider imageProvider;
        
        // 1. Check Local File First (Instant Feedback)
        if (_profileController.localImage.value != null) {
          imageProvider = FileImage(_profileController.localImage.value!);
        } 
        // 2. Check Network Image (Server Data) WITH CACHE BUSTING
        else if (customer?.imageUrl != null && customer!.imageUrl!.isNotEmpty) {
          // FIX: Append the version timestamp to the URL to force a refresh
          imageProvider = NetworkImage(
             '${customer.imageUrl!}?v=${_profileController.imageVersion.value}'
          );
        } 
        // 3. Fallback Default
        else {
          imageProvider = const AssetImage('assets/userprofile.webp');
        }

        return CircleAvatar(
          radius: 40 * scaleFactor,
          backgroundImage: imageProvider,
          backgroundColor: Colors.grey[200],
          onBackgroundImageError: (exception, stackTrace) {
            print('Error loading profile image: $exception');
          },
        );
      }),
            SizedBox(width: 16.w * scaleFactor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp * scaleFactor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (userPhone.isNotEmpty) ...[
                    SizedBox(height: 4.h * scaleFactor),
                    Text(
                      '+91 $userPhone',
                      style: TextStyle(
                        fontSize: 12.sp * scaleFactor,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF161616),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

Future<void> _handleLogout() async {
  FocusManager.instance.primaryFocus?.unfocus();
    if (_isLoggingOut) return;

    final bool? shouldLogout = await _showLogoutConfirmationDialog();
    if (shouldLogout != true) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // 1. Perform Secure Database Cleanup (Preserves Onboarding)
      final database = Get.find<AppDatabase>();
      await database.performSecureLogout();

      // 2. FORCE DELETE Critical Controllers (Fixes BUG-006 Crash)
      // This ensures fresh initialization on next login, preventing crashes from stale data.
      try {
        Get.delete<HomeController>(force: true);
        Get.delete<ProfileController>(force: true);
        Get.delete<LocationController>(force: true);
        Get.delete<CartController>(force: true); // Add if you have this class
        Get.delete<CategoryController>(force: true); // Add if you have this class
        // Add any other controllers that hold user-specific data
      } catch (e) {
        print("⚠️ Controller disposal warning: $e");
      }

      print('✅ User logged out successfully & State cleared');
      
      // 3. Navigate to Login Screen (clearing stack)
      Get.offAllNamed('/login');
      
    } catch (e) {
      print('❌ Error during logout: $e');
      // Fallback: Force navigation even if DB cleanup fails
      Get.offAllNamed('/login');
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Future<bool?> _showLogoutConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.orange, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Inter',
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).withId('logout_dialog_cancel'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE47830),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).withId('logout_dialog_confirm'),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              ChayanHeader(
                title: 'Profile',                   
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                  children: [
                    SizedBox(height: 24.h * scaleFactor),
                    
                    // User Profile Section
                    _buildUserProfile(scaleFactor).withId('profile_user_card'),
                    
                    SizedBox(height: 24.h * scaleFactor),
                    
                    // Quick Actions Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => BookingScreen()),
                          child: buildQuickAction("My Bookings", 'assets/icons/bookings.svg', scaleFactor),
                        ).withId('profile_quick_bookings'),
                        GestureDetector(
                          onTap: () => Get.to(() => const ReferAndEarnScreen()),
                          child: buildQuickAction("Invite Friends", 'assets/icons/refer.svg', scaleFactor),
                        ).withId('profile_quick_invite'),
                        GestureDetector(
                          onTap: () => Get.to(() => const HelpScreen()),
                          child: buildQuickAction("Help & Support", 'assets/icons/help.svg', scaleFactor),
                        ).withId('profile_quick_help'),
                      ],
                    ),
                    
                    SizedBox(height: 24.h * scaleFactor),
                    const Divider(color: Color(0xFFEBEBEB)),
                    
                    // Menu Items
                    buildListItem('assets/icons/location.svg', "Manage Address", scaleFactor,testId: 'profile_item_address', onTap: () {
                      Get.to(() => const ManageAddressScreen());
                    }),
                    buildListItem('assets/icons/refund.svg', "Bank Account Details", scaleFactor,testId: 'profile_item_edit', onTap: () {
                      // Pass customer data to edit screen
                      Get.to(() =>FinancialDetailsScreen ());
                    }),
                    buildListItem('assets/icons/rate.svg', "Rate us", scaleFactor,testId: 'profile_item_rate', onTap: () {
                      Get.to(() => RatingScreen());
                    }),
                    buildListItem('assets/icons/edit.svg', "Edit Profile", scaleFactor,testId: 'profile_item_edit', onTap: () {
                      // Pass customer data to edit screen
                      Get.toNamed('/edit-profile', arguments: _profileController.customer);
                    }),

                    buildListItem('assets/icons/about.svg', "About Chayan karo Services", scaleFactor,testId: 'profile_item_about', onTap: () {
                      Get.to(() => AboutChaynkaroServicesScreen());
                    }),
                    

                    
                    buildListItem(
                      'assets/icons/logout.svg', 
                      "Logout", 
                      scaleFactor,
                      testId: 'profile_item_logout', 
                      onTap: _isLoggingOut ? null : _handleLogout,
                    ),
                    
                    SizedBox(height: 20.h * scaleFactor),
                    
                    // Refer Banner
                    GestureDetector(
                      onTap: () => Get.to(() => const ReferAndEarnScreen()),
                      child: Container(
                        padding: EdgeInsets.all(20.r * scaleFactor),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDE0),
                          borderRadius: BorderRadius.circular(12.r * scaleFactor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Refer a Friend',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.sp * scaleFactor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h * scaleFactor),
                                  Text(
                                    'Share the app and let your friends discover Chayan Karo services',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 14.sp * scaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w * scaleFactor),
                            SvgPicture.asset(
                              'assets/icons/gifty.svg',
                              height: 57.h * scaleFactor,
                              width: 57.w * scaleFactor,
                            ),
                          ],
                        ),
                      ),
                    ).withId('profile_refer_banner'),
                    
                    SizedBox(height: 30.h * scaleFactor),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4, // Hardcoded 4
        onItemTapped: (index) => _onItemTapped(context, index), // Correct call
      ),
        );
      },
    );
  }

  Widget buildQuickAction(String label, String iconAssetPath, double scaleFactor) {
    return Container(
      width: 97.w * scaleFactor,
      height: 100.h * scaleFactor,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w * scaleFactor, color: const Color(0xB5E47830)),
          borderRadius: BorderRadius.circular(15.r * scaleFactor),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w * scaleFactor, vertical: 10.h * scaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30.w * scaleFactor,
              height: 30.h * scaleFactor,
              decoration: const ShapeDecoration(shape: OvalBorder()),
              child: SvgPicture.asset(
                iconAssetPath,
                width: 30.w * scaleFactor,
                height: 30.h * scaleFactor,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8.h * scaleFactor),
            SizedBox(
              height: 36.h * scaleFactor,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF161616),
                  fontSize: 12.sp * scaleFactor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(String iconPath, String label, double scaleFactor, {VoidCallback? onTap, required String testId}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w * scaleFactor),
      leading: SvgPicture.asset(
        iconPath,
        width: 20.w * scaleFactor,
        height: 20.h * scaleFactor,
        color: Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp * scaleFactor,
        ),
      ),
      trailing: _isLoggingOut && label == "Logout"
          ? SizedBox(
              width: 16.sp * scaleFactor,
              height: 16.sp * scaleFactor,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFE47830)),
              ),
            )
          : Icon(Icons.arrow_forward_ios, size: 16.sp * scaleFactor),
      onTap: onTap,
    ).withId(testId);
  }
}