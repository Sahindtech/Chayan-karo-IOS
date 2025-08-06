import 'package:chayankaro/views/booking/PaymentSuccess.dart';
import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';



class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  void _onSelect(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

@override
Widget build(BuildContext context) {
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xFFFFEEE0), // match ChayanHeader
      statusBarIconBrightness: Brightness.dark,
    ),
    child: Container(
      color: Colors.white, // 🟠 background behind status bar
      child: SafeArea(
        top: false, // 🟠 allow ChayanHeader to extend under status bar
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              ChayanHeader(
                title: 'Payment Option',
                onBackTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      const SizedBox(height: 16),
                      const Text('UPI', style: _sectionTitleStyle),
                      _paymentTile('Paytm UPI', 'assets/icons/paytm.svg'),
                      _paymentTile('PhonePe', 'assets/icons/phonepe.svg'),
                      _paymentTile('GPay', 'assets/icons/gpay.svg'),
                      const SizedBox(height: 24),
                      const Text('Cards', style: _sectionTitleStyle),
                      _cardTile(),
                      const SizedBox(height: 24),
                      const Text('Cash', style: _sectionTitleStyle),
                      _paymentTile('Cash', 'assets/icons/cash.svg'),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 16),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GestureDetector(
                onTap: selectedMethod != null
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
                      )
                    : null,
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    color: selectedMethod != null
                        ? const Color(0xFFE47830)
                        : const Color(0xFFD7D7D7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: selectedMethod != null
                          ? Colors.white
                          : const Color(0xFF858585),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


Widget _paymentTile(String title, String iconPath) {
  final isSelected = selectedMethod == title;
  final isCashIcon = iconPath == 'assets/icons/cash.svg';

  return GestureDetector(
    onTap: () => _onSelect(title),
    child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF161616), width: 1),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE47830),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xFF161616),
            ),
          ),
          const Spacer(),
          Container(
  width: 35,
  height: 35,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white, // optional background
  ),
  child: Padding(
    padding: const EdgeInsets.all(6), // optional for spacing inside circle
    child: SvgPicture.asset(
      iconPath,
      fit: BoxFit.contain,
      color: isCashIcon ? Colors.black : null,
    ),
  ),
)
        ],
      ),
    ),
  );
}

Widget _cardTile() {
  final isSelected = selectedMethod == 'Card';

  return GestureDetector(
    onTap: () => _onSelect('Card'),
    child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF161616), width: 1),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE47830),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // Mastercard icon (left of card number)
          Container(
  width: 32,
  height: 32,
  margin: const EdgeInsets.only(right: 10),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.transparent, // or use a background if needed
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SvgPicture.asset(
      'assets/icons/mastercard.svg',
      fit: BoxFit.contain,
    ),
  ),
),

          const Text(
            '************2575',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xFF161616),
            ),
          ),
          const Spacer(),

          // card.png on the right
          Container(
  width: 32,
  height: 32,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.transparent, // optional if background is needed
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SvgPicture.asset(
      'assets/icons/cc.svg',
      fit: BoxFit.contain,
      color: Colors.black, // equivalent to your colorFilter
    ),
  ),
),
        ],
      ),
    ),
  );
}

}

const _sectionTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  fontFamily: 'SF Pro Display',
  color: Color(0xFF161616),
);
