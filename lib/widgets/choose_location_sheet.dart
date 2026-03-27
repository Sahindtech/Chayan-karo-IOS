// lib/views/location/choose_location_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/location_controller.dart';
import '../../models/location_models.dart';
import 'package:flutter/services.dart';
import '../../utils/test_extensions.dart';


class ChooseLocationSheet extends StatefulWidget {
  final String? source; // 'home_header' | 'manage_address'
  const ChooseLocationSheet({super.key, this.source});

  @override
  State<ChooseLocationSheet> createState() => _ChooseLocationSheetState();
}

class _ChooseLocationSheetState extends State<ChooseLocationSheet> {
  final LocationController lc = Get.find<LocationController>();
  String? selectedId;

  @override
  void initState() {
    super.initState();
    // Trigger fetch; selectedId will be aligned after data arrives
    lc.fetchCustomerAddresses();
    // Optional initial guess from any preloaded data
    selectedId = lc.addresses.firstWhereOrNull((a) => a.isDefault)?.id;
  }

  Future<void> _handleSelect(CustomerAddress a) async {
    await lc.setDefaultAddressLocal(a.id);
    setState(() => selectedId = a.id);
    // Optional sync to keep other screens up-to-date without changing repo/controller
    await lc.fetchCustomerAddresses(silent: true);
    Get.back(result: a);
  }

  Future<void> _useCurrentLocation() async {
    final res = await Get.toNamed(
      '/location_popup',
      arguments: {
        'source': widget.source ?? 'home_header',
        'mode': 'instant_current',
      },
    );

    if (res == true) {
      await lc.fetchCustomerAddresses(silent: true);
      Get.back(result: lc.cachedLocation.value);
    }
  }

@override
Widget build(BuildContext context) {
  final themeOrange = const Color(0xFFE47830);
  const peachy = Color(0xFFFFEEE0);

  return Scaffold(
    backgroundColor: Colors.white,

    // ✅ AppBar paints BOTH header + status bar (no shift)
    appBar: AppBar(
      elevation: 0,
      backgroundColor: peachy,
      surfaceTintColor: peachy, // ✅ Android 12+ fix
      shadowColor: Colors.transparent,

      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: peachy,                 // ✅ Peachy status bar
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,  // iOS safety
      ),

      leadingWidth: 64.w,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black87,
          size: 20,
        ),
        onPressed: () {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    // If it can't pop, manually route them where they belong
    Get.offAllNamed('/home'); 
  }
}
      ),

      title: const Text(
        'Select location',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    ),

    body: Obx(() {
      final loading = lc.isLoadingAddresses.value;
      final err = lc.error.value;
      final list = lc.addresses;

      if (!loading && list.isNotEmpty) {
        final defId =
            list.firstWhereOrNull((a) => a.isDefault)?.id ??
            selectedId ??
            list.first.id;
        if (defId != selectedId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => selectedId = defId);
          });
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick actions
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 52.h,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.my_location, color: Colors.white),
                    label: const Text(
                      'Use my current location',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _useCurrentLocation,
                  ).withId('choose_loc_use_current_btn'),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 52.h,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: themeOrange, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: Icon(Icons.add, color: themeOrange),
                    label: Text(
                      'Add new address',
                      style: TextStyle(
                        color: themeOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      final res = await Get.toNamed(
                        '/location_popup',
                        arguments: 'manage_address',
                      );
                      if (res == true) lc.fetchCustomerAddresses();
                    },
                  ).withId('choose_loc_add_new_btn'),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 8.h),
            child: const Text(
              'Saved addresses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          if (loading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFE47830)),
              ),
            )
          else if (err.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.grey),
                    SizedBox(height: 8),
                    const Text('Failed to load addresses'),
                    TextButton(
                      onPressed: lc.fetchCustomerAddresses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (list.isEmpty)
            const Expanded(
              child: Center(child: Text('No addresses saved')),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final a = list[i];
                  final isSelected = (a.id == selectedId);
                  return InkWell(
                    onTap: () => _handleSelect(a),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected ? themeOrange : Colors.grey,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      a.city,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 8.w),
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE6EAFF),
                                          border:
                                              Border.all(color: themeOrange),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            color: themeOrange,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${a.addressLine1}, ${a.addressLine2}\n'
                                  '${a.city}, ${a.state} - ${a.postCode}',
                                  style: const TextStyle(
                                    color: Color(0xFF757575),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).withId('choose_loc_item_$i');
                },
              ),
            ),
        ],
      );
    }),
  );
}

}
