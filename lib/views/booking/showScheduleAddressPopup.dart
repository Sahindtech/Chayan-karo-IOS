import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/location_models.dart';
import '../profile/manage_address_screen.dart';

Future<String?> showScheduleAddressPopup(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const _ScheduleAddressSheet(),
        ),
      );
    },
  );
}

class _ScheduleAddressSheet extends StatefulWidget {
  const _ScheduleAddressSheet({super.key});

  @override
  State<_ScheduleAddressSheet> createState() => _ScheduleAddressSheetState();
}

class _ScheduleAddressSheetState extends State<_ScheduleAddressSheet> {
  bool isSelected = false;
  CustomerAddress? _selected;
  late final LocationController _loc;

  @override
  void initState() {
    super.initState();
    _loc = Get.find<LocationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loc.fetchCustomerAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final sheetHeight = screenH * 0.5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        return Container(
          height: sheetHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.h * scaleFactor)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h * scaleFactor, vertical: 16.h * scaleFactor),
            child: Obx(() {
              final loading = _loc.isLoadingAddresses.value;
              final err = _loc.error.value;
              final addresses = _loc.addresses;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select address',
                        style: TextStyle(
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await Get.to(() => const ManageAddressScreen());
                          await _loc.fetchCustomerAddresses();
                        },
                        icon: Icon(Icons.add, color: const Color(0xFFFF7900), size: 18 * scaleFactor),
                        label: Text(
                          'Add new address',
                          style: TextStyle(
                            fontSize: 14.sp * scaleFactor,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF7900),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF7900),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h * scaleFactor),
                  Divider(height: 1.h * scaleFactor),
                  SizedBox(height: 8.h * scaleFactor),

                  /// List
                  Expanded(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF7900)),
                          )
                        : err.isNotEmpty
                            ? Center(
                                child: Text(
                                  'Failed to load addresses',
                                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                                ),
                              )
                            : addresses.isEmpty
                                ? Center(
                                    child: Text(
                                      'No saved addresses yet',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                                    ),
                                  )
                                : ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(vertical: 6.h * scaleFactor),
                                    itemCount: addresses.length,
                                    separatorBuilder: (_, __) => SizedBox(height: 10.h * scaleFactor),
                                    itemBuilder: (_, i) {
                                      final a = addresses[i];
                                      final selected = _selected?.id == a.id;

                                      return InkWell(
                                        splashColor: Colors.orange.withOpacity(0.1),
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            isSelected = true;
                                            _selected = a;
                                          });
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                              value: a.id,
                                              groupValue: _selected?.id,
                                              activeColor: const Color(0xFFFF7900),
                                              onChanged: (_) {
                                                setState(() {
                                                  isSelected = true;
                                                  _selected = a;
                                                });
                                              },
                                            ),
                                            SizedBox(width: 6.w * scaleFactor),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/homy.svg',
                                                        width: 20.w * scaleFactor,
                                                        height: 20.h * scaleFactor,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(width: 6.w * scaleFactor),
                                                      Text(
                                                        a.isDefault ? 'Home' : 'Address',
                                                        style: TextStyle(
                                                          fontSize: 14.sp * scaleFactor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6.h * scaleFactor),
                                                  Text(
                                                    _formatLines(a),
                                                    style: TextStyle(
                                                      fontSize: 13.sp * scaleFactor,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                  ),

                  /// Proceed button
                  SizedBox(height: 8.h * scaleFactor),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h * scaleFactor,
                    child: ElevatedButton(
                      onPressed: isSelected && _selected != null
                          ? () {
                              final text = _formatAddressString(_selected!);
                              Navigator.pop(context, text);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFFFF7900) : const Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scaleFactor),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  String _formatLines(CustomerAddress a) {
    final parts = <String>[
      a.addressLine1,
      if (a.addressLine2.isNotEmpty) a.addressLine2,
      if (a.city.isNotEmpty) a.city,
      if (a.state.isNotEmpty) a.state,
      if (a.postCode.isNotEmpty) a.postCode,
    ];
    return parts.where((e) => e.trim().isNotEmpty).join(', ');
  }

  String _formatAddressString(CustomerAddress a) => _formatLines(a);
}
