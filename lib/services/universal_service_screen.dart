// screens/category_service_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/service_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/category_models.dart';
import '../models/service_models.dart';
import '../views/cart/cart_screen.dart';
import '../views/booking/Summaryscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'snakeanimation.dart';
import '../../utils/test_extensions.dart';
import '../controllers/coupon_controller.dart';
import '../data/repository/coupon_repository.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/three_dot_loader.dart';


class CategoryServiceScreen extends StatefulWidget {
  final Category category;
  final String? scrollToServiceCategoryId;
  final String? highlightServiceId; // 1. NEW PARAMETER

  const CategoryServiceScreen({
    super.key,
    required this.category,
    this.scrollToServiceCategoryId,
    this.highlightServiceId, // 1. Add to constructor
  });

  @override
  State<CategoryServiceScreen> createState() => _CategoryServiceScreenState();
}

class _CategoryServiceScreenState extends State<CategoryServiceScreen> {
  final ScrollController _scrollController = ScrollController();
  late ServiceController serviceController;
  late CartController cartController;
  late CouponController couponController; // Add this

  final RxSet<String> _currentPageInteractedServices = <String>{}.obs;
  final RxList<String> _currentPageSelectedServices = <String>[].obs;
  final Map<String, GlobalKey> _serviceCategoryKeys = {};
  final RxMap<String, List<Service>> _servicesByCategory = <String, List<Service>>{}.obs;
  final RxMap<String, bool> _loadingByCategory = <String, bool>{}.obs;
  final RxMap<String, bool> _errorByCategory = <String, bool>{}.obs;
  final RxSet<String> _loadingServiceIds = <String>{}.obs;
// 1. ADD THESE TWO VARIABLES
  final GlobalKey _highlightKey = GlobalKey(); // Key to find the specific card
  String? _activeHighlightId; // Tracks which ID gets the snake animation

  @override
  void initState() {
    super.initState();
    serviceController = Get.find<ServiceController>();
    cartController = Get.find<CartController>();
    couponController = Get.put(CouponController(repo: Get.find<CouponRepository>()));
    couponController.fetchCoupons(widget.category.categoryId);
    

// 2. ADD HIGHLIGHT INITIALIZATION LOGIC
    _activeHighlightId = widget.highlightServiceId;
    if (_activeHighlightId != null) {
      // Auto-stop snake animation after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _activeHighlightId = null;
          });
        }
      });
    }
    print('🟢 CategoryServiceScreen initialized for ${widget.category.categoryName}');

    for (var serviceCategory in widget.category.serviceCategory) {
      _serviceCategoryKeys[serviceCategory.serviceCategoryId] = GlobalKey();
    }
    
     _precacheBanner();
    _loadAllServices();
  }

  void _loadAllServices() async {
    for (var serviceCategory in widget.category.serviceCategory) {
      _loadServicesForCategory(serviceCategory.serviceCategoryId);
    }

    if (widget.scrollToServiceCategoryId != null) {
      _scrollToServiceCategory(widget.scrollToServiceCategoryId!);
    }
  }
void _precacheBanner() {
  // Use post frame callback to ensure context is ready for precacheImage
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    final String? imageUrl = (widget.category.bannerLink != null && widget.category.bannerLink!.isNotEmpty)
        ? widget.category.bannerLink
        : widget.category.imgLink;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(imageUrl), context);
    }
  });
}
 void _loadServicesForCategory(String serviceCategoryId) async {
    _loadingByCategory[serviceCategoryId] = true;
    _errorByCategory[serviceCategoryId] = false;

    try {
      print('🔄 Loading services for service category: $serviceCategoryId');
await serviceController.loadServices(
  serviceCategoryId,
  forceRefresh: true,
);      
      // FIX: Define the local variable 'services' here
      final services = List<Service>.from(serviceController.services);
      
      // Store it in your map
      _servicesByCategory[serviceCategoryId] = services;
      
      print('✅ Loaded ${services.length} services for category $serviceCategoryId');

     // 3. REPLACE SCROLL LOGIC WITH THIS BLOCK
      if (widget.highlightServiceId != null) {
        final containsTargetService = services.any((s) => s.id == widget.highlightServiceId);
        
        if (containsTargetService) {
           print('🎯 Found target service in $serviceCategoryId. Waiting for UI...');
           
           // Wait for the UI to rebuild with the new data
           WidgetsBinding.instance.addPostFrameCallback((_) {
             // Tiny delay to ensure layout is complete
             Future.delayed(const Duration(milliseconds: 300), () {
               if (_highlightKey.currentContext != null) {
                 Scrollable.ensureVisible(
                   _highlightKey.currentContext!,
                   duration: const Duration(milliseconds: 800),
                   curve: Curves.easeInOut,
                   alignment: 0.5, // Center the card on screen
                 );
               } else {
                 // Fallback to category header if card key isn't found
                 _scrollToServiceCategory(serviceCategoryId);
               }
             });
           });
        }
      }
    } catch (e) {
      print('❌ Error loading services for category $serviceCategoryId: $e');
      _errorByCategory[serviceCategoryId] = true;
    } finally {
      _loadingByCategory[serviceCategoryId] = false;
    }
  }
  

  void _scrollToServiceCategory(String serviceCategoryId) {
    Future.delayed(Duration(milliseconds: 500), () {
      final key = _serviceCategoryKeys[serviceCategoryId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

void _addToCart(Service service) {
    // 1. STRICT DEBOUNCE: If animation is running, do NOTHING.
    if (_loadingServiceIds.contains(service.id)) return;

    // 2. Start Animation State
    _loadingServiceIds.add(service.id);

    // 3. Update Cart Logic
    final catId = widget.category.categoryId;
    final item = CartItem.fromService(
      service,
      sourcePage: 'category_service_$catId',
      sourceTitle: widget.category.categoryName,
    ).copyWith(categoryId: catId);

    Get.find<CartController>().addItem(item);

    _currentPageInteractedServices.add(service.id);
    if (!_currentPageSelectedServices.contains(service.id)) {
      _currentPageSelectedServices.add(service.id);
    }

    // 4. Disable button for 1.5 seconds (Length of animation)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _loadingServiceIds.remove(service.id);
      }
    });
  }

  void _incrementCart(String serviceId) {
    // 1. STRICT DEBOUNCE: If animating, ignore click
    if (_loadingServiceIds.contains(serviceId)) return;

    // 2. Check Max Limit
    final currentQty = cartController.getQuantity(serviceId);
    if (currentQty >= 30) {
      HapticFeedback.mediumImpact();
      return;
    }

    // 3. Update Logic
    cartController.incrementQuantity(serviceId);
    if (!_currentPageSelectedServices.contains(serviceId)) {
      _currentPageSelectedServices.add(serviceId);
    }

    // 4. Start Animation & Disable for 1 second
    _loadingServiceIds.add(serviceId);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _loadingServiceIds.remove(serviceId);
      }
    });
  }

  void _decrementCart(String serviceId) {
    // 1. STRICT DEBOUNCE: If animating, ignore click
    if (_loadingServiceIds.contains(serviceId)) return;

    // 2. Update Logic
    cartController.decrementQuantity(serviceId);

    // 3. Cleanup if 0
    if (cartController.getQuantity(serviceId) == 0) {
      _currentPageSelectedServices.remove(serviceId);
      _currentPageInteractedServices.remove(serviceId);
      // If we are removing the counter, we don't need to block interaction anymore
      // or we can let the animation finish on the Add button.
    }

    // 4. Start Animation & Disable for 1 second
    _loadingServiceIds.add(serviceId);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _loadingServiceIds.remove(serviceId);
      }
    });
  }

  bool get _hasCurrentPageSelections {
    return _currentPageSelectedServices.isNotEmpty &&
        _currentPageSelectedServices.any((serviceId) => cartController.getQuantity(serviceId) > 0);
  }

  double get _currentPageTotal {
    double total = 0;
    for (String serviceId in _currentPageSelectedServices) {
      final quantity = cartController.getQuantity(serviceId);
      if (quantity > 0) {
        Service? service;
        for (var serviceList in _servicesByCategory.values) {
          service = serviceList.firstWhereOrNull((s) => s.id == serviceId);
          if (service != null) break;
        }
        if (service != null) {
          total += service.discountedPrice * quantity;
        }
      }
    }
    return total;
  }

  int get _currentPageItemCount {
    int count = 0;
    for (String serviceId in _currentPageSelectedServices) {
      count += cartController.getQuantity(serviceId);
    }
    return count;
  }

  // Helper method to check if URL is an SVG
  bool _isSvgUrl(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  // Helper to check if category needs larger card format
  bool _shouldUseLargeCard(String categoryName) {
    final largeCategoryNames = [
      'facial',
      'manicure',
      'pedicure',
      'deep cleaning',
      'move-in kitchen cleaning',
      'bathroom cleaning',
    ];
    
    return largeCategoryNames.any((name) => 
      categoryName.toLowerCase().contains(name.toLowerCase())
    );
  }

  // Universal image builder for network images

Widget _buildNetworkImage({
  required String imageUrl,
  required double width,
  required double height,
  BoxFit fit = BoxFit.cover,
  double borderRadius = 0,
  double scaleFactor = 1.0,
  Widget? errorWidget,
}) {
  final isSvg = _isSvgUrl(imageUrl);

  final defaultErrorWidget = errorWidget ??
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: (width / 3).clamp(24.0, 48.0),
        ),
      );

  Widget imageWidget;

  if (isSvg) {
    imageWidget = Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        SvgPicture.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (context) => const SizedBox.shrink(),
        ),
      ],
    );
  } else {
    imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      errorWidget: (context, url, error) => defaultErrorWidget,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 75),
    );
  }

  if (borderRadius > 0) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }

  return imageWidget;
}

Widget _buildCategoryIcon(
  String imgUrl,
  double width,
  double height,
  double borderRadius,
  double scaleFactor,
) {
  final isSvg = _isSvgUrl(imgUrl);

  if (isSvg) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          SvgPicture.network(
            imgUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(
            Icons.home_repair_service,
            color: Colors.grey,
            size: 24 * scaleFactor,
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 75),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xFFFFEEE0),
      statusBarIconBrightness: Brightness.dark,
    ));

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 74.r * scaleFactor + MediaQuery.of(context).padding.top),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h * scaleFactor),
                          _buildTopBanner(scaleFactor),
                          SizedBox(height: 12.h * scaleFactor),
                          _buildCategoryInfoBlock(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildDiscountCards(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                         // _buildCustomPackageSection(scaleFactor),
                          //SizedBox(height: 16.h * scaleFactor),
                          _buildServiceCategoryGrid(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildServiceCategorySections(scaleFactor),
                          // AFTER - Use cart count instead:
Obx(() => cartController.cartItemCount > 0
    ? SizedBox(height: 100.h * scaleFactor)
    : SizedBox(height: 16.h * scaleFactor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0.r,
                left: 0.r,
                right: 0.r,
                child: Container(
                  color: const Color(0xFFFFEEE0),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: _buildHeader(context, scaleFactor),
                ),
              ),
// AFTER - Always show when cart has items:
Obx(() => cartController.cartItemCount > 0 ? _buildBottomBar(scaleFactor) : SizedBox()),            ],
          ),
        );
      },
    );
  }

Widget _buildHeader(BuildContext context, double scaleFactor) {
  return Container(
    width: double.infinity,
    height: 48.h * scaleFactor,
    decoration: BoxDecoration(
      color: const Color(0xFFFFEEE0),
      boxShadow: [
        BoxShadow(
          color: const Color(0x26000000),
          blurRadius: 4 * scaleFactor,
          offset: Offset(0, 2 * scaleFactor),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Back Icon
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new, size: 20 * scaleFactor),
          ),
          
          SizedBox(width: 8.w * scaleFactor),
          
          // 2. Title Category Name (The Fixed Part)
          Expanded(
            // KEY FIX: Use Align to stop GestureDetector from stretching
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                // Container with transparent color ensures clicks register on the text body
                child: Container(
                  color: Colors.transparent, 
                  child: Text(
                    widget.category.categoryName,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 8.w * scaleFactor),
          
          // 3. Cart Icon
          Obx(() => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/cart.svg',
                      width: 40.w * scaleFactor,
                      height: 40.h * scaleFactor,
                      color: Colors.black,
                    ),
                    if (cartController.cartItemCount > 0)
                      Positioned(
                        right: -2 * scaleFactor,
                        top: -2 * scaleFactor,
                        child: Container(
                          padding: EdgeInsets.all(4 * scaleFactor),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10 * scaleFactor),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18 * scaleFactor,
                            minHeight: 18 * scaleFactor,
                          ),
                          child: Text(
                            '${cartController.cartItemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              )),
        ],
      ),
    ),
  );
}

Widget _buildTopBanner(double scaleFactor) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12 * scaleFactor),
      child: Stack(
        children: [
          buildBannerImage(scaleFactor),
          // Gradient Overlay
          Container(
            width: double.infinity,
            height: 160.h * scaleFactor,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.35),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildBannerImage(double scaleFactor) {
  String? imageUrl;
  
  if (widget.category.bannerLink != null && widget.category.bannerLink!.trim().isNotEmpty) {
    imageUrl = widget.category.bannerLink;
  } else if (widget.category.imgLink.isNotEmpty) {
    imageUrl = widget.category.imgLink;
  }

  if (imageUrl == null || imageUrl.isEmpty) {
    return _buildErrorPlaceholder(scaleFactor);
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: double.infinity,
    height: 160.h * scaleFactor,
    fit: BoxFit.cover,
    key: ValueKey(imageUrl), 
    // ✨ REMOVED: CircularProgressIndicator
    // ✨ ADDED: A simple colored container that matches your UI background
    placeholder: (context, url) => Container(
      width: double.infinity,
      height: 160.h * scaleFactor,
      color: const Color(0xFFFFEEE0).withOpacity(0.5), // Matches your header color
    ),
    // ✨ OPTIMIZATION: Faster transition durations
    fadeInDuration: const Duration(milliseconds: 100),
    fadeOutDuration: Duration.zero,
    errorWidget: (context, url, error) => _buildErrorPlaceholder(scaleFactor),
  );
}

Widget _buildErrorPlaceholder(double scaleFactor) {
  return Container(
    width: double.infinity,
    height: 160.h * scaleFactor,
    color: Colors.grey[200],
    child: Icon(
      Icons.image_not_supported_outlined,
      size: 40 * scaleFactor,
      color: Colors.grey[400],
    ),
  );
}
Widget _buildCategoryInfoBlock(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.category.categoryName,
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.r * scaleFactor),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/warranty.svg',
                      width: 20.w * scaleFactor,
                      height: 20.h * scaleFactor,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6.w * scaleFactor),
                    Text(
                      'CK safe',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp * scaleFactor,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h * scaleFactor),
          Row(
            children: [
              SvgPicture.asset('assets/icons/star.svg',
                  width: 18.w * scaleFactor, height: 18.h * scaleFactor, color: Colors.black),
              SizedBox(width: 6.w * scaleFactor),
              Text(
                "4.8 (23k)",
                style: TextStyle(fontSize: 14.sp * scaleFactor),
              ),
            ],
          ),
          SizedBox(height: 4.h * scaleFactor),
          Row(
            children: [
              Container(
                width: 20.w * scaleFactor,
                height: 20.h * scaleFactor,
                alignment: Alignment.center,
                child: SvgPicture.asset('assets/icons/tick.svg', color: Colors.black),
              ),
              SizedBox(width: 6.w * scaleFactor),
              Text(
                "${widget.category.serviceCategory.length} service categories available",
                style: TextStyle(fontSize: 14.sp * scaleFactor),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildDiscountCards(double scaleFactor) {
  final CouponController couponController = Get.find<CouponController>();

  return Obx(() {
    // 1. Loading State - show shimmer
    if (couponController.isLoading.value) {
      return _buildShimmerLoading(scaleFactor);
    }

    // 2. Hide entirely if no coupons exist
    if (couponController.coupons.isEmpty) {
      return const SizedBox.shrink();
    }

    // 3. Show Dynamic Coupons
    return SizedBox(
      height: 100.h * scaleFactor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        scrollDirection: Axis.horizontal,
        itemCount: couponController.coupons.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
        itemBuilder: (context, index) {
          final coupon = couponController.coupons[index];
          
          final String title = coupon.discountType == "PERCENTAGE" 
              ? "${coupon.discountPercentage}% Instant Discount" 
              : "Flat ₹${coupon.amount.toInt()} Off";
          
          final String subtitle = coupon.description; 
          const String iconPath = 'assets/icons/card.svg';

          return _buildSingleDiscountCard(title, subtitle, iconPath, scaleFactor);
        },
      ),
    );
  });
}
Widget _buildSingleDiscountCard(String title, String subtitle, String icon, double scaleFactor) {
  return Container(
    width: 240.w * scaleFactor,
    padding: EdgeInsets.symmetric(horizontal: 12.h * scaleFactor, vertical: 14.h * scaleFactor),
    decoration: BoxDecoration(
      color: const Color(0xFFF6F6F6),
      borderRadius: BorderRadius.circular(12 * scaleFactor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6 * scaleFactor,
          offset: Offset(0, 2 * scaleFactor),
        ),
      ],
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 28.w * scaleFactor,
          height: 28.h * scaleFactor,
          color: Colors.black,
        ),
        SizedBox(width: 12.w * scaleFactor),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp * scaleFactor,
                ),
                maxLines: 1, // Keep title clean
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h * scaleFactor),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp * scaleFactor,
                  color: Colors.black54,
                ),
                maxLines: 2, // Allow subtitle to wrap if needed
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildShimmerLoading(double scaleFactor) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SizedBox(
      height: 100.h * scaleFactor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
        itemBuilder: (context, index) => Container(
          width: 240.w * scaleFactor,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * scaleFactor),
          ),
        ),
      ),
    ),
  );
}

 /* Widget _buildCustomPackageSection(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Container(
        width: double.infinity,
        height: 100.h * scaleFactor,
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE47830), Color(0xFFFA9441)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          boxShadow: [
            BoxShadow(
              color: Color(0x33E47830),
              blurRadius: 8 * scaleFactor,
              offset: Offset(0, 4 * scaleFactor),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/package.svg',
                  width: 58.w * scaleFactor,
                  height: 62.h * scaleFactor,
                ),
                SizedBox(width: 12.w * scaleFactor),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 205.67.w * scaleFactor,
                      child: Text(
                        'Create a Custom Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp * scaleFactor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h * scaleFactor),
                    SizedBox(
                      width: 156.31.w * scaleFactor,
                      child: Opacity(
                        opacity: 0.50,
                        child: Text(
                          'Specifically for your needs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp * scaleFactor,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16 * scaleFactor,
            ),
          ],
        ),
      ),
    );
  } */

Widget _buildServiceCategoryGrid(double scaleFactor) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: TextStyle(
            fontSize: 16.sp * scaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        // UPDATED: Reduced from 12.h to 4.h to minimize gap below "Categories"
        SizedBox(height: 12.h * scaleFactor), 
        GridView.builder(
          // UPDATED: Added zero padding to remove any default system spacing
          padding: EdgeInsets.zero, 
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.category.serviceCategory.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 18 * scaleFactor,
            crossAxisSpacing: 14 * scaleFactor,
            childAspectRatio: 0.82, 
          ),
          itemBuilder: (context, index) {
            final serviceCategory = widget.category.serviceCategory[index];
            return GestureDetector(
              onTap: () => _scrollToServiceCategory(serviceCategory.serviceCategoryId),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFFFD9BE),
                    width: 1.w * scaleFactor,
                  ),
                  borderRadius: BorderRadius.circular(12 * scaleFactor),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x33E47830),
                      blurRadius: 6 * scaleFactor,
                      offset: Offset(0, 4 * scaleFactor),
                      spreadRadius: -2 * scaleFactor,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w * scaleFactor,
                    vertical: 4.h * scaleFactor, 
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Container(
                        width: 65.w * scaleFactor,
                        height: 65.h * scaleFactor,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * scaleFactor),
                          color: Colors.white,
                        ),
                        child: _buildCategoryIcon(
                          serviceCategory.imgLink,
                          65.w * scaleFactor,
                          65.h * scaleFactor,
                          8 * scaleFactor,
                          scaleFactor,
                        ),
                      ),
                      SizedBox(height: 4.h * scaleFactor), 
                      Flexible(
                        child: Text(
                          serviceCategory.serviceCategoryName,
                          style: TextStyle(
                            fontSize: 11.sp * scaleFactor,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
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
      ],
    ),
  );
}

  Widget _buildServiceCategorySections(double scaleFactor) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.category.serviceCategory.map((serviceCategory) {
            return Container(
              key: _serviceCategoryKeys[serviceCategory.serviceCategoryId],
              margin: EdgeInsets.only(bottom: 24.h * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceCategory.serviceCategoryName,
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h * scaleFactor),
                  _buildServicesForCategory(serviceCategory, scaleFactor),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildServicesForCategory(ServiceSubCategory serviceCategory, double scaleFactor) {
    final serviceCategoryId = serviceCategory.serviceCategoryId;
    final isLoading = _loadingByCategory[serviceCategoryId] ?? true;
    final hasError = _errorByCategory[serviceCategoryId] ?? false;
    final services = _servicesByCategory[serviceCategoryId] ?? [];

    if (isLoading && services.isEmpty) {
      return SizedBox(
        height: 100.h * scaleFactor,
        child: const Center(
          child: ThreeDotLoader(color: Color(0xFFFF6F00)),
        ),
      );
    }

    if (hasError && services.isEmpty) {
      return SizedBox(
        height: 100.h * scaleFactor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              SizedBox(height: 4.h * scaleFactor),
              Text(
                'Failed to load services',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.sp * scaleFactor,
                ),
              ),
              SizedBox(height: 4.h * scaleFactor),
              ElevatedButton(
                onPressed: () => _loadServicesForCategory(serviceCategoryId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (services.isEmpty) {
      return SizedBox(
        height: 60.h * scaleFactor,
        child: Center(
          child: Text(
            'No services available',
            style: TextStyle(color: Colors.grey, fontSize: 12.sp * scaleFactor),
          ),
        ),
      );
    }

    // Check if this category should use large cards
    final useLargeCards = _shouldUseLargeCard(serviceCategory.serviceCategoryName);

    return Column(
      children: services.map((service) {
        if (useLargeCards) {
          return _buildLargeServiceCard(service, scaleFactor);
        } else {
          return _buildServiceCard(service, scaleFactor);
        }
      }).toList(),
    );
  }

  Widget _buildServiceCard(Service service, double scaleFactor) {
    final RxBool isExpanded = false.obs;

    return Obx(() {
      // Check highlight state
      final bool isHighlighted = (service.id == widget.highlightServiceId); // Use widget ID for key/anim check

      // 1. Move Margin to Padding
      return Padding(
        padding: EdgeInsets.only(bottom: 16.r * scaleFactor),
        
        // 2. Wrap with Snake Animation
        child: AnimatedBorderWrapper(
          isAnimating: (service.id == _activeHighlightId), // Use active ID for animation (so it stops)
          scaleFactor: scaleFactor,
          
          // 3. Container with Key
          child: Container(
            // ASSIGN KEY HERE if highlighted
            key: isHighlighted ? _highlightKey : null,
            
            padding: EdgeInsets.all(12.r * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12 * scaleFactor),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.05),
                  blurRadius: 10 * scaleFactor,
                  offset: Offset(0, 4 * scaleFactor),
                ),
              ],
            ),
            child: Column(
              children: [
                // ... (Keep existing Row content) ...
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNetworkImage(
                      imageUrl: service.imgLink,
                      width: 70.w * scaleFactor,
                      height: 70.h * scaleFactor,
                      fit: BoxFit.cover,
                      borderRadius: 8 * scaleFactor,
                      scaleFactor: scaleFactor,
                    ),
                    SizedBox(width: 12.w * scaleFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => isExpanded.toggle(),
                            behavior: HitTestBehavior.translucent,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return _buildSmartServiceName(service.name, isExpanded, scaleFactor, constraints.maxWidth);
                              },
                            ),
                          ),
                          SizedBox(height: 4.h * scaleFactor),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/star.svg', width: 16.w * scaleFactor, height: 16.h * scaleFactor, color: Colors.black),
                              SizedBox(width: 4.w * scaleFactor),
                              Text("${service.ratingText} | ${service.formattedDuration}", style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 6.h * scaleFactor),
                          Text(service.formattedPrice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp * scaleFactor)),
                        ],
                      ),
                    ),
                    _buildQuantitySelector(service, scaleFactor),
                  ],
                ),
                // ... (Keep existing CrossFade) ...
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: service.description.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8.h * scaleFactor, left: 4.w * scaleFactor, right: 4.w * scaleFactor),
                          child: Align(alignment: Alignment.centerLeft, child: Text(service.description, style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.black87))),
                        )
                      : const SizedBox.shrink(),
                  crossFadeState: isExpanded.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  Widget _buildLargeServiceCard(Service service, double scaleFactor) {
    final RxBool isExpanded = false.obs;
    
    return Obx(() {
      final bool isHighlighted = (service.id == widget.highlightServiceId);

      return Padding(
        padding: EdgeInsets.only(bottom: 16.r * scaleFactor),
        child: AnimatedBorderWrapper(
          isAnimating: (service.id == _activeHighlightId),
          scaleFactor: scaleFactor,
          child: Container(
            // ASSIGN KEY HERE if highlighted
            key: isHighlighted ? _highlightKey : null,
            
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12 * scaleFactor),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.05),
                  blurRadius: 10 * scaleFactor,
                  offset: Offset(0, 4 * scaleFactor),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12 * scaleFactor)),
                  child: AspectRatio(
                    aspectRatio: 7 / 3,
                    child: _buildNetworkImage(
                      imageUrl: service.imgLink,
                      width: double.infinity,
                      height: 300.h * scaleFactor,
                      fit: BoxFit.cover,
                      borderRadius: 0,
                      scaleFactor: scaleFactor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.r * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => isExpanded.toggle(),
                              child: Text(
                                service.name,
                                style: TextStyle(fontSize: 15.sp * scaleFactor, fontWeight: FontWeight.bold),
                                maxLines: isExpanded.value ? null : 2,
                                overflow: isExpanded.value ? null : TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          _buildQuantitySelector(service, scaleFactor),
                        ],
                      ),
                      // ... (Keep rest of existing large card content) ...
                      SizedBox(height: 4.h * scaleFactor),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/star.svg', width: 18.w * scaleFactor, color: Colors.black),
                          SizedBox(width: 4.w * scaleFactor),
                          Text("${service.ratingText} | ${service.formattedDuration}", style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 6.h * scaleFactor),
                      Text(service.formattedPrice, style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.bold, color: Colors.black)),
                      if (service.description.isNotEmpty) ...[
                        SizedBox(height: 8.h * scaleFactor),
                        Text(service.description, style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.black87), maxLines: isExpanded.value ? null : 3, overflow: isExpanded.value ? null : TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  
  Widget _buildSmartServiceName(
      String serviceName, RxBool isExpanded, double scaleFactor, double availableWidth) {
    final words = serviceName.split(' ');
    final textStyle = TextStyle(
      fontSize: 14.sp * scaleFactor,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    if (words.length >= 3) {
      final fullTextPainter = TextPainter(
        text: TextSpan(text: serviceName, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      fullTextPainter.layout();

      final arrowWidth = 28 * scaleFactor;
      final totalWidth = fullTextPainter.width + arrowWidth;

      if (totalWidth > availableWidth * 0.8) {
        final firstPart = words.sublist(0, words.length - 1).join(' ');
        final lastWord = words.last;

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: firstPart, style: textStyle),
              TextSpan(text: '\n$lastWord', style: textStyle),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w * scaleFactor),
                  child: AnimatedRotation(
                    turns: isExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20 * scaleFactor,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: serviceName, style: textStyle),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w * scaleFactor),
              child: AnimatedRotation(
                turns: isExpanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20 * scaleFactor,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildQuantitySelector(Service service, double scaleFactor) {
    return Obx(() {
      final quantity = cartController.getQuantity(service.id);
      
      // REMOVED: final hasInteractedOnThisPage = ...
      // We want the UI to reflect the GLOBAL cart state, not just local interaction.

      // Is the animation "active"?
      final isAnimating = _loadingServiceIds.contains(service.id);
      final isMaxLimitReached = quantity >= 30;
      final showCounter = quantity > 0;

      // Decoration for the Counter (White bg, shadow, rounded corners)
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
        // CHANGED LOGIC: Show "Add" button ONLY if quantity is 0.
        // If quantity > 0 (even if added from another screen), show the counter.
        child: !showCounter
            // STATE 1: ADD BUTTON
            ? AnimatedAddButton(
                key: ValueKey('add_${service.id}'),
                isLoading: isAnimating, 
                scaleFactor: scaleFactor,
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Note: _addToCart should also have a check for max limit if needed, 
                  // but usually "Add" implies going from 0 to 1, so it's fine.
                  _addToCart(service);
                },
              ).withId('service_add_btn_${service.id}')
            
            // STATE 2: COUNTER
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
                              // BLOCK: Disable if max limit reached OR animating
                              onTap: (isMaxLimitReached || isAnimating)
                                  ? () {
                                      if (isMaxLimitReached) {
                                         HapticFeedback.mediumImpact();
                                         // Optional: Show snackbar or visual feedback
                                      }
                                    }
                                  : () {
                                      HapticFeedback.lightImpact();
                                      _incrementCart(service.id);
                                    },
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 16 * scaleFactor,
                                  // GREY OUT color if limit reached
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
      
      return Container(
        padding: EdgeInsets.fromLTRB(
          16.w * scaleFactor,
          16.h * scaleFactor,
          16.w * scaleFactor,
          MediaQuery.of(context).viewPadding.bottom + 16.h * scaleFactor,
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
                // ✨ CHANGED: Navigate to CartScreen instead of SummaryScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  CartScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w * scaleFactor,
                  vertical: 12.h * scaleFactor,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE47830),
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
                  /*  SizedBox(width: 6.w * scaleFactor),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18 * scaleFactor,
                    ), */
                  ],
                ),
              ),
            ).withId('category_view_cart_btn'),
          ],
        ),
      );
    }),
  );
}
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}