import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../widgets/chayan_header.dart';
import 'cancel_booking_screen.dart';
import 'showReschedulePopup.dart';
import 'Helpscreen.dart';
import 'EmergencyScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'reschedule_summary_screen.dart';
import 'package:intl/intl.dart';

// NEW
import '../../models/booking_read_models.dart';

class UpcomingBookingScreen extends StatelessWidget {
  const UpcomingBookingScreen({super.key, this.booking});
  final CustomerBooking? booking;

  // --- HELPER START: Robust Date Parser ---
  // If the model's getter fails (null), we force parse the string string.
  DateTime? _getValidDateTime(CustomerBooking b) {
    // 1. Try the extension getter
    if (b.displayDateTimeLocal != null) return b.displayDateTimeLocal;

    // 2. Try parsing the bookingDate string manually (e.g. "2025-12-10")
    if (b.bookingDate.isNotEmpty) {
      try {
        return DateTime.parse(b.bookingDate);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
  // --- HELPER END ---

  // --- FIX 1: Display Date (e.g., 10 Dec, 2025) ---
  String _displayDate(CustomerBooking b) {
    final dt = _getValidDateTime(b);
    if (dt == null) {
      // Last resort fallback
      return (b.bookingDate.length >= 10)
          ? b.bookingDate.substring(0, 10)
          : b.bookingDate;
    }
    // Formats strictly as "10 Dec, 2025"
    return DateFormat('dd MMM, yyyy').format(dt);
  }

  // --- FIX 2: Day Header (Today / Tomorrow / Wednesday) ---
  String _displayDayHeader(CustomerBooking b) {
    final dt = _getValidDateTime(b);
    if (dt == null) return '—';

    // Normalize everything to midnight for accurate comparison
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(dt.year, dt.month, dt.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    }
    
    // Otherwise return full day name (e.g. "Wednesday")
    return DateFormat('EEEE').format(dt);
  }

  // --- FIX 3: Time Parsing (Handles 10.30, 10:30, 1030) ---
  String _displayTime(CustomerBooking b) {
    // 1. Try using the valid DateTime object first
    final dt = _getValidDateTime(b);
    // Only use dt for time if the original string implies it had time components
    // (Optional check, but safe to rely on manual parsing if dt time is 00:00:00 and suspicious)
    
    // 2. Manual parsing to be safe against "10.30" format which DateTime.parse might miss or handle oddly
    String t = b.bookingTime; 
    if (t.isEmpty) {
        // If bookingTime string is empty but dt exists, try extracting from dt
        if (dt != null) return DateFormat('hh:mm a').format(dt);
        return "";
    }

    try {
      int h = 0;
      int m = 0;

      // Clean the string
      t = t.trim();

      if (t.contains(':')) {
        final parts = t.split(':');
        h = int.parse(parts[0]);
        if (parts.length > 1) m = int.parse(parts[1]);
      } else if (t.contains('.')) {
        // Handles "10.30"
        final parts = t.split('.');
        h = int.parse(parts[0]);
        if (parts.length > 1) m = int.parse(parts[1]);
      } else if (t.length == 4 && int.tryParse(t) != null) {
        // Handles "1030"
        h = int.parse(t.substring(0, 2));
        m = int.parse(t.substring(2, 4));
      } else {
        // Unknown format, return as is
        return t;
      }

      final tempDate = DateTime(2022, 1, 1, h, m);
      return DateFormat('hh:mm a').format(tempDate);

    } catch (e) {
      // If manual parsing fails, fallback to standard date object if available
      if (dt != null) return DateFormat('hh:mm a').format(dt);
      return t;
    }
  }

  // NEW: map backend paymentMode to display label
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
        final double scaleFactor =
            isTablet ? constraints.maxWidth / 411 : 1.0;

        final hasData = booking != null;
        final services = booking?.bookingService ?? [];
        final address = booking?.customerAddress;
        final provider = booking?.serviceProvider;
        // --- FIX: Check for In Progress Status ---
        final status = (booking?.status ?? '').toLowerCase();
        final bool isInProgress = status.contains('progress');
        // -----------------------------------------

        // Pricing: forward-calculated billing
       // --- Updated Financial Logic ---
// --- Updated Financial Logic ---
final bool hasAmountData = booking?.bookingAmount != null;

// 1. Total of items before any discount (Sum of 'price')
final double itemTotal = services.fold<double>(0, (s, e) => s + e.price.toDouble());

// 2. The amount after item-level/coupon discount
final double actualAmount = hasAmountData 
    ? booking!.bookingAmount!.actualAmount.toDouble() 
    : services.fold<double>(0, (s, e) => s + e.discountPrice.toDouble());

// 3. Coupon Savings (Difference between original price and actual amount)
final double couponDiscount = itemTotal - actualAmount;

// 4. Taxes & Fees (prioritize backend value)
final int gstOnPlatform = hasAmountData 
    ? booking!.bookingAmount!.gstAmount.toInt() 
    : ((itemTotal * 0.20) * 0.18).round();
// 5. Grand Total (Actual amount + taxes)
final int total = (actualAmount + gstOnPlatform).round();

final inr = NumberFormat.currency(
    locale: 'en_IN', symbol: '₹', decimalDigits: 0);
        final String dateHeader =
            hasData ? _displayDate(booking!) : 'Nov, Tuesday';
        final String dayHeader =
            hasData ? _displayDayHeader(booking!) : '22nd';

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEEE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  ChayanHeader(
                    title: 'Upcoming Booking',
                    onBack: () => Navigator.pop(context),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w * scaleFactor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h * scaleFactor),

                          // Date + Actions
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Shows "Today" or "Wednesday"
                                  Text(
                                    dayHeader,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          18.sp * scaleFactor,
                                    ),
                                  ),
                                  // Shows "10 Dec, 2025"
                                  Text(
                                    dateHeader,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          18.sp * scaleFactor,
                                      color: Colors.grey[700], // distinct color
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push<void>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const HelpScreen(),
                                        ),
                                      );
                                    },
                                    child: _actionButton(
                                      'Help',
                                      'assets/icons/help.svg',
                                      const Color(0xFFE47830),
                                      scaleFactor: scaleFactor,
                                    ),
                                  ),
                                  SizedBox(width: 8.w * scaleFactor),
                                  GestureDetector(
                                    // Emergency
                                    onTap: () async {
                                      await Navigator.push<void>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const EmergencyScreen(),
                                        ),
                                      );
                                    },
                                    child: _actionButton(
                                      'Emergency',
                                      'assets/icons/emergency.svg',
                                      const Color(0xFFFF3300),
                                      scaleFactor: scaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h * scaleFactor),

                          // Service list (text-only, no images)
                          if (hasData && services.isNotEmpty)
                            ...services.map(
                              (s) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: 12.h * scaleFactor),
                                child: _serviceLine(
                                  title: s.serviceIName,
                                  subtitle: s.categoryName,
                                  durationMinutes: s.serviceDuration ?? 0,
                                  scaleFactor: scaleFactor,
                                ),
                              ),
                            )
                          else ...[
                            _serviceLine(
                              title: 'Diamond Facial',
                              subtitle: 'Includes lorem ipsum',
                              durationMinutes: 120,
                              scaleFactor: scaleFactor,
                            ),
                            SizedBox(height: 12.h * scaleFactor),
                            _serviceLine(
                              title: 'Cleanup',
                              subtitle: 'Includes lorem',
                              durationMinutes: 30,
                              scaleFactor: scaleFactor,
                            ),
                          ],
                          if (hasData && (booking?.totalDuration ?? 0) > 0)
  Padding(
    padding: EdgeInsets.only(top: 8.h * scaleFactor, bottom: 16.h * scaleFactor, left: 4.w),
    child: Row(
      children: [
        Icon(Icons.access_time_filled, size: 18.sp * scaleFactor, color: const Color(0xFFE47830)),
        SizedBox(width: 8.w),
        Text(
          "Total Duration: ${booking!.totalDuration} mins",
          style: TextStyle(
            fontSize: 14.sp * scaleFactor,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    ),
  ),

                          SizedBox(height: 20.h * scaleFactor),

                          // Billing (forward split) with real payment mode
                          Container(
                            padding: EdgeInsets.all(
                                16.r * scaleFactor),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                      12 * scaleFactor),
                              border: Border.all(
                                color:
                                    const Color(0xFFF3F3F3),
                                width: 2.w,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Billing Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        16.sp * scaleFactor,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        16.h * scaleFactor),
                                        // --- NEW LINES START HERE ---
                                        // --- ADD THE COUPON UI HERE ---
if (booking?.coupon != null)
  Padding(
    padding: EdgeInsets.only(bottom: 12.h * scaleFactor),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, size: 14.sp, color: Colors.green.shade700),
          SizedBox(width: 6.w),
          Text(
            '${booking!.coupon!.couponCode} Applied', // Now dynamic!
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12.sp * scaleFactor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  ),
                                // 1. Booking Reference Number
                                if (booking?.bookingReferenceNumber != null)
                                  _detailRow(
                                    'Reference No.', 
                                    booking!.bookingReferenceNumber, 
                                    scaleFactor: scaleFactor,
                                    isCopyable: true, // Allow copying ref number
                                  ),
                                
                                // 2. Booking PIN
                                if (booking?.bookingPin != null)
                                  _detailRow(
                                    'Start PIN', 
                                    booking!.bookingPin.toString().padLeft(4, '0'), 
                                    scaleFactor: scaleFactor
                                  ),

                                // 3. Payment Status (Paid/Unpaid)
                                if (booking?.paymentStatus != null)
                                  _detailRow(
                                    'Payment Status', 
                                    booking!.paymentStatus ?? 'N/A', 
                                    scaleFactor: scaleFactor
                                  ),
                                
                                Divider(height: 24.h * scaleFactor, color: const Color(0xFFEBEBEB)),
                                // --- NEW LINES END HERE ---
                               _billingRow(
  'Item Total', // Changed label for clarity
  inr.format(itemTotal),
  scaleFactor: scaleFactor,
),
if (booking?.coupon != null || couponDiscount > 0)
  _billingRow(
    'Coupon Discount', 
    "- ${inr.format(couponDiscount)}",
    valueColor: Colors.green.shade700, // Make it green
    scaleFactor: scaleFactor,
  ),
_billingRow(
  'Taxes & Fees (GST)', 
  inr.format(gstOnPlatform),
  valueColor: Colors.black87,
  scaleFactor: scaleFactor,
),
Divider(height: 30.h * scaleFactor),
_billingRow(
  'Total Amount',
  inr.format(total),
  isBold: true,
  scaleFactor: scaleFactor,
),
                                SizedBox(
                                    height:
                                        16.h * scaleFactor),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        12.h * scaleFactor,
                                    horizontal:
                                        16.h * scaleFactor,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFF3F3F3),
                                    borderRadius:
                                        BorderRadius.circular(
                                            10 * scaleFactor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Text(
                                        'Payment mode',
                                        style: TextStyle(
                                          fontSize: 14.sp *
                                              scaleFactor,
                                        ),
                                      ),
                                      Text(
                                        _paymentModeLabel(
                                            booking),
                                        style: TextStyle(
                                          fontSize: 14.sp *
                                              scaleFactor,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h * scaleFactor),

                          // Address + schedule + provider
                          _addressPanel(
                            scaleFactor,
                            hasData
                                ? "${address?.addressLine1 ?? ''}"
                                    "${address?.addressLine2 != null ? ', ${address!.addressLine2}' : ''}, "
                                    "${address?.city ?? ''}, ${address?.state ?? ''} ${address?.postCode ?? ''}"
                                : 'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033, Ph: +91234567890',
                            hasData
                                ? "${_displayDate(booking!)} - ${_displayTime(booking!)}"
                                : 'Sat, Apr 09 - 07:30 PM',
                            hasData
                                ? "${provider?.firstName ?? ''} ${provider?.lastName ?? ''}"
                                : 'Sumit Gupta, (180+ work), 4.5 rating',
                          ),

                          SizedBox(height: 20.h * scaleFactor),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Bottom Buttons
                  if (!isInProgress)
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        16.w * scaleFactor,
                        20.w * scaleFactor,
                        16.w * scaleFactor,
                        20.w * scaleFactor,
                      ),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // If there’s no booking object, open screen with safe fallbacks.
                                if (booking == null) {
                                  await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CancelBookingScreen(
                                        bookingId:
                                            '', // unknown; screen will guard submission
                                        serviceNameFallback:
                                            'Selected Service',
                                        totalDurationFallback: 60,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final b = booking!;
                                final id = (b.id).toString().trim();
                                final svc =
                                    b.bookingService.isNotEmpty
                                        ? b.bookingService.first
                                            .serviceIName
                                        : 'Selected Service';
                                final dur = b.totalDuration;

                                await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CancelBookingScreen(
                                      booking: b,
                                      bookingId:
                                          id.isNotEmpty ? id : '',
                                      serviceNameFallback: svc,
                                      totalDurationFallback:
                                          dur,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      14.h * scaleFactor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          10 * scaleFactor),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      16.sp * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w * scaleFactor),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (booking == null) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RescheduleSummaryScreen(
                                        bookingId: '',
                                        serviceName:
                                            'Selected Service',
                                        totalDuration: 60,
                                        categoryId: '',
                                        serviceId: '',
                                        // ADD THESE TWO LINES (Pass dummy current time for fallback)
          currentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          currentTime: DateFormat('HH:mm').format(DateTime.now()),
        
                                        
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final b = booking!;
                                final String bookingId =
                                    (b.id).toString().trim();
                                final String serviceName =
                                    b.bookingService.isNotEmpty
                                        ? b.bookingService.first
                                            .serviceIName
                                        : 'Selected Service';
                                final int duration =
                                    b.totalDuration;

                                final String categoryId =
                                    b.bookingService.isNotEmpty
                                        ? b
                                            .bookingService
                                            .first
                                            .categoryId
                                        : '';
                                final String serviceId =
                                    b.bookingService.isNotEmpty
                                        ? b
                                            .bookingService
                                            .first
                                            .serviceId
                                        : '';
                                final DateTime? validDt = _getValidDateTime(b);
  
  // Format: "yyyy-MM-dd" (Required for dayToken)
  final String dateParam = validDt != null 
      ? DateFormat('yyyy-MM-dd').format(validDt) 
      : ''; 

  // Format: "HH:mm" (Required for preferredTime parser)
  String timeParam = b.bookingTime;
  if (timeParam.isEmpty && validDt != null) {
    // If string is empty, fallback to extracting from DateTime
    timeParam = DateFormat('HH:mm').format(validDt);
  }        

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RescheduleSummaryScreen(
                                      bookingId: bookingId,
                                      serviceName: serviceName,
                                      totalDuration: duration,
                                      categoryId: categoryId,
                                      serviceId: serviceId,
                                      currentDate: dateParam, 
                                      currentTime: timeParam,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFE47830),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      14.h * scaleFactor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          10 * scaleFactor),
                                ),
                              ),
                              child: Text(
                                'Reschedule',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      16.sp * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helpers

  Widget _actionButton(
    String label,
    String iconPath,
    Color color, {
    required double scaleFactor,
  }) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 8.w * scaleFactor),
      height: 28.h * scaleFactor,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(5 * scaleFactor),
      ),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 16.w * scaleFactor,
              height: 16.h * scaleFactor,
            ),
          ),
          SizedBox(width: 4.w * scaleFactor),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp * scaleFactor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Text-only service row
  Widget _serviceLine({
    required String title,
    required String subtitle,
    required int durationMinutes,
    required double scaleFactor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r * scaleFactor),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFF3F3F3),
          width: 2.w,
        ),
        borderRadius:
            BorderRadius.circular(14 * scaleFactor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 8.w * scaleFactor,
            height: 8.h * scaleFactor,
            decoration: const BoxDecoration(
              color: Color(0xFFE47830),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12.sp * scaleFactor,
                          color:
                              const Color(0xFF757575),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w * scaleFactor),
                    Text(
                      "${durationMinutes} mins",
                      style: TextStyle(
                        fontSize: 12.sp * scaleFactor,
                        color:
                            const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _billingRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
    bool isBold = false,
    required double scaleFactor,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 4.h * scaleFactor),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp * scaleFactor,
              fontWeight: isBold
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp * scaleFactor,
              fontWeight: isBold
                  ? FontWeight.w700
                  : FontWeight.w400,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String iconPath,
    String text,
    double scaleFactor,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 20.w * scaleFactor,
            height: 20.h * scaleFactor,
          ),
        ),
        SizedBox(width: 8.w * scaleFactor),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: TextStyle(
              fontSize: 12.sp * scaleFactor,
              color: const Color(0xFF757575),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(double scaleFactor) {
    return Container(
      width: 4.w * scaleFactor,
      height: 4.h * scaleFactor,
      decoration: const BoxDecoration(
        color: Color(0xFF757575),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _addressPanel(
    double scaleFactor,
    String addressText,
    String scheduleText,
    String providerText,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r * scaleFactor),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12 * scaleFactor),
        border: Border.all(
          color: const Color(0xFFF3F3F3),
          width: 2.w,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _infoRow(
            'assets/icons/home.svg',
            addressText,
            scaleFactor,
          ),
          SizedBox(height: 12.h * scaleFactor),
          _infoRow(
            'assets/icons/calendar.svg',
            scheduleText,
            scaleFactor,
          ),
          SizedBox(height: 12.h * scaleFactor),
          _infoRow(
            'assets/icons/user.svg',
            providerText,
            scaleFactor,
          ),
        ],
      ),
    );
  }
  // Helper for displaying PIN, Ref No, etc. inside the billing box or separate card
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
              color: Colors.grey[700],
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
                ),
              ),
              if (isCopyable) ...[
                SizedBox(width: 8.w * scaleFactor),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    // Optional: Show a toast/snackbar
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