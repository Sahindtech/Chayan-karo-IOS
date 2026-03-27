import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart'; // add url_launcher [web:2]

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<bool> _isExpanded = [false, false, false, false, false, false];

  final List<Map<String, String>> faqs = [
    {
      'question': 'How is chayankaro.com different?',
      'answer': 'We let you choose your professional. View profiles, compare prices, read reviews.',
    },
    {
      'question': 'Are the professionals verified?',
      'answer': 'Yes. All professionals are verified and have passed a background check',
    },
    {
      'question': 'How to book?',
      'answer': 'Select a service, choose your preferred time, and confirm.',
    },
    {
      'question': 'Can I reschedule/cancel?',
      'answer': 'Yes, you can easily reschedule or cancel your bookings from the booking section.',
    },
    {
      'question': 'Payment options?',
      'answer': 'We support UPI, cards, wallets, and COD (Cash on Delivery).',
    },
    {
      'question': 'Where are you available?',
      'answer': 'We are currently available in major Indian cities.',
    },
  ];

  Future<void> _callSupport() async {
    final uri = Uri(scheme: 'tel', path: '+918299217231');
    // Open native dialer with number prefilled [web:10]
    await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication); // [web:2]
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isTablet = constraints.maxWidth > 600;
      final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ChayanHeader(title: 'Help', onBack: () => Navigator.pop(context)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h * scaleFactor),

                    // Need Assistance title
                    Padding(
                      padding: EdgeInsets.only(left: 16.r * scaleFactor),
                      child: Text(
                        'Need assistance?',
                        style: TextStyle(
                          fontSize: 20.sp * scaleFactor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SF Pro',
                          color: Color(0xFF161616),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h * scaleFactor),

                    // Call for Support button (tappable)
                    Container(
                      height: 33.h * scaleFactor,
                      width: 160.w * scaleFactor,
                      margin: EdgeInsets.only(left: 16.r * scaleFactor),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(5 * scaleFactor),
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5 * scaleFactor),
                          onTap: _callSupport, // launch dialer [web:2]
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/help.svg',
                                height: 20.h * scaleFactor,
                                width: 20.w * scaleFactor,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8.w * scaleFactor),
                              Text(
                                'Call For Support',
                                style: TextStyle(
                                  fontSize: 14.sp * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h * scaleFactor),

                    // FAQ Title
                    Padding(
                      padding: EdgeInsets.only(left: 16.r * scaleFactor),
                      child: Text(
                        'Frequently Asked Question(FAQ’s)',
                        style: TextStyle(
                          fontSize: 18.sp * scaleFactor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro',
                          color: Color(0xFF161616),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h * scaleFactor),
                    Divider(thickness: 6, color: Color(0x7FD9D9D9)),

                    // FAQ list
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w * scaleFactor),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: faqs.length,
                        separatorBuilder: (_, __) => Divider(
                          thickness: 1,
                          color: Colors.black.withOpacity(0.56),
                        ),
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            initiallyExpanded: _isExpanded[index],
                            onExpansionChanged: (val) {
                              setState(() {
                                _isExpanded[index] = val;
                              });
                            },
                            trailing: Text(
                              _isExpanded[index] ? '✕' : '+',
                              style: TextStyle(
                                fontSize: 16.sp * scaleFactor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            title: Text(
                              faqs[index]['question']!,
                              style: TextStyle(
                                fontSize: 16.sp * scaleFactor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro',
                                color: Colors.black,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.r * scaleFactor),
                                child: Text(
                                  faqs[index]['answer']!,
                                  style: TextStyle(
                                    fontSize: 14.sp * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h * scaleFactor),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
