// lib/views/booking/PreviousBookingScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter/services.dart'; // <--- Add this import

// NEW: import your read model
import '../../models/booking_read_models.dart';

class PreviousBookingScreen extends StatelessWidget {
  final CustomerBooking booking; // inject from list "View details"

  const PreviousBookingScreen({super.key, required this.booking});

  String _humanDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
    } catch (_) {
      return iso;
    }
  }
  // --- NEW: Day Header Helper ---
  String _displayDayHeader(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final dateToCheck = DateTime(dt.year, dt.month, dt.day);

      if (dateToCheck == today) {
        return 'Today';
      } else if (dateToCheck == tomorrow) {
        return 'Tomorrow';
      }
      return DateFormat('EEEE').format(dt); // e.g. "Wednesday"
    } catch (_) {
      return '—';
    }
  }

  String _humanTime(String hm) {
    try {
      final parts = hm.split(':');
      int h = int.parse(parts[0]);
      final m = parts.length > 1 ? int.parse(parts[1]) : 0;
      final ampm = h >= 12 ? "PM" : "AM";
      h = h % 12;
      if (h == 0) h = 12;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm";
    } catch (_) {
      return hm;
    }
  }

  String _durationLabel(int mins) {
    if (mins <= 0) return '0 min';
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h > 0 && m > 0) return '$h hrs $m mins';
    if (h > 0) return '$h hrs';
    return '$m mins';
  }
  String _paymentModeLabel(CustomerBooking? b) {
    if (b == null) return 'Payment mode: N/A';
    final mode = (b.paymentMode ?? '').toUpperCase();
    switch (mode) {
      case 'ONLINE':
        return 'Online payment';
      case 'CASH':
        return 'Cash payment';
      default:
        return 'Payment mode: N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        final statusLower = booking.status.toLowerCase();
        final bool isCancelled = statusLower == 'cancelled';
        final bool isCompleted = statusLower == 'completed';

        // --- NEW: Dynamic Title Logic ---
        String headerTitle = 'Previous Booking';
        if (isCancelled) {
          headerTitle = 'Cancelled Booking';
        } else if (isCompleted) headerTitle = 'Completed Booking';
        // --------------------------------

        // Top date (keeps your header line style)
        final topDate = _humanDate(booking.bookingDate);
        final dayHeader = _displayDayHeader(booking.bookingDate);

        // Service list cards (dot-leading, like Upcoming)
        final cards = booking.bookingService.map((svc) {
          final title = svc.categoryName.isNotEmpty ? svc.categoryName : (svc.serviceIName);
final duration = _durationLabel(svc.serviceDuration ?? 0);
          final details = svc.serviceIName;
          return _bookingCard(
            title: title,
            duration: duration,
            details: details,
            scaleFactor: scaleFactor,
          );
        }).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.r * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChayanHeader(
                    title: headerTitle,
                    onBack: () => Navigator.pop(context),
                  ),

                  SizedBox(height: 16.h * scaleFactor),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Day Header (Today / Tuesday)
                        Text(
                          dayHeader, 
                          style: TextStyle(
                            color: const Color(0xFF161616),
                            fontSize: 18.sp * scaleFactor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        // 2. Date (12-11-2025)
                        Text(
                          topDate,
                          style: TextStyle(
                            color: Colors.grey[700], // distinct color
                            fontSize: 18.sp * scaleFactor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h * scaleFactor),

                  // Render each service card
                  ...cards.expand((w) => [w, SizedBox(height: 16.h * scaleFactor)]),
                  // ADD THIS: Total Duration Summary
if (booking.totalDuration > 0)
  Padding(
    padding: EdgeInsets.only(left: 20.w * scaleFactor, bottom: 16.h * scaleFactor),
    child: Row(
      children: [
        Icon(Icons.access_time_filled, size: 18.sp * scaleFactor, color: const Color(0xFFE47830)),
        SizedBox(width: 8.w),
        Text(
          "Total Duration: ${_durationLabel(booking.totalDuration)}",
          style: TextStyle(
            fontSize: 14.sp * scaleFactor,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  ),

// ADD THIS: Coupon Applied UI
if (booking.coupon?.couponCode != null)
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
    child: Container(
      margin: EdgeInsets.only(bottom: 16.h * scaleFactor),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, size: 16.sp, color: Colors.green.shade700),
          SizedBox(width: 8.w),
          Text(
            '${booking.coupon!.couponCode} Applied',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 13.sp * scaleFactor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ),
  ),

                  // Cancel reason only for cancelled bookings
                  if (isCancelled) _cancelReasonSection(scaleFactor),

                  SizedBox(height: 24.h * scaleFactor),

                  // Billing (80/20 + 18% on platform)
                  _billingSection(
                    scaleFactor,
                   booking: booking,
                  ),

                  SizedBox(height: 24.h * scaleFactor),

                  // Address + date/time + provider
                  _addressSection(
                    scaleFactor,
                    addressLine: _composeAddress(
                      booking.customerAddress.addressLine1,
                      booking.customerAddress.addressLine2,
                      booking.customerAddress.city,
                      booking.customerAddress.state,
                      booking.customerAddress.postCode,
                    ),
                    dateTimeLabel: "${_humanDate(booking.bookingDate)} - ${_humanTime(booking.bookingTime)}",
                    providerLabel:
                        "${booking.serviceProvider.firstName} ${booking.serviceProvider.lastName}".trim(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _composeAddress(String l1, String? l2, String city, String state, String post) {
    final parts = <String>[];
    if (l1.trim().isNotEmpty) parts.add(l1.trim());
    if ((l2 ?? '').trim().isNotEmpty) parts.add((l2 ?? '').trim());
    if (city.trim().isNotEmpty) parts.add(city.trim());
    if (state.trim().isNotEmpty) parts.add(state.trim());
    if (post.trim().isNotEmpty) parts.add(post.trim());
    return parts.join(', ');
  }

  // Dot-leading service card (matching Upcoming)
  Widget _bookingCard({
    required String title,
    required String duration,
    required String details,
    required double scaleFactor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Container(
        padding: EdgeInsets.all(12.r * scaleFactor),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF3F3F3), width: 2.w),
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Leading dot like Upcoming
            Container(
              width: 8.w * scaleFactor,
              height: 8.h * scaleFactor,
              decoration: const BoxDecoration(color: Color(0xFFE47830), shape: BoxShape.circle),
            ),
            SizedBox(width: 10.w * scaleFactor),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp * scaleFactor,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h * scaleFactor),
                  // Details and duration in one line
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          details,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF757575)),
                        ),
                      ),
                      SizedBox(width: 8.w * scaleFactor),
                      Text(
                        duration,
                        style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF757575)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cancel reason section
  Widget _cancelReasonSection(double scaleFactor) {
    final reason = (booking.cancelReason ?? '').trim();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 8.h * scaleFactor),
        padding: EdgeInsets.all(14.r * scaleFactor),
        decoration: ShapeDecoration(
          color: const Color(0xFFFFF7F7),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.w * scaleFactor, color: const Color(0xFFFFE1E1)),
            borderRadius: BorderRadius.circular(10 * scaleFactor),
          ),
        ),
        child: Text(
          reason.isNotEmpty
              ? "You cancelled this booking because: $reason"
              : "You cancelled this booking.",
          style: TextStyle(
            fontSize: 14.sp * scaleFactor,
            fontFamily: 'Inter',
            color: const Color(0xFFD32F2F),
          ),
        ),
      ),
    );
  }

  Widget _bulletDot(double scaleFactor) {
    return Container(
      width: 4.w * scaleFactor,
      height: 4.h * scaleFactor,
      decoration: const ShapeDecoration(
        color: Color(0xFF757575),
        shape: OvalBorder(),
      ),
    );
  }

  // Updated Billing: 80% per service + 20% platform + 18% GST (on platform)
 Widget _billingSection(
  double scaleFactor, {
  required CustomerBooking booking,
}) {
  final services = booking.bookingService ?? [];

  // 1. Prioritize backend-calculated amounts
 final bool hasAmountData = booking.bookingAmount != null;

// 1. Total of items before any discount (Sum of 'price')
final double itemTotal = services.fold<double>(0, (s, e) => s + e.price.toDouble());

// 2. The amount after item-level/coupon discount
final double actualAmount = hasAmountData 
    ? booking.bookingAmount!.actualAmount.toDouble() 
    : services.fold<double>(0, (s, e) => s + e.discountPrice.toDouble());

// 3. Coupon Savings (Difference between original price and actual amount)
final double couponDiscount = itemTotal - actualAmount;

// 4. Taxes & Fees (prioritize backend value)
final int gstOnPlatform = hasAmountData 
    ? booking.bookingAmount!.gstAmount.toInt() 
    : ((itemTotal * 0.20) * 0.18).round();
// 5. Grand Total (Actual amount + taxes)
final int total = (actualAmount + gstOnPlatform).round();

  final inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
    child: Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.w * scaleFactor, color: const Color(0xFFF3F3F3)),
          borderRadius: BorderRadius.circular(10 * scaleFactor),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w * scaleFactor),
            child: Row(
              children: [
                Text(
                  'Billing Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp * scaleFactor,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),
          
          if (booking.bookingReferenceNumber.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
              child: _detailRow('Reference No.', booking.bookingReferenceNumber, scaleFactor: scaleFactor, isCopyable: true),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
            child: _detailRow('Start PIN', booking.bookingPin.toString().padLeft(4, '0'), scaleFactor: scaleFactor),
          ),
          if (booking.paymentStatus != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
              child: _detailRow('Payment Status', booking.paymentStatus!, scaleFactor: scaleFactor),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
            child: Divider(height: 24.h * scaleFactor, color: const Color(0xFFF3F3F3), thickness: 1.5),
          ),

          // Simplified rows as per requirement
          _billingRow(
            'Item Total', 
            inr.format(itemTotal), 
            scaleFactor: scaleFactor,
          ),
if ((booking.coupon?.couponCode != null) || couponDiscount > 0)
  _billingRow(
    'Coupon Discount', 
    "- ${inr.format(couponDiscount)}",
    color: Colors.green.shade700, // Make it green
    scaleFactor: scaleFactor,
  ),

          _billingRow(
            'Taxes & Fees (GST)', 
            inr.format(gstOnPlatform),
            color: Colors.black87, 
            scaleFactor: scaleFactor,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
            child: Divider(height: 30.h * scaleFactor, color: const Color(0xFFF3F3F3)),
          ),

          _billingRow(
            'Total Amount', 
            inr.format(total), 
            isBold: true, 
            scaleFactor: scaleFactor,
          ),

          // Payment Mode Footer
          Container(
            height: 47.h * scaleFactor,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.h * scaleFactor),
                bottomRight: Radius.circular(10.h * scaleFactor),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment mode', style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp * scaleFactor)),
                Text(
                  _paymentModeLabel(booking),
                  style: TextStyle(
                    fontSize: 14.sp * scaleFactor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _billingRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
    required double scaleFactor,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w * scaleFactor, 6.w * scaleFactor, 16.w * scaleFactor, 6.w * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp * scaleFactor,
              fontFamily: 'Inter',
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp * scaleFactor,
              fontFamily: 'Inter',
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: color ?? const Color(0xFF161616),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSection(
    double scaleFactor, {
    required String addressLine,
    required String dateTimeLabel,
    required String providerLabel,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
      child: Container(
        padding: EdgeInsets.all(16.r * scaleFactor),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.w * scaleFactor, color: const Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(20 * scaleFactor),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/home.svg', width: 20.w * scaleFactor, height: 20.h * scaleFactor, color: Colors.black),
                SizedBox(width: 8.w * scaleFactor),
                Text('Home', style: TextStyle(fontSize: 14.sp * scaleFactor, fontFamily: 'Inter', fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 8.h * scaleFactor),
            Text(
              addressLine,
              style: TextStyle(
                fontSize: 12.sp * scaleFactor,
                fontFamily: 'SF Pro Display',
                color: const Color(0xFF757575),
                height: 1.5,
              ),
            ),
            SizedBox(height: 8.h * scaleFactor),
            Row(
              children: [
                SvgPicture.asset('assets/icons/calendar.svg', width: 18.w * scaleFactor, height: 18.h * scaleFactor, color: Colors.black),
                SizedBox(width: 6.w * scaleFactor),
                Text(
                  dateTimeLabel,
                  style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF757575), fontFamily: 'SF Pro Display'),
                ),
              ],
            ),
            SizedBox(height: 8.h * scaleFactor),
            Row(
              children: [
                SvgPicture.asset('assets/icons/user.svg', width: 20.w * scaleFactor, height: 20.h * scaleFactor, color: Colors.black),
                SizedBox(width: 6.w * scaleFactor),
                Text(
                  providerLabel.isNotEmpty ? providerLabel : 'Provider',
                  style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF757575), fontFamily: 'SF Pro Display'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // --- NEW HELPER ---
  Widget _detailRow(String label, String value, {double scaleFactor = 1.0, bool isCopyable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp * scaleFactor,
              color: const Color(0xFF757575), // Grey text for label
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              if (isCopyable) ...[
                SizedBox(width: 8.w * scaleFactor),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    // Optional: Show a snackbar
                  },
                  child: Icon(Icons.copy, size: 16.sp * scaleFactor, color: const Color(0xFFE47830)),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
