import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';

void showReschedulePopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _RescheduleContent(),
  );
}

class _RescheduleContent extends StatefulWidget {
  @override
  State<_RescheduleContent> createState() => _RescheduleContentState();
}

class _RescheduleContentState extends State<_RescheduleContent> {
  String? selectedDate;
  String? selectedTime;

  final List<Map<String, String>> dates = [
    {'day': 'Sat', 'date': '10'},
    {'day': 'Sun', 'date': '11'},
    {'day': 'Mon', 'date': '12'},
  ];

  final List<String> times = ['06:30 PM', '07:30 PM', '08:30 PM'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
  bottom: true,
  top: false, // don't affect top design
  child: Container(
    width: MediaQuery.of(context).size.width,
    height: 530.h,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select date and time',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text('Your service will take approx. 45 mins',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14.sp,
            color: Color(0xFF7D7F88),
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dates.map((d) {
            bool isSelected = selectedDate == d['date'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = d['date'];
                });
              },
              child: _buildDateChip(d['day']!, d['date']!, isSelected),
            );
          }).toList(),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: times.map((t) {
            bool isSelected = selectedTime == t;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime = t;
                });
              },
              child: _buildTimeChip(t, isSelected),
            );
          }).toList(),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: (selectedDate != null && selectedTime != null)
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChayanSathiScreen(),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedDate != null && selectedTime != null
                  ? const Color(0xFFE47830)
                  : const Color(0xFFEFEFEF),
              foregroundColor: selectedDate != null && selectedTime != null
                  ? Colors.white
                  : const Color(0xFFB3B3B3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Proceed to checkout',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

  }

  Widget _buildDateChip(String day, String date, bool isSelected) {
    return Container(
      width: 80.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFF2F2FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFE47830) : const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 14.sp,
              color: isSelected ? const Color(0xFFE47830) : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFFE47830) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected) {
    return Container(
      width: 100.w,
      height: 48.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFF2F2FF) : Colors.white,
        border: Border.all(
          color: isSelected ? const Color(0xFFE47830) : const Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFFE47830) : Colors.black,
        ),
      ),
    );
  }
}