import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 16.h), // <-- Added spacing here

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
                      children: [
                        Icon(Icons.add, color: Color(0xFFE47830), size: 20),
                        SizedBox(width: 8.w),
                        Text(
                          'Add another address',
                          style: TextStyle(
                            color: Color(0xFFE47830),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16.r),
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
                            width: 20.w,
                            height: 20.h,
                            color: Colors.black, ),
                            SizedBox(width: 8.w),
                            Text(
                              locationLabel,
                              style:  TextStyle(
                                fontSize: 16.sp,
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
                        SizedBox(height: 8.h),
                        Text(
                          '$address\nPh: $phone',
                          style:  TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            height: 1.5.h,
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
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Madhapur, Hyderabad',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Set as Default',
                                  style: TextStyle(
                                    color: Color(0xFFE47830),
                                    fontSize: 12.sp,
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
                          SizedBox(height: 4.h),
                          Text(
                            'Plot no.209, Kavuri Hills, Madhapur, Telangana 500033\nPh: +91234567890',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Color(0xFF757575),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 24.h),

                          Text(
                            'House/Flat Number *',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xFFABABAB),
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextFormField(
                            initialValue: 'Plot no.209',
                            style: TextStyle(
                              fontSize: 14.sp,
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
                          SizedBox(height: 16.h),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Landmark (Optional)',
                              labelStyle: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xFFABABAB),
                                fontFamily: 'SF Pro Display',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Text(
                            'Save as',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SF Pro Display',
                              color: Color(0xFF757575),
                            ),
                          ),
                          SizedBox(height: 10.h),

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
                              SizedBox(width: 10.w),
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
                          SizedBox(height: 24.h),

                          SizedBox(
                            width: double.infinity,
                            height: 47.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE47830),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Update address',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  letterSpacing: 0.3,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
          child: Text('Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

}