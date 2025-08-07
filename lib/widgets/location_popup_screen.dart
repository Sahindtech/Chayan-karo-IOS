import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/home/home_screen.dart';

class LocationPopupScreen extends StatefulWidget {
  const LocationPopupScreen({super.key});

  @override
  State<LocationPopupScreen> createState() => _LocationPopupScreenState();
}

class _LocationPopupScreenState extends State<LocationPopupScreen> {
  String locationTitle = 'Fetching location...';
  String locationDetails = '';
  final TextEditingController houseController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  String selectedLabel = 'Home';
  LatLng? currentLatLng;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() {
          error = 'Location services are disabled.';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          error = 'Location permission denied.';
          isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;

      final titleParts = [
        placemark?.subLocality,
        placemark?.locality,
      ];

      final detailParts = [
        placemark?.street,
        placemark?.subLocality,
        placemark?.locality,
        placemark?.administrativeArea,
        placemark?.postalCode,
      ];

      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
        locationTitle = titleParts
            .where((e) => e != null && e.trim().isNotEmpty)
            .join(', ');
        locationDetails = detailParts
            .where((e) => e != null && e.trim().isNotEmpty)
            .join(', ');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to get location. Please try again.';
        isLoading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFDF5F0),
    body: isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Icon(
                  Icons.location_on,
                  color: Color(0xFFE47830),
                  size: 64,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Getting your location...',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF444444),
                  ),
                ),
                SizedBox(height: 24.h),
                CircularProgressIndicator(
                  color: Color(0xFFE47830),
                ),
              ],
            ),
          )
        : error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      color: Color(0xFFE47830),
                      size: 64,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Location unavailable',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF444444),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        error!,
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: _fetchLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE47830),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:  Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _buildMapUI(context),
  );
}

  Widget _buildMapUI(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: FlutterMap(
                options: MapOptions(
                  center: currentLatLng,
                  zoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0.w,
                        height: 40.0.h,
                        point: currentLatLng!,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.orange,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                      .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locationTitle,
                          style:  TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                          )),
                      SizedBox(height: 4.h),
                      Text(locationDetails,
                          style:  TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF757575),
                            fontFamily: 'SF Pro Display',
                          )),
                      Divider(height: 24.h),
                      _buildInputField('House/Flat Number *', houseController),
                      SizedBox(height: 12.h),
                      _buildInputField('Landmark (Optional)', landmarkController),
                      SizedBox(height: 24.h),
                      Text('Save as',
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14.sp,
                            fontFamily: 'SF Pro Display',
                          )),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildOptionChip('Home'),
                          SizedBox(width: 12.w),
                          _buildOptionChip('Other'),
                          const Spacer(),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE47830)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _handleSubmit,
                            child:  Text(
                              'Set as Default',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFE47830),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        height: 47.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: houseController.text.isNotEmpty
                                ? const Color(0xFFE47830)
                                : const Color(0xFFD7D7D7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: houseController.text.isNotEmpty
                              ? _handleSubmit
                              : null,
                          child:  Text(
                            'Save and Proceed to slots',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              letterSpacing: 0.32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 40.r,
          right: 16.r,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    final fullAddress = '${houseController.text}, ${landmarkController.text}, $locationTitle';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location_label', selectedLabel);
    await prefs.setString('location_address', fullAddress);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFABABAB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildOptionChip(String label) {
    final isSelected = selectedLabel == label;
    return GestureDetector(
      onTap: () => setState(() => selectedLabel = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE6EAFF) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFE47830) : const Color(0xFFE3E3E3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE47830) : const Color(0xFFABABAB),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}