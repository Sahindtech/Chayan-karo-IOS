import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/location_controller.dart';
import '../../models/location_models.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    // Fetch addresses from API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locationController.fetchCustomerAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth > 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              ChayanHeader(
                title: 'Manage Address',
                onBack: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h * scaleFactor),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Navigate to location screen
await Get.toNamed(
      '/location_popup',
      arguments: 'manage_address', // Pass source screen identifier
    );                          
                          // Refresh address list when coming back
                          locationController.fetchCustomerAddresses();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add, color: const Color(0xFFE47830), size: 20 * scaleFactor),
                            SizedBox(width: 8.w * scaleFactor),
                            Text(
                              'Add another address',
                              style: TextStyle(
                                color: const Color(0xFFE47830),
                                fontSize: 16.sp * scaleFactor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                     // SizedBox(height: 5.h * scaleFactor),

                      // Address List with GetX Observable
                      Expanded(
                        child: Obx(() {
                          // Show loading indicator
                          if (locationController.isLoadingAddresses.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFE47830),
                              ),
                            );
                          }

                          // Show error message
                          if (locationController.error.value.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48 * scaleFactor,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.h * scaleFactor),
                                  Text(
                                    'Failed to load addresses',
                                    style: TextStyle(
                                      fontSize: 16.sp * scaleFactor,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 8.h * scaleFactor),
                                  TextButton(
                                    onPressed: () => locationController.fetchCustomerAddresses(),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: const Color(0xFFE47830),
                                        fontSize: 14.sp * scaleFactor,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show empty state
                          if (locationController.addresses.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off_outlined,
                                    size: 48 * scaleFactor,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.h * scaleFactor),
                                  Text(
                                    'No addresses found',
                                    style: TextStyle(
                                      fontSize: 16.sp * scaleFactor,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show address list
                          return ListView.builder(
                            itemCount: locationController.addresses.length,
                            itemBuilder: (context, index) {
                              final address = locationController.addresses[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 12.h * scaleFactor),
                                padding: EdgeInsets.all(16.r * scaleFactor),
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
                                          width: 20.w * scaleFactor,
                                          height: 20.h * scaleFactor,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 8.w * scaleFactor),
                                        Text(
                                          '${address.city}',
                                          style: TextStyle(
                                            fontSize: 16.sp * scaleFactor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        SizedBox(width: 8.w * scaleFactor),
                                        // Show default badge
                                        if (address.isDefault)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w * scaleFactor,
                                              vertical: 2.h * scaleFactor,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE6EAFF),
                                              borderRadius: BorderRadius.circular(4.r * scaleFactor),
                                              border: Border.all(color: const Color(0xFFE47830)),
                                            ),
                                            child: Text(
                                              'Default',
                                              style: TextStyle(
                                                color: const Color(0xFFE47830),
                                                fontSize: 10.sp * scaleFactor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ),
                                        const Spacer(),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showUpdateAddressBottomSheet(scaleFactor, address);
                                            } else if (value == 'delete') {
                                              _confirmDelete(scaleFactor, address.id);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 14.sp * scaleFactor,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 14.sp * scaleFactor,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                          color: Colors.white,
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 20 * scaleFactor,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h * scaleFactor),
                                    Text(
                                      '${address.addressLine1}, ${address.addressLine2}\n${address.city}, ${address.state} - ${address.postCode}',
                                      style: TextStyle(
                                        fontSize: 14.sp * scaleFactor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                        height: 1.5,
                                        color: const Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),
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

  void _showUpdateAddressBottomSheet(double scaleFactor, CustomerAddress address) {
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.h * scaleFactor)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    SizedBox(height: 8.h * scaleFactor),
                    Container(
                      width: 40.w * scaleFactor,
                      height: 4.h * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r * scaleFactor),
                      ),
                    ),
                    SizedBox(height: 16.h * scaleFactor),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${address.city}, ${address.state}',
                                    style: TextStyle(
                                      fontSize: 16.sp * scaleFactor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                if (!address.isDefault)
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement set as default API call
                                    },
                                    style: TextButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFFE47830)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.r * scaleFactor),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.h * scaleFactor,
                                        vertical: 4.h * scaleFactor,
                                      ),
                                    ),
                                    child: Text(
                                      'Set as Default',
                                      style: TextStyle(
                                        color: const Color(0xFFE47830),
                                        fontSize: 12.sp * scaleFactor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h * scaleFactor),
                            Text(
                              '${address.addressLine1}, ${address.addressLine2}\n${address.city}, ${address.state} - ${address.postCode}',
                              style: TextStyle(
                                fontSize: 13.sp * scaleFactor,
                                color: const Color(0xFF757575),
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: 24.h * scaleFactor),

                            Text(
                              'House/Flat Number *',
                              style: TextStyle(
                                fontSize: 10.sp * scaleFactor,
                                color: const Color(0xFFABABAB),
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            SizedBox(height: 4.h * scaleFactor),
                            TextFormField(
                              initialValue: address.addressLine1,
                              style: TextStyle(
                                fontSize: 14.sp * scaleFactor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12 * scaleFactor,
                                    vertical: 14 * scaleFactor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h * scaleFactor),

                            TextFormField(
                              initialValue: address.addressLine2,
                              decoration: InputDecoration(
                                labelText: 'Landmark (Optional)',
                                labelStyle: TextStyle(
                                  fontSize: 14.sp * scaleFactor,
                                  color: const Color(0xFFABABAB),
                                  fontFamily: 'SF Pro Display',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h * scaleFactor),

                            Text(
                              'Save as',
                              style: TextStyle(
                                fontSize: 14.sp * scaleFactor,
                                fontFamily: 'SF Pro Display',
                                color: const Color(0xFF757575),
                              ),
                            ),
                            SizedBox(height: 10.h * scaleFactor),

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
                                    borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                  ),
                                  onSelected: (_) {},
                                ),
                                SizedBox(width: 10.w * scaleFactor),
                                ChoiceChip(
                                  label: const Text('Other'),
                                  selected: false,
                                  labelStyle: const TextStyle(
                                    color: Color(0xFFABABAB),
                                    fontFamily: 'SF Pro Display',
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Color(0xFFE3E3E3)),
                                    borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                  ),
                                  onSelected: (_) {},
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h * scaleFactor),
                          ],
                        ),
                      ),
                    ),

                    SafeArea(
                      top: false,
                      minimum: EdgeInsets.only(
                        left: 16.w * scaleFactor,
                        right: 16.w * scaleFactor,
                        top: 8.h * scaleFactor,
                        bottom: MediaQuery.of(context).viewPadding.bottom > 0
                            ? MediaQuery.of(context).viewPadding.bottom
                            : 8.h * scaleFactor,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 47.h * scaleFactor,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE47830),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r * scaleFactor),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Implement update address API call
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Update address',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp * scaleFactor,
                              letterSpacing: 0.3,
                              color: Colors.white,
                            ),
                          ),
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

  void _confirmDelete(double scaleFactor, String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Delete Address',
          style: TextStyle(
            fontSize: 18.sp * scaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: TextStyle(
            fontSize: 14.sp * scaleFactor,
            fontFamily: 'Inter',
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp * scaleFactor,
                color: Colors.grey[600],
                fontFamily: 'Inter',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete API call with addressId
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w * scaleFactor,
                vertical: 8.h * scaleFactor,
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
