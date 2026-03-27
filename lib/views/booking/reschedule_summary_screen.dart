import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/chayan_header.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../models/location_models.dart'; // Ensure CustomerAddress model is imported
import '../../widgets/discard_changes_sheet.dart'; // Ensure correct path
// Make sure this file exists with the code you provided
import 'merged_booking_modal.dart'; 
import 'showScheduleAddressPopup.dart';
import 'booking_rescheduled_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';

class RescheduleSummaryScreen extends StatefulWidget {
  final String bookingId;
  final String serviceName;
  final int totalDuration;
  final String categoryId;
  final String serviceId;
  final String currentDate; // Format: "yyyy-MM-dd"
  final String currentTime; // Format: "HH:mm" (24h) or "hh:mm a"

  const RescheduleSummaryScreen({
    super.key,
    required this.bookingId,
    required this.serviceName,
    required this.totalDuration,
    required this.categoryId,
    required this.serviceId,
    required this.currentDate, 
    required this.currentTime,
  });

  @override
  State<RescheduleSummaryScreen> createState() => _RescheduleSummaryScreenState();
}

class _RescheduleSummaryScreenState extends State<RescheduleSummaryScreen> {
  late final LocationController locationController;
  late final BookingController bookingController;

  String addressText = "Select address";
  String? addressId;
  String? locationId;

  String dayToken = ""; // dd or yyyy-MM-dd
  TimeOfDay? preferredTime; // Stores the selected time
  DateTime? _originalBlockedSlot;

  Map<String, dynamic>? saathi;

  bool _bootstrapped = false;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> _reasons = const [
    "Preferred a different time",
    "Conflict with another plan",
    "Traffic or travel delay",
    "Location change needed",
    "Emergency/personal reason",
    "Other", // <-- ADD THIS

  ];

  String _pickedReason = "Preferred a different time";

  Future<void> _handleBack() async {
    final shouldDiscard = await showDiscardChangesSheet(context);
    if (shouldDiscard && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    locationController = Get.find<LocationController>();
    bookingController = Get.put(BookingController(), permanent: false);
    // 3. ADD THIS BLOCK TO INITIALIZE THE BLOCKED SLOT
    try {
      // Parse Date
      dayToken = widget.currentDate; 
      
      // Parse Time (Simple parser for "HH:mm" or "HH:mm:ss")
      final timeParts = widget.currentTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1].substring(0, 2)); // clean potential seconds
      preferredTime = TimeOfDay(hour: hour, minute: minute);

      // Set the original blocked slot
      _originalBlockedSlot = _resolveBookingDateTime(dayToken, preferredTime);
    } catch (e) {
      print("Error parsing current booking time: $e");
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Fetch latest addresses from API
      await locationController.fetchCustomerAddresses();
      // 2. Start logic
      _startWizardIfNeeded();
    });
  }

  Future<void> _startWizardIfNeeded() async {
    if (_bootstrapped) return;
    _bootstrapped = true;
    
    // 1. Pick Default Address (SILENTLY - NO POPUP)
    _pickDefaultAddress();

    // 2. Pick Date & Time (Merged)
    // Only prompt for date if we successfully got an address
    if ((addressId ?? "").isNotEmpty) {
       await _editDateAndTime();
    }
    
    // REMOVED: await _editSaathi(); 
    // Reason: _editDateAndTime() already calls _editSaathi() internally 
    // when a date is selected. Keeping this caused the double screen glitch.
  }
  // --- Address Logic ---

  // NEW METHOD: Selects default address without showing UI
  void _pickDefaultAddress() {
    final list = locationController.addresses;
    if (list.isEmpty) return;

    // Find default, otherwise take the first one
    CustomerAddress? target = list.firstWhereOrNull((a) => a.isDefault) ?? list.first;
    
    setState(() {
      addressId = target.id;
      locationId = target.locationId;
      addressText = _formatAddress(
        target.addressLine1 ?? "", 
        target.addressLine2 ?? "", 
        target.city ?? "", 
        target.state ?? "", 
        target.postCode ?? ""
      );
    });
    }

  void _syncAddressToIds(String disp) {
    final list = locationController.addresses;
    if (list.isEmpty) return;
    final match = list.firstWhereOrNull((a) {
      final formatted = _formatAddress(
          a.addressLine1 ?? "", 
          a.addressLine2 ?? "", 
          a.city ?? "", 
          a.state ?? "", 
          a.postCode ?? ""
      ).toLowerCase().trim();
      return formatted == disp.toLowerCase().trim();
    });
    if (match != null) {
      setState(() {
        addressId = match.id;
        locationId = match.locationId;
      });
    }
  }

  String _formatAddress(String l1, String l2, String city, String state, String post) {
    final parts = <String>[];
    if (l1.trim().isNotEmpty) parts.add(l1);
    if (l2.trim().isNotEmpty) parts.add(l2);
    if (city.trim().isNotEmpty) parts.add(city);
    // if (state.trim().isNotEmpty) parts.add(state); // Optional: keep short
    if (post.trim().isNotEmpty) parts.add(post);
    return parts.join(', ');
  }

 Future<void> _editAddress() async {
    // This calls the popup ONLY when user explicitly clicks the Edit button
    final newAddress = await showScheduleAddressPopup(context);
    if (newAddress == null) return;
    
    // Refresh list to ensure IDs are synced
    await locationController.fetchCustomerAddresses();
    
    setState(() {
      addressText = newAddress;
      // Reset current saathi because providers vary by location
      saathi = null; 
    });
    _syncAddressToIds(newAddress);

    // NEW: Automatically open Saathi screen after address change
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay for smooth UI
      _editSaathi();
    }
  }
  // --- Date & Time Logic (Merged) ---

  String _scheduleLabelFromToken(String token, TimeOfDay? time) {
    if (token.trim().isEmpty) return "Select date & time";
    
    // 1. Get Date Part
    final full = RegExp(r'^\d{4}-\d{2}-\d{2}$').firstMatch(token)?.group(0);
    final dateToken = full ?? RegExp(r'(\d{2})').firstMatch(token)?.group(1) ?? DateFormat('dd').format(DateTime.now());
    
    final datePart = _formatScheduledLabel(dateToken);
    
    // 2. Get Time Part
    if (time == null) return datePart; 
    
    final timePart = _formatInlineTime(time);
    
    // Combine: "Tomorrow, 9 Dec | 10:30 AM"
    return "$datePart | $timePart";
  }

  String _formatScheduledLabel(String dayNumberOrFull) {
    final now = DateTime.now();
    DateTime? target;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dayNumberOrFull)) {
      target = DateFormat('yyyy-MM-dd').parse(dayNumberOrFull);
    } else {
      final dd = int.tryParse(dayNumberOrFull);
      if (dd != null) {
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        final safe = dd.clamp(1, lastDay);
        target = DateTime(now.year, now.month, safe);
      }
    }
    target ??= now;
    final today = DateTime(now.year, now.month, now.day);
    final tgt = DateTime(target.year, target.month, target.day);
    final diff = tgt.difference(today).inDays;
    
    final lead = diff == 0 ? "Today" : diff == 1 ? "Tomorrow" : DateFormat('EEE').format(target);
    final day = DateFormat('dd').format(target);
    final mon = DateFormat('MMM').format(target);
    
    return "$lead, $day $mon";
  }

  String _formatInlineTime(TimeOfDay? t) {
    if (t == null) return "Time";
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  // --- REUSABLE SNACKBAR HELPER ---
  void _showCustomSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? const Color(0xFFFFE5E5) : Colors.green[100], // Light Red for error, Green for success
      colorText: isError ? Colors.red[800] : Colors.green[800],
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(16.w), // Responsive margin
      borderRadius: 12,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: isError ? Colors.red[800] : Colors.green[800],
      ),
      shouldIconPulse: true,
    );
  }

 Future<void> _editDateAndTime() async {
    String? nextSlotConstraint;
    if (saathi != null) {
      if (saathi!['availabilityResult'] != null && saathi!['availabilityResult'] is Map) {
        nextSlotConstraint = saathi!['availabilityResult']['nextAvailableSlot'];
      } else if (saathi!['nextAvailableSlot'] != null) {
        nextSlotConstraint = saathi!['nextAvailableSlot'];
      }
    }

    final DateTime? result = await showMergedBookingModal(
      context,
      initialDateStr: dayToken,
      initialTime: preferredTime,
      minTimeConstraint: nextSlotConstraint,
      blockedSlot: _originalBlockedSlot, // Pass the frozen original time
    );

    // Only run if the user actually selected a time (didn't just close the modal)
    if (result != null) {
      setState(() {
        dayToken = DateFormat('yyyy-MM-dd').format(result);
        preferredTime = TimeOfDay.fromDateTime(result);
      });

      // NEW: Automatically open Saathi screen after time change
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 100)); // Small delay for UI smoothness
        _editSaathi();
      }
    }
  }

  DateTime _resolveBookingDateTime(String token, TimeOfDay? tod) {
    final now = DateTime.now();
    DateTime date;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(token)) {
      date = DateFormat('yyyy-MM-dd').parse(token);
    } else {
      final dd = int.tryParse(RegExp(r'(\d{2})').firstMatch(token)?.group(1) ?? "") ?? now.day;
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      final safe = dd.clamp(1, lastDay);
      date = DateTime(now.year, now.month, safe);
    }
    final t = tod ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(date.year, date.month, date.day, t.hour, t.minute);
  }

  // --- Saathi Logic ---

Future<void> _editSaathi() async {
    if ((addressId ?? "").isEmpty) {
     _showCustomSnackbar("Address required", "Please select an address first");
      return;
    }
    if (dayToken.trim().isEmpty) {
     _showCustomSnackbar("Day required", "Please select a scheduled day first");
      return;
    }
    if (preferredTime == null) {
      _showCustomSnackbar("Time required", "Please select a time slot first");
      return;
    }
    if ((locationId ?? "").isEmpty) {
_showCustomSnackbar("Location missing", "Could not resolve location for address");
      return;
    }
    // --- ADD THIS BLOCK: PREVENT SAME TIME SELECTION ---
    if (_originalBlockedSlot != null) {
      // Create a DateTime object from current selection
      final currentSelection = _resolveBookingDateTime(dayToken, preferredTime);
      
      // Compare checks
      final bool isSameSlot = 
          currentSelection.year == _originalBlockedSlot!.year &&
          currentSelection.month == _originalBlockedSlot!.month &&
          currentSelection.day == _originalBlockedSlot!.day &&
          currentSelection.hour == _originalBlockedSlot!.hour &&
          currentSelection.minute == _originalBlockedSlot!.minute;

      if (isSameSlot) {
        _showCustomSnackbar(
          "No Change Detected", 
          "Please select a new date or time to reschedule.", 
          isError: true
        );
        return; // Stop here, do not navigate
      }
    }
    // ---------------------------------------------------

    final DateTime resolvedDate = _resolveBookingDateTime(dayToken, const TimeOfDay(hour: 0, minute: 0));
    final String preciseDateString = DateFormat('yyyy-MM-dd').format(resolvedDate);
    final TimeOfDay t = preferredTime!;
    final String timeString = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    final selectedSaathi = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ChayanSathiScreen(
          categoryId: widget.categoryId,
          serviceId: widget.serviceId,
          locationId: locationId!,
          addressId: addressId!,
          initialSlot: preciseDateString, 
          bookingTime: timeString,       
          currentBookingDuration: widget.totalDuration,
        ),
      ),
    );

    if (selectedSaathi != null) {
      setState(() => saathi = selectedSaathi);
    }
  }

  // --- Submission Logic ---

  bool get _canSubmit =>
      (addressId ?? "").isNotEmpty &&
      dayToken.trim().isNotEmpty &&
      saathi != null &&
      (saathi?['id']?.toString().isNotEmpty ?? false) &&
      preferredTime != null &&
      widget.bookingId.trim().isNotEmpty;



 Future<void> _submitWithReason() async {
    // 1. Validation for 'Other' Reason Text
    if (_pickedReason == 'Other' && _otherReasonController.text.trim().isEmpty) {
      _showCustomSnackbar("Reason required", "Please specify the reason for rescheduling", isError: true);
      return;
    }

    if (!_canSubmit) return;

    final slot = _resolveBookingDateTime(dayToken, preferredTime);

    // 2. CHECK: Prevent Rescheduling to the Exact Same Time
    if (_originalBlockedSlot != null) {
      final bool isSameSlot = 
          slot.year == _originalBlockedSlot!.year &&
          slot.month == _originalBlockedSlot!.month &&
          slot.day == _originalBlockedSlot!.day &&
          slot.hour == _originalBlockedSlot!.hour &&
          slot.minute == _originalBlockedSlot!.minute;

      if (isSameSlot) {
        _showCustomSnackbar(
          "No Change Detected", 
          "Please select a new date or time to reschedule.", 
          isError: true
        );
        return; // Stop here. Do not show modal. Do not call API.
      }
    }

    // 3. SHOW CONFIRMATION MODAL
    final bool confirm = await _showRescheduleConfirmation(slot);
    if (!confirm) return; // If user clicked "No" or dismissed, stop here.

    // 4. Proceed with API Call
    final String finalReason = _pickedReason == 'Other' 
        ? _otherReasonController.text.trim() 
        : _pickedReason;
    
    final spId = saathi!['id'].toString();

    try {
      bookingController.isRescheduling.value = true;

      final ok = await bookingController.rescheduleBookingTyped(
        bookingId: widget.bookingId,
        spId: spId,
        addressId: addressId!,
        preferred: slot,
        rescheduleReason: finalReason,
      );

      if (ok) {
        final dateStr = "${slot.year.toString().padLeft(4, '0')}-${slot.month.toString().padLeft(2, '0')}-${slot.day.toString().padLeft(2, '0')}";
        final timeStr = DateFormat('hh:mm a').format(slot);
        final dur = widget.totalDuration >= 60
            ? "${(widget.totalDuration / 60).toStringAsFixed(0)} hr"
            : "${widget.totalDuration} min";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingRescheduledScreen(
              bookingId: widget.bookingId,
              bookingDate: dateStr,
              bookingTime: timeStr,
              serviceTitle: widget.serviceName,
              durationLabel: dur,
            ),
          ),
        );
      }
      // Note: Error snackbars are now handled by the Controller, so no else block needed here.
      
    } catch (e) {
      print("Unexpected UI error: $e");
    } finally {
      bookingController.isRescheduling.value = false;
    }
  }
  Future<bool> _showRescheduleConfirmation(DateTime slot) async {
    final scale = MediaQuery.of(context).size.width >= 600 ? MediaQuery.of(context).size.width / 411 : 1.0;
    final dateStr = DateFormat('dd MMM, yyyy').format(slot);
    final timeStr = DateFormat('hh:mm a').format(slot);

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20 * scale)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w * scale, vertical: 24.h * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm Reschedule?",
                style: TextStyle(
                  fontSize: 18.sp * scale,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h * scale),
              Text(
                "Are you sure you want to change your booking to\n$dateStr at $timeStr?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp * scale,
                  color: const Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h * scale),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false), // Return False
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h * scale),
                        side: const BorderSide(color: Color(0xFFE47830)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                      ),
                      child: Text(
                        "No, Go Back",
                        style: TextStyle(
                          color: const Color(0xFFE47830),
                          fontSize: 15.sp * scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w * scale),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true), // Return True
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE47830),
                        padding: EdgeInsets.symmetric(vertical: 12.h * scale),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Yes, Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp * scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h * scale),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
  
@override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width >= 600 ? MediaQuery.of(context).size.width / 411 : 1.0;
    
    final scheduledDisplay = _scheduleLabelFromToken(dayToken, preferredTime);

    final double hPad = 16.w * scale;
    final double vPad = 10.h * scale;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 1. Ensures layout adjusts for keyboard
        backgroundColor: const Color(0xFFFFFEFD),
        body: SafeArea(
          // 2. Changed from Stack to Column for better layout control
          child: Column( 
            children: [
              // Header stays at top
              ChayanHeader(title: "Reschedule", onBack: _handleBack),
              
              // 3. Scrollable content takes all remaining space
              Expanded( 
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoCardCompact(
                        scale: scale,
                        address: addressText,
                        scheduled: scheduledDisplay,
                        saathiText: saathi == null
                            ? "Select Chayan Saathi"
                            : "${saathi!['name']}, (${saathi!['jobs'] ?? 0}+ work), ${saathi!['rating'] ?? 0.0} rating",
                        onEditAddress: _editAddress, 
                        onEditDateAndTime: _editDateAndTime,
                        onEditSaathi: _editSaathi,
                      ),
                      
                      SizedBox(height: 24.h * scale),
                      
                      Text(
                        "REASON FOR RESCHEDULE",
                        style: TextStyle(
                          color: const Color(0xFF9F9F9F),
                          fontSize: 11.sp * scale,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: 4.h * scale),

                      // Radio Buttons
                      ..._reasons.map((r) => _ReasonTileCompact(
                            scale: scale,
                            text: r,
                            selected: _pickedReason == r,
                            onTap: () {
                              setState(() => _pickedReason = r);
                              if (r != "Other") {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          )),

                      // Animated Text Field
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: _pickedReason == "Other"
                            ? Padding(
                                padding: EdgeInsets.only(top: 8.h * scale, left: 16.w * scale, right: 16.w * scale),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(12 * scale),
                                    border: Border.all(color: const Color(0xFFE0E0E0)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12.w * scale),
                                  child: TextField(
                                    controller: _otherReasonController,
                                    maxLines: 3,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Please specify reason...",
                                      hintStyle: TextStyle(
                                        fontSize: 13.sp * scale, 
                                        color: Colors.grey,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 13.sp * scale, 
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Reduced bottom spacing since button is no longer floating over
                      SizedBox(height: 20.h * scale),
                    ],
                  ),
                ),
              ),

              // 4. Button is now a sibling at the bottom (Not floating over content)
              // This ensures it sits ON TOP of the keyboard, pushing the scrollview up.
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, 10.h * scale, hPad, 10.h * scale),
                child: Obx(() {
                  final loading = bookingController.isRescheduling.value;
                  final enabled = _canSubmit && !loading;
                  return SizedBox(
                    height: 45.h * scale,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: enabled ? _submitWithReason : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: enabled ? const Color(0xFFE47830) : const Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10 * scale)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        loading ? "Rescheduling..." : "Confirm Reschedule",
                        style: TextStyle(
                          color: enabled ? Colors.white : const Color(0xFF9E9E9E),
                          fontSize: 15.sp * scale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Compact cards and tiles (Unchanged)
class _InfoCardCompact extends StatelessWidget {
  final double scale;
  final String address;
  final String scheduled;
  final String saathiText;
  final VoidCallback onEditAddress;
  final VoidCallback onEditDateAndTime;
  final VoidCallback onEditSaathi;

  const _InfoCardCompact({
    required this.scale,
    required this.address,
    required this.scheduled,
    required this.saathiText,
    required this.onEditAddress,
    required this.onEditDateAndTime,
    required this.onEditSaathi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18 * scale),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6 * scale, offset: Offset(0, 2 * scale))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(scale: scale, icon: 'assets/icons/home.svg', title: 'Home', value: address, onEdit: onEditAddress),
          SizedBox(height: 12.h * scale),
          _row(scale: scale, icon: 'assets/icons/calendar.svg', title: 'Scheduled', value: scheduled, onEdit: onEditDateAndTime),
          SizedBox(height: 12.h * scale),
          _row(scale: scale, icon: 'assets/icons/chayansathi.svg', title: 'Chayan Saathi', value: saathiText, onEdit: onEditSaathi),
        ],
      ),
    );
  }

  Widget _row({required double scale, required String icon, required String title, required String value, required VoidCallback onEdit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          child: SvgPicture.asset(icon, width: 18.w * scale, height: 18.h * scale),
        ),
        SizedBox(width: 8.w * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp * scale, color: Colors.black)),
              SizedBox(height: 2.h * scale),
              Text(value, style: TextStyle(fontSize: 13.sp * scale, color: Colors.black)),
            ],
          ),
        ),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(6 * scale),
          child: Padding(
            padding: EdgeInsets.all(2.w * scale),
            child: Icon(Icons.edit, size: 16 * scale, color: const Color(0xFFE47830)),
          ),
        ),
      ],
    );
  }
}


class _ReasonTileCompact extends StatelessWidget {
  final double scale;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ReasonTileCompact({required this.scale, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      minLeadingWidth: 0,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 6.w * scale,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        size: 18 * scale,
        color: selected ? const Color(0xFFE47830) : const Color(0xFFBDBDBD),
      ),
      title: Text(text, style: TextStyle(fontSize: 13.sp * scale, color: Colors.black)),
    );
  }
}