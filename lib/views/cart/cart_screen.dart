import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../models/service_models.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../booking/Summaryscreen.dart'; // Add this import

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final CartController cartController = Get.find<CartController>();
  final int _selectedIndex = -2;

  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEEE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Container(
            color: const Color(0xFFFFEEE0),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEE0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x26000000),
                            blurRadius: 4 * (isTabletDevice ? scaleFactor : 1.0),
                            offset: Offset(0, 2 * (isTabletDevice ? scaleFactor : 1.0)),
                          )
                        ],
                      ),
                      child: ChayanHeader(
                        title: 'Cart',
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        if (cartController.isCartEmpty) {
                          return _buildEmptyCart(context, scaleFactor);
                        } else {
                          return _buildCartWithItems(context, scaleFactor);
                        }
                      }),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: CustomBottomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: (index) => _onItemTapped(context, index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context, double scaleFactor) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.75.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110.w * scaleFactor,
              height: 110.h * scaleFactor,
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/cart_empty.svg",
                  fit: BoxFit.cover,
                  width: 110.w * scaleFactor,
                  height: 110.h * scaleFactor,
                ),
              ),
            ),
            SizedBox(height: 20.h * scaleFactor),
            Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 20.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.h * scaleFactor),
            Opacity(
              opacity: 0.8,
              child: Text(
                'Lets add some services',
                style: TextStyle(
                  fontSize: 20.sp * scaleFactor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro',
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.h * scaleFactor),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 175.w * scaleFactor,
                height: 45.h * scaleFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                  border: Border.all(
                    color: const Color(0xFFE47830),
                    width: 2.w * scaleFactor,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Explore Services',
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro',
                    color: Color(0xFFE47830),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartWithItems(BuildContext context, double scaleFactor) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final groupedItems = cartController.getItemsGroupedBySource();
            final sourceKeys = groupedItems.keys.toList();
            
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h * scaleFactor),
              itemCount: sourceKeys.length,
              itemBuilder: (context, groupIndex) {
                final sourceTitle = sourceKeys[groupIndex];
                final items = groupedItems[sourceTitle]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSourceHeader(sourceTitle, items, scaleFactor),
                    ...items.map((item) => _buildCartItemCard(context, item, scaleFactor)).toList(),
                    if (groupIndex < sourceKeys.length - 1)
                      SizedBox(height: 16.h * scaleFactor),
                  ],
                );
              },
            );
          }),
        ),
        _buildCartSummary(context, scaleFactor),
      ],
    );
  }

  Widget _buildSourceHeader(
      String sourceTitle, List<CartItem> items, double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w * scaleFactor, vertical: 12.h * scaleFactor),
      child: Text(
        sourceTitle,
        style: TextStyle(
          fontSize: 18.sp * scaleFactor,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro',
          color: Colors.black,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCartItemCard(
      BuildContext context, CartItem cartItem, double scaleFactor) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 16.w * scaleFactor, vertical: 4.h * scaleFactor),
      padding: EdgeInsets.all(16.r * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * scaleFactor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6 * scaleFactor,
            offset: Offset(0, 2 * scaleFactor),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8 * scaleFactor),
            child: Image.network(
              cartItem.image,
              width: 70.w * scaleFactor,
              height: 70.h * scaleFactor,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70.w * scaleFactor,
                height: 70.h * scaleFactor,
                color: Colors.grey[300],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[500],
                  size: 30 * scaleFactor,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 70.w * scaleFactor,
                  height: 70.h * scaleFactor,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFE47830),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16.w * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.name,
                  style: TextStyle(
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h * scaleFactor),
                if (cartItem.rating.isNotEmpty && cartItem.duration.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16 * scaleFactor,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w * scaleFactor),
                      Text(
                        '${cartItem.rating} | ${cartItem.duration}',
                        style: TextStyle(
                          fontSize: 13.sp * scaleFactor,
                          color: Colors.grey[600],
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8.h * scaleFactor),
                Row(
                  children: [
                    Text(
                      cartItem.formattedPrice,
                      style: TextStyle(
                        fontSize: 18.sp * scaleFactor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro',
                        color: const Color(0xFFE47830),
                      ),
                    ),
                    if (cartItem.hasDiscount) ...[
                      SizedBox(width: 8.w * scaleFactor),
                      Text(
                        '₹${cartItem.originalPrice.toInt()}',
                        style: TextStyle(
                          fontSize: 14.sp * scaleFactor,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ],
                  ],
                ),
                if (cartItem.description.isNotEmpty) ...[
                  SizedBox(height: 6.h * scaleFactor),
                  Text(
                    cartItem.description,
                    style: TextStyle(
                      fontSize: 12.sp * scaleFactor,
                      color: Colors.grey[600],
                      fontFamily: 'SF Pro',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => cartController.decrementQuantity(cartItem.id),
                      child: Container(
                        width: 32.w * scaleFactor,
                        height: 32.h * scaleFactor,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6 * scaleFactor),
                            bottomLeft: Radius.circular(6 * scaleFactor),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 18 * scaleFactor,
                          color: const Color(0xFFE47830),
                        ),
                      ),
                    ),
                    Container(
                      width: 40.w * scaleFactor,
                      height: 32.h * scaleFactor,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '${cartItem.quantity}',
                        style: TextStyle(
                          fontSize: 14.sp * scaleFactor,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE47830),
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cartController.incrementQuantity(cartItem.id),
                      child: Container(
                        width: 32.w * scaleFactor,
                        height: 32.h * scaleFactor,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6 * scaleFactor),
                            bottomRight: Radius.circular(6 * scaleFactor),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18 * scaleFactor,
                          color: const Color(0xFFE47830),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, double scaleFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6 * scaleFactor,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    cartController.formattedItemCount,
                    style: TextStyle(
                      fontSize: 14.sp * scaleFactor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro',
                      color: Colors.black87,
                    ),
                  )),
                  SizedBox(height: 2.h * scaleFactor),
                  Obx(() {
                    final groupedItems = cartController.getItemsGroupedBySource();
                    return Text(
                      'From ${groupedItems.length} ${groupedItems.length == 1 ? 'source' : 'sources'}',
                      style: TextStyle(
                        fontSize: 12.sp * scaleFactor,
                        color: Colors.grey[600],
                        fontFamily: 'SF Pro',
                      ),
                    );
                  }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12.sp * scaleFactor,
                      color: Colors.grey[600],
                      fontFamily: 'SF Pro',
                    ),
                  ),
                  Obx(() => Text(
                    cartController.formattedTotalPrice,
                    style: TextStyle(
                      fontSize: 22.sp * scaleFactor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro',
                      color: const Color(0xFFE47830),
                    ),
                  )),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h * scaleFactor),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showClearCartDialog(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h * scaleFactor),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Clear Cart',
                      style: TextStyle(
                        fontSize: 16.sp * scaleFactor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro',
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w * scaleFactor),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _proceedToCheckout(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h * scaleFactor),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE47830),
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE47830).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 16.sp * scaleFactor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  size: 48,
                  color: Color(0xFFE47830),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Clear Cart?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to remove all items from your cart?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontFamily: 'SF Pro',
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro',
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        cartController.clearCart();
                        Navigator.pop(context);
                        Get.snackbar(
                          'Cart Cleared',
                          'All items have been removed',
                          snackPosition: SnackPosition.TOP, // ✅ Changed to TOP
                          backgroundColor: Color(0xFFE47830), // ✅ Changed to orange
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16), // ✅ Added margin
                          borderRadius: 12, // ✅ Added border radius
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Color(0xFFE47830),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _proceedToCheckout(BuildContext context) {
  cartController.validateCartForCheckout().then((isValid) {
    if (!isValid) return;

    final groupedItems = cartController.getItemsGroupedBySource();
    final totalAmount = cartController.totalPrice;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE47830).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    size: 40,
                    color: Color(0xFFE47830),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF Pro',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      ...groupedItems.entries.map((entry) {
                        final sourceTitle = entry.key;
                        final items = entry.value;
                        final itemCount = items.fold(0, (sum, item) => sum + item.quantity);
                        final sourceTotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
                        
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sourceTitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SF Pro',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontFamily: 'SF Pro',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                '₹${sourceTotal.toInt()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(height: 24, thickness: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                              Text(
                                cartController.formattedItemCount,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${totalAmount.toInt()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE47830),
                              fontSize: 20,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro',
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          
                          // Get all selected service IDs from grouped items
                          final List<String> selectedServiceIds = [];
                          groupedItems.values.forEach((items) {
                            selectedServiceIds.addAll(items.map((item) => item.id));
                          });
                          
                          // Navigate to SummaryScreen with the same parameters
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                currentPageSelectedServices: selectedServiceIds,
                                initialAddress: 'Default Address',
                                initialTimeSlot: 'Select time slot',
                                initialSaathi: null,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Color(0xFFE47830),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFE47830).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'SF Pro',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}

}
