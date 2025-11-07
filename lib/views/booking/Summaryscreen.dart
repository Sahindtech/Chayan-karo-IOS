// ... imports unchanged ...
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/chayan_header.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/location_controller.dart';
import '../../models/service_models.dart';
import 'showReschedulePopup.dart'; // date-only modal used in initial flow
import 'showScheduleAddressPopup.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import 'PaymentScreen.dart';
import 'package:intl/intl.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SummaryScreen extends StatefulWidget {
  final List<String>? currentPageSelectedServices;
  final String initialAddress;
  final String initialTimeSlot;
  final Map<String, dynamic>? initialSaathi;

  const SummaryScreen({
    Key? key,
    this.currentPageSelectedServices,
    this.initialAddress = 'Default Address',
    this.initialTimeSlot = 'Select time slot',
    this.initialSaathi,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

enum PaymentMethod { afterService, online }

class _SummaryScreenState extends State<SummaryScreen> {
  late String address;
  late String timeSlot;
  late Map<String, dynamic>? saathi;

  String? _locationId;

  // Reveal inline preferred time + payment after initial popup flow
  bool _showEditableBlocks = false;

  // Payment selection
  PaymentMethod _paymentMethod = PaymentMethod.afterService;

  // Inline preferred time (clock only)
  TimeOfDay? _inlineTime;

  late final LocationController _locationController;

  @override
  void initState() {
    super.initState();
    address = "Static address 123, City XYZ";
    timeSlot = widget.initialTimeSlot;
    saathi = widget.initialSaathi;

    _locationController = Get.find<LocationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _locationController.fetchCustomerAddresses();
      _useDefaultAddress();
    });
  }

  void _useDefaultAddress() {
    final list = _locationController.addresses;
    if (list.isEmpty) return;
    final def = list.firstWhereOrNull((a) => a.isDefault) ?? list.first;
    final disp = _formatAddress(def.addressLine1, def.addressLine2, def.city, def.state, def.postCode);
    setState(() {
      address = disp;
      _locationId = def.id;
    });
  }

  String _formatAddress(String l1, String l2, String city, String state, String post) {
    final parts = <String>[
      l1,
      if (l2.trim().isNotEmpty) l2,
      if (city.trim().isNotEmpty) city,
      if (state.trim().isNotEmpty) state,
      if (post.trim().isNotEmpty) post,
    ];
    return parts.join(', ');
  }

  // Format “Today, 07 Oct” / “Tomorrow, 08 Oct” / “Wed, 09 Oct”
  String _formatScheduledLabelFromSlot(String slot) {
    if (slot.trim().isEmpty) return 'Select time slot';
    // Try to extract full date first
    final full = RegExp(r'^(\d{4}-\d{2}-\d{2})').firstMatch(slot)?.group(1);
    String dateToken;
    if (full != null) {
      dateToken = full;
    } else {
      // fallback to dd
      dateToken = RegExp(r'\b(\d{2})\b').firstMatch(slot)?.group(1) ?? DateFormat('dd').format(DateTime.now());
    }
    return _formatScheduledLabel(dateToken);
  }

  String _formatScheduledLabel(String dayNumberOrFull) {
    final now = DateTime.now();
    DateTime? target;

    // Parse yyyy-MM-dd if given
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dayNumberOrFull)) {
      target = DateFormat('yyyy-MM-dd').parse(dayNumberOrFull);
    } else {
      // Assume dd for current month/year
      final dd = int.tryParse(dayNumberOrFull);
      if (dd != null) {
        target = DateTime(now.year, now.month, dd);
        // Clamp invalid day to month last day
        if (target.month != now.month) {
          final lastDay = DateTime(now.year, now.month + 1, 0).day;
          target = DateTime(now.year, now.month, lastDay);
        }
      }
    }
    target ??= now;

    final today = DateTime(now.year, now.month, now.day);
    final tgt = DateTime(target.year, target.month, target.day);
    final diff = tgt.difference(today).inDays;

    final lead = diff == 0
        ? 'Today'
        : diff == 1
            ? 'Tomorrow'
            : DateFormat('EEE').format(target);
    final day = DateFormat('dd').format(target);
    final mon = DateFormat('MMM').format(target);
    return '$lead, $day $mon';
  }

  String _formatInlineTime() {
    final t = _inlineTime;
    if (t == null) return 'Select time';
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scale = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Obx(() {
        final currentPageItems = _getCurrentPageCartItems(cartController);
        final hasCurrentPageItems = currentPageItems.isNotEmpty;

        final itemTotal = _calculateCurrentPageTotal(currentPageItems);

        // Discount removed per request: always 0
        final double discount = 0;

        final serviceFee = _calculateServiceFee(_getCurrentPageItemCount(currentPageItems));
        final grandTotal = itemTotal + serviceFee; // no discount subtraction

        // Scheduled label (uses selected day token from timeSlot)
        final scheduledDisplay = _formatScheduledLabelFromSlot(timeSlot);

        return Scaffold(
          backgroundColor: const Color(0xFFFFFEFD),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ChayanHeader(
                      title: 'Summary',
                      onBack: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.h * scale, vertical: 8.h * scale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show top details only after initial selection
                            if (_showEditableBlocks) ...[
                              _TopDetailsBlock(
                                scale: scale,
                                address: address,
                                timeLabel: scheduledDisplay,
                                saathi: saathi,
                                onEditAddress: () async {
                                  final newAddress = await showScheduleAddressPopup(context);
                                  if (newAddress != null) {
                                    await _locationController.fetchCustomerAddresses();
                                    final match = _locationController.addresses.firstWhereOrNull((a) {
                                      final existing = _formatAddress(
                                        a.addressLine1, a.addressLine2, a.city, a.state, a.postCode,
                                      ).toLowerCase().trim();
                                      return existing == newAddress.toLowerCase().trim();
                                    });
                                    setState(() {
                                      address = newAddress;
                                      _locationId = match?.id ?? _locationId;
                                    });
                                  }
                                },
                                onEditTime: () async {
                                  final newDay = await showReschedulePopup(context, initialSlot: timeSlot);
                                  if (newDay != null) {
                                    // Keep legacy slot shape "DD hh:mm AM/PM" if needed; here store only date token
                                    setState(() => timeSlot = newDay);
                                  }
                                },
                                onEditSaathi: () async {
                                  if (_locationId == null || _locationId!.isEmpty) return;
                                  final items = _getCurrentPageCartItems(Get.find<CartController>());
                                  if (items.isEmpty) return;
                                  final first = items.first;
                                  final selectedSaathi = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChayanSathiScreen(
                                        categoryId: first.categoryId,
                                        serviceId: first.id,
                                        locationId: _locationId!,
                                        initialSlot: timeSlot,
                                      ),
                                    ),
                                  );
                                  if (selectedSaathi != null) setState(() => saathi = selectedSaathi);
                                },
                              ),
                              SizedBox(height: 18.h * scale),
                            ],

                            // Inline preferred time (clock only) after reveal
                            if (_showEditableBlocks) ...[
                              Container(
                                padding: EdgeInsets.all(16.r * scale),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20 * scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.07),
                                      blurRadius: 8 * scale,
                                      offset: Offset(0, 2 * scale),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Request a Service Time',
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp * scale)),
                                    SizedBox(height: 12.h * scale),
                                    _InlineField(
                                      label: 'Preferred Time',
                                      value: _formatInlineTime(),
                                      icon: Icons.access_time,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: _inlineTime ?? TimeOfDay.now(),
                                        );
                                        if (picked != null) setState(() => _inlineTime = picked);
                                      },
                                    ),
                                    SizedBox(height: 8.h * scale),
                                    Text(
                                      'The provider will confirm availability for your suggested time.',
                                      style: TextStyle(fontSize: 12.sp * scale, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h * scale),

                              // Payment Method radios
                              Container(
                                padding: EdgeInsets.all(16.r * scale),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20 * scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.07),
                                      blurRadius: 8 * scale,
                                      offset: Offset(0, 2 * scale),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp * scale)),
                                    SizedBox(height: 8.h * scale),
                                    Row(
                                      children: [
                                        Radio<PaymentMethod>(
                                          value: PaymentMethod.afterService,
                                          groupValue: _paymentMethod,
                                          onChanged: (v) => setState(() => _paymentMethod = v!),
                                        ),
                                        const Text('Pay after service'),
                                        const SizedBox(width: 8),
                                        Text('(via online or cash mode)', style: TextStyle(fontSize: 12.sp * scale, color: Colors.grey)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio<PaymentMethod>(
                                          value: PaymentMethod.online,
                                          groupValue: _paymentMethod,
                                          onChanged: (v) => setState(() => _paymentMethod = v!),
                                        ),
                                        const Text('Pay Online Now'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h * scale),
                            ],

                            // Services
                            if (hasCurrentPageItems) ...[
                              _SelectedServicesBlock(
                                items: currentPageItems,
                                scale: scale,
                                buildItem: (ci) => _buildServiceItem(ci, scale),
                              ),
                              SizedBox(height: 20.h * scale),
                            ] else ...[
                              _EmptyServicesBlock(scale: scale),
                              SizedBox(height: 20.h * scale),
                            ],

                            _FrequentlyAddedBlock(scale: scale),
                            SizedBox(height: 20.h * scale),

                            if (hasCurrentPageItems) ...[
                              _CouponsRow(scale: scale),
                              SizedBox(height: 20.h * scale),

                              // Payment summary with Item Discount = 0, hidden tag
                              _PaymentSummaryBlock(
                                scale: scale,
                                itemTotal: itemTotal,
                                itemDiscount: 0, // fixed
                                serviceFee: serviceFee,
                                grandTotal: grandTotal,
                                showSavingsTag: false,
                              ),
                              SizedBox(height: 70.h * scale),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom CTA
                if (hasCurrentPageItems)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.h * scale, vertical: 12.h * scale),
                      child: SafeArea(
                        top: false,
                        child: _showEditableBlocks
                            ? InkWell(
                                onTap: () {
                                  if (_locationId == null || _locationId!.isEmpty) {
                                    Get.snackbar('Address required', 'Please add/select an address to continue',
                                        backgroundColor: Colors.red[50], colorText: Colors.red[800]);
                                    return;
                                  }
                                  final preferredTime = _inlineTime == null ? _formatScheduledLabelFromSlot(timeSlot) : _formatInlineTime();
                                  if (_paymentMethod == PaymentMethod.online) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const PaymentScreen(),
                                        settings: RouteSettings(
                                          arguments: {
                                            'amount': grandTotal,
                                            'paymentMethod': 'online',
                                            'preferredTime': preferredTime,
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Request placed',
                                      'Pay after service selected. Provider will confirm your time.',
                                      backgroundColor: Colors.green[50],
                                      colorText: Colors.green[900],
                                    );
                                  }
                                },
                                child: Container(
                                  height: 47.h * scale,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE47830),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _paymentMethod == PaymentMethod.online
                                        ? 'Pay Now (₹${grandTotal.toInt()})'
                                        : 'Confirm Booking',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp * scale, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  // Address
                                  final newAddress = await showScheduleAddressPopup(context);
                                  if (newAddress == null) return;

                                  await _locationController.fetchCustomerAddresses();
                                  final match = _locationController.addresses.firstWhereOrNull((a) {
                                    final existing = _formatAddress(
                                      a.addressLine1, a.addressLine2, a.city, a.state, a.postCode,
                                    ).toLowerCase().trim();
                                    return existing == newAddress.toLowerCase().trim();
                                  });
                                  setState(() {
                                    address = newAddress;
                                    _locationId = match?.id ?? _locationId;
                                  });

                                  // Date-only modal (returns "DD" or your chosen token)
                                  final selectedDay = await showReschedulePopup(context, initialSlot: timeSlot);
                                  if (selectedDay == null) return;
                                  setState(() => timeSlot = selectedDay);

                                  // Saathi
                                  if (_locationId == null || _locationId!.isEmpty) {
                                    Get.snackbar('Address required', 'Please add/select an address first',
                                        backgroundColor: Colors.red[50], colorText: Colors.red[800]);
                                    return;
                                  }
                                  final items = _getCurrentPageCartItems(Get.find<CartController>());
                                  if (items.isEmpty) {
                                    Get.snackbar('No service', 'Please add at least one service',
                                        backgroundColor: Colors.red[50], colorText: Colors.red[800]);
                                    return;
                                  }
                                  final first = items.first;

                                  final selectedSaathi = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChayanSathiScreen(
                                        categoryId: first.categoryId,
                                        serviceId: first.id,
                                        locationId: _locationId!,
                                        initialSlot: timeSlot,
                                      ),
                                    ),
                                  );
                                  if (selectedSaathi == null) return;

                                  setState(() {
                                    saathi = selectedSaathi;
                                    _showEditableBlocks = true;
                                  });
                                },
                                child: Container(
                                  height: 47.h * scale,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE47830),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Request Now (₹${itemTotal.toInt() + serviceFee.toInt()})',
                                    style: TextStyle(color: Colors.white, fontSize: 14.sp * scale, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      });
    });
  }

  // Cart helpers
  List<CartItem> _getCurrentPageCartItems(CartController cartController) {
    if (widget.currentPageSelectedServices == null || widget.currentPageSelectedServices!.isEmpty) return [];
    return cartController.cartItems
        .where((item) =>
            widget.currentPageSelectedServices!.contains(item.id) && cartController.getQuantity(item.id) > 0)
        .toList();
  }

  double _calculateCurrentPageTotal(List<CartItem> items) {
    double total = 0;
    for (final item in items) {
      final qty = Get.find<CartController>().getQuantity(item.id);
      total += item.price * qty;
    }
    return total;
  }

  int _getCurrentPageItemCount(List<CartItem> items) {
    int count = 0;
    for (final item in items) {
      count += Get.find<CartController>().getQuantity(item.id);
    }
    return count;
  }

  // Keep service fee rules unchanged
  double _calculateServiceFee(int itemCount) {
    if (itemCount >= 5) return 100;
    if (itemCount >= 3) return 75;
    if (itemCount >= 1) return 50;
    return 0;
  }

  // Service item tile
  Widget _buildServiceItem(CartItem cartItem, double scale) {
    final totalItemPrice = cartItem.price * cartItem.quantity;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12 * scale),
            child: Image.network(
              cartItem.image,
              width: 60.w * scale,
              height: 60.h * scale,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60.w * scale,
                height: 60.h * scale,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey, size: 30 * scale),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60.w * scale,
                  height: 60.h * scale,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE47830)),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.name,
                            style: TextStyle(fontSize: 14.sp * scale, fontWeight: FontWeight.w600, color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (cartItem.quantity > 1) ...[
                            SizedBox(height: 4.h * scale),
                            Text(
                              'Quantity: ${cartItem.quantity} × ₹${cartItem.price.toInt()}',
                              style: TextStyle(fontSize: 12.sp * scale, color: Colors.grey[600], fontWeight: FontWeight.w500),
                            ),
                          ],
                          if (cartItem.rating.isNotEmpty && cartItem.duration.isNotEmpty) ...[
                            SizedBox(height: 4.h * scale),
                            Row(
                              children: [
                                Icon(Icons.star, size: 12 * scale, color: Colors.amber),
                                SizedBox(width: 2.w * scale),
                                Text('${cartItem.rating} | ${cartItem.duration}',
                                    style: TextStyle(fontSize: 11.sp * scale, color: Colors.grey[600])),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w * scale),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${totalItemPrice.toInt()}',
                          style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w700, color: const Color(0xFFE47830)),
                        ),
                        if (cartItem.hasDiscount) ...[
                          SizedBox(height: 2.h * scale),
                          Text(
                            '₹${(cartItem.originalPrice * cartItem.quantity).toInt()}',
                            style: TextStyle(fontSize: 12.sp * scale, decoration: TextDecoration.lineThrough, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (cartItem.description.isNotEmpty) ...[
                  SizedBox(height: 8.h * scale),
                  BulletText(cartItem.description, scale: scale),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Top details (shown after reveal)
class _TopDetailsBlock extends StatelessWidget {
  final double scale;
  final String address;
  final String timeLabel; // already formatted “Today, 07 Oct”
  final Map<String, dynamic>? saathi;
  final VoidCallback onEditAddress;
  final VoidCallback onEditTime;
  final VoidCallback onEditSaathi;

  const _TopDetailsBlock({
    required this.scale,
    required this.address,
    required this.timeLabel,
    required this.saathi,
    required this.onEditAddress,
    required this.onEditTime,
    required this.onEditSaathi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.07), blurRadius: 8 * scale, offset: Offset(0, 2 * scale))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(icon: 'assets/icons/home.svg', title: 'Home', value: address, onEdit: onEditAddress, scale: scale),
          SizedBox(height: 14.h * scale),
          _row(icon: 'assets/icons/calendar.svg', title: 'Scheduled', value: timeLabel, onEdit: onEditTime, scale: scale),
          SizedBox(height: 14.h * scale),
          _row(
            icon: 'assets/icons/chayansathi.svg',
            title: 'Chayan Saathi',
            value: saathi == null
                ? 'Select Chayan Saathi'
                : "${saathi!['name']}, (${saathi!['jobs'] ?? ''}+ work), ${saathi!['rating'] ?? ''} rating",
            onEdit: onEditSaathi,
            scale: scale,
          ),
        ],
      ),
    );
  }

  Widget _row({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
    required double scale,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, width: 22 * scale, height: 22 * scale, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp * scale, color: Colors.black)),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13.sp * scale, color: Colors.black)),
          ]),
        ),
        InkWell(onTap: onEdit, child: Icon(Icons.edit, size: 18 * scale, color: const Color(0xFFE47830))),
      ],
    );
  }
}

// Simple inline field
class _InlineField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _InlineField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7E7E7)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Existing blocks (minor tweaks for discount removal)
class _SelectedServicesBlock extends StatelessWidget {
  final List<CartItem> items;
  final double scale;
  final Widget Function(CartItem) buildItem;

  const _SelectedServicesBlock({required this.items, required this.scale, required this.buildItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(color: const Color(0xFFE5E9FF), borderRadius: BorderRadius.circular(20 * scale)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Services (${items.fold<int>(0, (p, e) => p + e.quantity)} items)',
              style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w700)),
          SizedBox(height: 12.h * scale),
          ...items.map(buildItem).toList(),
        ],
      ),
    );
  }
}

class _EmptyServicesBlock extends StatelessWidget {
  final double scale;
  const _EmptyServicesBlock({required this.scale});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.r * scale),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20 * scale)),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64 * scale, color: Colors.grey),
            SizedBox(height: 16.h * scale),
            Text('No services selected from this page',
                style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w600, color: Colors.grey[600])),
            SizedBox(height: 8.h * scale),
            Text('Go back and select services to proceed', style: TextStyle(fontSize: 14.sp * scale, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

class _FrequentlyAddedBlock extends StatelessWidget {
  final double scale;
  const _FrequentlyAddedBlock({required this.scale});
  @override
  Widget build(BuildContext context) {
    Widget buildAddCard(String asset, String title, String price) {
      return Container(
        width: 140.w * scale,
        margin: EdgeInsets.only(right: 16.r * scale),
        padding: EdgeInsets.all(8.r * scale),
        decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(25 * scale)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14 * scale),
              child: Image.asset(asset, width: 120.w * scale, height: 120.h * scale, fit: BoxFit.cover),
            ),
            SizedBox(height: 8.h * scale),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp * scale)),
            SizedBox(height: 4.h * scale),
            Text(price, style: TextStyle(fontSize: 14.sp * scale)),
            SizedBox(height: 8.h * scale),
            Container(
              width: 120.w * scale,
              height: 30.h * scale,
              decoration: BoxDecoration(
                color: const Color(0xFFE47830),
                borderRadius: BorderRadius.circular(30 * scale),
                boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 1))],
              ),
              alignment: Alignment.center,
              child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 14.sp * scale)),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequently added together', style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w700)),
        SizedBox(height: 12.h * scale),
        SizedBox(
          height: 240.h * scale,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              buildAddCard('assets/saloon_manicure.webp', 'Manicure', '₹499'),
              buildAddCard('assets/saloon_pedicure.webp', 'Pedicure', '₹499'),
              buildAddCard('assets/saloon_threading.webp', 'Threading', '₹49'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CouponsRow extends StatelessWidget {
  final double scale;
  const _CouponsRow({required this.scale});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(Icons.local_offer_outlined, size: 20 * scale),
          SizedBox(width: 8.w * scale),
          Text('Coupons and offers', style: TextStyle(fontSize: 14.sp * scale)),
        ]),
        Text('2 offers  >', style: TextStyle(fontWeight: FontWeight.w800, color: const Color(0xFFFA9441))),
      ],
    );
  }
}

class _PaymentSummaryBlock extends StatelessWidget {
  final double scale;
  final double itemTotal;
  final double itemDiscount; // fixed 0
  final double serviceFee;
  final double grandTotal;
  final bool showSavingsTag;

  const _PaymentSummaryBlock({
    required this.scale,
    required this.itemTotal,
    required this.itemDiscount,
    required this.serviceFee,
    required this.grandTotal,
    this.showSavingsTag = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10 * scale, offset: Offset(0, 2 * scale))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Summary', style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w700)),
          SizedBox(height: 12.h * scale),
          PriceRow(title: 'Item Total', amount: '₹${itemTotal.toInt()}', scale: scale),
          // Show item discount row but as ₹0 (or hide entirely by commenting next line)
          PriceRow(title: 'Item Discount', amount: '₹${itemDiscount.toInt()}', color: Colors.black54, scale: scale),
          //PriceRow(title: 'Service Fee', amount: '₹${serviceFee.toInt()}', scale: scale),
          Divider(height: 20.h * scale),
          PriceRow(title: 'Grand Total', amount: '₹${grandTotal.toInt()}', isBold: true, scale: scale),
          if (showSavingsTag) ...[
            SizedBox(height: 12.h * scale),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h * scale, vertical: 6.h * scale),
                decoration: BoxDecoration(color: const Color(0x33FFAD33), borderRadius: BorderRadius.circular(6 * scale)),
                child: Text('Hurray! You saved ₹0 on final bill',
                    style: TextStyle(color: const Color(0xFFFA9441), fontSize: 12.sp * scale, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Reusable bits
class BulletText extends StatelessWidget {
  final String text;
  final double scale;
  const BulletText(this.text, {super.key, this.scale = 1});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h * scale),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 6.r * scale, top: 4.r * scale),
            child: CircleAvatar(radius: 2 * scale, backgroundColor: const Color(0xFF757575)),
          ),
          Flexible(child: Text(text, style: TextStyle(color: const Color(0xFF757575), fontSize: 12.sp * scale))),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final bool isBold;
  final double scale;

  const PriceRow({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp * scale, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          Text(amount,
              style: TextStyle(
                  fontSize: 14.sp * scale, color: color ?? Colors.black, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}
