import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'showReschedulePopup.dart';

void showScheduleAddressPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const _ScheduleAddressSheet();
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
      height: 330, // Adjusted height to match screenshot
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            const Text(
              'Select address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            /// Add new address (below title)
            GestureDetector(
              onTap: () {
                // Add address logic here
              },
              child: Row(
                children: const [
                  Icon(Icons.add, color: Color(0xFFFF7900), size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Add new address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF7900),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

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
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/homy.svg',
                              width: 20,
                              height: 20,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ph: +91234567890',
                          style: TextStyle(
                            fontSize: 13,
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
              height: 48,
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
                    fontSize: 16,
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
