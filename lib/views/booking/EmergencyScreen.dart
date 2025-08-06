import 'package:flutter/material.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header stays at top
          ChayanHeader(title: 'Emergency', onBackTap: () {}),
          
          // Main content below header
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: "Need assistance?"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Need assistance?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro',
                        letterSpacing: 0.2,
                        color: Color(0xFF161616),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Call for support button
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      width: 148,
                      height: 33,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 6),
                          SvgPicture.asset('assets/icons/help.svg',
                              height: 20, width: 20, color: Colors.black),
                          const SizedBox(width: 10),
                          const Text(
                            'Call For Support',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF Pro',
                              letterSpacing: 0.14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(height: 6, color: const Color(0x7FD9D9D9)),

                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 20),
                    child: Text(
                      'Local emergency contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro',
                        color: Color(0xFF161616),
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/emergency.svg',
                    label: 'All emergencies',
                    number: 'Call 112',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/police.svg',
                    label: 'Police',
                    number: 'Call 100',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/med.svg',
                    label: 'Medical',
                    number: 'Call 101',
                  ),
                  _buildDivider(),
                  _buildEmergencyRow(
                    iconAsset: 'assets/icons/fire.svg',
                    label: 'Fire',
                    number: 'Call 102',
                  ),
                  _buildDivider(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyRow({
    required String iconAsset,
    required String label,
    required String number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Row(
        children: [
          SvgPicture.asset(iconAsset, width: 25, height: 25, color: Colors.black),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                letterSpacing: 0.13,
              ),
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro',
              letterSpacing: 0.13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Opacity(
      opacity: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 1,
          color: const Color(0xFFD9D9D9),
        ),
      ),
    );
  }
}
