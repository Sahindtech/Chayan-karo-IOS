import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

Future<String?> showReschedulePopup(BuildContext context, {String? initialSlot}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
    ),
    builder: (context) => _RescheduleContent(initialSlot: initialSlot),
  );
}

class _RescheduleContent extends StatefulWidget {
  final String? initialSlot;
  const _RescheduleContent({super.key, this.initialSlot});

  @override
  State<_RescheduleContent> createState() => _RescheduleContentState();
}

class _RescheduleContentState extends State<_RescheduleContent> {
  // Selected day number like "05"
  String? selectedDate;

  // Four dates only: Today + next 3
  late List<Map<String, String>> dates;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    dates = List.generate(4, (index) {
      final date = now.add(Duration(days: index));
      String dayLabel;
      if (index == 0) {
        dayLabel = 'Today';
      } else if (index == 1) {
        dayLabel = 'Tomorrow';
      } else {
        dayLabel = DateFormat('EEE').format(date); // e.g., "Thu"
      }
      return {
        'day': dayLabel,
        'date': DateFormat('dd').format(date),             // "05"
        'fullDate': DateFormat('yyyy-MM-dd').format(date), // "2025-11-05"
      };
    });

    // Try to preselect from initialSlot if a day number is present
    if (widget.initialSlot != null && widget.initialSlot!.isNotEmpty) {
      final match = RegExp(r'\b(\d{2})\b').firstMatch(widget.initialSlot!);
      if (match != null) selectedDate = match.group(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        final Widget content = Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 24.h * scaleFactor,
            vertical: 24.h * scaleFactor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.h * scaleFactor)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select date',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 18.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h * scaleFactor),

              // Keep legacy chip visuals, but lay out in a responsive grid to avoid overflow
              LayoutBuilder(
                builder: (context, c) {
                  final bool wide = c.maxWidth >= 600;
                  final int crossAxisCount = wide ? 4 : 2;
                  final double s = wide ? c.maxWidth / 411 : scaleFactor;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12.w * s,
                      mainAxisSpacing: 12.h * s,
                      childAspectRatio: 100 / 70, // matches chip size (width 100, height 70)
                    ),
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final d = dates[index];
                      final isSelected = selectedDate == d['date'];
                      return GestureDetector(
                        onTap: () {
                          // Return only the day number for backward compatibility.
                          Navigator.pop(context, d['date']);
                        },
                        child: _buildDateChip(d['day']!, d['date']!, isSelected, s),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 12.h * scaleFactor),
            ],
          ),
        );

        // Only chips; tap returns immediately. No time slots, no bottom CTA.
        return SafeArea(bottom: true, top: false, child: content);
      },
    );
  }

  Widget _buildDateChip(String day, String date, bool isSelected, [double scaleFactor = 1.0]) {
    return Container(
      width: 100.w * scaleFactor,
      height: 70.h * scaleFactor,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF2F2FF) : Colors.white,
        borderRadius: BorderRadius.circular(12 * scaleFactor),
        border: Border.all(
          color: isSelected ? const Color(0xFFE47830) : const Color(0xFFE0E0E0),
          width: scaleFactor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 13.sp * scaleFactor,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFFE47830) : const Color(0xFF7D7F88),
            ),
          ),
          SizedBox(height: 4.h * scaleFactor),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 18.sp * scaleFactor,
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xFFE47830) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
