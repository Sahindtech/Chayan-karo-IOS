import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/chayan_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/location_controller.dart';
import '../../models/location_models.dart';
import '../../utils/test_extensions.dart';
import '../../widgets/three_dot_loader.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final LocationController locationController = Get.find<LocationController>();
  String? selectedDefaultId;

  @override
  void initState() {
    super.initState();
    // Fetch after first frame; then align local selection based on data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await locationController.fetchCustomerAddresses();
      _alignSelectedDefaultFromData();
    });
  }

  void _alignSelectedDefaultFromData() {
    final list = locationController.addresses;
    if (list.isEmpty) return;
    final defId = list.firstWhereOrNull((a) => a.isDefault)?.id ?? selectedDefaultId ?? list.first.id;
    if (defId != selectedDefaultId && mounted) {
      // schedule to avoid setState during Obx build phases
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => selectedDefaultId = defId);
      });
    }
  }

 Future<void> _navigateAddOrEditAddress() async {
    // 1. Wait for the location popup to close
    await Get.toNamed('/location_popup', arguments: 'manage_address');

    // 2. ALWAYS Refresh (Fixes BUG-036)
    // We fetch addresses even if 'res' is null/false. 
    // This clears any "Non-Serviceable" error states that might have been set 
    // in the controller while the user was on the map screen.
    await locationController.fetchCustomerAddresses();
    _alignSelectedDefaultFromData();
  }
  Future<void> _setAsDefault(CustomerAddress address) async {
    await locationController.setDefaultAddressLocal(address.id);
    if (mounted) setState(() => selectedDefaultId = address.id);
    await locationController.fetchCustomerAddresses(silent: true);
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
                        onTap: _navigateAddOrEditAddress,
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
                      ).withId('manage_addr_add_btn'),

                      Expanded(
                        child: Obx(() {
                          if (locationController.isLoadingAddresses.value) {
                            return Center(
  child: ThreeDotLoader(
    color: const Color(0xFFE47830),
    size: 14,
  ),
);
                          }

                          if (locationController.error.value.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 48 * scaleFactor, color: Colors.grey),
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
                                    onPressed: () async {
                                      await locationController.fetchCustomerAddresses();
                                      _alignSelectedDefaultFromData();
                                    },
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

                          final list = locationController.addresses;

                          // Keep local selection aligned once data is ready
                          if (list.isNotEmpty) {
                            final defId = list.firstWhereOrNull((a) => a.isDefault)?.id ?? selectedDefaultId ?? list.first.id;
                            if (defId != selectedDefaultId) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) setState(() => selectedDefaultId = defId);
                              });
                            }
                          }

                          if (list.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_off_outlined, size: 48 * scaleFactor, color: Colors.grey),
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

                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final address = list[index];
                              final isSelectedDefault = address.id == selectedDefaultId;

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
                                        // Badge driven by local selection to guarantee a single visual default
                                        if (isSelectedDefault)
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
                                          onSelected: (value) async {
                                          /*  if (value == 'edit') {
                                              _showUpdateAddressBottomSheet(scaleFactor, address);
                                            } else */ if (value == 'delete') {
                                              _confirmDelete(scaleFactor, address.id);
                                            } else if (value == 'make_default') {
                                              await _setAsDefault(address);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                           /* PopupMenuItem(
                                              value: 'edit',
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 14.sp * scaleFactor,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),*/
                                            PopupMenuItem(
                                              value: 'make_default',
                                              enabled: !isSelectedDefault,
                                              child: Text(
                                                'Set as Default',
                                                style: TextStyle(
                                                  fontSize: 14.sp * scaleFactor,
                                                  color: Colors.black,
                                                ),
                                              ).withId('address_set_default_btn_$index'),
                                            ),
                                            // --- CHANGE START: Only show delete if NOT default ---
                                            if (!isSelectedDefault)
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 14.sp * scaleFactor,
                                                    color: Colors.black,
                                                  ),
                                                ).withId('address_menu_btn_$index'),
                                              ),
                                            // --- CHANGE END ---
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

 /* void _showUpdateAddressBottomSheet(double scaleFactor, CustomerAddress address) {
    final addressLine1 = address.addressLine1.trim();
    final addressLine2 = address.addressLine2.trim();
    final cityStatePin = '${address.city}, ${address.state} - ${address.postCode}'.trim();

    final subtitle = <String>[
      if (addressLine1.isNotEmpty) addressLine1,
      if (addressLine2.isNotEmpty) addressLine2,
      cityStatePin,
    ].join(', ').trim();

    // Prefill controllers
    final houseCtrl = TextEditingController(text: addressLine1);
    final landmarkCtrl = TextEditingController(text: addressLine2);

    // --- LOGIC START: Auto-select current address type ---
    // 1. We check if address.addressType (from DB) is valid.
    // 2. We normalize it (trim/capitalize) to match our chip list.
    // 3. If null or not in list, no chip is selected initially.
    final List<String> typeOptions = ['Home', 'Work', 'Other'];
    String? selectedType;
    
    if (address.addressType != null) {
      final normalized = address.addressType!.trim();
      // Only select if it matches one of our options (case-insensitive)
      selectedType = typeOptions.firstWhereOrNull(
        (option) => option.toLowerCase() == normalized.toLowerCase()
      );
    }
    // --- LOGIC END ---

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.8,
          minChildSize: 0.45,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
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
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Update Address',
                                  style: TextStyle(
                                    fontSize: 18.sp * scaleFactor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 4.h * scaleFactor),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13.sp * scaleFactor,
                                    color: const Color(0xFF757575),
                                    fontFamily: 'Inter',
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 24.h * scaleFactor),
                                _OutlinedIconField(
                                  scaleFactor: scaleFactor,
                                  controller: houseCtrl,
                                  hintText: 'House/Flat Number *',
                                  testId: 'update_addr_house_input',
                                  icon: Icons.home_outlined,
                                ),
                                SizedBox(height: 16.h * scaleFactor),
                                _OutlinedIconField(
                                  scaleFactor: scaleFactor,
                                  controller: landmarkCtrl,
                                  hintText: 'Landmark / Area *',
                                  testId: 'update_addr_landmark_input',
                                  icon: Icons.location_on_outlined,
                                ),
                                SizedBox(height: 24.h * scaleFactor),
                                Text(
                                  'Save as',
                                  style: TextStyle(
                                    fontSize: 14.sp * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12.h * scaleFactor),
                                Row(
                                  children: typeOptions.map((type) {
                                    bool isSelected = selectedType == type;
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.w * scaleFactor),
                                      child: ChoiceChip(
                                        label: Text(type),
                                        selected: isSelected,
                                        onSelected: (bool selected) {
                                          setModalState(() {
                                            selectedType = selected ? type : null;
                                          });
                                        },
                                        selectedColor: const Color(0xFFE47830).withOpacity(0.15),
                                        backgroundColor: const Color(0xFFF8F6F4),
                                        labelStyle: TextStyle(
                                          color: isSelected ? const Color(0xFFE47830) : Colors.grey[600],
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          fontSize: 14.sp * scaleFactor,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.r * scaleFactor),
                                          side: BorderSide(
                                            color: isSelected ? const Color(0xFFE47830) : Colors.transparent,
                                          ),
                                        ),
                                        showCheckmark: false,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 24.h * scaleFactor),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w * scaleFactor),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.h * scaleFactor,
                            child: Obx(() {
                              final isMutating = locationController.isMutatingAddress.value;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE47830),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r * scaleFactor),
                                  ),
                                ),
                               onPressed: isMutating ? null : () async {
  final hNum = houseCtrl.text.trim();
  final lMark = landmarkCtrl.text.trim();

  if (hNum.isEmpty || lMark.isEmpty) {
    Get.snackbar(
      "Required Fields",
      "Please fill in both House Number and Landmark",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[50],
      colorText: Colors.orange[800],
      margin: EdgeInsets.all(16.w * scaleFactor),
      borderRadius: 8,
    );
    return;
  }

  // EXECUTE UPDATE API
  final success = await locationController.updateCustomerAddress(
    addressId: address.id,
    locationId: address.locationId ?? "",
    houseNumber: hNum,
    landmark: lMark,
    city: address.city,
    state: address.state,
    postCode: address.postCode,
    addressType: selectedType, // Passing the Home/Work/Other selection
  );

  if (context.mounted) {
    if (success) {
      // 1. Close Bottom Sheet
      Navigator.pop(context);

      // 2. Custom Success Snackbar
      Get.snackbar(
        'Success',
        'Address updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    } else {
      // 3. Custom Error Snackbar
      Get.snackbar(
        'Error',
        locationController.error.value.isNotEmpty 
            ? locationController.error.value 
            : 'Failed to update address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    }
  }
},
                                child: isMutating 
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Update address', style: TextStyle(color: Colors.white)),
                              );
                            }),
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
      },
    );
  } */
 void _confirmDelete(double scaleFactor, String addressId) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing while deleting
      builder: (dialogContext) {
        // Local state for the loading spinner inside the dialog
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                // Cancel Button
                TextButton(
                  onPressed: isDeleting ? null : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp * scaleFactor,
                      color: isDeleting ? Colors.grey[400] : Colors.grey[600],
                      fontFamily: 'Inter',
                    ),
                  ),
                ).withId('delete_dialog_cancel'),

                // Delete / Retry Button
                TextButton(
                  onPressed: isDeleting
                      ? null // Disable button while loading
                      : () async {
                          setState(() => isDeleting = true); // Show Spinner

                          // Call API (Dialog is still open)
                          final success = await locationController.deleteAddress(addressId);

                          if (context.mounted) {
                            if (success) {
                              // Success: Close dialog & Refresh
                              Navigator.pop(dialogContext);
                              Get.snackbar(
                                'Success',
                                'Address deleted successfully',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.green[100],
                                colorText: Colors.green[800],
                                margin: EdgeInsets.all(16.w * scaleFactor),
                                borderRadius: 8,
                                duration: const Duration(seconds: 2),
                              );
                              _alignSelectedDefaultFromData();
                            } else {
                          // Failure: Stop spinner, keep dialog open for Retry
                          setState(() => isDeleting = false);
                          
                          // --- CHANGE START: User-Friendly Error Handling ---
                          String rawError = locationController.error.value;
                          String friendlyError = "Something went wrong. Please try again.";

                          // check for common network keywords
                          if (rawError.contains("SocketException") || 
                              rawError.contains("host lookup") || 
                              rawError.contains("connection error")) {
                            friendlyError = "No internet connection. Please check your settings.";
                          } else if (rawError.isNotEmpty) {
                            friendlyError = rawError; // Use server message if it's not a socket error
                          }

                          Get.snackbar(
                            'Connection Failed', // Clearer Title
                            friendlyError,       // Optimized Message
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[800],
                            margin: EdgeInsets.all(16.w * scaleFactor),
                            borderRadius: 8,
                            icon: const Icon(Icons.wifi_off, color: Colors.red), // Visual cue
                          );
                            }
                          }
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: isDeleting ? Colors.red.shade200 : Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w * scaleFactor,
                      vertical: 8.h * scaleFactor,
                    ),
                  ),
                  child: isDeleting
                      ? SizedBox(
                          width: 14.w * scaleFactor,
                          height: 14.w * scaleFactor,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp * scaleFactor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                ).withId('delete_dialog_confirm'),
              ],
            );
          },
        );
      },
    );
  }
}
class _OutlinedIconField extends StatelessWidget {
  final double scaleFactor;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String testId; // <--- 1. Add this field
  final TextInputType? keyboardType;

  const _OutlinedIconField({
    required this.scaleFactor,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.testId,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F4),
        borderRadius: BorderRadius.circular(14 * scaleFactor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12 * scaleFactor, vertical: 2 * scaleFactor),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE47830)),
          SizedBox(width: 8 * scaleFactor),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                hintText: '',
                border: InputBorder.none,
              ).copyWith(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: const Color(0xFFB9B6B3),
                  fontSize: 15 * scaleFactor,
                ),
              ),
            ).withId(testId),
          ),
        ],
      ),
    );
  }
}