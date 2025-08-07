import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'showReschedulePopup.dart';

void showScheduleAddressPopup(BuildContext context) {
 showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const _ScheduleAddressSheet(),
      ),
    );
  },
);

}

class _ScheduleAddressSheet extends StatefulWidget {
  const _ScheduleAddressSheet({Key? key}) : super(key: key);

  @override
  State<_ScheduleAddressSheet> createState() => _ScheduleAddressSheetState();
}

class _ScheduleAddressSheetState extends State<_ScheduleAddressSheet> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330.h, // Adjusted height to match screenshot
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text('Select address',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 8.h),

            /// Add new address (below title)
            GestureDetector(
              onTap: () {
                // Add address logic here
              },
              child: Row(
                children:  [
                  Icon(Icons.add, color: Color(0xFFFF7900), size: 18),
                  SizedBox(width: 4.w),
                  Text(
                    'Add new address',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7900),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            Divider(height: 1.h),
            SizedBox(height: 12.h),

            /// Address Card
            GestureDetector(
              onTap: () {
                setState(() => isSelected = true);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isSelected,
                    activeColor: Colors.black,
                    onChanged: (_) {
                      setState(() => isSelected = true);
                    },
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/homy.svg',
                              width: 20.w,
                              height: 20.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6.w),
                            Text('Home',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text('Plot no.209, Kavuri Hills, Madhapur, Telangana 500033',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text('Ph: +91234567890',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Proceed Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isSelected
                    ? () {
                        Navigator.pop(context);
                        showReschedulePopup(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? const Color(0xFFFF7900) : const Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}