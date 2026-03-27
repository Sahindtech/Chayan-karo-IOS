import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../models/hair_skin_service.dart';
import '../../controllers/hair_skin_service_controller.dart';
import '../../controllers/cart_controller.dart';
import '../views/cart/cart_screen.dart';
import '../views/booking/Summaryscreen.dart';

class HairSkinScreen extends StatefulWidget {
  final String? scrollToServiceId;
  const HairSkinScreen({super.key, this.scrollToServiceId});

  @override
  _HairSkinScreenState createState() => _HairSkinScreenState();
}

class _HairSkinScreenState extends State<HairSkinScreen> {
  final ScrollController _scrollController = ScrollController();
  final HairSkinServiceController controller = Get.put(HairSkinServiceController());
  final CartController cartController = Get.find<CartController>();
  
  final RxSet<String> _currentPageInteractedServices = <String>{}.obs;
  final RxList<String> _currentPageSelectedServices = <String>[].obs;

  // Source page information - CONSTANTS
  static const String SOURCE_PAGE = 'hair_skin_studio';
  static const String SOURCE_TITLE = 'Hair & Skin Studio';

  final Map<String, GlobalKey> _categoryKeys = {
    'Haircut & Styling': GlobalKey(),
    'Hair Color & Spa': GlobalKey(),
    'Beard Grooming': GlobalKey(),
    'Hair Fall Treatments': GlobalKey(),
    'Skin Brightening': GlobalKey(),
    'Anti-Acne Care': GlobalKey(),
  };

  final Map<String, String> _serviceToCategory = {
    'classic_haircut': 'Haircut & Styling',
    'trendy_hair_styling': 'Haircut & Styling',
    'global_hair_color': 'Hair Color & Spa',
    'hair_spa_with_steam': 'Hair Color & Spa',
    'beard_trim_shape': 'Beard Grooming',
    'beard_spa_hydration': 'Beard Grooming',
    'anti_hair_fall_serum': 'Hair Fall Treatments',
    'dandruff_control_spa': 'Hair Fall Treatments',
  };

  final Map<String, String> _categoryGridToSection = {
    'Haircut & Styling': 'Haircut & Styling',
    'Hair Color & Spa': 'Hair Color & Spa',
    'Beard Grooming': 'Beard Grooming',
    'Hair Fall Treatments': 'Hair Fall Treatments',
    'Skin Brightening': 'Hair Fall Treatments',
    'Anti-Acne Care': 'Beard Grooming',
  };

  @override
  void initState() {
    super.initState();
    print('🟢 HairSkinScreen initialized with scrollToServiceId: ${widget.scrollToServiceId}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollToServiceId != null) {
        _scrollToService(widget.scrollToServiceId!);
      }
    });
  }

  void _scrollToService(String serviceId) {
    String? categoryName = _serviceToCategory[serviceId];
    if (categoryName != null) {
      _scrollToCategory(categoryName);
    }
  }

  void _scrollToCategory(String categoryName) {
    final key = _categoryKeys[categoryName];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  void _onCategoryGridTap(String categoryTitle) {
    String? targetSection = _categoryGridToSection[categoryTitle];
    if (targetSection != null) {
      _scrollToCategory(targetSection);
    } else {
      _scrollToCategory('Haircut & Styling');
    }
  }

  // UPDATED: Add to cart with source information
  /* void _addToCart(HairSkinService service) {
    cartController.addItem(
      service,
      sourcePage: SOURCE_PAGE,
      sourceTitle: SOURCE_TITLE,
    );
    _currentPageInteractedServices.add(service.id);
    if (!_currentPageSelectedServices.contains(service.id)) {
      _currentPageSelectedServices.add(service.id);
    }
  } */

  void _incrementCart(String serviceId) {
    cartController.incrementQuantity(serviceId);
    if (!_currentPageSelectedServices.contains(serviceId)) {
      _currentPageSelectedServices.add(serviceId);
    }
  }

  void _decrementCart(String serviceId) {
    cartController.decrementQuantity(serviceId);
    if (cartController.getQuantity(serviceId) == 0) {
      _currentPageSelectedServices.remove(serviceId);
      _currentPageInteractedServices.remove(serviceId);
    }
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
        final cartItem = cartController.cartItems.firstWhereOrNull((item) => item.id == serviceId);
        if (cartItem != null) {
          total += cartItem.price * quantity;
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: const Color(0xFFFFEEE0),
          statusBarIconBrightness: Brightness.dark,
        ));

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
                          _buildSalonInfoBlock(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildDiscountCards(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildCustomPackageSection(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildCategoryGrid(scaleFactor),
                          SizedBox(height: 16.h * scaleFactor),
                          _buildServiceCards(scaleFactor),
                          Obx(() => _hasCurrentPageSelections
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
              Obx(() => _hasCurrentPageSelections ? _buildBottomBar(scaleFactor) : SizedBox()),
            ],
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
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_new, size: 20 * scaleFactor),
            ),
            SizedBox(width: 8.w * scaleFactor),
            Expanded(
              child: Text(
                SOURCE_TITLE, // Use the constant
                style: TextStyle(
                  fontSize: 16.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w * scaleFactor),
            Obx(() => GestureDetector(
                  onTap: () {
                    Get.to(() => CartScreen());
                  },
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/cart.svg',
                        width: 40.w * scaleFactor,
                        height: 40.h * scaleFactor,
                        color: Colors.black,
                      ),
                      if (cartController.cartItemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
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
            Image.asset(
              'assets/single_use_product.webp',
              width: double.infinity,
              height: 160.h * scaleFactor,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 12.r * scaleFactor,
              left: 12.r * scaleFactor,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.h * scaleFactor,
                  vertical: 6.h * scaleFactor,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20 * scaleFactor),
                ),
                child: Text(
                  "Single use products",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp * scaleFactor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSalonInfoBlock(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SOURCE_TITLE, // Use the constant
                style: TextStyle(
                  fontSize: 16.sp * scaleFactor,
                  fontWeight: FontWeight.bold,
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
                    SizedBox(width: 4.w * scaleFactor),
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
              SvgPicture.asset(
                'assets/icons/star.svg',
                width: 18.w * scaleFactor,
                height: 18.h * scaleFactor,
                color: Colors.black,
              ),
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
                child: SvgPicture.asset(
                  'assets/icons/tick.svg',
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 6.w * scaleFactor),
              Text(
                "354 jobs completed",
                style: TextStyle(fontSize: 14.sp * scaleFactor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCards(double scaleFactor) {
    final List<Map<String, String>> offers = [
      {
        'icon': 'assets/icons/cash.svg',
        'title': 'Save 15% on every order',
        'subtitle': 'Get Plus now',
      },
      {
        'icon': 'assets/icons/card.svg',
        'title': 'CRED Pay',
        'subtitle': 'Upto Rs. 100 cashback',
      },
    ];

    return SizedBox(
      height: 100.h * scaleFactor,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 240.w * scaleFactor,
            padding: EdgeInsets.symmetric(
              horizontal: 12.h * scaleFactor,
              vertical: 14.h * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12 * scaleFactor),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  offer['icon']!,
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
                        offer['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp * scaleFactor,
                        ),
                        softWrap: true,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.h * scaleFactor),
                      Text(
                        offer['subtitle']!,
                        style: TextStyle(
                          fontSize: 12.sp * scaleFactor,
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
        separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
        itemCount: offers.length,
      ),
    );
  }

  Widget _buildCustomPackageSection(double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Container(
        width: double.infinity,
        height: 100.h * scaleFactor,
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        decoration: BoxDecoration(
          color: const Color(0xFFE47830),
          borderRadius: BorderRadius.circular(12 * scaleFactor),
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
                      height: 26.46.h * scaleFactor,
                      child: Text(
                        'Create a Customer Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp * scaleFactor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h * scaleFactor),
                    SizedBox(
                      width: 156.31.w * scaleFactor,
                      height: 26.46.h * scaleFactor,
                      child: Opacity(
                        opacity: 0.50,
                        child: Text(
                          'Specifically for your needs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp * scaleFactor,
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
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16 * scaleFactor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(double scaleFactor) {
    final categories = [
      {'title': 'Haircut & Styling', 'image': 'assets/z2.webp'},
      {'title': 'Hair Color & Spa', 'image': 'assets/s1.webp'},
      {'title': 'Beard Grooming', 'image': 'assets/s2.webp'},
      {'title': 'Hair Fall Treatments', 'image': 'assets/s3.webp'},
      {'title': 'Skin Brightening', 'image': 'assets/s4.webp'},
      {'title': 'Anti-Acne Care', 'image': 'assets/s5.webp'},
    ];

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
          SizedBox(height: 12.h * scaleFactor),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20 * scaleFactor,
              crossAxisSpacing: 16 * scaleFactor,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return GestureDetector(
                onTap: () => _onCategoryGridTap(item['title']!),
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
                      horizontal: 8.h * scaleFactor,
                      vertical: 12.h * scaleFactor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.w * scaleFactor,
                          height: 48.h * scaleFactor,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8 * scaleFactor),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8 * scaleFactor),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h * scaleFactor),
                        Text(
                          item['title']!,
                          style: TextStyle(
                            fontSize: 11.5.sp * scaleFactor,
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCards(double scaleFactor) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.groupedServices.entries.map((entry) {
            final String category = entry.key;
            final List<HairSkinService> services = entry.value;
            return Container(
              key: _categoryKeys[category],
              margin: EdgeInsets.only(bottom: 24.h * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category,
                      style: TextStyle(
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h * scaleFactor),
                  ...services.map((service) =>
                      _buildServiceCard(service, scaleFactor, category)),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildServiceCard(HairSkinService service, double scaleFactor, String category) {
    if (category == 'Hair Fall Treatments') {
      return _buildHairTreatmentCard(service, scaleFactor);
    } else {
      return _buildRegularServiceCard(service, scaleFactor);
    }
  }

  Widget _buildRegularServiceCard(HairSkinService service, double scaleFactor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.r * scaleFactor),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8 * scaleFactor),
            child: Image.asset(
              service.image,
              width: 60.w * scaleFactor,
              height: 60.h * scaleFactor,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.title,
                    style: TextStyle(
                        fontSize: 14.sp * scaleFactor,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h * scaleFactor),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/star.svg',
                        width: 18.w * scaleFactor, color: Colors.black),
                    SizedBox(width: 4.w * scaleFactor),
                    Text("${service.rating} | ${service.duration}",
                        style: TextStyle(
                            fontSize: 12.sp * scaleFactor,
                            color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 4.h * scaleFactor),
                Text(service.price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp * scaleFactor)),
              ],
            ),
          ),
          _buildQuantitySelector(service, scaleFactor),
        ],
      ),
    );
  }

  Widget _buildHairTreatmentCard(HairSkinService service, double scaleFactor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.r * scaleFactor),
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
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(12.h * scaleFactor)),
            child: Image.asset(
              service.image,
              width: double.infinity,
              height: 180.h * scaleFactor,
              fit: BoxFit.cover,
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
                        child: Text(service.title,
                            style: TextStyle(
                                fontSize: 15.sp * scaleFactor,
                                fontWeight: FontWeight.bold))),
                    _buildQuantitySelector(service, scaleFactor),
                  ],
                ),
                SizedBox(height: 4.h * scaleFactor),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/star.svg',
                        width: 18.w * scaleFactor, color: Colors.black),
                    SizedBox(width: 4.w * scaleFactor),
                    Text("${service.rating} | ${service.duration}",
                        style: TextStyle(
                            fontSize: 12.sp * scaleFactor, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 6.h * scaleFactor),
                Row(
                  children: [
                    Text(service.price,
                        style: TextStyle(
                            fontSize: 16.sp * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    if (service.originalPrice != null) ...[
                      SizedBox(width: 6.w * scaleFactor),
                      Text(service.originalPrice!,
                          style: TextStyle(
                              fontSize: 14.sp * scaleFactor,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)),
                    ],
                  ],
                ),
                if (service.desc != null && service.desc!.isNotEmpty) ...[
                  SizedBox(height: 8.h * scaleFactor),
                  Text(
                    service.desc!,
                    style: TextStyle(
                        fontSize: 12.sp * scaleFactor, color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(HairSkinService service, double scaleFactor) {
    return Obx(() {
      final quantity = cartController.getQuantity(service.id);
      final hasInteractedOnThisPage = _currentPageInteractedServices.contains(service.id);

      if (quantity == 0 || !hasInteractedOnThisPage) {
        return GestureDetector(
     //     onTap: () => _addToCart(service),
          child: Container(
            width: 75.w * scaleFactor,
            height: 29.h * scaleFactor,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * scaleFactor)),
              shadows: [
                BoxShadow(
                  color: const Color(0x33000000),
                  blurRadius: 4 * scaleFactor,
                  offset: Offset(0, 1 * scaleFactor),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add,
                    size: 12 * scaleFactor, color: Color(0xFFE47830)),
                SizedBox(width: 4.w * scaleFactor),
                Text('Add',
                    style: TextStyle(
                        color: Color(0xFFE47830),
                        fontSize: 14.sp * scaleFactor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      } else {
        return Container(
          width: 85.w * scaleFactor,
          height: 29.h * scaleFactor,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * scaleFactor)),
            shadows: [
              BoxShadow(
                color: const Color(0x33000000),
                blurRadius: 4 * scaleFactor,
                offset: Offset(0, 1 * scaleFactor),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _decrementCart(service.id),
                child: Icon(Icons.remove,
                    size: 14 * scaleFactor, color: Color(0xFFE47830)),
              ),
              Text('$quantity',
                  style: TextStyle(
                      color: Color(0xFFE47830),
                      fontSize: 14.sp * scaleFactor,
                      fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: () => _incrementCart(service.id),
                child: Icon(Icons.add,
                    size: 14 * scaleFactor, color: Color(0xFFE47830)),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildBottomBar(double scaleFactor) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(() {
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
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$_currentPageItemCount items",
                      style: TextStyle(
                          fontSize: 12.sp * scaleFactor, color: Colors.grey)),
                  SizedBox(height: 4.h * scaleFactor),
                  Text("₹${_currentPageTotal.toInt()}",
                      style: TextStyle(
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => SummaryScreen(
                    currentPageSelectedServices: _currentPageSelectedServices.toList(),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w * scaleFactor, 
                      vertical: 12.h * scaleFactor),
                  decoration: BoxDecoration(
                    color: Color(0xFFE47830),
                    borderRadius: BorderRadius.circular(30 * scaleFactor),
                  ),
                  child: Text("Buy Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp * scaleFactor)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
