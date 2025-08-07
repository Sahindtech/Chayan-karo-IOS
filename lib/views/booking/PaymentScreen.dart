import 'package:chayankaro/views/booking/PaymentSuccess.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    padding: EdgeInsets.only(bottom: 100.r),
                    children: [
                      SizedBox(height: 16.h),
                       Text('UPI', style: _sectionTitleStyle),
                      _paymentTile('Paytm UPI', 'assets/icons/paytm.svg'),
                      _paymentTile('PhonePe', 'assets/icons/phonepe.svg'),
                      _paymentTile('GPay', 'assets/icons/gpay.svg'),
                      SizedBox(height: 24.h),
                     Text('Cards', style: _sectionTitleStyle),
                      _cardTile(),
                      SizedBox(height: 24.h),
                     Text('Cash', style: _sectionTitleStyle),
                      _paymentTile('Cash', 'assets/icons/cash.svg'),
                      SizedBox(height: 24.h),
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
                  height: 47.h,
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
                      fontSize: 16.sp,
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
      padding: EdgeInsets.only(top: 16.r),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF161616), width: 1.w),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE47830),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Text(
            title,
            style: TextStyle(fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xFF161616),
            ),
          ),
          const Spacer(),
          Container(
  width: 35.w,
  height: 35.h,
  decoration: BoxDecoration(shape: BoxShape.circle,
    color: Colors.white, // optional background
  ),
  child: Padding(
    padding: EdgeInsets.all(6.r), // optional for spacing inside circle
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
      padding: EdgeInsets.only(top: 16.r),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF161616), width: 1.w),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE47830),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 16.w),

          // Mastercard icon (left of card number)
          Container(
  width: 32.w,
  height: 32.h,
  margin: EdgeInsets.only(right: 10.r),
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

          Text('************2575',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Color(0xFF161616),
            ),
          ),
          const Spacer(),

          // card.png on the right
          Container(
  width: 32.w,
  height: 32.h,
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

final _sectionTitleStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w700,
  fontFamily: 'SF Pro Display',
  color: Color(0xFF161616),
);