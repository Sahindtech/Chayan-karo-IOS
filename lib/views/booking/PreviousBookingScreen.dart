import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';

class PreviousBookingScreen extends StatelessWidget {
  const PreviousBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChayanHeader(
                title: 'Previous Booking',
                onBackTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '19th Nov, Saturday',
                  style: TextStyle(
                    color: Color(0xFF161616),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _bookingCard(
                imageAsset: 'assets/ac_services.png',
                title: 'AC Service',
                duration: '1 hrs',
                details: 'Includes general cleaning',
              ),
              const SizedBox(height: 16),
              _bookingCard(
                imageAsset: 'assets/ac_installation.jpg',
                title: 'AC Installation',
                duration: '30 mins',
                details: 'Includes lorem',
              ),
              const SizedBox(height: 24),
              _billingSection(),
              const SizedBox(height: 24),
              _addressSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingCard({
    required String imageAsset,
    required String title,
    required String duration,
    required String details,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 132,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF161616),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _bulletDot(),
                        const SizedBox(width: 6),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _bulletDot(),
                        const SizedBox(width: 6),
                        Text(
                          details,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const ShapeDecoration(
        color: Color(0xFF757575),
        shape: OvalBorder(),
      ),
    );
  }

  Widget _billingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Billing Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
            _billingRow('Item Total', '₹699'),
            _billingRow('Item Discount', '-₹50', color: Color(0xFF52B46B)),
            _billingRow('Service Fee', '₹50'),
            _billingRow('Grand Total', '₹749', isBold: true),
            Container(
              height: 47,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment mode',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
                  Text('Paytm UPI',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: color ?? const Color(0xFF161616),
              )),
        ],
      ),
    );
  }

  Widget _addressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/icons/home.png', width: 20, height: 20,  color: Colors.black,),
                const SizedBox(width: 8),
                const Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033, Ph: +91234567890',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF757575),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset('assets/icons/calendar.png', width: 18, height: 18,  color: Colors.black,),
                const SizedBox(width: 6),
                const Text('Sat, Apr 09 - 07:30 PM',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                      fontFamily: 'SF Pro Display',
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset('assets/icons/user.png', width: 20, height: 20,  color: Colors.black,),
                const SizedBox(width: 6),
                const Text('Sumit Gupta, (180+ work), 4.5 rating',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                      fontFamily: 'SF Pro Display',
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
