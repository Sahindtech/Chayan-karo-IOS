import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
        const SizedBox(height: 16), // <-- Added spacing here

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
                           SvgPicture.asset(
                          'assets/icons/home.svg',
                            width: 20,
                            height: 20,
                            color: Colors.black, ),
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
PopupMenuButton<String>(
  onSelected: (value) {
    if (value == 'edit') {
      _showUpdateAddressBottomSheet();
    } else if (value == 'delete') {
      _confirmDelete();
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(value: 'edit', child: Text('Edit')),
    const PopupMenuItem(value: 'delete', child: Text('Delete')),
  ],
  icon: Icon(Icons.more_vert, size: 20, color: Colors.grey.shade700),
),
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
  void _showUpdateAddressBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.3),
        child: Stack(
          children: [
            Positioned(
              top: 114,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Madhapur, Hyderabad',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {}, // handle set default
                          child: const Text(
                            'Set as Default',
                            style: TextStyle(
                              color: Color(0xFFE47830),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE47830)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033\nPh: +91234567890',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'House/Flat Number *',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFABABAB),
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: 'Plot no.209',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Landmark (Optional)',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFABABAB),
                          fontFamily: 'SF Pro Display',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Save as',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro Display',
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Home'),
                          selected: true,
                          selectedColor: const Color(0xFFE6EAFF),
                          labelStyle: const TextStyle(
                            color: Color(0xFFE47830),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFE47830)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (_) {},
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text('Other'),
                          selected: false,
                          labelStyle: const TextStyle(
                            color: Color(0xFFABABAB),
                            fontFamily: 'SF Pro Display',
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFE3E3E3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (_) {},
                        ),
                      ],
                    ),
                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 47,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE47830),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Update address',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _confirmDelete() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Address'),
      content: const Text('Are you sure you want to delete this address?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle deletion
            Navigator.pop(context);
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

}
