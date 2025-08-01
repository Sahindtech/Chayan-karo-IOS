import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/chayan_header.dart';
import 'cancel_booking_screen.dart';
import 'showReschedulePopup.dart';

class UpcomingBookingScreen extends StatelessWidget {
  const UpcomingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              ChayanHeader(title: 'Upcoming Booking', onBackTap: () {  },),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Date + Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('22nd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Nov, Tuesday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                          Row(
                            children: [
                              _actionButton('Help', 'assets/icons/help.png', const Color(0xFFE47830)),
                              const SizedBox(width: 8),
                              _actionButton('Emergency', 'assets/icons/emergency.png', const Color(0xFFFF3300)),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Service Cards
                      _bookingCard('assets/facial.png', 'Diamond Facial', '2 hrs', 'Includes lorem ipsum'),
                      const SizedBox(height: 16),
                      _bookingCard('assets/cleanup.png', 'Cleanup', '30 mins', 'Includes lorem'),

                      const SizedBox(height: 20),

                      // Billing Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF3F3F3), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Billing Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 16),
                            _billingRow('Item Total', '₹699'),
                            _billingRow('Item Discount', '-₹50', valueColor: const Color(0xFF52B46B)),
                            _billingRow('Service Fee', '₹50'),
                            const Divider(height: 30),
                            _billingRow('Grand Total', '₹749', isBold: true),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Payment mode', style: TextStyle(fontSize: 14)),
                                  Text('Paytm UPI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Address + Person Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF3F3F3), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow('assets/icons/home.png', 'Home'),
                            const SizedBox(height: 4),
                            const Padding(
                              padding: EdgeInsets.only(left: 32),
                              child: Text(
                                'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033, Ph: +91234567890',
                                style: TextStyle(fontSize: 12, color: Color(0xFF757575), height: 1.5),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _infoRow('assets/icons/calendar.png', 'Sat, Apr 09 - 07:30 PM'),
                            const SizedBox(height: 12),
                            _infoRow('assets/icons/user.png', 'Sumit Gupta, (180+ work), 4.5 rating'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                             onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => CancelBookingScreen()));
                             },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                            onPressed: () => showReschedulePopup(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE47830),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Reschedule', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, String iconPath, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    height: 28,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: Image.asset(iconPath, width: 16, height: 16),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}


  Widget _bookingCard(String imagePath, String title, String duration, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF3F3F3), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(duration, style: const TextStyle(fontSize: 14, color: Color(0xFF757575))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF757575))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _billingRow(String label, String value, {Color valueColor = Colors.black, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400, color: valueColor)),
        ],
      ),
    );
  }

  Widget _infoRow(String iconPath, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: Image.asset(iconPath, width: 20, height: 20),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF757575)))),
    ],
  );
}

}
