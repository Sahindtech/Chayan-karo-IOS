import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/home_screen.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../rewards/rewards_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/chayan_header.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final int _selectedIndex = -2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChayanSathiScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RewardsScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
  value: SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: const Color(0xFFFFEEE0),
    statusBarIconBrightness: Brightness.dark,
  ),
  child: Container(
    color: const Color(0xFFFFEEE0), // this ensures status bar background shows
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEEE0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: ChayanHeader(
                title: 'Cart',
                onBackTap: () => Navigator.pop(context),
              ),
            ),
            // rest of your code...

              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: const ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/cart_empty.png"),
                              fit: BoxFit.cover,
                            ),
                            shape: OvalBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Cart is Empty',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro',
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Let’s add some services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: Container(
                            width: 175,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE47830),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Explore Services',
                              style: TextStyle(
                                fontSize: 16,
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
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    )
    );
  }
}
