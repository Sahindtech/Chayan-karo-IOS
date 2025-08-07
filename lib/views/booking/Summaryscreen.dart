import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/chayan_header.dart';
import 'showReschedulePopup.dart';
import 'showScheduleAddressPopup.dart';


class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFD),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                 ChayanHeader(title: 'Summary', onBackTap: () {  },),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selected Services Card
                        // Selected Services Title + Card (Updated)
Container(
  padding: EdgeInsets.all(16.r),
  decoration: BoxDecoration(
    color: const Color(0xFFE5E9FF),
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Selected Services',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: 12.h),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/facial.webp',
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Expanded(
                      child: Text(
                        'Diamond Facial',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '₹699',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFA9441),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const BulletText('45 mins'),
                const BulletText('For all skin types. Pinacolada mask.'),
                const BulletText('6-step process. Includes 10-min massage'),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
),


                        SizedBox(height: 20.h),

                        // Frequently Added Together
                        Text('Frequently added together',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 240.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              buildAddCard('assets/saloon_manicure.webp', 'Manicure', '₹499'),
                              buildAddCard('assets/saloon_pedicure.webp', 'Pedicure', '₹499'),
                              buildAddCard('assets/saloon_threading.webp', 'Threading', '₹49'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Coupons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Row(
                              children: [
                                Icon(Icons.local_offer_outlined, size: 20),
                                SizedBox(width: 8.w),
                                Text(
                                  'Coupons and offers',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Text(
                              '2 offer  >',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFA9441),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Payment Summary
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment Summary',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              const PriceRow(title: 'Item Total', amount: '₹699'),
                              const PriceRow(title: 'Item Discount', amount: '-₹50', color: Color(0xFF52B46B)),
                              const PriceRow(title: 'Service Fee', amount: '₹50'),
                              Divider(height: 20.h),
                              const PriceRow(title: 'Grand Total', amount: '₹749', isBold: true),
                              SizedBox(height: 12.h),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33FFAD33),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child:  Text(
                                    'Hurray ! You saved ₹50 on final bill',
                                    style: TextStyle(
                                      color: Color(0xFFFA9441),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Buttons
            Positioned(
              bottom: 0.r,
              left: 0.r,
              right: 0.r,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
  children: [
    Expanded(
      child: InkWell(
 onTap: () {
      showScheduleAddressPopup(context);
    },        child: Container(
          height: 47.h,
          decoration: ShapeDecoration(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text('Schedule for later',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
    SizedBox(width: 16.w),
    Expanded(
      child: InkWell(
       onTap: () {
      showReschedulePopup(context); // Call your popup function
    },        child: Container(
          height: 47.h,
          decoration: ShapeDecoration(
            color: Color(0xFFE47830),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text('Request Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
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

  Widget buildAddCard(String asset, String title, String price) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 16.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              asset,
              width: 120.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(price),
          SizedBox(height: 8.h),
          Container(
            width: 120.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE47830),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text('Add',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(right: 6.r, top: 4.r),
          child: CircleAvatar(radius: 2, backgroundColor: Color(0xFF757575)),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Color(0xFF757575), fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final bool isBold;

  const PriceRow({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}