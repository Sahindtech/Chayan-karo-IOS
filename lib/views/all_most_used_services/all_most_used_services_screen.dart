import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/snakeanimation.dart';
import '../../utils/test_extensions.dart';
import '../chayan_sathi/previouschayansathiscreen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../booking/booking_screen.dart';

// Controllers
import '../../controllers/most_used_service_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/cart_controller.dart';

// Models
import '../../models/category_models.dart';
import '../../models/service_models.dart' as service_models; // Alias Service model
// Alias CartItem model

// Screens
import '../../services/universal_service_screen.dart';
import '../cart/cart_screen.dart';

// Widgets
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/common_top_bar.dart';

class AllMostUsedServicesScreen extends StatefulWidget {
  const AllMostUsedServicesScreen({super.key});

  @override
  State<AllMostUsedServicesScreen> createState() =>
      _AllMostUsedServicesScreenState();
}

class _AllMostUsedServicesScreenState extends State<AllMostUsedServicesScreen> {
  // Theme Color
  final Color _themeOrange = const Color(0xFFE47830);

  // Animation & Interaction State
  final RxSet<String> _loadingServiceIds = <String>{}.obs;

  late CartController cartController;
  late CategoryController categoryController;
  late MostUsedServiceController controller;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
    categoryController = Get.find<CategoryController>();
    controller = Get.put(MostUsedServiceController());
  }

  // --- Helper to check for SVG ---
  bool _isSvgUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.path.toLowerCase().endsWith('.svg');
    } catch (e) {
      return url.toLowerCase().contains('.svg');
    }
  }

  void _navigateToService(service_models.Service service, Category? targetCategory) {
    if (targetCategory != null) {
      Get.to(() => CategoryServiceScreen(
            category: targetCategory,
            scrollToServiceCategoryId: service.categoryId,
            highlightServiceId: service.id,
          ));
    } else {
      Get.snackbar('Error', 'Service category not found');
    }
  }

  // --- CART LOGIC ---

  void _addToCart(service_models.Service service) {
    if (_loadingServiceIds.contains(service.id)) return;

    _loadingServiceIds.add(service.id);
    HapticFeedback.lightImpact();

    String parentCatName = "Most Used Service";
    String parentCatId = service.categoryId;

    final Category? matchedCategory = categoryController.categories
        .firstWhereOrNull((cat) => cat.categoryId == service.categoryId);

    if (matchedCategory != null) {
      parentCatName = matchedCategory.categoryName;
    }

    double originalPriceVal = service.price;
    if (service.discountPercentage > 0) {
       originalPriceVal = service.price / ((100 - service.discountPercentage) / 100);
    } else {
       originalPriceVal = service.price * 1.25;
    }
    
    // Rating Logic: If 0.0, show "New"
    String ratingStr = service.averageRating > 0 ? service.averageRating.toString() : "New";

    // Manual Construction using Aliased Model
    final item = service_models.CartItem(
      id: service.id,
      name: service.name, 
      price: service.price, 
      originalPrice: originalPriceVal, 
      image: service.imgLink,
      duration: service.formattedDuration, // ✅ FIX: Use formatted duration (e.g. "1hr 30min")
      rating: ratingStr,
      description: service.description,
      discountPercentage: service.discountPercentage.toInt(),
      sourcePage: 'most_used_services_screen',
      sourceTitle: parentCatName,
      categoryId: parentCatId,
      quantity: 1,
      dateAdded: DateTime.now(),
    );

    cartController.addItem(item);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _loadingServiceIds.remove(service.id);
      }
    });
  }

  void _incrementCart(String serviceId) {
    if (_loadingServiceIds.contains(serviceId)) return;

    final currentQty = cartController.getQuantity(serviceId);
    
    if (currentQty >= 30) {
      HapticFeedback.mediumImpact();
      Get.rawSnackbar(
        messageText: const Text(
          "Maximum limit of 30 reached for this service",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _loadingServiceIds.add(serviceId);
    cartController.incrementQuantity(serviceId);
    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _loadingServiceIds.remove(serviceId);
    });
  }

  void _decrementCart(String serviceId) {
    if (_loadingServiceIds.contains(serviceId)) return;

    _loadingServiceIds.add(serviceId);
    cartController.decrementQuantity(serviceId);
    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _loadingServiceIds.remove(serviceId);
    });
  }

  // --- WIDGETS ---

// Import the file where AnimatedAddButton and AnimatedBorderWrapper are defined
  // import 'snakeanimation.dart'; 

  Widget _buildQuantitySelector(service_models.Service service, double scaleFactor) {
    return Obx(() {
      final quantity = cartController.getQuantity(service.id);
      final isAnimating = _loadingServiceIds.contains(service.id);
      final isMaxLimitReached = quantity >= 30;
      final showCounter = quantity > 0;

      // Decoration for the Counter (Standard white box)
      final counterDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 * scaleFactor),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 4 * scaleFactor,
            offset: Offset(0, 1 * scaleFactor),
          ),
        ],
      );

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: !showCounter
            // STATE 1: ADD BUTTON (Using AnimatedAddButton)
            ? AnimatedAddButton(
                key: ValueKey('add_${service.id}'),
                isLoading: isAnimating,
                scaleFactor: scaleFactor,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _addToCart(service);
                },
              ).withId('service_add_btn_${service.id}')
            
            // STATE 2: COUNTER (Using AnimatedBorderWrapper)
            : AnimatedBorderWrapper(
                key: ValueKey('counter_${service.id}'),
                isAnimating: isAnimating,
                scaleFactor: scaleFactor,
                child: Container(
                  width: 85.w * scaleFactor,
                  height: 29.h * scaleFactor,
                  decoration: counterDecoration,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8 * scaleFactor),
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // --- MINUS BUTTON ---
                          Expanded(
                            child: InkWell(
                              // Disable click if animating
                              onTap: isAnimating
                                  ? null
                                  : () {
                                      HapticFeedback.lightImpact();
                                      _decrementCart(service.id);
                                    },
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 16 * scaleFactor,
                                  // Grey out if disabled (animating)
                                  color: isAnimating
                                      ? Colors.grey.shade400
                                      : const Color(0xFFE47830),
                                ),
                              ),
                            ),
                          ),

                          // --- QUANTITY TEXT ---
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w * scaleFactor),
                            child: Text(
                              '$quantity',
                              style: TextStyle(
                                color: const Color(0xFFE47830),
                                fontSize: 14.sp * scaleFactor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // --- PLUS BUTTON ---
                          Expanded(
                            child: InkWell(
                              // Disable click if animating OR limit reached
                              onTap: (isMaxLimitReached || isAnimating)
                                  ? null
                                  : () {
                                      HapticFeedback.lightImpact();
                                      _incrementCart(service.id);
                                    },
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 16 * scaleFactor,
                                  // Grey out if disabled
                                  color: (isMaxLimitReached || isAnimating)
                                      ? Colors.grey.shade400
                                      : const Color(0xFFE47830),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).withId('service_counter_${service.id}'),
      );
    });
  }

  Widget _buildBottomBar(double scaleFactor) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        // Show total cart summary instead of just current page
        final totalItems = cartController.cartItemCount;
        final totalAmount = cartController.totalPrice;
        
        if (totalItems == 0) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.fromLTRB(
            16.w * scaleFactor,
            10.h * scaleFactor, // Reduced from 16.h to 12.h
            16.w * scaleFactor,
            MediaQuery.of(context).viewPadding.bottom + 10.h * scaleFactor, // Reduced from 16.h to 12.h
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, -2 * scaleFactor),
                blurRadius: 8 * scaleFactor,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$totalItems ${totalItems == 1 ? 'item' : 'items'}",
                    style: TextStyle(
                      fontSize: 12.sp * scaleFactor,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h * scaleFactor),
                  Text(
                    "₹${totalAmount.toInt()}",
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w * scaleFactor,
                    vertical: 8.h * scaleFactor, // Reduced from 12.h to 10.h
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE47830),
                    borderRadius: BorderRadius.circular(30 * scaleFactor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp * scaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Get.back();
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Get.offAllNamed('/profile');
        break;
      default:
        Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MostUsedServiceController());

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        double gridSpacing = isTablet ? 20.w : 16.w;
        double gridPadding = isTablet ? 24.w : 16.w;
        double titleFontSize = isTablet ? 15.sp : 13.sp;
        double ratingFontSize = isTablet ? 13.sp : 11.sp;
        double oldPriceFontSize = isTablet ? 13.sp : 11.sp;
        double newPriceFontSize = isTablet ? 15.sp : 14.sp;
        double imageHeight = isTablet ? 140.h : 115.h;
        double cardRadius = 16;
        double starSize = isTablet ? 16.h : 14.h;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          // ✅ FIX: Use SafeArea inside Body to avoid overlapping status bar
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top Bar (Standard Header)
                    const CommonTopBar(title: 'Most Used Services'),
                    SizedBox(height: 12.h * scaleFactor),

                    // Content Grid
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator(color: _themeOrange));
                        }

                        if (controller.mostUsedServices.isEmpty) {
                          return Center(
                            child: Text(
                              'No services available',
                              style: TextStyle(fontSize: 18.sp, color: Colors.grey[700]),
                            ),
                          );
                        }

                        return GridView.builder(
                          itemCount: controller.mostUsedServices.length,
                          // 🟢 REPLACE WITH THIS:
  padding: EdgeInsets.fromLTRB(
    gridPadding, 
    0, 
    gridPadding, 
    // Check if cart has items. 
    // If > 0, give 100 space for BottomBar. 
    // If 0, give standard 20 space.
    cartController.cartItemCount > 0 
        ? 100.h * scaleFactor 
        : 20.h * scaleFactor
  ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 3 : 2,
                            mainAxisSpacing: gridSpacing,
                            crossAxisSpacing: gridSpacing,
                            childAspectRatio: isTablet ? 0.72 : 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final mostUsedData = controller.mostUsedServices[index];

                            // Map Data
                            final service = service_models.Service(
                              id: mostUsedData.id ?? "",
                              categoryId: mostUsedData.categoryId ?? "",
                              name: mostUsedData.name ?? "",
                              price: mostUsedData.price ?? 0.0,
                              description: mostUsedData.description ?? "",
                              duration: mostUsedData.duration ?? 0,
                              imgLink: mostUsedData.imgLink ?? "",
                              discountPercentage: mostUsedData.discountPercentage ?? 0.0,
                              averageRating: mostUsedData.averageRating ?? 0.0,
                            );

                            // Logic for Rating display
                            String displayRating = service.averageRating > 0 
                                ? service.averageRating.toStringAsFixed(1) 
                                : "New";

                            // Calculate Prices
                            double originalPriceVal;
                            if (service.discountPercentage > 0) {
                              originalPriceVal = service.price / ((100 - service.discountPercentage) / 100);
                            } else {
                              originalPriceVal = service.price * 1.25;
                            }
                            final int finalOldPrice = originalPriceVal.toInt();

                            return GestureDetector(
                              onTap: () {
                                final targetCat = categoryController.filteredCategories
                                    .firstWhereOrNull((cat) => cat.categoryId == service.categoryId);
                                _navigateToService(service, targetCat);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(cardRadius),
                                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(cardRadius)),
                                          child: _buildServiceImage(service.imgLink, imageHeight, scaleFactor),
                                        ),
                                        if (service.discountPercentage > 0)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '${service.discountPercentage.toInt()}% OFF',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: _themeOrange,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    // Details
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.r * scaleFactor),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  service.name,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: titleFontSize,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                    height: 1.2,
                                                    color: const Color(0xFF2D2D2D),
                                                  ),
                                                ),
                                                SizedBox(height: 4.h * scaleFactor),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/star.svg',
                                                      height: starSize,
                                                      width: starSize,
                                                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      displayRating,
                                                      style: TextStyle(
                                                        fontSize: ratingFontSize,
                                                        color: Colors.grey[600],
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // Price & Button Row
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '₹$finalOldPrice',
                                                      style: TextStyle(
                                                        fontSize: oldPriceFontSize,
                                                        decoration: TextDecoration.lineThrough,
                                                        color: Colors.grey[400],
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.h),
                                                    Text(
                                                      '₹${service.price.toInt()}',
                                                      style: TextStyle(
                                                        fontSize: newPriceFontSize,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                
                                                // Quantity Selector
                                                _buildQuantitySelector(service, scaleFactor),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),

                // Bottom Bar (Overlay)
                _buildBottomBar(scaleFactor),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 2,
            onItemTapped: (index) => _onItemTapped(index),
          ),
        );
      },
    );
  }

  Widget _buildServiceImage(String imgUrl, double height, double scaleFactor) {
    if (imgUrl.isEmpty) {
      return Container(
        color: Colors.grey[100],
        height: height,
        child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 30),
      );
    }

    if (_isSvgUrl(imgUrl)) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: SvgPicture.network(
          imgUrl,
          fit: BoxFit.cover,
          placeholderBuilder: (_) => Container(color: Colors.grey[100]),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imgUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[100],
          height: height,
          child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 30),
        ),
      );
    }
  }
}