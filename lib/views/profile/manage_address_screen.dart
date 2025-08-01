import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/chayan_header.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  String locationLabel = 'Home';
  String address = 'Not Available';
  String phone = '+91 0000000000'; // Optional – you can store phone if needed

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      locationLabel = prefs.getString('location_label') ?? 'Home';
      address = prefs.getString('location_address') ?? 'Not Available';
      phone = prefs.getString('user_phone') ?? '+91 0000000000'; // Optional
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ChayanHeader(
            title: 'Manage Address',
            onBack: () => Navigator.pop(context),
            onBackTap: () {},
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: Open address adding flow
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: Color(0xFFE47830), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Add another address',
                          style: TextStyle(
                            color: Color(0xFFE47830),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFEBEBEB)),
                        bottom: BorderSide(color: Color(0xFFEBEBEB)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.home_filled, size: 20, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              locationLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.more_vert, size: 20, color: Colors.grey.shade700),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$address\nPh: $phone',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            height: 1.5,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
