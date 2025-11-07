import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/category_controller.dart';

// Widgets
import './widgets/home_header_widget.dart';
import './widgets/categories_grid_widget.dart';
import './widgets/home_banner_widget.dart';
import './widgets/most_used_services_widget.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

// Screens
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../booking/booking_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../profile/profile_screen.dart';

// Repositories
import '../../data/repository/location_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();

    // Add lifecycle observer to detect app resume
    WidgetsBinding.instance.addObserver(this);

    // Initialize controllers immediately - no postFrameCallback delay
    try {
      Get.find<HomeController>();
      Get.find<CartController>();
      Get.find<CategoryController>();
      print('✅ HomeScreen: Controllers initialized successfully');
    } catch (e) {
      print('❌ HomeScreen: Error initializing controllers: $e');
    }

    // Address presence check: enforce server-side address before allowing Home
    Future.microtask(() async {
      try {
        final repo = Get.find<LocationRepository>();
        final list = await repo.getCustomerAddresses();
        if (list.isEmpty) {
          // No address on server → require user to pick location
          Get.offAllNamed('/location_popup');
        }
      } catch (e) {
        // On API/network failure, fail-safe to Location to avoid showing Home without prerequisites
        Get.offAllNamed('/location_popup');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      print('🏠 App resumed - refreshing cart');
      try {
        final cartController = Get.find<CartController>();
        cartController.refreshCart();
      } catch (e) {
        print('❌ Error refreshing cart: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Get.to(() => PreviousChayanSathiScreen());
        break;
      case 1:
        Get.to(() => BookingScreen());
        break;
      case 3:
        Get.to(() => ReferAndEarnScreen());
        break;
      case 4:
        Get.to(() => ProfileScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;
        final mediaQuery = MediaQuery.of(context);

        final horizontalPadding = 16.w * scaleFactor;
        final bottomPadding = mediaQuery.padding.bottom +
            (isTablet ? 90.h * scaleFactor : 70.h * scaleFactor);

        return Scaffold(
          backgroundColor: const Color(0xFFFDFDFD),
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                final categoryController = Get.find<CategoryController>();
                final homeController = Get.find<HomeController>();
                final cartController = Get.find<CartController>();

                await Future.wait([
                  categoryController.refreshCategories(),
                  homeController.refreshData(),
                ]);
                cartController.refreshCart();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomPadding),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section - wrapped in RepaintBoundary
                    RepaintBoundary(
                      child: HomeHeaderWidget(
                        scaleFactor: scaleFactor,
                        horizontalPadding: horizontalPadding,
                      ),
                    ),

                    SizedBox(height: 16.h * scaleFactor),

                    // Categories Grid - wrapped in RepaintBoundary
                    RepaintBoundary(
                      child: CategoriesGridWidget(
                        scaleFactor: scaleFactor,
                        horizontalPadding: horizontalPadding,
                      ),
                    ),

                    SizedBox(height: 20.h * scaleFactor),

                    // Banner - wrapped in RepaintBoundary
                    RepaintBoundary(
                      child: HomeBannerWidget(
                        scaleFactor: scaleFactor,
                        horizontalPadding: horizontalPadding,
                      ),
                    ),

                    SizedBox(height: 24.h * scaleFactor),

                    // Most Used Services - wrapped in RepaintBoundary
                    RepaintBoundary(
                      child: MostUsedServicesWidget(scaleFactor: scaleFactor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        );
      },
    );
  }
}
