import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// --- IMPORTS ---
// Adjust these paths to match your project structure exactly
import '../../../controllers/cart_controller.dart';
import '../../../utils/test_extensions.dart';
import '../../../models/category_models.dart'; 
import '../../../models/service_models.dart'; 
import '../../../views/login/widgets/legal_modal.dart';
import '../../../views/login/widgets/legal_content.dart';
import '../../../models/coupon_models.dart';
import '../../../controllers/coupon_controller.dart';

// --- ENUMS & MODELS ---

enum PaymentMethod { afterService, online }


// --- WIDGETS ---

// 1. Top Details Block
class SummaryTopDetailsBlock extends StatelessWidget {
  final double scale;
  final String address;
  final String timeLabel;
  final Map<String, dynamic>? saathi;
  final VoidCallback onEditAddress;
  final VoidCallback onEditTime;
  final VoidCallback onEditSaathi;

  const SummaryTopDetailsBlock({
    super.key,
    required this.scale,
    required this.address,
    required this.timeLabel,
    required this.saathi,
    required this.onEditAddress,
    required this.onEditTime,
    required this.onEditSaathi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8 * scale,
              offset: Offset(0, 2 * scale))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
              icon: 'assets/icons/home.svg',
              title: 'Home',
              value: address,
              onEdit: onEditAddress,
              scale: scale,
              testId: 'summary_edit_address_btn'),
          SizedBox(height: 14.h * scale),
          _row(
              icon: 'assets/icons/calendar.svg',
              title: 'Scheduled',
              value: timeLabel,
              onEdit: onEditTime,
              scale: scale,
              testId: 'summary_edit_time_btn'),
          SizedBox(height: 14.h * scale),
          _row(
            icon: 'assets/icons/chayansathi.svg',
            title: 'Chayan Saathi',
            value: saathi == null
                ? 'Select Chayan Saathi'
                : "${saathi!['name']}, (${saathi!['jobs'] ?? ''}+ work), ${saathi!['rating'] ?? ''} rating",
            onEdit: onEditSaathi,
            scale: scale,
            testId: 'summary_edit_saathi_btn',
          ),
        ],
      ),
    );
  }

  Widget _row({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
    required double scale,
    required String testId,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon,
            width: 22 * scale, height: 22 * scale, color: Colors.black),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp * scale,
                        color: Colors.black)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp * scale,
                        color: Colors.black)),
              ]),
        ),
        InkWell(
                onTap: onEdit,
                child: Icon(Icons.edit,
                    size: 18 * scale, color: const Color(0xFFE47830)))
            .withId(testId),
      ],
    );
  }
}

// 2. Payment Method Block
class SummaryPaymentMethodBlock extends StatelessWidget {
  final double scale;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?> onChanged;

  const SummaryPaymentMethodBlock({
    super.key,
    required this.scale,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8 * scale,
              offset: Offset(0, 2 * scale)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 16.sp * scale)),
          SizedBox(height: 8.h * scale),
          Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.afterService,
                groupValue: groupValue,
                activeColor: const Color(0xFFE47830),
                onChanged: onChanged,
              ),
              const Text('Pay after service'),
            ],
          ).withId('payment_option_cash'),
          Row(
            children: [
              Radio<PaymentMethod>(
                value: PaymentMethod.online,
                groupValue: groupValue,
                activeColor: const Color(0xFFE47830),
                onChanged: onChanged,
              ),
              const Text('Pay Online Now'),
            ],
          ).withId('payment_option_online'),
        ],
      ),
    );
  }
}

// 3. Selected Services List & Item
class SummarySelectedServicesBlock extends StatelessWidget {
  final List<CartItem> items;
  final double scale;
  final bool isLocked;
  final bool isLoading;
  final Function(String id, bool increment) onUpdateQty;

  const SummarySelectedServicesBlock({
    super.key,
    required this.items,
    required this.scale,
    required this.onUpdateQty,
    this.isLocked = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
          color: const Color(0xFFE5E9FF),
          borderRadius: BorderRadius.circular(20 * scale)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Selected Services (${items.fold<int>(0, (p, e) => p + e.quantity)} items)',
              style: TextStyle(
                  fontSize: 16.sp * scale, fontWeight: FontWeight.w700)),
          SizedBox(height: 12.h * scale),
          ...items
              .map((item) => _SummaryServiceItem(
                    cartItem: item,
                    scale: scale,
                    showControls: !isLocked, // LOGIC: If locked, controls are false.
                    isLoading: isLoading,
                    onUpdateQty: onUpdateQty,
                  ))
              ,
        ],
      ),
    );
  }
}

class _SummaryServiceItem extends StatelessWidget {
  final CartItem cartItem;
  final double scale;
  final bool showControls;
  final bool isLoading;
  final Function(String id, bool increment) onUpdateQty;

  const _SummaryServiceItem({
    required this.cartItem,
    required this.scale,
    required this.showControls,
    required this.isLoading,
    required this.onUpdateQty,
  });

  @override
  Widget build(BuildContext context) {
    final totalItemPrice = cartItem.price * cartItem.quantity;
    final bool isMaxLimit = cartItem.quantity >= 30;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- IMAGE BLOCK ---
          ClipRRect(
            borderRadius: BorderRadius.circular(12 * scale),
            child: Image.network(
              cartItem.image,
              width: 60.w * scale,
              height: 60.h * scale,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60.w * scale,
                height: 60.h * scale,
                color: Colors.grey[300],
                child: Icon(Icons.image, color: Colors.grey, size: 30 * scale),
              ),
            ),
          ),
          SizedBox(width: 12.w * scale),

          // --- DETAILS BLOCK ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.name,
                            style: TextStyle(
                              fontSize: 14.sp * scale,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h * scale),

                          if (!showControls) ...[
                            // LOCKED STATE
                            Text(
                              'Quantity: ${cartItem.quantity} × ₹${cartItem.price.toInt()}',
                              style: TextStyle(
                                  fontSize: 12.sp * scale,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500),
                            ),
                          ] else ...[
                            // EDITABLE STATE
                            Container(
                              width: 90.w * scale,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w * scale, vertical: 2.h * scale),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6 * scale),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Decrement
                                  InkWell(
                                    onTap: isLoading
                                        ? null
                                        : () => onUpdateQty(cartItem.id, false),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0 * scale),
                                      child: Icon(Icons.remove,
                                          size: 16 * scale, color: Colors.black),
                                    ),
                                  ).withId('summary_minus_${cartItem.id}'),
                                  // Quantity
                                  Text(
                                    '${cartItem.quantity}',
                                    style: TextStyle(
                                        fontSize: 13.sp * scale,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFE47830)),
                                  ),
                                  // Increment
                                  InkWell(
                                    onTap: (isLoading || isMaxLimit)
                                        ? null
                                        : () => onUpdateQty(cartItem.id, true),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0 * scale),
                                      child: Icon(
                                        Icons.add,
                                        size: 16 * scale,
                                        color: isMaxLimit
                                            ? Colors.grey[400]
                                            : const Color(0xFFE47830),
                                      ),
                                    ),
                                  ).withId('summary_plus_${cartItem.id}'),
                                ],
                              ),
                            ),
                          ],
                          
                          // Rating & Duration
                          if (cartItem.rating.isNotEmpty &&
                              cartItem.duration.isNotEmpty) ...[
                            SizedBox(height: 4.h * scale),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/star.svg',
                                    width: 12.w, height: 12.h, color: Colors.black),
                                SizedBox(width: 2.w * scale),
                                Text(
                                  '${cartItem.rating} | ${cartItem.duration}',
                                  style: TextStyle(
                                      fontSize: 11.sp * scale,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w * scale),
                    // Price Code
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${totalItemPrice.toInt()}',
                          style: TextStyle(
                              fontSize: 16.sp * scale,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE47830)),
                        ),
                        if (cartItem.hasDiscount) ...[
                          SizedBox(height: 2.h * scale),
                          Text(
                            '₹${(cartItem.originalPrice * cartItem.quantity).toInt()}',
                            style: TextStyle(
                                fontSize: 12.sp * scale,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (cartItem.description.isNotEmpty) ...[
                  SizedBox(height: 8.h * scale),
                  SummaryBulletText(cartItem.description, scale: scale),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Empty Services Block
class SummaryEmptyServicesBlock extends StatelessWidget {
  final double scale;
  const SummaryEmptyServicesBlock({super.key, required this.scale});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.r * scale),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20 * scale)),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 64 * scale, color: Colors.grey),
            SizedBox(height: 16.h * scale),
            Text('No services selected from this page',
                style: TextStyle(
                    fontSize: 16.sp * scale,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600])),
            SizedBox(height: 8.h * scale),
            Text('Go back and select services to proceed',
                style: TextStyle(fontSize: 14.sp * scale, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

// 5. Coupons Row
// 5. Coupons Row ✅ UPDATED FOR API MODEL
// 5. Coupons Row ✅ UPDATED FOR REMOVE OPTION
class SummaryCouponsRow extends StatelessWidget {
  final double scale;
  final VoidCallback onTap;
  final VoidCallback onRemove; // ✅ Add this
  final Coupon? selectedCoupon;
  final double discountAmount;

  const SummaryCouponsRow({super.key, 
    required this.scale,
    required this.onTap,
    required this.onRemove, // ✅ Added
    this.selectedCoupon,
    this.discountAmount = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8 * scale,
              offset: Offset(0, 2 * scale)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Info & Tap Area
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Row(children: [
                Icon(Icons.local_offer_outlined,
                    size: 20 * scale,
                    color: selectedCoupon != null ? Colors.green : Colors.black),
                SizedBox(width: 8.w * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coupons and offers',
                        style: TextStyle(
                            fontSize: 14.sp * scale, fontWeight: FontWeight.w600),
                      ),
                      if (selectedCoupon != null)
                        Text(
                          '${selectedCoupon!.couponCode} applied',
                          style: TextStyle(
                              fontSize: 12.sp * scale,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        )
                    ],
                  ),
                ),
              ]),
            ),
          ),
          
          // Right: Action Area (Price or Offers text)
          Row(
            children: [
              if (selectedCoupon != null) ...[
                if (discountAmount > 0)
                  Text('-₹${discountAmount.toInt()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                          fontSize: 14.sp * scale))
                else
                  Text('Min order ₹${selectedCoupon!.minPurchaseAmount.toInt()}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                          fontSize: 12.sp * scale)),
                
                // ✅ THE REMOVE BUTTON
                SizedBox(width: 10.w * scale),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.cancel, color: Colors.red[300], size: 20 * scale),
                  onPressed: onRemove,
                ),
              ] else ...[
                InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Text('Offers',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFA9441))),
                      SizedBox(width: 4.w * scale),
                      Icon(Icons.chevron_right,
                          color: const Color(0xFFFA9441), size: 18 * scale)
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ).withId('summary_open_coupon_btn');
  }
}
// 6. Payment Summary Block
class SummaryPaymentDetailsBlock extends StatelessWidget {
  final double scale;
  final int grandTotal;
  final double feeRate;
  final double gstOnFeeRate;
  final bool showSavingsTag;
  final double discountAmount;

  const SummaryPaymentDetailsBlock({
    super.key,
    required this.scale,
    required this.grandTotal,
    this.feeRate = 0.20,
    this.gstOnFeeRate = 0.18,
    this.showSavingsTag = false,
    this.discountAmount = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final int booking = grandTotal;
    final int platformFee = (booking * feeRate).round();
    final int perService = (booking * (1 - feeRate)).round();
    final int gst = (platformFee * gstOnFeeRate).round();

    final int subTotal = perService + platformFee + gst;
    final int total = (subTotal - discountAmount).toInt() > 0
        ? (subTotal - discountAmount).toInt()
        : 0;

    return Container(
      padding: EdgeInsets.all(16.r * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10 * scale,
            offset: Offset(0, 2 * scale),
          )
        ],
      ),
     child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Payment Summary',
      style: TextStyle(
        fontSize: 16.sp * scale,
        fontWeight: FontWeight.w700,
      ),
    ),

    SizedBox(height: 12.h * scale),

    SummaryPriceRow(
      title: 'Booking Price',
      amount: '₹${booking.toString()}',
      scale: scale,
    ),

    SummaryPriceRow(
      title: 'Taxes & Fees',
      amount: '₹${gst.toString()}',
      scale: scale,
      color: Colors.black87,
    ),

    if (discountAmount > 0)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h * scale),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coupon Discount',
              style: TextStyle(
                fontSize: 14.sp * scale,
                color: Colors.green,
              ),
            ),
            Text(
              '-₹${discountAmount.toInt()}',
              style: TextStyle(
                fontSize: 14.sp * scale,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

    Divider(height: 20.h * scale),

    SummaryPriceRow(
      title: 'Total',
      amount: '₹$total',
      isBold: true,
      scale: scale,
    ),
  ],
)
    );
  }
}

// Helper Widgets
class SummaryBulletText extends StatelessWidget {
  final String text;
  final double scale;
  const SummaryBulletText(this.text, {super.key, this.scale = 1});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h * scale),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 6.r * scale, top: 4.r * scale),
            child: CircleAvatar(
                radius: 2 * scale, backgroundColor: const Color(0xFF757575)),
          ),
          Flexible(
              child: Text(text,
                  style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 12.sp * scale))),
        ],
      ),
    );
  }
}

class SummaryPriceRow extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final bool isBold;
  final double scale;

  const SummaryPriceRow({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14.sp * scale,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          Text(amount,
              style: TextStyle(
                  fontSize: 14.sp * scale,
                  color: color ?? Colors.black,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}

// 7. Coupons Bottom Sheet
class CouponsBottomSheet extends StatefulWidget {
  final double scale;
  final Function(Coupon) onApply;
  final VoidCallback onRemove;
  final Coupon? selectedCoupon;
  final double orderAmount;

  const CouponsBottomSheet({
    super.key,
    required this.scale,
    required this.onApply,
    required this.onRemove,
    this.selectedCoupon,
    required this.orderAmount,
  });

  @override
  State<CouponsBottomSheet> createState() => _CouponsBottomSheetState();
}

class _CouponsBottomSheetState extends State<CouponsBottomSheet> {
  final TextEditingController _codeController = TextEditingController();
  final CouponController couponController = Get.find<CouponController>();

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20 * scale)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w * scale, vertical: 16.h * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coupons & Offers',
                    style: TextStyle(fontSize: 18.sp * scale, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close, size: 24 * scale),
                  onPressed: () => Navigator.pop(context),
                ).withId('coupon_sheet_close_btn'),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          Expanded(
            child: Obx(() {
              if (couponController.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFE47830)));
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w * scale, vertical: 16.h * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code Input
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w * scale),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _codeController,
                              onChanged: (val) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Enter Coupon Code',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp * scale),
                                border: InputBorder.none,
                              ),
                            ).withId('coupon_sheet_input'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final inputCode = _codeController.text.trim();
                              if (inputCode.isEmpty) return;
                              
                              final found = couponController.coupons.firstWhereOrNull(
                                (c) => c.couponCode.toLowerCase() == inputCode.toLowerCase()
                              );

                              if (found != null) {
                                await widget.onApply(found);
                              } else {
                                Get.snackbar('Invalid', 'Coupon code not found', 
                                    backgroundColor: Colors.red.shade50, colorText: Colors.red.shade900);
                              }
                            },
                            child: Text('Apply',
                              style: TextStyle(
                                  color: _codeController.text.isNotEmpty ? const Color(0xFFE47830) : Colors.grey[400],
                                  fontWeight: FontWeight.w600, fontSize: 14.sp * scale)),
                          ).withId('coupon_sheet_apply_btn'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h * scale),
                    
                    // Conditionally show "Available Offers" title only if list isn't empty
                    if (couponController.coupons.isNotEmpty) ...[
                      Text('Available Offers',
                          style: TextStyle(fontSize: 16.sp * scale, fontWeight: FontWeight.w600)),
                      SizedBox(height: 16.h * scale),
                      ...couponController.coupons
                          .map((coupon) => _buildCouponItem(coupon, scale))
                          ,
                    ] else
                      // ✅ BEAUTIFUL EMPTY STATE
                      _buildEmptyState(scale),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double scale) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h * scale),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Styled Icon Container
            Container(
              padding: EdgeInsets.all(20.r * scale),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                size: 60 * scale,
                color: const Color(0xFFE47830).withOpacity(0.8),
              ),
            ),
            SizedBox(height: 20.h * scale),
            Text(
              'No Offers Right Now',
              style: TextStyle(
                fontSize: 18.sp * scale,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w * scale),
              child: Text(
                'We couldn’t find any coupons for this category. Check back later for new deals!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp * scale,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildCouponItem(Coupon coupon, double scale) {
  // Check if this specific coupon is the one currently selected in the sheet
  final bool isSelected = widget.selectedCoupon?.id == coupon.id;
  
  // 1. Check Eligibility against the current order amount
  final bool isEligible = widget.orderAmount >= coupon.minPurchaseAmount;

  return InkWell(
    onTap: () {
      // 2. Block tap if ineligible and show why
      if (!isEligible) {
        Get.snackbar(
          'Not Eligible',
          'Add items worth ₹${(coupon.minPurchaseAmount - widget.orderAmount).toInt()} more',
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // 3. Toggle Logic: If already selected, remove it. Otherwise, apply it.
      if (!isSelected) {
        widget.onApply(coupon);
        // Note: We don't pop here because the controller's applyCoupon 
        // method handles the validation and closing of the sheet.
      } else {
        widget.onRemove();
        Navigator.pop(context);
      }
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 24.h * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 40.w * scale,
            height: 40.h * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8 * scale),
            ),
            child: const Center(
              child: Icon(
                Icons.account_balance_wallet,
                color: Color(0xFFFA9441), // Standardized orange icon color
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 12.w * scale),
          
          // Coupon Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.couponCode, // ✅ API field: couponCode
                  style: TextStyle(
                    fontSize: 15.sp * scale, 
                    fontWeight: FontWeight.w600,
                    color: isEligible ? Colors.black : Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h * scale),
                Text(
                  coupon.description, // ✅ Computed property from model
                  style: TextStyle(
                    fontSize: 13.sp * scale, 
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h * scale),
                
                // 3. T&C Link Logic
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const LegalModal(
                        title: LegalContent.termsTitle,
                        lastUpdated: LegalContent.termsUpdate,
                        content: LegalContent.termsText,
                      ),
                    );
                  },
                  child: Text(
                    'View T&C',
                    style: TextStyle(
                      fontSize: 12.sp * scale,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 4. Apply/Remove Button UI
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 12.w * scale, vertical: 6.h * scale),
            decoration: BoxDecoration(
              border: Border.all(
                  color: !isEligible
                      ? Colors.grey.shade300
                      : (isSelected ? Colors.red : const Color(0xFFE47830))),
              borderRadius: BorderRadius.circular(20 * scale),
            ),
            child: Text(
              isSelected ? 'REMOVE' : 'APPLY',
              style: TextStyle(
                color: !isEligible
                    ? Colors.grey.shade400
                    : (isSelected ? Colors.red : const Color(0xFFE47830)),
                fontSize: 12.sp * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).withId('coupon_action_${coupon.couponCode}'),
        ],
      ),
    ),
  ).withId('coupon_item_${coupon.couponCode}');
}
}