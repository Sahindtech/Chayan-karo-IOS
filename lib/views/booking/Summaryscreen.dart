import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// --- App Imports ---
import '../../widgets/chayan_header.dart';
import '../../widgets/three_dot_loader.dart';
import 'frequently_added_block.dart';
import 'merged_booking_modal.dart';
import 'showScheduleAddressPopup.dart';
import 'booking_successful_screen.dart';
import 'PaymentScreen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../../models/coupon_models.dart';

// --- Controller & Model Imports ---
import '../../controllers/cart_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../models/service_models.dart';
import '../../models/category_models.dart'; 
import '../../models/booking_models.dart';
import '../../utils/test_extensions.dart';
import '../../controllers/coupon_controller.dart';

// --- WIDGET IMPORT ---
// Ensure summary_widgets.dart is in the same folder or update path
import './widgets/summary_widgets.dart'; 

// Helper class for mapping
class _Agg {
  _Agg({required this.categoryId, required this.serviceId, required this.discountPct});
  final String categoryId;
  final String serviceId;
  final int discountPct;
  num price = 0;
  num discountPrice = 0;
}

class SummaryScreen extends StatefulWidget {
  final List<String>? currentPageSelectedServices;
  final String initialAddress;
  final String initialTimeSlot;
  final Map<String, dynamic>? initialSaathi;
  // ✅ NEW: Rebooking Context Parameters
  final bool isRebooking;
  final String? rebookingLocationId;
  final String? rebookingAddressId;

  const SummaryScreen({
    super.key,
    this.currentPageSelectedServices,
    this.initialAddress = 'Default Address',
    this.initialTimeSlot = 'Select time slot',
    this.initialSaathi,
    // ✅ NEW: Defaults
    this.isRebooking = false,
    this.rebookingLocationId,
    this.rebookingAddressId,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // --- State Variables ---
  late String address;
  late String timeSlot;
  late Map<String, dynamic>? saathi;

  String? _locationId;
  String? _addressId;
  
  List<Service> _frequentlyServices = [];
  bool _frequentlyLoading = false;

  bool _showEditableBlocks = false; // Logic for showing Payment Summary vs Cart View

  PaymentMethod _paymentMethod = PaymentMethod.afterService;
  TimeOfDay? _inlineTime;
  bool _isGlobalLoading = false;
  
Coupon? _selectedCoupon;

  late final LocationController _locationController;
  late final BookingController _bookingController;

@override
  void initState() {
    super.initState();
    Get.find<CouponController>().selectedCoupon.value = null;
    address = widget.initialAddress;
    timeSlot = widget.initialTimeSlot;
    saathi = widget.initialSaathi;

    _locationController = Get.find<LocationController>();
    _bookingController = Get.put(BookingController(), permanent: false);

    // --- ✅ FIXED: Time Parsing for Rebooking ---
    if (widget.isRebooking && timeSlot.contains(' ')) {
      try {
        // Expected format from SaathiServiceScreen: "yyyy-MM-dd hh:mm a"
        // Example: "2023-10-25 04:30 PM"
        final format = DateFormat("yyyy-MM-dd hh:mm a");
        final DateTime parsedDate = format.parse(timeSlot);
        
        // Extract the date part for the API/Display logic
        timeSlot = DateFormat('yyyy-MM-dd').format(parsedDate);
        
        // Extract the time part for _inlineTime
        _inlineTime = TimeOfDay.fromDateTime(parsedDate);
      } catch (e) {
        debugPrint("Error parsing rebooking time: $e");
        // Fallback if parsing fails
        _inlineTime = const TimeOfDay(hour: 10, minute: 0);
      }
    }

  WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ NEW: Skip default fetching if Rebooking
      if (widget.isRebooking) {
         _locationId = widget.rebookingLocationId;
         _addressId = widget.rebookingAddressId;
         // Lock the UI immediately for rebooking
         _showEditableBlocks = true; 
      } else {
         await _locationController.fetchCustomerAddresses();
         _useDefaultAddress();
      }
      
      // ✅ NEW: Only load frequently added for normal flow
      if (!widget.isRebooking) {
        await _loadFrequentlyServicesForCurrentCategory();
      }
    });
  }

  // --- Address Logic ---
  void _useDefaultAddress() {
    final list = _locationController.addresses;
    if (list.isEmpty) return;

    final def = list.firstWhereOrNull((a) => a.isDefault) ?? list.first;
    final disp = _formatAddress(
        def.addressLine1 ?? "",
        def.addressLine2 ?? "",
        def.city ?? "",
        def.state ?? "",
        def.postCode ?? "");

    setState(() {
      address = disp;
      _locationId = def.locationId;
      _addressId = def.id;
      _showEditableBlocks = false;
    });
  }

  String _formatAddress(String l1, String l2, String city, String state, String post) {
    final parts = <String>[l1, if (l2.trim().isNotEmpty) l2, if (city.trim().isNotEmpty) city, if (state.trim().isNotEmpty) state, if (post.trim().isNotEmpty) post];
    return parts.join(', ');
  }

  // --- Cart/Service Logic ---
  // --- Cart/Service Logic (UPDATED) ---
  
  void _addServiceIdToCurrentPage(String serviceId) {
    if (widget.isRebooking) return; // Disable for rebooking
    if (widget.currentPageSelectedServices == null) return;
    if (!widget.currentPageSelectedServices!.contains(serviceId)) {
      setState(() {
        widget.currentPageSelectedServices!.add(serviceId);
      });
    }
  }
  void _handleBack() {
  // ✅ Clear the coupon state
  Get.find<CouponController>().selectedCoupon.value = null;
  
  // ✅ Then pop the screen
  Navigator.pop(context);
}

  // ✅ NEW: Context-Aware Cart Item Retrieval
  List<CartItem> _getCurrentPageCartItems(CartController cartController) {
    if (widget.isRebooking) {
      // Return ALL items from rebooking context
      return cartController.rebookingItems;
    }

    // Normal Flow
    if (widget.currentPageSelectedServices == null || widget.currentPageSelectedServices!.isEmpty) return [];
    return cartController.cartItems
        .where((item) => widget.currentPageSelectedServices!.contains(item.id) && cartController.getQuantity(item.id) > 0)
        .toList();
  }

  // ✅ NEW: Context-Aware Total Calculation
  double _calculateCurrentPageTotal(List<CartItem> items) {
    double total = 0;
    final cartController = Get.find<CartController>();
    
    for (final item in items) {
      final qty = widget.isRebooking
          ? cartController.getRebookingQuantity(item.id)
          : cartController.getQuantity(item.id);
      total += item.price * qty;
    }
    return total;
  }

  // ✅ NEW: Context-Aware Quantity Update
  Future<void> _updateServiceQty(String itemId, bool increment) async {
    final cartController = Get.find<CartController>();
    final currentQty = widget.isRebooking
        ? cartController.getRebookingQuantity(itemId)
        : cartController.getQuantity(itemId);

    if (increment && currentQty >= 30) return;

    setState(() => _isGlobalLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); 

    if (widget.isRebooking) {
       // 🎯 REBOOKING UPDATE
       if (increment) {
         cartController.updateRebookingQuantity(itemId, currentQty + 1);
       } else {
         cartController.updateRebookingQuantity(itemId, currentQty - 1);
       }
    } else {
       // 🛒 NORMAL UPDATE
       if (increment) {
         cartController.incrementQuantity(itemId);
       } else {
         cartController.decrementQuantity(itemId);
       }
    }

    if (mounted) setState(() => _isGlobalLoading = false);
  }

  Future<void> _loadFrequentlyServicesForCurrentCategory() async {
    final cartController = Get.find<CartController>();
    final categoryController = Get.find<CategoryController>();
    final serviceController = Get.find<ServiceController>();
    final currentItems = _getCurrentPageCartItems(cartController);

    if (currentItems.isEmpty) return;
    final currentCategoryId = currentItems.first.categoryId;
    if (currentCategoryId.isEmpty) return;
    
    setState(() {
      _frequentlyLoading = true;
      _frequentlyServices = [];
    });

    final subCats = categoryController.getServiceSubCategories(currentCategoryId);
    final List<Service> all = [];
    for (final sub in subCats) {
      final scId = sub.serviceCategoryId;
      await serviceController.loadServices(scId);
      all.addAll(serviceController.services);
    }
    
    setState(() {
      _frequentlyServices = all;
      _frequentlyLoading = false;
    });
  }

  // --- Scheduling Logic ---
  String _formatFullScheduleDisplay() {
    if (timeSlot == 'Select time slot' || timeSlot.isEmpty) return 'Select time slot';
    
    DateTime datePart;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(timeSlot)) {
       datePart = DateFormat('yyyy-MM-dd').parse(timeSlot);
    } else {
       return timeSlot;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(datePart.year, datePart.month, datePart.day);
    final diff = checkDate.difference(today).inDays;

    String dayPrefix = '';
    if (diff == 0) {
      dayPrefix = 'Today';
    } else if (diff == 1) dayPrefix = 'Tomorrow';
    else dayPrefix = DateFormat('EEE').format(datePart); 

    final dayMonth = DateFormat('d MMM').format(datePart);
    String timeString = '';
    if (_inlineTime != null) {
      final dt = DateTime(2022, 1, 1, _inlineTime!.hour, _inlineTime!.minute);
      timeString = DateFormat('h:mm a').format(dt);
    } else {
      timeString = 'Select time';
    }
    return '$dayPrefix $dayMonth $timeString';
  }

  Future<bool> _openMergedBookingModal() async {
    String? nextSlotConstraint;
    if (saathi != null) {
      if (saathi!['availabilityResult'] != null && saathi!['availabilityResult'] is Map) {
         nextSlotConstraint = saathi!['availabilityResult']['nextAvailableSlot'];
      } else if (saathi!['nextAvailableSlot'] != null) {
         nextSlotConstraint = saathi!['nextAvailableSlot'];
      }
    }

    String dateToSend = timeSlot;
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateToSend)) {
       dateToSend = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
      final items = _getCurrentPageCartItems(Get.find<CartController>());
  

        
    final int totalDuration = _estimateTotalDurationMinutes(items);


    final DateTime? picked = await showMergedBookingModal(
      context,
      initialDateStr: dateToSend,
      initialTime: _inlineTime,
      minTimeConstraint: nextSlotConstraint,
      currentBookingDuration: totalDuration,

      
    );

    if (picked != null) {
      setState(() {
        timeSlot = DateFormat('yyyy-MM-dd').format(picked);
        _inlineTime = TimeOfDay.fromDateTime(picked);
      });
      return true; 
    }
    return false;
  }

  Future<void> _navigateToSaathiScreen() async {
    if ((_locationId ?? '').isEmpty) return;
    final items = _getCurrentPageCartItems(Get.find<CartController>());
    if (items.isEmpty) return;
    final first = items.first;

    final DateTime resolvedDate = _resolveBookingDateTime(timeSlot, const TimeOfDay(hour: 0, minute: 0));
    final String preciseDateString = DateFormat('yyyy-MM-dd').format(resolvedDate);
    final TimeOfDay t = _inlineTime ?? const TimeOfDay(hour: 0, minute: 0);
    final String timeString = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
    final int totalDuration = _estimateTotalDurationMinutes(items);

    final selectedSaathi = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChayanSathiScreen(
          categoryId: first.categoryId,
          serviceId: first.id,
          locationId: _locationId!,
          addressId: _addressId,
          initialSlot: preciseDateString,
          bookingTime: timeString,
          currentBookingDuration: totalDuration,
        ),
      ),
    );

    if (selectedSaathi != null) {
      setState(() {
        saathi = selectedSaathi;
        _showEditableBlocks = true; 
      });
    }
  }

  DateTime _resolveBookingDateTime(String dayToken, TimeOfDay? tod) {
    final now = DateTime.now();
    DateTime date;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dayToken)) {
      date = DateFormat('yyyy-MM-dd').parse(dayToken);
    } else {
      final dd = int.tryParse(dayToken) ?? now.day;
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      final safeDay = dd.clamp(1, lastDay);
      date = DateTime(now.year, now.month, safeDay);
    }
    final time = tod ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // --- Booking Helpers ---
  int _estimateTotalDurationMinutes(List<CartItem> items) {
    int total = 0;
    final cartController = Get.find<CartController>(); // Get instance once

    for (final it in items) {
      // ✅ FIX: Use correct quantity getter based on mode
      final q = widget.isRebooking 
          ? cartController.getRebookingQuantity(it.id)
          : cartController.getQuantity(it.id);
          
      final mins = _parseDurationToMinutes(it.duration);
      total += (mins > 0 ? mins : 30) * q;
    }
    return total;
  }

  int _parseDurationToMinutes(String label) {
    if (label.trim().isEmpty) return 0;
    int totalMinutes = 0;
    String lower = label.toLowerCase().trim();

    final hourRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:h|hr|hrs|hour|hours)');
    final hourMatch = hourRegex.firstMatch(lower);
    if (hourMatch != null) {
      double hours = double.tryParse(hourMatch.group(1) ?? '0') ?? 0;
      totalMinutes += (hours * 60).round();
    }

    final minRegex = RegExp(r'(\d+)\s*(?:m|min|mins|minute|minutes)');
    final minMatch = minRegex.firstMatch(lower);
    if (minMatch != null) {
      totalMinutes += int.tryParse(minMatch.group(1) ?? '0') ?? 0;
    }

    if (totalMinutes == 0) {
      final pureNumberRegex = RegExp(r'^(\d+)$');
      final numberMatch = pureNumberRegex.firstMatch(lower);
      if (numberMatch != null) {
         return int.tryParse(numberMatch.group(1)!) ?? 0;
      }
    }
    return totalMinutes;
  }

List<BookingServiceItem> _mapCartToBookingItems(List<CartItem> items, {int couponPct = 0}) {
    final cart = Get.find<CartController>();
    final Map<String, _Agg> agg = {};
    
    for (final it in items) {
      final q = widget.isRebooking 
          ? cart.getRebookingQuantity(it.id) 
          : cart.getQuantity(it.id);

      if (q <= 0) continue;

      final key = '${it.categoryId}::${it.id}';
      
      // 1. Original Price (The "Price" field in API)
      final pricePerUnit = it.hasDiscount ? it.originalPrice : it.price;
      
      // 2. Base Discount from Item (e.g. 10% off on the menu)
      int itemDiscountPct = it.hasDiscount && it.originalPrice > 0
          ? (((it.originalPrice - it.price) / it.originalPrice) * 100).round()
          : 0;
          
      // 3. Total Discount Percentage (Item Discount + Coupon Discount)
      final totalDiscountPct = itemDiscountPct + couponPct;

      final entry = agg.putIfAbsent(
        key,
        () => _Agg(categoryId: it.categoryId, serviceId: it.id, discountPct: totalDiscountPct),
      );
      
      entry.price += pricePerUnit * q;
      
      // 4. Calculate final discountPrice for this item after Coupon
      double effectiveItemPrice = it.price.toDouble(); 
      if (couponPct > 0) {
        effectiveItemPrice = effectiveItemPrice * (1 - (couponPct / 100));
      }
      entry.discountPrice += effectiveItemPrice * q;
    }

    return agg.values.map((a) => BookingServiceItem(
      categoryId: a.categoryId,
      serviceId: a.serviceId,
      discountPercentage: a.discountPct, // Combined %
      price: a.price,                   // Original Total
      discountPrice: a.discountPrice,   // Final price user paid for this item
    )).toList();
  }
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final CouponController couponController = Get.find<CouponController>(); // <--- ADD IT HERE

    return PopScope(
    canPop: false, // Prevent default pop
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      _handleBack(); // Trigger our manual cleanup and pop
    },
    child: LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scale = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Obx(() {
        // Data Preparation
        final currentPageItems = _getCurrentPageCartItems(cartController);
        final hasCurrentPageItems = currentPageItems.isNotEmpty;
        final selected = couponController.selectedCoupon.value;
        
        String currentCategoryId = '';
        if (currentPageItems.isNotEmpty) {
          currentCategoryId = currentPageItems.first.categoryId;
        }
        
        // Fetch Category Name
        final categoryController = Get.find<CategoryController>();
        final category = categoryController.getCategoryById(currentCategoryId);
        final String categoryName = category?.categoryName ?? '';

        // Financial Calculations
        // --- Financial Calculations (80/20 Scenario) ---
final double itemTotal = _calculateCurrentPageTotal(currentPageItems);
final int servicePriceInclusive = itemTotal.round(); // Actual Service Price (100%)

// 1. Calculate the Platform's 20% share
final double platformShare = servicePriceInclusive * 0.20;

// 2. Calculate 18% GST ONLY on that 20% share
final int gstOnFee = (platformShare * 0.18).round();

// 3. User views: Actual Service Price + GST
final int subTotal = servicePriceInclusive + gstOnFee;

double discountAmount = 0.0;
int? discountPercentage;

if (selected != null) {
  // Check minimum purchase against the item total, not the subtotal
  if (itemTotal >= selected.minPurchaseAmount) { 
    if (selected.discountType == "PERCENTAGE") {
      discountPercentage = selected.discountPercentage.toInt();
      // Apply discount ONLY to itemTotal
      discountAmount = itemTotal * (selected.discountPercentage / 100); 
    } else {
      discountAmount = selected.amount;
      // Calculate effective percentage based on itemTotal
      discountPercentage = ((discountAmount / itemTotal) * 100).round();
    }
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      couponController.selectedCoupon.value = null;
    });
  }
}

// Final total calculation: (Service + GST) - Discount
//final int subTotal = servicePriceInclusive + gstOnFee; 
final int totalRaw = (subTotal - discountAmount).toInt();
final int total = totalRaw > 0 ? totalRaw : 0;
        
        final inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
        final scheduledDisplay = _formatFullScheduleDisplay();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFFFEFD),
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    ChayanHeader(
                      title: 'Summary',
                      onBack: _handleBack, // Now points to our handler
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.h * scale, vertical: 8.h * scale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           if (_showEditableBlocks || widget.isRebooking) ...[
                              // --- MODULE 1: TOP DETAILS ---
                              SummaryTopDetailsBlock(
                                scale: scale,
                                address: address,
                                timeLabel: scheduledDisplay,
                                saathi: saathi,
                                
                                // ✅ FIXED: Pass a valid function that does nothing if rebooking
                                onEditAddress: () {
                                  if (widget.isRebooking) return; // Locked for rebooking

                                  showScheduleAddressPopup(context).then((newAddress) async {
                                    if (newAddress != null) {
                                      await _locationController.fetchCustomerAddresses();
                                      final match = _locationController.addresses.firstWhereOrNull((a) {
                                        final existing = _formatAddress(
                                          a.addressLine1 ?? "", 
                                          a.addressLine2 ?? "", 
                                          a.city ?? "", 
                                          a.state ?? "", 
                                          a.postCode ?? ""
                                        ).toLowerCase().trim();
                                        return existing == newAddress.toLowerCase().trim();
                                      });
                                      
                                      setState(() {
                                        address = newAddress;
                                        _addressId = match?.id ?? _addressId;
                                        _locationId = match?.locationId ?? _locationId;
                                        saathi = null; 
                                        _showEditableBlocks = false; 
                                      });

                                      if (mounted) {
                                        _openMergedBookingModal().then((timePicked) async {
                                          if (timePicked && mounted) {
                                              await _navigateToSaathiScreen();
                                          }
                                        });
                                      }
                                    }
                                  });
                                },

                                // ✅ FIXED: Pass a valid function that does nothing if rebooking
                                onEditTime: () {
                                  if (widget.isRebooking) return; // Locked for rebooking

                                  _openMergedBookingModal().then((timePicked) async {
                                    if (timePicked && mounted) {
                                       setState(() {
                                          saathi = null;
                                          _showEditableBlocks = false;
                                       });
                                       await _navigateToSaathiScreen();
                                    }
                                  });
                                },

                                // ✅ FIXED: Pass a valid function that does nothing if rebooking
                                onEditSaathi: () {
                                  if (widget.isRebooking) return; // Locked for rebooking
                                  _navigateToSaathiScreen();
                                },
                              ),
                              SizedBox(height: 18.h * scale),
                              // --- MODULE 2: PAYMENT METHOD ---
                              SummaryPaymentMethodBlock(
                                scale: scale,
                                groupValue: _paymentMethod,
                                onChanged: (v) => setState(() => _paymentMethod = v!),
                              ),
                              SizedBox(height: 20.h * scale),
                            ],

                           // --- MODULE 3: SERVICE LIST ---
                            if (hasCurrentPageItems) ...[
                              SummarySelectedServicesBlock(
                                items: currentPageItems,
                                scale: scale,
                                // ✅ FIX: Lock buttons if blocks are editable OR if rebooking
                                isLocked: _showEditableBlocks || widget.isRebooking, 
                                isLoading: _isGlobalLoading,
                                onUpdateQty: _updateServiceQty,
                              ),
                            ] else ...[
                              // Empty State
                              SummaryEmptyServicesBlock(scale: scale),
                              SizedBox(height: 20.h * scale),
                            ],

// --- FREQUENTLY ADDED ---
                            // ✅ NEW: Hide frequently added block in rebooking flow
                            if (!widget.isRebooking && !_showEditableBlocks && !_frequentlyLoading && _frequentlyServices.isNotEmpty)
                              FrequentlyAddedBlock(
                                scale: scale,
                                categoryId: currentCategoryId,
                                categoryName: categoryName,
                                services: _frequentlyServices,
                                onAdded: (serviceId) {
                                  _addServiceIdToCurrentPage(serviceId);
                                },
                              )
                            else
                              const SizedBox.shrink(),

                            SizedBox(height: 20.h * scale),
                            

                            // --- MODULE 4: COUPONS ---
                           if (hasCurrentPageItems) ...[
  SummaryCouponsRow(
  scale: scale,
  selectedCoupon: couponController.selectedCoupon.value,
  discountAmount: discountAmount,
  onRemove: () => couponController.removeCoupon(), 
  onTap: () {
    // 1. Fetch fresh coupons for this category
    couponController.fetchCoupons(currentCategoryId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CouponsBottomSheet(
        scale: scale,
        orderAmount: subTotal.toDouble(),
        selectedCoupon: couponController.selectedCoupon.value,
        // ✅ UPDATED: Added async/await to handle sheet closing
        onApply: (coupon) async {
          final bool success = await couponController.applyCoupon(
            coupon, 
            subTotal.toDouble(), 
            currentCategoryId,
          );
          
          // ✅ Close the sheet only if validation succeeded
          if (success && mounted) {
            Navigator.of(context).pop(); 
          }
        },
        onRemove: () {
          couponController.removeCoupon();
          // Use Navigator for consistency within the UI layer
        },
      ),
    );
  },
),
                              
                              SizedBox(height: 20.h * scale),
                              
                              // --- MODULE 5: PAYMENT BILL SUMMARY ---
                              SummaryPaymentDetailsBlock(
                                scale: scale,
                                grandTotal: servicePriceInclusive,
                                feeRate: 0.20,
                                gstOnFeeRate: 0.18,
                                showSavingsTag: false,
                                discountAmount: discountAmount,
                              ),
                              
                              SizedBox(height: 70.h * scale),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // --- Bottom CTA ---
                if (hasCurrentPageItems)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.h * scale, vertical: 12.h * scale),
                      child: SafeArea(
                        top: false,
                        child: Obx(() {
                          final placing = _bookingController.isPlacing.value;
                          // ✅ MODIFIED: Button Text Logic
                          final btnText = placing 
                              ? 'Placing...' 
                              : ((_showEditableBlocks || widget.isRebooking)
                                  ? (_paymentMethod == PaymentMethod.online ? 'Pay Now (${inr.format(total)})' : 'Confirm & Book') 
                                  : 'Request Now (${inr.format(total)})');

                          return InkWell(
                            onTap: placing ? null : () async {
                                // 1. Validate Address
                                if ((_locationId ?? '').isEmpty) {
                                  final newAddress = await showScheduleAddressPopup(context);
                                  if (newAddress != null) {
                                     // In real app, you might want to call _locationController.fetch... here again or assume return is up to date
                                     return; 
                                  }
                                  if((_locationId ?? '').isEmpty) {
                                      Get.snackbar('Address required', 'Please select an address');
                                      return;
                                  }
                                }
                                
                                // 2. Validate Time/Saathi Logic flow
                                // ✅ CHECK: In Rebooking, blocks ARE shown/locked, so we skip this validation step 
                                // because we already have the data.
                                if (!_showEditableBlocks && !widget.isRebooking) {
                                     // Normal Flow Trigger
                                     bool timePicked = await _openMergedBookingModal();
                                     if (timePicked && mounted) {
                                          await _navigateToSaathiScreen();
                                     }
                                     return;
                                }
                                // 3. Validate for Final Submission
                                if (saathi == null || (saathi?['id']?.toString().isEmpty ?? true)) {
                                  Get.snackbar('Saathi required', 'Please select a Chayan Saathi');
                                  return;
                                }
                                if (_inlineTime == null) {
                                  Get.snackbar('Time required', 'Please select a preferred time');
                                  return;
                                }

                                // 4. PREPARE DATA
                                final preferredDateTime = _resolveBookingDateTime(
                                    RegExp(r'^(\d{4}-\d{2}-\d{2})').hasMatch(timeSlot)
                                        ? timeSlot
                                        : (RegExp(r'\b(\d{2})\b').firstMatch(timeSlot)?.group(1) ?? DateFormat('dd').format(DateTime.now())),
                                    _inlineTime,
                                );
                                
// --- ADD THIS LOGIC TO SYNC WITH BUILD CALCULATIONS ---
// --- SYNC WITH UPDATED CALCULATIONS ---
int couponPctForMapper = 0;
if (selected != null) {
  if (selected.discountType == "PERCENTAGE") {
    couponPctForMapper = selected.discountPercentage.toInt();
  } else {
    // UPDATED: Use itemTotal as the denominator instead of subTotal
    couponPctForMapper = ((discountAmount / itemTotal) * 100).round();
  }
}

final bookingItems = _mapCartToBookingItems(currentPageItems, couponPct: couponPctForMapper);
                                final totalDuration = _estimateTotalDurationMinutes(currentPageItems);
                                final spId = saathi!['id'].toString();
                                final addressId = _addressId!;
                                final paymentMode = _paymentMethod == PaymentMethod.afterService ? 'CASH' : 'ONLINE';
                                final String? selectedCouponId = couponController.selectedCoupon.value?.id;
                                const double currentGstPercentage = 18.0;
                                
                                // 5. SUBMIT VIA CONTROLLER
                                
                                // --- FIXED: Online Payment Logic ---
                                if (_paymentMethod == PaymentMethod.online) {
                                  try {
                                    final res = await _bookingController.placeBooking(
                                      spId: spId,
                                      addressId: addressId,
                                      slot: preferredDateTime,
                                      paymentMode: 'ONLINE',
                                      services: bookingItems,
                                      totalDuration: totalDuration,
                                      couponId: selectedCouponId,
                                      actualAmount: servicePriceInclusive, 
    plateFormFee: platformShare.round(),
    gstAmount: gstOnFee,
    gstPercentage: 18.0,
                                    );

                                    if (!(res.success) || (res.bookingId ?? '').isEmpty) {
                                       // Error Handling for Online Init
                                       String title = 'Booking Failed';
                                       String msg = res.message.isNotEmpty ? res.message : 'Failed to create booking for online payment';
                                       final mLower = msg.toLowerCase();
                                       if (mLower.contains('network') || mLower.contains('internet')) {
                                          title = 'Connection Error';
                                       } else if (mLower.contains('already booked') || mLower.contains('unavailable')) {
                                          title = 'Provider Unavailable';
                                       }
                                       Get.snackbar(title, msg, backgroundColor: Colors.red[100], colorText: Colors.red[900]);
                                       return; 
                                    }

                                    // Navigate to Payment Screen
                                    final bookingId = res.bookingId!;
                                    final dateStr = "${preferredDateTime.year.toString().padLeft(4, '0')}-${preferredDateTime.month.toString().padLeft(2, '0')}-${preferredDateTime.day.toString().padLeft(2, '0')}";
                                    final firstItem = currentPageItems.first;
                                    final title = firstItem.name;
                                    final imageUrl = firstItem.image;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const PaymentScreen(),
                                        settings: RouteSettings(arguments: {
                                          'amount': total,
                                          'bookingId': bookingId,
                                          'paymentMethod': 'online',
                                          'preferredTime': DateFormat('hh:mm a').format(preferredDateTime),
                                          'bookingCard': {
                                            'bookingId': bookingId,
                                            'bookingDate': dateStr,
                                            'serviceTitle': title,
                                            'totalDuration': totalDuration,
                                            'imageUrl': imageUrl,
                                          }
                                        }),
                                      ),
                                    );
                                    // ✅ NEW: Clear Rebooking Cart if successful init
                                    if(widget.isRebooking) cartController.clearRebookingCart();
                                  } catch (e) {
                                    Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[100]);
                                  }
                                  return; // <--- CRITICAL FIX: Stops execution here so it doesn't run the Cash logic below.
                                }

                                // --- Cash / Pay After Service Logic ---
                                try {
                                    final res = await _bookingController.placeBooking(
                                      spId: spId,
                                      addressId: addressId,
                                      slot: preferredDateTime,
                                      paymentMode: paymentMode,
                                      services: bookingItems,
                                      totalDuration: totalDuration,
// ✅ Coupon Logic: Pass values if selected, else null
couponId: selectedCouponId, // Null if no coupon applied  
                                        actualAmount: servicePriceInclusive, 
    plateFormFee: platformShare.round(),
    gstAmount: gstOnFee,
    gstPercentage: 18.0,
                                    );

                                    if (res.success && (res.bookingId?.isNotEmpty ?? false)) {
                                       // Success Navigation
                                       final firstItem = currentPageItems.first;
                                       int h = totalDuration ~/ 60;
                                       int m = totalDuration % 60;
                                       String dur = (totalDuration < 60) ? '$totalDuration min' : (m == 0 ? '$h hr' : '$h hr $m m');

                                       // ✅ NEW: Clear Rebooking Cart on Success
                                       if(widget.isRebooking) cartController.clearRebookingCart();
                                       
                                       Navigator.push(context, MaterialPageRoute(builder: (_) => BookingSuccessfulScreen(
                                            bookingId: res.bookingId!,
                                            bookingDate: DateFormat('yyyy-MM-dd').format(preferredDateTime),
                                            serviceTitle: firstItem.name,
                                            durationLabel: dur,
                                            imageUrl: firstItem.image,
                                       )));
                                    } else {
                                        // Error Handling
                                        Get.snackbar('Booking Failed', res.message.isNotEmpty ? res.message : 'Could not place booking', backgroundColor: Colors.red[100], colorText: Colors.red[900]);
                                    }
                                } catch (e) {
                                    Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[100]);
                                }
                            },
                            child: Container(
                              height: 47.h * scale,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE47830),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                              ),
                              alignment: Alignment.center,
                              child: Text(btnText, style: TextStyle(color: Colors.white, fontSize: 14.sp * scale, fontWeight: FontWeight.w500)),
                            ),
                          ).withId('summary_confirm_btn');
                        }),
                      ),
                    ),
                  ),
                  
                if (_isGlobalLoading)
                   Container(
                     width: double.infinity, height: double.infinity,
                     color: Colors.black.withOpacity(0.3),
                     child: Center(
                       child: ThreeDotLoader(size: 20.0, color: const Color(0xFFE47830)),
                     ),
                   ),
                ],
              ),
            ),
          );
        }); 
      }), 
    ); 
  }
}