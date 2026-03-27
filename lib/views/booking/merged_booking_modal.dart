import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Returns a DateTime containing BOTH the selected date and the selected time.
Future<DateTime?> showMergedBookingModal(
  BuildContext context, {
  required String initialDateStr, // "yyyy-MM-dd" or "dd"
  TimeOfDay? initialTime,
  String? minTimeConstraint,
  DateTime? blockedSlot, // <--- ADD THIS LINE
  int currentBookingDuration = 0, // ✅ Add this
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => _MergedBookingSheet(
      initialDateStr: initialDateStr,
      initialTime: initialTime,
      minTimeConstraint: minTimeConstraint,
      blockedSlot: blockedSlot, // <--- ADD THIS LINE
      currentBookingDuration: currentBookingDuration, // ✅ Pass it here
    ),
  );
}

class _MergedBookingSheet extends StatefulWidget {
  final String initialDateStr;
  final TimeOfDay? initialTime;
  final String? minTimeConstraint;
  final DateTime? blockedSlot; // <--- ADD THIS LINE
  final int currentBookingDuration; // ✅ Add this

  const _MergedBookingSheet({
    super.key,
    required this.initialDateStr,
    this.initialTime,
    this.minTimeConstraint,
    this.blockedSlot, // <--- ADD THIS LINE
    this.currentBookingDuration = 0, // ✅ Add this with default value
  });

  @override
  State<_MergedBookingSheet> createState() => _MergedBookingSheetState();
}

class _MergedBookingSheetState extends State<_MergedBookingSheet> {
  late List<DateTime> _availableDates;
  late DateTime _selectedDate;
  
  late List<TimeOfDay> _allSlots;
  TimeOfDay? _selectedTime;

  // Configuration constant
  final int _bufferMinutes = 45;

  @override
  void initState() {
    super.initState();
    _initTimeSlots(); // Init slots first to help date filtering
    _initDates(); // Filter dates based on slot availability
    
    // Set initial selection if available
    _selectedTime = widget.initialTime;
  }

  void _initTimeSlots() {
    // Generate slots from 8:30 AM to 7:00 PM
    _allSlots = _generateSlots(
      start: const TimeOfDay(hour: 8, minute: 30),
      end: const TimeOfDay(hour: 19, minute: 0),
      stepMinutes: 30,
    );
  }

  void _initDates() {
    final now = DateTime.now();
    List<DateTime> rawDates = List.generate(4, (index) => now.add(Duration(days: index)));
    _availableDates = [];

    // Filter out dates that have NO slots available (e.g., if it's 8 PM today)
    for (var date in rawDates) {
      if (_hasSlotsForDate(date)) {
        _availableDates.add(date);
      }
    }

    // Parse initial date string to set selection
    DateTime? parsedInitial;
    try {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(widget.initialDateStr)) {
         parsedInitial = DateFormat('yyyy-MM-dd').parse(widget.initialDateStr);
      }
    } catch (_) {}

    // Logic to select a valid date
    if (parsedInitial != null && _isDateAvailable(parsedInitial)) {
       _selectedDate = parsedInitial;
    } else {
       // Default to the first available date (Tomorrow if Today is finished)
       _selectedDate = _availableDates.isNotEmpty ? _availableDates[0] : now.add(const Duration(days: 1));
    }
    
    // Normalize
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
  }

  bool _isDateAvailable(DateTime date) {
    return _availableDates.any((d) => 
      d.year == date.year && d.month == date.month && d.day == date.day);
  }

  /// Check if a specific date has at least one slot ahead of (Now + 45 mins)
  bool _hasSlotsForDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    
    if (!isToday) return true; // Future dates assumed to have slots

    final bufferTime = now.add(Duration(minutes: _bufferMinutes));
    final bufferMinutesOfDay = bufferTime.hour * 60 + bufferTime.minute;

    // Check if any slot in _allSlots is after the buffer
    return _allSlots.any((slot) {
      final slotMinutes = slot.hour * 60 + slot.minute;
      return slotMinutes > bufferMinutesOfDay;
    });
  }

  List<TimeOfDay> _generateSlots({
    required TimeOfDay start,
    required TimeOfDay end,
    required int stepMinutes,
  }) {
    final List<TimeOfDay> list = [];
    TimeOfDay cur = start;
    int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
    
    while (toMinutes(cur) <= toMinutes(end)) {
      list.add(cur);
      final total = cur.hour * 60 + cur.minute + stepMinutes;
      cur = TimeOfDay(hour: total ~/ 60, minute: total % 60);
    }
    return list;
  }

  // Filter slots based on the _selectedDate and 45-min buffer
  List<TimeOfDay> get _visibleSlots {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year && 
                    _selectedDate.month == now.month && 
                    _selectedDate.day == now.day;

    if (!isToday) return _allSlots;

    final bufferTime = now.add(Duration(minutes: _bufferMinutes));
    final bufferMinutesOfDay = bufferTime.hour * 60 + bufferTime.minute;

    return _allSlots.where((t) {
      final slotMinutes = t.hour * 60 + t.minute;
      return slotMinutes > bufferMinutesOfDay; 
    }).toList();
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _selectedTime = null; // Reset time when date changes to ensure validity
    });
  }
// --- ADD THIS HELPER METHOD ---
  bool _isSlotBlocked(TimeOfDay slot) {
    if (widget.blockedSlot == null) return false;

    // Check if the currently selected DATE matches the blocked date
    final bool sameDate = 
        widget.blockedSlot!.year == _selectedDate.year &&
        widget.blockedSlot!.month == _selectedDate.month &&
        widget.blockedSlot!.day == _selectedDate.day;

    if (!sameDate) return false;

    // Check if TIME matches (ignoring seconds)
    return widget.blockedSlot!.hour == slot.hour && widget.blockedSlot!.minute == slot.minute;
  }
  void _onTimeTap(TimeOfDay slot) {
    if (_isSlotBlocked(slot)) {
      Get.snackbar(
        'Current Booking',
        'This is your currently booked slot.',
         snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 3),
      );
      return;
    }
    // Check Provider Constraint Logic
    if (widget.minTimeConstraint != null && widget.minTimeConstraint!.isNotEmpty) {
      final now = DateTime.now();
      final isToday = _selectedDate.year == now.year &&
          _selectedDate.month == now.month &&
          _selectedDate.day == now.day;

      if (isToday) {
        try {
          final parts = widget.minTimeConstraint!.split(':');
          final int constraintTotal = (int.parse(parts[0]) * 60) + int.parse(parts[1]);
          final int selectedTotal = (slot.hour * 60) + slot.minute;

          if (selectedTotal < constraintTotal) {
            Get.snackbar(
              'Slot Unavailable',
              'Provider available after ${_formatTimeString(widget.minTimeConstraint!)} today.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
            return;
          }
        } catch (_) {}
      }
    }

    setState(() {
      _selectedTime = slot;
    });
  }

  String _formatTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      final dt = DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth > 600 ? constraints.maxWidth / 411 : 1.0;
        
        // Use DraggableScrollableSheet or just SingleChildScrollView inside Column with mainAxisSize.min
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w * scale, vertical: 16.h * scale),
          // Removing fixed height so it grows/shrinks.
          // ConstrainedBox ensures it doesn't go full screen if few slots.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // This makes the modal dynamic height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Row(
                children: [
                    Expanded(
                      child: Text('When should the professional arrive?',
                          style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                ],
              ),
              Text('Select date and time together', 
                  style: TextStyle(fontSize: 12.sp * scale, color: Colors.grey)),
              
              SizedBox(height: 20.h * scale),

              // 2. Date Selector (Horizontal)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _availableDates.map((date) {
                    final isSelected = date.year == _selectedDate.year &&
                                       date.month == _selectedDate.month &&
                                       date.day == _selectedDate.day;
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w * scale),
                      child: _DateCard(
                        date: date,
                        isSelected: isSelected,
                        onTap: () => _onDateTap(date),
                        scale: scale,
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 25.h * scale),

              // 3. Time Slots Grid
              Text('Select start time of service', 
                   style: TextStyle(fontSize: 15.sp * scale, fontWeight: FontWeight.w700)),
              SizedBox(height: 10.h * scale),

              // Using Flexible + ListView/GridView with shrinkWrap lets it expand
              Flexible(
                child: SingleChildScrollView(
                  child: _visibleSlots.isEmpty 
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h * scale),
                      child: Center(
                        child: Text("No slots available for this date.", style: TextStyle(color: Colors.grey, fontSize: 14.sp * scale)),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true, // Key for dynamic height
                      physics: const NeverScrollableScrollPhysics(), // Scroll outer container
                      itemCount: _visibleSlots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w * scale,
                        mainAxisSpacing: 10.h * scale,
                        childAspectRatio: 2.5,
                      ),
                      itemBuilder: (ctx, i) {
                        final slot = _visibleSlots[i];
                        final isSelected = _selectedTime == slot;
                        final isBlocked = _isSlotBlocked(slot);
                        return _TimeChip(
                          time: slot, 
                          isSelected: isSelected, 
                          isBlocked: isBlocked, // <--- PASS THIS
                          onTap: () => _onTimeTap(slot),
                          scale: scale,
                        );
                      },
                    ),
                ),
              ),

              // 4. Bottom Button (Safe Area for Gesture Nav)
              SizedBox(height: 20.h * scale),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 0 : 10.h * scale
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h * scale,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedTime == null ? Colors.grey[300] : const Color(0xFFE47830),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r * scale)),
                        elevation: 0,
                      ),
                      onPressed: _selectedTime == null 
                        ? null 
                        : () {
                            // 1. Calculate the end time of the booking
      final int startMinutes = _selectedTime!.hour * 60 + _selectedTime!.minute;
      final int endMinutes = startMinutes + widget.currentBookingDuration;
      
      // 2. Check if it exceeds 7:00 PM (19 * 60 = 1140 minutes)
      const int cutoffMinutes = 20 * 60; 

      if (endMinutes > cutoffMinutes) {
        Get.snackbar(
          'Booking Duration Exceeds', 
          'The total duration exceeds service hours (8 PM). Please select an earlier slot.',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.TOP,
        );
        return; // ⛔ Prevent navigation/closing
      }

      // 3. If valid, merge and return
      final finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      Navigator.pop(context, finalDateTime);
    },
                      child: Text('Proceed to checkout', 
                        style: TextStyle(
                          fontSize: 16.sp * scale, 
                          color: _selectedTime == null ? Colors.grey[600] : Colors.white,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class _DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  final double scale;

  const _DateCard({required this.date, required this.isSelected, required this.onTap, required this.scale});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cardDate = DateTime(date.year, date.month, date.day);
    final diff = cardDate.difference(today).inDays;
    
    String label = DateFormat('EEE').format(date); 
    if (diff == 0) {
      label = 'Today';
    } else if (diff == 1) label = 'Tomorrow';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w * scale,
        padding: EdgeInsets.symmetric(vertical: 12.h * scale),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(10.r * scale),
          border: Border.all(
            color: isSelected ? const Color(0xFFE47830) : Colors.grey[300]!, 
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(label, 
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 12.sp * scale
              )
            ),
            SizedBox(height: 4.h * scale),
            Text(DateFormat('dd').format(date), 
               style: TextStyle(
                 fontWeight: FontWeight.bold, 
                 fontSize: 16.sp * scale,
                 color: Colors.black,
               )
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final TimeOfDay time;
  final bool isSelected;
  final bool isBlocked; // <--- ADD THIS
  final VoidCallback onTap;
  final double scale;

  const _TimeChip({required this.time, required this.isSelected, required this.onTap,this.isBlocked = false, required this.scale});

  @override
  Widget build(BuildContext context) {
    final dt = DateTime(0, 1, 1, time.hour, time.minute);
    final label = DateFormat('hh:mm a').format(dt);
    // --- UPDATE COLORS ---
    final Color bgColor = isBlocked 
        ? Colors.grey[200]! // Gray background if blocked
        : (isSelected ? const Color(0xFFFFF0E3) : Colors.white); // Light orange if selected
    
    final Color borderColor = isBlocked
        ? Colors.transparent 
        : (isSelected ? const Color(0xFFE47830) : Colors.grey[300]!);
        
    final Color textColor = isBlocked
        ? Colors.grey[400]! // Gray text if blocked
        : (isSelected ? const Color(0xFFE47830) : Colors.black);
    // ---------------------

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r * scale),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 13.sp * scale,
            fontWeight: FontWeight.w600,
            decoration: isBlocked ? TextDecoration.lineThrough : null, // Optional strikethrough
            color: textColor
          ),
        ),
      ),
    );
  }
}