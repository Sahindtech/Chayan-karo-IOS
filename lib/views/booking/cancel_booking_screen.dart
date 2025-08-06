import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';
import 'BookingCancelledScreen.dart';
import 'showReschedulePopup.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  final List<String> reasons = [
    'A reason here for cancellation of booking',
    'A reason here for cancellation of booking, a reason here for cancellation of booking',
    'A reason here for cancellation of booking',
    'A reason here for cancellation of booking, a reason here for cancellation of booking',
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChayanHeader(title: 'Cancel Booking', onBackTap: () => Navigator.pop(context)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Booking Card
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 132,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFF3F3F3), width: 2),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                'assets/cleanup.webp',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Diamond Facial',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter',
                                          color: Color(0xFF161616))),
                                  SizedBox(height: 8),
                                  Row(children: [_dot(), SizedBox(width: 8), Text('2 hrs', style: _subTextStyle())]),
                                  SizedBox(height: 6),
                                  Row(children: [_dot(), SizedBox(width: 8), Text('Includes dummy info', style: _subTextStyle())]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Reason Title
                    Container(
                      width: double.infinity,
                      color: Color(0xFFF3F3F3),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        'REASON FOR CANCELLATION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),

                    // Reason options
                    ...List.generate(reasons.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF757575)),
                                ),
                                child: selectedIndex == index
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE47830),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reasons[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: Color(0xFF161616),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Text Area
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Container(
                        height: 150,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Describe a problem / comment',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFABABAB),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cancel Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: selectedIndex != null ? () => _showBottomPopup(context) : null,
                child: Container(
                  height: 47,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: selectedIndex != null ? Color(0xFFE47830) : Color(0xFFD7D7D7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Cancel Now',
                    style: TextStyle(
                      color: selectedIndex != null ? Colors.white : Color(0xFF858585),
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  TextStyle _subTextStyle() {
    return TextStyle(fontSize: 14, fontFamily: 'Inter', color: Color(0xFF757575));
  }

  Widget _dot() {
    return Container(width: 4, height: 4, decoration: BoxDecoration(color: Color(0xFF757575), shape: BoxShape.circle));
  }

 void _showBottomPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea( // ✅ Ensures proper visibility of buttons
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/icons/sad.svg', width: 40, height: 40),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure about cancelling   this booking ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF161616),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You can always reschedule it',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF717171),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BookingCancelledScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancel anyway',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // close current popup
                          showReschedulePopup(context); // show reschedule popup
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE47830),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Reschedule',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

}
