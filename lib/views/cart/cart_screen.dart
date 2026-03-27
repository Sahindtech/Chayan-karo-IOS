import 'package:chayankaro/views/chayan_sathi/previouschayansathiscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/test_extensions.dart';
import '../../controllers/cart_controller.dart';
import '../../models/service_models.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';
// ADD THIS IMPORT
import '../../widgets/three_dot_loader.dart'; 
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../rewards/ReferAndEarnScreen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../booking/Summaryscreen.dart';
import './widgets/read_more_text.dart';
import '../../widgets/app_snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  final int _selectedIndex = -2;
  bool _isLoading = false;
  bool _isNavigatingBack = false;
  String? _expandedServiceId;


  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => PreviousChayanSathiScreen()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ReferAndEarnScreen()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  // Logic to handle updates, show loader, and enforce limit
  Future<void> _handleQuantityUpdate(String itemId, bool isIncrement) async {
    // 1. Check Limits (Max 3)
    if (isIncrement) {
      final int currentQty = cartController.getQuantity(itemId);
      // Strictly stop if limit reached. No Snackbar.
      if (currentQty >= 30) {
        return; 
      }
    }

    // 2. Show Loader
    setState(() {
      _isLoading = true;
    });

    // 3. Simulate Loading Delay (Good animation time)
    await Future.delayed(const Duration(milliseconds: 600));

    // 4. Perform Action
    if (isIncrement) {
      cartController.incrementQuantity(itemId);
    } else {
      cartController.decrementQuantity(itemId);
    }

    // 5. Hide Loader
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor =
            isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEEE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Container(
            color: const Color(0xFFFFEEE0),
            child: Stack(
              children: [
                // --- Main Body ---
                Scaffold(
                  extendBodyBehindAppBar: true, // ✅ ADD

                  backgroundColor: Colors.white,
                  body: SafeArea(
                    top: false, // ✅ ADD
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEE0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x26000000),
                                blurRadius:
                                    4 * (isTabletDevice ? scaleFactor : 1.0),
                                offset: Offset(
                                    0, 2 * (isTabletDevice ? scaleFactor : 1.0)),
                              )
                            ],
                          ),
                          child: ChayanHeader(
                            title: 'Cart',
onBack: () {
                              if (_isNavigatingBack) return;
                              _isNavigatingBack = true;
                              Navigator.pop(context);
                            },                          ),
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

                // --- Floating Loader Overlay (No Box) ---
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3), // Slightly dim background
                    child: Center(
                      // Using the imported reusable widget
                      child: const ThreeDotLoader(), 
                    ),
                  ),
              ],
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
            SizedBox(
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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
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
            ).withId('cart_empty_explore_btn'),
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
                    ...items
                        .map((item) =>
                            _buildCartItemCard(context, item, scaleFactor))
                        ,
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
    
    // Determine if max limit is reached
    final bool isMaxLimit = cartItem.quantity >= 30;

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
      // CHANGE 1: Main layout is now a Column to allow full-width description
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Image, Details, Quantity
          Row(
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
                    if (cartItem.rating.isNotEmpty &&
                        cartItem.duration.isNotEmpty)
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/star.svg',
                              width: 18.w * scaleFactor,
                              height: 18.h * scaleFactor,
                              color: Colors.black),
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
                    // CHANGE 2: Removed Description from here
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
                          onTap: () =>
                              _handleQuantityUpdate(cartItem.id, false),
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
                        ).withId('cart_minus_${cartItem.id}'),
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
                          onTap: isMaxLimit
                              ? null
                              : () => _handleQuantityUpdate(cartItem.id, true),
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
                              color: isMaxLimit
                                  ? Colors.grey
                                  : const Color(0xFFE47830),
                            ),
                          ),
                        ).withId('cart_plus_${cartItem.id}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // CHANGE 3: Description added here (Full Width)
          if (cartItem.description.isNotEmpty) ...[
            SizedBox(height: 12.h * scaleFactor), // Slightly more spacing
            ReadMoreText(
              text: cartItem.description,
              trimLines: 2, // It will show 2 full-width lines before "Read more"
              isExpanded: _expandedServiceId == cartItem.id,
              onToggle: () {
                setState(() {
                  _expandedServiceId =
                      _expandedServiceId == cartItem.id ? null : cartItem.id;
                });
              },
            ),
          ],
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
                  final groupedItems =
                      cartController.getItemsGroupedBySource();
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
        
        // --- UPDATED BUTTON SECTION ---
        // Removed Row and Clear Cart button. 
        // Proceed button now takes full width.
        GestureDetector(
          onTap: () => _proceedToCheckout(context),
          child: Container(
            width: double.infinity, // Ensures button is centered and full width
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
        ).withId('cart_checkout_btn'),
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
                      ).withId('cart_dialog_cancel_btn'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          cartController.clearCart();
                          Navigator.pop(context);
                         AppSnackbar.showSuccess('All items have been removed');
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
                      ).withId('cart_dialog_confirm_btn'),
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

  void _proceedToCheckout(BuildContext context) async {
    final groupedItems = cartController.getItemsGroupedBySource();
    // 1. Restriction: Minimum Order Value Check
    if (cartController.totalPrice < 99) {
      AppSnackbar.showWarning(
  'Minimum order ₹99 required. Please add more items.'
);
      return;
    }

    if (groupedItems.length > 1) {
     AppSnackbar.showWarning(
  'You can purchase services from only one category at a time.'
);

      return;
    }

    final isValid = await cartController.validateCartForCheckout();
    if (!isValid) return;

    final List<String> selectedServiceIds = [];
    for (var items in groupedItems.values) {
      selectedServiceIds.addAll(items.map((item) => item.id));
    }

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
  }
}