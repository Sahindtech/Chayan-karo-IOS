import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

// Models
import '../../models/booked_saathi_model.dart';
import '../../models/provider_service_model.dart';
import '../../models/service_models.dart';

// Controllers
import '../../controllers/saathi_service_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/location_controller.dart'; 

// Data & Repositories
import '../../data/repository/location_repository.dart'; 
import '../../data/remote/api_service.dart';
import '../../data/local/database.dart';

// Views
import '../booking/Summaryscreen.dart'; // ✅ Standard casing

// Popups & Modals
import '../booking/showScheduleAddressPopup.dart'; 
import '../booking/merged_booking_modal.dart';

// Widgets
import '../../widgets/chayan_header.dart';
import '../../widgets/three_dot_loader.dart';
import '../../services/snakeanimation.dart';

class SaathiServiceScreen extends StatefulWidget {
  final BookedSaathiItem providerData;
  final bool isRebooking;

  const SaathiServiceScreen({
    super.key,
    required this.providerData,
    this.isRebooking = false,
  });

  @override
  State<SaathiServiceScreen> createState() => _SaathiServiceScreenState();
}

class _SaathiServiceScreenState extends State<SaathiServiceScreen> {
  late SaathiServiceController controller;
  late CartController cartController;
  late LocationController locationController;

  // Animation states
  final RxSet<String> _loadingServiceIds = <String>{}.obs;

  @override
  void initState() {
    super.initState();
    
    // 1. Initialize Service Controller
    controller = Get.put(SaathiServiceController(
      providerId: widget.providerData.id,
    ));

    // 2. Initialize Cart Controller
    try {
      cartController = Get.find<CartController>();
    } catch (e) {
      cartController = Get.put(CartController());
    }

    // 3. Initialize Location Controller
    try {
      locationController = Get.find<LocationController>();
    } catch (e) {
      try {
        final apiService = Get.find<ApiService>();
        final database = Get.find<AppDatabase>();
        final repository = LocationRepository(apiService: apiService, database: database);
        locationController = Get.put(LocationController(repository: repository));
      } catch (depError) {
        debugPrint("❌ CRITICAL: Could not initialize LocationController: $depError");
      }
    }

    // 4. Auto-clear rebooking cart if entering fresh
    if (widget.isRebooking) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cartController.clearRebookingCart();
      });
    }
  }
  // ✅ Helper to clear cart
// ✅ CENTRAL CLEANUP FUNCTION WITH DEBUG PRINTS
  void _handleCleanup() {
    print("DEBUG: _handleCleanup triggered.");
    if (widget.isRebooking) {
      try {
        if (Get.isRegistered<CartController>()) {
          print("DEBUG: CartController found. Clearing Rebooking Cart now.");
          Get.find<CartController>().clearRebookingCart();
        } else {
          print("DEBUG: CartController NOT found during cleanup.");
        }
      } catch (e) {
        debugPrint("DEBUG ERROR: Error clearing cart: $e");
      }
    } else {
      print("DEBUG: Not rebooking mode, skipping cleanup.");
    }
  }

  Service _mapToService(ProviderServiceItem item) {
    return Service(
      id: item.id,
      name: item.name,
      price: item.price,
      description: item.description,
      duration: item.duration,
      imgLink: item.imgLink ?? '',
      discountPercentage: 0.0,
      categoryId: item.categoryId,
    );
  }

  // --- REBOOKING CART ACTIONS (Strictly Rebooking) ---

 // --- REBOOKING CART ACTIONS (Strictly Rebooking) ---

  void _addToCart(ProviderServiceItem serviceItem) {
    // 1. Debounce Check
    if (_loadingServiceIds.contains(serviceItem.id)) return;
    
    // 2. Start Animation/Debounce immediately
    _loadingServiceIds.add(serviceItem.id);

    // 3. Perform Action
    final service = _mapToService(serviceItem);
    cartController.addServiceToRebooking(
      service, 
      providerId: widget.providerData.id,
      sourcePage: 'rebooking_screen'
    );

    // 4. Wait for 2 seconds (Debounce) before stopping animation
    Future.delayed(const Duration(seconds: 2), () { 
      if (mounted) _loadingServiceIds.remove(serviceItem.id);
    });
  }

  void _incrementCart(String serviceId) {
    // 1. Debounce Check
    if (_loadingServiceIds.contains(serviceId)) return;
    
    int currentQty = cartController.getRebookingQuantity(serviceId);
    if (currentQty >= 30) {
      HapticFeedback.mediumImpact();
      return;
    }

    // 2. Start Animation/Debounce immediately
    _loadingServiceIds.add(serviceId);

    // 3. Perform Action
    cartController.updateRebookingQuantity(serviceId, currentQty + 1);

    // 4. Wait for 2 seconds
    Future.delayed(const Duration(seconds: 2), () { 
      if (mounted) _loadingServiceIds.remove(serviceId);
    });
  }

  void _decrementCart(String serviceId) {
    // 1. Debounce Check
    if (_loadingServiceIds.contains(serviceId)) return;
    
    // 2. Start Animation/Debounce immediately
    _loadingServiceIds.add(serviceId);

    // 3. Perform Action
    int currentQty = cartController.getRebookingQuantity(serviceId);
    cartController.updateRebookingQuantity(serviceId, currentQty - 1);

    // 4. Wait for 2 seconds
    Future.delayed(const Duration(seconds: 2), () { 
      if (mounted) _loadingServiceIds.remove(serviceId);
    });
  }

  // --- NAVIGATION FLOW ---

// --- UPDATED NAVIGATION FLOW ---

// Inside SaathiServiceScreen.dart

 // --- Helper to calculate duration from Rebooking Items ---
  int _calculateRebookingDuration() {
    int totalMinutes = 0;
    // We use rebookingItems directly from the controller
    for (var item in cartController.rebookingItems) {
      final qty = cartController.getRebookingQuantity(item.id);
      if (qty > 0) {
        // Simple parsing logic (assuming format "30 mins" or "1 hr")
        int itemMins = 0;
        final lower = item.duration.toLowerCase();
        if (lower.contains('hr')) {
           final parts = lower.split('hr'); // simplistic
           double h = double.tryParse(parts[0].trim()) ?? 0;
           itemMins = (h * 60).round();
        } else if (lower.contains('min')) {
           final parts = lower.split('min');
           itemMins = int.tryParse(parts[0].trim()) ?? 0;
        } else {
           itemMins = int.tryParse(lower) ?? 30; // Default
        }
        totalMinutes += (itemMins * qty);
      }
    }
    return totalMinutes;
  }
  void _showAvailabilityErrorSheet({required String message}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            
            // Icon
            Icon(Icons.event_busy_rounded, color: Colors.redAccent, size: 48.sp),
            SizedBox(height: 16.h),
            
            // Title
            Text(
              "Provider Unavailable",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE47830),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Try Another Slot",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _handleRebookingFlow() async {
    // 0. Validation
    if (cartController.rebookingItemCount == 0) {
      Get.snackbar("Cart Empty", "Please select a service.");
      return;
    }

    // 1. Pick Address
    final String? selectedAddressString = await showScheduleAddressPopup(context);
    if (selectedAddressString == null) return; 

    // 2. Resolve Address ID
    await locationController.fetchCustomerAddresses(); 
    final selectedAddressObj = locationController.addresses.firstWhereOrNull((a) {
       final parts = <String>[
         a.addressLine1 ?? "", 
         if ((a.addressLine2 ?? "").trim().isNotEmpty) a.addressLine2,
         if ((a.city ?? "").trim().isNotEmpty) a.city, 
         if ((a.state ?? "").trim().isNotEmpty) a.state, 
         if ((a.postCode ?? "").trim().isNotEmpty) a.postCode
       ];
       final constructed = parts.join(', ');
       return constructed.toLowerCase().trim() == selectedAddressString.toLowerCase().trim();
    }) ?? locationController.addresses.firstOrNull; 

    if (selectedAddressObj == null) {
      Get.snackbar("Error", "Could not resolve address details.");
      return;
    }

    if (!mounted) return;

    // 3. Pick Date & Time
    final DateTime? pickedDate = await showMergedBookingModal(
      context,
      initialDateStr: DateFormat('yyyy-MM-dd').format(DateTime.now()), 
    );

    if (pickedDate == null) return; 

    // ---------------------------------------------------------
    // ✅ NEW STEP: CHECK AVAILABILITY BEFORE NAVIGATING
    // ---------------------------------------------------------
    
    // A. Calculate Duration
    final int totalDuration = _calculateRebookingDuration();

    // B. Call API via Controller
    final bool isAvailable = await controller.checkProviderAvailability(
      providerId: widget.providerData.id,
      addressId: selectedAddressObj.id,
      dateTime: pickedDate,
      totalDurationMinutes: totalDuration,
    );

    // C. Check Result
    if (!isAvailable) {
      // Show Error from Controller (or generic message)
      _showAvailabilityErrorSheet(
        message: controller.error.value.isNotEmpty 
            ? controller.error.value 
            : "This provider is not available at the selected time.",
      );
      return; // ⛔ STOP HERE
    }

    // ---------------------------------------------------------
    // ✅ SUCCESS: Proceed to Summary
    // ---------------------------------------------------------

    final String fullTimeSlot = DateFormat('yyyy-MM-dd hh:mm a').format(pickedDate);
    
    final Map<String, dynamic> saathiMap = {
      'id': widget.providerData.id,
      'name': widget.providerData.fullName,
      'displayName': widget.providerData.fullName, 
      'fullName': widget.providerData.fullName,
      'image': widget.providerData.imgLink ?? '', 
      'imgLink': widget.providerData.imgLink ?? '',
      'rating': widget.providerData.averageRating,
      'averageRating': widget.providerData.averageRating,
      'jobs': widget.providerData.totalReview,
      'jobsCompleted': widget.providerData.totalReview,
      'totalReview': widget.providerData.totalReview,
      'description': '',
      'availabilityResult': {
        'isAvailable': true,
        'nextAvailableSlot': null
      }
    };

    Get.to(() => SummaryScreen(
      isRebooking: true,
      currentPageSelectedServices: cartController.rebookingServiceIds,
      initialAddress: selectedAddressString,
      initialTimeSlot: fullTimeSlot, 
      initialSaathi: saathiMap, 
      rebookingLocationId: selectedAddressObj.locationId,
      rebookingAddressId: selectedAddressObj.id,
    ));
  }
  // --- UI BUILDERS ---

  Map<String, List<ProviderServiceItem>> _groupServices(List<ProviderServiceItem> list) {
    final Map<String, List<ProviderServiceItem>> grouped = {};
    for (var item in list) {
      final key = (item.serviceCategoryId.isNotEmpty) 
          ? item.serviceCategoryId 
          : "Other";
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  String _getCategoryName(String id) {
    if (id == "Other") return "Other Services";
    return ""; 
  }

@override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      // ✅ FIX 1: PopScope to Catch Hardware Back Gesture
      return PopScope(
        canPop: true, // We allow the pop, but we intercept the result
        onPopInvokedWithResult: (didPop, result) {
          print("DEBUG: Hardware/Gesture Pop Detected. didPop: $didPop");
          if (didPop) {
            _handleCleanup(); // Run cleanup immediately
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  // ✅ FIX 2: Header Back Button
                  ChayanHeader(
                    title: widget.providerData.fullName,
                    onBack: () {
                      print("DEBUG: Header Back Button Clicked");
                      _handleCleanup(); // Run cleanup
                      Navigator.pop(context); // Then Pop manually
                    },
                  ),

                  // 2. Provider Info
                  _buildProviderInfoCard(scaleFactor),

                  // 3. Service List
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 100.h * scaleFactor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        /*  // Rebooking Banner
                          Container(
                            width: double.infinity,
                            color: Colors.blue.withOpacity(0.1),
                            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                            child: Row(
                              children: [
                                Icon(Icons.repeat, size: 16.sp, color: Colors.blue[800]),
                                SizedBox(width: 8.w),
                                Text(
                                  "Rebooking Mode",
                                  style: TextStyle(
                                    fontSize: 12.sp, 
                                    color: Colors.blue[800], 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
*/
                          // Service List Loader/Content
                          Obx(() {
                            if (controller.isLoading.value) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.h),
                                  child: ThreeDotLoader(size: 14.w * scaleFactor, color: const Color(0xFFE47830)),
                                ),
                              );
                            }

                            if (controller.serviceList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.h),
                                  child: Text("No services found.", style: TextStyle(fontFamily: 'SFPro', fontSize: 14.sp * scaleFactor, color: Colors.grey)),
                                ),
                              );
                            }

                            final grouped = _groupServices(controller.serviceList);

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: grouped.entries.map((entry) {
                                  String sectionTitle = _getCategoryName(entry.key);
                                  bool showHeader = sectionTitle.isNotEmpty;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (showHeader)
                                        Padding(
                                          padding: EdgeInsets.only(top: 12.h * scaleFactor, bottom: 8.h * scaleFactor),
                                          child: Text(sectionTitle, style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.bold, color: Colors.black)),
                                        ),
                                      
                                      ...entry.value.map((service) => 
                                        _buildServiceCard(service, scaleFactor)
                                      ),
                                      
                                      if (showHeader) SizedBox(height: 8.h * scaleFactor),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 4. CONFIRM REQUEST BUTTON (Rebooking Only)
              Obx(() {
                if (cartController.rebookingItemCount > 0) {
                  return Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        16.w * scaleFactor,
                        16.h * scaleFactor,
                        16.w * scaleFactor,
                        MediaQuery.of(context).viewPadding.bottom + 16.h * scaleFactor,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), offset: Offset(0, -2 * scaleFactor), blurRadius: 8 * scaleFactor),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleRebookingFlow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE47830),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 16.h * scaleFactor),
                          elevation: 0,
                        ),
                        child: Text(
                          "Confirm Request",
                          style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      );
    });
  }
  Widget _buildProviderInfoCard(double scaleFactor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w * scaleFactor, 16.h * scaleFactor, 16.w * scaleFactor, 16.h * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              width: 70.w * scaleFactor,
              height: 70.w * scaleFactor,
              color: Colors.grey.shade100,
              child: (widget.providerData.imgLink != null && widget.providerData.imgLink!.isNotEmpty)
                  ? Image.network(widget.providerData.imgLink!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.person, size: 35.w * scaleFactor, color: Colors.grey))
                  : Icon(Icons.person, size: 35.w * scaleFactor, color: Colors.grey),
            ),
          ),
          SizedBox(width: 16.w * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.providerData.fullName, style: TextStyle(fontFamily: 'SFProSemibold', fontSize: 18.sp * scaleFactor, color: Colors.black)),
                SizedBox(height: 4.h * scaleFactor),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/star.svg', width: 14.w * scaleFactor, color: const Color(0xFFFFA500)),
                    SizedBox(width: 4.w * scaleFactor),
                    Text("${(widget.providerData.averageRating).toStringAsFixed(1)} Average Rating", style: TextStyle(fontFamily: 'SFPro', fontSize: 14.sp * scaleFactor, color: Colors.grey.shade700)),
                  ],
                ),
                SizedBox(height: 4.h * scaleFactor),
                Text("${widget.providerData.totalReview} Jobs Completed", style: TextStyle(fontFamily: 'SFPro', fontSize: 13.sp * scaleFactor, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildServiceCard(ProviderServiceItem service, double scaleFactor) {
    final RxBool isExpanded = false.obs;

    return Obx(() {
      // Use strictly rebooking quantity check for Saathi screen
      final quantity = cartController.getRebookingQuantity(service.id);
      
      return Padding(
        padding: EdgeInsets.only(bottom: 16.r * scaleFactor),
        child: Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image
                  _buildNetworkImage(
                    imageUrl: service.imgLink ?? "",
                    width: 70.w * scaleFactor,
                    height: 70.h * scaleFactor,
                    fit: BoxFit.cover,
                    borderRadius: 8 * scaleFactor,
                    scaleFactor: scaleFactor,
                  ),
                  SizedBox(width: 12.w * scaleFactor),
                  
                  // 2. Details Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => isExpanded.toggle(),
                          behavior: HitTestBehavior.translucent,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return _buildSmartServiceName(
                                service.name, 
                                isExpanded, 
                                scaleFactor, 
                                constraints.maxWidth
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4.h * scaleFactor),
                        
                        // Rating & Duration Line
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/star.svg', 
                              width: 16.w * scaleFactor, 
                              height: 16.h * scaleFactor, 
                              color: Colors.black
                            ),
                            SizedBox(width: 4.w * scaleFactor),
                            Text(
                              // Assuming hardcoded rating for provider items or fetch if available
                             "${service.ratingText} | ${service.formattedDuration}",
                              style: TextStyle(
                                fontSize: 12.sp * scaleFactor, 
                                color: Colors.grey
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h * scaleFactor),
                        
                        // Price
                        Text(
                          "₹${service.price.toStringAsFixed(0)}", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 14.sp * scaleFactor
                          )
                        ),
                      ],
                    ),
                  ),
                  
                  // 3. Quantity Selector (Add Button)
                  _buildQuantitySelector(service, scaleFactor),
                ],
              ),
              
              // 4. Description Dropdown
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: service.description.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: 8.h * scaleFactor, 
                          left: 4.w * scaleFactor, 
                          right: 4.w * scaleFactor
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service.description, 
                            style: TextStyle(
                              fontSize: 12.sp * scaleFactor, 
                              color: Colors.black87
                            )
                          )
                        ),
                      )
                    : const SizedBox.shrink(),
                crossFadeState: isExpanded.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNetworkImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    double borderRadius = 0,
    double scaleFactor = 1.0,
  }) {
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');
    Widget imageWidget;
    
    if (isSvg) {
      imageWidget = SvgPicture.network(
        imageUrl, width: width, height: height, fit: fit,
        placeholderBuilder: (context) => Container(color: Colors.grey[200]),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl, width: width, height: height, fit: fit,
        placeholder: (context, url) => Container(color: Colors.grey[200]),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200], 
          child: Icon(Icons.image_not_supported, color: Colors.grey)
        ),
      );
    }

    if (borderRadius > 0) {
      return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildSmartServiceName(String serviceName, RxBool isExpanded, double scaleFactor, double availableWidth) {
    // Logic to handle long names and arrow placement
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
        textDirection: ui.TextDirection.ltr,
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
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 20 * scaleFactor, color: Colors.black),
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
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 20 * scaleFactor, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildQuantitySelector(ProviderServiceItem service, double scaleFactor) {
    return Obx(() {
      // ✅ Use strict rebooking quantity for Saathi
      final quantity = cartController.getRebookingQuantity(service.id);
      
      final isAnimating = _loadingServiceIds.contains(service.id);
      final isMaxLimitReached = quantity >= 30;
      final showCounter = quantity > 0;

      // Decoration for the Counter (Matches Category Screen)
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
            // ---------------------------------------------------------
            // STATE 1: ADD BUTTON
            // ✅ CHANGED: Use 'AnimatedAddButton' to match Category Screen exactly.
            // This handles the "Snake Animation" via 'isLoading' and ensures exact styling.
            // ---------------------------------------------------------
            ? AnimatedAddButton(
                key: ValueKey('add_${service.id}'),
                isLoading: isAnimating, 
                scaleFactor: scaleFactor,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _addToCart(service);
                },
              ) // Remove .withId(...) if you don't have that extension, or keep if you do.
            
            // ---------------------------------------------------------
            // STATE 2: COUNTER
            // ✅ WRAPPED: Matches Category Screen's snake animation wrapper on counter
            // ---------------------------------------------------------
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
                              onTap: isAnimating ? null : () {
                                HapticFeedback.lightImpact();
                                _decrementCart(service.id);
                              },
                              child: Icon(Icons.remove, size: 16 * scaleFactor, color: const Color(0xFFE47830)),
                            ),
                          ),

                          // --- QUANTITY TEXT ---
                          Text(
                            '$quantity',
                            style: TextStyle(
                              color: const Color(0xFFE47830),
                              fontSize: 14.sp * scaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // --- PLUS BUTTON ---
                          Expanded(
                            child: InkWell(
                              onTap: (isMaxLimitReached || isAnimating) ? null : () {
                                HapticFeedback.lightImpact();
                                _incrementCart(service.id);
                              },
                              child: Icon(
                                Icons.add, 
                                size: 16 * scaleFactor, 
                                color: (isMaxLimitReached || isAnimating) 
                                    ? Colors.grey 
                                    : const Color(0xFFE47830)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      );
    });
  }
}