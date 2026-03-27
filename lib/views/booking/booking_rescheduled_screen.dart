import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'booking_screen.dart';

class BookingRescheduledScreen extends StatelessWidget {
  final String bookingId;         // optional display/use if needed
  final String serviceTitle;      // display name from read model
  final String bookingDate;       // yyyy-MM-dd
  final String bookingTime;       // hh:mm a
  final String durationLabel;     // e.g., "2 hr" or "45 min"
  final String? customerName;     // optional greeting

  const BookingRescheduledScreen({
    super.key,
    required this.bookingId,
    required this.serviceTitle,
    required this.bookingDate,
    required this.bookingTime,
    required this.durationLabel,
    this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      // Yellow theme palette
      const Color kPrimary = Color(0xFFFFC107);    // amber/yellow
      const Color kPrimaryDark = Color(0xFFFFA000); // deeper amber
      final Color kTint = const Color(0x1AFFC107); // 10% tint

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 80.h * scaleFactor),

              // Circular status badge (same as cancelled, color swapped)
              Container(
                width: 72.w * scaleFactor,
                height: 72.h * scaleFactor,
                decoration: BoxDecoration(
                  color: kTint, // light yellow tint
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimary, width: 2 * scaleFactor),
                ),
                child: Center(
                  child: Icon(Icons.check_rounded, color: kPrimary, size: 36 * scaleFactor),
                ),
              ),

              SizedBox(height: 16.h * scaleFactor),
              Text(
                'Booking Rescheduled!',
                style: TextStyle(
                  color: kPrimaryDark,
                  fontSize: 20.sp * scaleFactor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h * scaleFactor,
                  vertical: 24.h * scaleFactor,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Dear ${customerName?.trim().isNotEmpty == true ? customerName!.trim() : 'Customer'}, your booking for ',
                        style: TextStyle(
                          color: const Color(0xFF161616),
                          fontSize: 16.sp * scaleFactor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: serviceTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp * scaleFactor,
                          color: const Color(0xFF161616),
                        ),
                      ),
                      TextSpan(
                        text: ' has been rescheduled to ',
                        style: TextStyle(
                          color: const Color(0xFF161616),
                          fontSize: 16.sp * scaleFactor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: "$bookingDate at $bookingTime",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp * scaleFactor,
                          color: const Color(0xFF161616),
                        ),
                      ),
                      TextSpan(
                        text: '. See you soon!',
                        style: TextStyle(
                          color: const Color(0xFF161616),
                          fontSize: 16.sp * scaleFactor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Summary card (same layout as cancelled)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                child: Container(
                  height: 132.h * scaleFactor,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF3F3F3), width: 2.w * scaleFactor),
                    borderRadius: BorderRadius.circular(20 * scaleFactor),
                  ),
                  padding: EdgeInsets.all(12.r * scaleFactor),
                  child: Row(
                    children: [
                      // Yellow dot
                      Container(
                        width: 16.w * scaleFactor,
                        height: 16.h * scaleFactor,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC107),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 16.w * scaleFactor),
                    // --- FIX 2: Layout Overflow Protection ---
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Title
                                    Text(
                                      serviceTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp * scaleFactor,
                                        fontFamily: 'Inter',
                                        color: const Color(0xFF161616),
                                      ),
                                    ),
                                    SizedBox(height: 6.h * scaleFactor),
                                    // Duration
                                    Row(
                                      children: [
                                        _dot(scaleFactor),
                                        SizedBox(width: 6.w * scaleFactor),
                                        Text(
                                          durationLabel,
                                          style: TextStyle(
                                            fontSize: 14.sp * scaleFactor,
                                            color: const Color(0xFF757575),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h * scaleFactor),
                                    // Helpful caption
                                    Row(
                                      children: [
                                        _dot(scaleFactor),
                                        SizedBox(width: 6.w * scaleFactor),
                                        Flexible(
                                          child: Text(
                                            'We’ve updated your slot!',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.sp * scaleFactor,
                                              color: const Color(0xFF757575),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h * scaleFactor),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                child: SizedBox(
                  width: double.infinity,
                  height: 47.h * scaleFactor,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) =>  BookingScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE47830),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                      ),
                    ),
                    child: Text(
                      'Go back',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16.sp * scaleFactor,
                        color: Colors.white,
                        letterSpacing: 0.32 * scaleFactor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h * scaleFactor),
            ],
          ),
        ),
      );
    });
  }

  Widget _dot(double scale) {
    return Container(
      width: 4.w * scale,
      height: 4.h * scale,
      decoration: const BoxDecoration(
        color: Color(0xFF757575),
        shape: BoxShape.circle,
      ),
    );
  }
}
