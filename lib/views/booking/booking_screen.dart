import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../chayan_sathi/chayan_sathi_screen.dart';
import '../rewards/rewards_screen.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'upcoming_booking_screen.dart';
import 'PreviousBookingScreen.dart';
import 'feedback_screen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 1;
  bool showUpcoming = true;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChayanSathiScreen()));
        break;
      case 1:
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

  Widget buildTabBar() {
  return Container(
    color: const Color(0xFFFFEDE0),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Upcoming tab (left)
          GestureDetector(
            onTap: () => setState(() => showUpcoming = true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                  ),
                ),
                if (showUpcoming)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 76, // slightly wider than text
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE47830),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),

          // Previous tab (right)
          GestureDetector(
            onTap: () => setState(() => showUpcoming = false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: !showUpcoming ? const Color(0xFFE47830) : const Color(0xFFA2A2A2),
                  ),
                ),
                if (!showUpcoming)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 72, // similar width for visual balance
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE47830),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['Warranty', 'Cancelled', 'Delivered'].map((label) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x66FF9437)),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPinBoxes(String pin) {
    return Row(
      children: pin.split('').map((digit) {
        return Container(
          margin: EdgeInsets.only(left: 4),
          width: 20,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF161616),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            digit,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro',
            ),
          ),
        );
      }).toList(),
    );
  }

    Widget buildUpcomingCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UpcomingBookingScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFECEEFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Salon for Woman',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: Color(0xFF161616),
                  ),
                ),
                // "Your PIN" with boxes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Your PIN',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF161616),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    buildPinBoxes("3333"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            // Services
            Text(
              '• Diamond Facial',
              style: TextStyle(fontSize: 12, color: Color(0xFF555555), fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 2),
            Text(
              '• Cleanup',
              style: TextStyle(fontSize: 12, color: Color(0xFF555555), fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 12),
            // Booking status
            Text(
              'Booking scheduled',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '22nd Nov, Tuesday / ',
                    style: TextStyle(fontSize: 13),
                  ),
                  TextSpan(
                    text: '07:30 PM',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'When Your Chayan sathi arrives share your PIN',
              style: TextStyle(fontSize: 8, color: Colors.black.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildPreviousCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('19th Nov, Saturday', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('AC service', style: TextStyle(color: Colors.black54)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text('• General service', style: TextStyle(color: Colors.black54)),
              Icon(Icons.arrow_drop_down, size: 16, color: Colors.black54),
            ],
          ),
          SizedBox(height: 12),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE47830),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FeedbackScreen()),
  );
},
      child: Text(
        'Share Feedback',
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PreviousBookingScreen()),
        );
      },
      child: Text(
        'View details',
        style: TextStyle(fontSize: 12, color: Color(0xFFE47830)),
      ),
    ),
  ],
),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          buildTabBar(),
          Divider(height: 1, color: Color(0xFFEBEBEB)),
          if (showUpcoming) buildFilterChips(),
          Expanded(
            child: ListView(
              children: showUpcoming
                  ? [buildUpcomingCard(), buildUpcomingCard()]
                  : [buildPreviousCard()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}