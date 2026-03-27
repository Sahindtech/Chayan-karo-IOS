import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'upcoming_booking_screen.dart';
import 'PreviousBookingScreen.dart';
import 'feedback_screen.dart';
import '../../widgets/no_internet_screen.dart'; // Import the new file
import '../../widgets/three_dot_loader.dart';

// NEW
import '../../controllers/booking_read_controller.dart';
import '../../models/booking_read_models.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final int _selectedIndex = 1;
  bool showUpcoming = true;

  // UPDATED: Start both as false to represent "Show All" by default
  bool _showCancelled = false;
  bool _showCompleted = false;

  // Read controller for bookings list
  final BookingReadController readCtrl = Get.put(BookingReadController(), permanent: true);

  @override
  void initState() {
    super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUpcoming();
    });
  }  

  void _fetchUpcoming() {
    readCtrl.fetchCustomerBookings();
  }

void _onItemTapped(BuildContext context, int index) {
  if (index == 1) return; // Already on Booking Screen
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  Widget buildTabBar(double scaleFactor) {
    return Container(
      color: const Color(0xFFFFEDE0),
      padding: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 12.h * scaleFactor),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => showUpcoming = true);
                _fetchUpcoming();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w500,
                      color: showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                    ),
                  ),
                  if (showUpcoming)
                    Container(
                      margin: EdgeInsets.only(top: 4.r * scaleFactor),
                      width: 76.w * scaleFactor,
                      height: 4.h * scaleFactor,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE47830),
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => showUpcoming = false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w400,
                      color: !showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                    ),
                  ),
                  if (!showUpcoming)
                    Container(
                      margin: EdgeInsets.only(top: 4.r * scaleFactor),
                      width: 72.w * scaleFactor,
                      height: 4.h * scaleFactor,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE47830),
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
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

  // PIN boxes (string version)
  Widget buildPinBoxes(String pin, double scaleFactor) {
    return Row(
      children: pin.split('').map((digit) {
        return Container(
          margin: EdgeInsets.only(left: 4.r * scaleFactor),
          width: 20.w * scaleFactor,
          height: 22.h * scaleFactor,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(4 * scaleFactor),
          ),
          child: Text(
            digit,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp * scaleFactor,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro',
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helpers: date and time formatting
  String _humanDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
    } catch (_) {
      return iso;
    }
  }

  String _displayDate(CustomerBooking b) {
  final dt = b.displayDateTimeLocal;
  if (dt == null) return b.bookingDate.length >= 10 ? b.bookingDate.substring(0,10) : b.bookingDate;
  return DateFormat('dd-MM-yyyy').format(dt);
}

String _displayTime(CustomerBooking b) {
    final dt = b.displayDateTimeLocal;
    
    // 1. If we already have a full DateTime object, use it directly.
    if (dt != null) {
      return DateFormat('hh:mm a').format(dt);
    }

    String t = b.bookingTime; // e.g. "10:30", "15:00", or "11:00"

    // 2. Handle standard "HH:mm" format from your backend
    if (t.contains(':')) {
      try {
        final parts = t.split(':'); // Splits "10:30" into ["10", "30"]
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]); 

        // Convert 24h to 12h AM/PM
        final ap = h >= 12 ? "PM" : "AM";
        final hh12 = (h % 12 == 0) ? 12 : h % 12;
        
        return "${hh12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ap";
      } catch (e) {
        return t; // If data is corrupted, just show raw string
      }
    }

    // 3. Fallback for older "HHmm" format (e.g. "1030") just in case
    if (t.length >= 4) {
      final h = int.tryParse(t.substring(0, 2)) ?? 0;
      final m = int.tryParse(t.substring(2, 4)) ?? 0;
      final ap = h >= 12 ? "PM" : "AM";
      final hh12 = (h % 12 == 0) ? 12 : h % 12;
      return "${hh12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ap";
    }

    return t;
  }


  Widget _pinBoxes(int pin, double scaleFactor) => buildPinBoxes(pin.toString().padLeft(4, '0'), scaleFactor);

  // Dynamic upcoming card from data
  Widget buildUpcomingCardFromBooking(CustomerBooking b, double scaleFactor) {
    final services = b.bookingService;
    final primaryTitle = services.isNotEmpty ? services.first.categoryName : "Service";
    final serviceBullets = services.map((s) => "• ${s.serviceIName}").toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UpcomingBookingScreen(booking: b)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 10.h * scaleFactor),
        padding: EdgeInsets.all(16.r * scaleFactor),
        decoration: BoxDecoration(
          color: const Color(0xFFECEEFF),
          borderRadius: BorderRadius.circular(16 * scaleFactor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    primaryTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp * scaleFactor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: const Color(0xFF161616),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Your PIN',
                      style: TextStyle(
                        fontSize: 10.sp * scaleFactor,
                        color: const Color(0xFF161616),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h * scaleFactor),
                    _pinBoxes(b.bookingPin, scaleFactor),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h * scaleFactor),
            ...serviceBullets.map((t) => Padding(
                  padding: EdgeInsets.only(bottom: 2.h * scaleFactor),
                  child: Text(t, style: TextStyle(fontSize: 12.sp * scaleFactor, color: const Color(0xFF555555))),
                )),
            SizedBox(height: 12.h * scaleFactor),
// FIX: Check for both 'progress' and 'in progress'
            if ((b.status ?? '').toLowerCase().contains('progress'))
              Container(
                margin: EdgeInsets.only(bottom: 4.h * scaleFactor),
                padding: EdgeInsets.symmetric(horizontal: 10.w * scaleFactor, vertical: 4.h * scaleFactor),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD), // Light Blue Background
                  borderRadius: BorderRadius.circular(4 * scaleFactor),
                  border: Border.all(color: const Color(0xFF2196F3)), // Blue Border
                ),
                child: Text(
                  'In Progress', // Always display "In Progress" for better UX
                  style: TextStyle(
                    fontSize: 12.sp * scaleFactor,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2196F3), // Blue Text
                  ),
                ),
              )
            else
              Text(
                'Booking scheduled',
                style: TextStyle(
                  fontSize: 16.sp * scaleFactor, 
                  fontWeight: FontWeight.w600
                ),
              ),            SizedBox(height: 4.h * scaleFactor),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${_displayDate(b)} / ', style: TextStyle(fontSize: 13.sp * scaleFactor)),
                  TextSpan(text: _displayTime(b), style: TextStyle(fontSize: 10.sp * scaleFactor)),
                ],
              ),
            ),
            SizedBox(height: 4.h * scaleFactor),
            Text(
              'When Your Chayan sathi arrives share your PIN',
              style: TextStyle(fontSize: 8.sp * scaleFactor, color: Colors.black.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  // PRESENT previous-card design, with simplified status label
  // UPDATED: Previous Card to show Multiple Services
  Widget buildPreviousCardFromBooking(CustomerBooking b, double scaleFactor) {
    final services = b.bookingService;
    
    // We keep firstService logic for the feedback parameters
    final firstService = services.isNotEmpty ? services.first : null;
    final String serviceNameForFeedback = firstService?.serviceIName ?? 'Service';

    // EXTRACT ALL SERVICE NAMES
    final serviceBullets = services.isNotEmpty 
        ? services.map((s) => "• ${s.serviceIName}").toList() 
        : ["• Service"];

    final String bookingId = b.id ?? '';
    final String spId = b.spId ?? '';

    final dateLabel = _displayDate(b);

    final statusLower = (b.status).toLowerCase();
    final bool isCancelled = statusLower == 'cancelled';
    final bool isCompleted = statusLower == 'completed';
    final bool canShowFeedbackButton = isCompleted && !isCancelled && !b.feedbackSubmitted;

    final String statusText = isCancelled ? 'Cancelled' : (isCompleted ? 'Completed' : b.status);
// BUG FIX: Set specific colors for status
    Color statusColor = Colors.black54; // Default grey
    if (isCancelled) {
      statusColor = Colors.red; // Explicit Red for Cancelled
    } else if (isCompleted) {
      statusColor = Colors.green; // Explicit Green for Completed
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 10.h * scaleFactor),
      padding: EdgeInsets.all(16.r * scaleFactor),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16 * scaleFactor),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: date and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateLabel, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp * scaleFactor)),
// Apply the dynamic color here
              Text(
                statusText, 
                style: TextStyle(
                  color: statusColor, 
                  fontSize: 14.sp * scaleFactor,
                  fontWeight: FontWeight.w600 // Optional: make bold for better visibility
                )
              ),            ],
          ),
          SizedBox(height: 8.h * scaleFactor),

          // UPDATED: Service lines (Multiple)
          ...serviceBullets.map((t) => Padding(
                padding: EdgeInsets.only(bottom: 4.h * scaleFactor),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        t,
                        style: TextStyle(
                            color: Colors.black54, 
                            fontSize: 12.sp * scaleFactor
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Removed the single dropdown icon, as we are listing multiple items now
                  ],
                ),
              )),
          
          SizedBox(height: 12.h * scaleFactor),

          // Bottom actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Share Feedback (only when allowed)
              if (canShowFeedbackButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE47830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h * scaleFactor,
                      vertical: 8.h * scaleFactor,
                    ),
                  ),
                  onPressed: () {
                    Get.to(
                      () => const FeedbackScreen(),
                      arguments: {
                        'spId': spId,
                        'bookingId': bookingId,
                        'serviceName': serviceNameForFeedback,
                      },
                    );
                  },
                  child: Text(
                    'Share Feedback',
                    style: TextStyle(
                      fontSize: 12.sp * scaleFactor,
                      color: Colors.white,
                    ),
                  ),
                ),

              // Always show View Details
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PreviousBookingScreen(booking: b),
                    ),
                  );
                },
                child: Text(
                  'View details',
                  style: TextStyle(
                    fontSize: 12.sp * scaleFactor,
                    color: const Color(0xFFE47830),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildPillChipsRow(double scaleFactor) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.w * scaleFactor, 6.h * scaleFactor, 16.w * scaleFactor, 4.h * scaleFactor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- Cancelled Chip ---
        Expanded(
          child: _OutlinedPill(
            label: 'Cancelled',
            selected: _showCancelled,
            onTap: () {
              setState(() {
                if (_showCancelled) {
                  _showCancelled = false; // Deselect -> Show All
                } else {
                  _showCancelled = true;  // Select Cancelled
                  _showCompleted = false; // Turn off Completed
                }
              });
            },
            scaleFactor: scaleFactor,
          ),
        ),
        SizedBox(width: 8.w * scaleFactor),
        // --- Completed Chip ---
        Expanded(
          child: _OutlinedPill(
            label: 'Completed',
            selected: _showCompleted,
            onTap: () {
              setState(() {
                if (_showCompleted) {
                  _showCompleted = false; // Deselect -> Show All
                } else {
                  _showCompleted = true;  // Select Completed
                  _showCancelled = false; // Turn off Cancelled
                }
              });
            },
            scaleFactor: scaleFactor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildEmptyState(BuildContext context, double scaleFactor, {
    bool isPrevious = false,
    String? title,    // NEW: Allow custom title
    String? message,  // NEW: Allow custom message
  }) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Default texts if custom ones aren't provided
    final defaultTitle = isPrevious ? 'No Previous Booking Yet' : 'No Upcoming Booking Yet';
    final defaultMessage = isPrevious
        ? 'You don’t have any previous bookings yet'
        : 'You don’t have any upcoming bookings right now';

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.75.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 110.w * scaleFactor,
              height: 110.h * scaleFactor,
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/bookings.svg",
                  fit: BoxFit.cover,
                  width: 110.w * scaleFactor,
                  height: 110.h * scaleFactor,
                ),
              ),
            ),
            SizedBox(height: 20.h * scaleFactor),
            Text(
              title ?? defaultTitle, // Use custom title or fallback
              style: TextStyle(
                fontSize: 20.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.h * scaleFactor),
            Opacity(
              opacity: 0.8,
              child: Text(
                message ?? defaultMessage, // Use custom message or fallback
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp * scaleFactor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro',
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.h * scaleFactor),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Container(
                width: 175.w * scaleFactor,
                height: 45.h * scaleFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                  border: Border.all(
                    color: const Color(0xFFE47830),
                    width: 2.w * scaleFactor,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Explore Services',
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro',
                    color: const Color(0xFFE47830),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            buildTabBar(scaleFactor),
            Divider(height: 1.h * scaleFactor, color: const Color(0xFFEBEBEB)),

            // Show chips only for Previous tab
            if (!showUpcoming)   _buildPillChipsRow(scaleFactor),

            if (!showUpcoming) Divider(height: 1.h * scaleFactor, color: const Color(0xFFEBEBEB)),

            Expanded(
              child: Obx(() {
                // 1. Loading State
                if (readCtrl.isLoading.value && readCtrl.bookings.isEmpty) {
                  return Center(
                          // --- REPLACED CircularProgressIndicator ---
                          child: ThreeDotLoader(
                            size: 14.w * scaleFactor, // Responsive size
                            color: const Color(0xFFE47830),
                          ),
                        );
                }

                // 2. Error Handling (Network Check)
               if (readCtrl.error.isNotEmpty) {
                  final err = readCtrl.error.value.toLowerCase();
                  
                  // If it's a network error or a code crash (like the Null cast error), 
                  // show the No Internet UI or a Friendly "Something went wrong"
                  if (err.contains('socket') || err.contains('timeout') ) {
                    return NoInternetScreen(onRetry: _fetchUpcoming);
                  }
                  
                  // Clean fallback for any other error
                  return _buildEmptyState(
                    context, 
                    scaleFactor, 
                    title: "System Update",
                    message: "We're refreshing your bookings. Please try again in a moment.",
                    isPrevious: !showUpcoming
                  );
                }
                // Base dataset by tab
                final base = showUpcoming ? readCtrl.upcoming : readCtrl.previous;

               // UPDATED FILTER LOGIC
                final data = showUpcoming
                    ? base
                    : base.where((b) {
                        // 1. If NO filters are selected, Show ALL
                        if (!_showCancelled && !_showCompleted) return true;

                        final s = (b.status).toLowerCase();

                        // 2. If Cancelled is selected, show only Cancelled
                        if (_showCancelled && s == 'cancelled') return true;

                        // 3. If Completed is selected, show only Completed
                        if (_showCompleted && s == 'completed') return true;

                        return false;
                      }).toList();

               if (data.isEmpty) {
                  String? customTitle;
                  String? customMsg;

                  if (!showUpcoming) {
                    // Logic for Previous Tab Empty States
                    if (_showCancelled) {
                      customTitle = "No Cancelled Bookings";
                      customMsg = "You don't have any cancelled bookings.";
                    } else if (_showCompleted) {
                      customTitle = "No Completed Bookings";
                      customMsg = "You don't have any completed bookings yet.";
                    } else {
                      // Default Previous Empty State (No filters selected)
                      customTitle = "No Previous Booking Yet";
                      customMsg = "You don’t have any previous bookings yet";
                    }
                  }

                  return _buildEmptyState(
                    context, 
                    scaleFactor, 
                    isPrevious: !showUpcoming,
                    title: customTitle,
                    message: customMsg,
                  );
                }
                // ----------------------------------

                // SORTING LOGIC: In Progress first, then Newest Date
                final list = [...data]..sort((a, b) {
                  // 1. Check if item is In Progress
                  // We use .contains('progress') to catch "Progress" or "In Progress"
                  final aInProgress = (a.status ?? '').toLowerCase().contains('progress');
                  final bInProgress = (b.status ?? '').toLowerCase().contains('progress');

                  // 2. Prioritize In Progress
                  if (aInProgress && !bInProgress) return -1; // 'a' comes first
                  if (!aInProgress && bInProgress) return 1;  // 'b' comes first

                  // 3. Fallback: Sort by Creation Time (Newest First)
                  return DateTime.parse(b.creationTime)
                      .compareTo(DateTime.parse(a.creationTime));
                });

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => showUpcoming
                      ? buildUpcomingCardFromBooking(list[i], scaleFactor)
                      : buildPreviousCardFromBooking(list[i], scaleFactor),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // <--- FIXED: Hardcoded to 1
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
      );
    });
  }
}
class _OutlinedPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double scaleFactor;

  const _OutlinedPill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFE47830);
    final bg = selected ? const Color(0xFFFFF3EA) : Colors.white;
    final border = selected ? orange.withOpacity(0.45) : orange.withOpacity(0.25);
    final textColor = const Color(0xFF6F6F6F);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28.h * scaleFactor,                 // was 34
        padding: EdgeInsets.symmetric(              // add minimal padding
          horizontal: 10.w * scaleFactor,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999 * scaleFactor),
          border: Border.all(color: border, width: 1.0 * scaleFactor), // was 1.2
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015), // slightly lighter
              blurRadius: 1.5 * scaleFactor,
              offset: Offset(0, 0.5 * scaleFactor),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 11.sp * scaleFactor,         // was 12
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
