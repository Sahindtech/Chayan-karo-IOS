// lib/views/location/location_popup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:get/get.dart';
import '../../controllers/location_controller.dart';
import '../views/home/home_screen.dart';
import '../widgets/places_search_widget.dart';
const kGoogleApiKey = "AIzaSyAJsorrGKIgn2WoWP22VDCF1Utr8-Y1eqI"; // Replace with your actual API key

class LocationPopupScreen extends StatefulWidget {
  const LocationPopupScreen({super.key});

  @override
  State<LocationPopupScreen> createState() => _LocationPopupScreenState();
}

class _LocationPopupScreenState extends State<LocationPopupScreen> with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController houseController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(); // ✅ ADDED
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // ✨ GetX Controller
  late final LocationController locationController;
      final FocusNode houseFocusNode = FocusNode();
final FocusNode landmarkFocusNode = FocusNode();
final FocusNode phoneFocusNode = FocusNode(); // ✅ ADDED


  // State variables
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String locationTitle = 'Fetching location...';
  String locationDetails = '';
  String selectedLabel = 'Home';
  bool isLoading = false;
  bool isSearching = false;
  String? error;
  
  // Screen state: 'choice' | 'map_confirm' | 'manual_search' | 'map_detail'
  String screenState = 'choice';
    String? _sourceScreen;


  @override
void initState() {
  super.initState();
  debugPrint('🟢 LocationPopupScreen: initState()');

  // Backward-compatible argument parsing
  final args = Get.arguments;
  String? source;
  String? mode;

  if (args is Map) {
    // New style: {'source': 'home_header', 'mode': 'instant_current'}
    source = args['source'] as String?;
    mode   = args['mode'] as String?;
  } else if (args is String) {
    // Legacy style: 'home_header' or 'manage_address'
    source = args;
  } else {
    source = null;
    mode = null;
  }

  _sourceScreen = source;
  debugPrint('📍 Source screen: $_sourceScreen');
  if (mode != null) debugPrint('⚙️ Popup mode: $mode');

  // Initialize GetX controller
  locationController = Get.find<LocationController>();

  // Attach listeners
  searchController.addListener(_onSearchTextChanged);

  // Auto-run current-location flow if requested by caller (choice sheet)
  if (mode == 'instant_current') {
    // Defer to next frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCurrentLocation(); // your existing method
    });
  }
}

  @override
  void dispose() {
    debugPrint('🔴 LocationPopupScreen: dispose()');
    searchController.removeListener(_onSearchTextChanged);
    houseController.dispose();
    landmarkController.dispose();
    phoneController.dispose(); // ✅ ADDED
    searchController.dispose();
    searchFocusNode.dispose();
    _mapController?.dispose();
    houseFocusNode.dispose();
  landmarkFocusNode.dispose();
  phoneFocusNode.dispose(); // ✅ ADDED

    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      isSearching = searchController.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    debugPrint('🧹 Clearing search');
    searchController.clear();
    searchFocusNode.unfocus();
    setState(() {
      isSearching = false;
    });
  }

  Future<void> _fetchCurrentLocation() async {
    debugPrint('🎯 _fetchCurrentLocation() called');
    FocusScope.of(context).unfocus();
    
    setState(() {
      isLoading = true;
      screenState = 'map_confirm';
    });
    debugPrint('🔄 State changed to: map_confirm (loading)');

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          error = 'Location permission denied.';
          isLoading = false;
          screenState = 'choice';
        });
        if (mounted) {
          _showSnackBar('Location permission is required', isError: true);
        }
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint('✅ Got position: ${pos.latitude}, ${pos.longitude}');

      await _updateAddressFromLatLng(LatLng(pos.latitude, pos.longitude));
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _fetchCurrentLocation: $e');
      setState(() {
        error = 'Failed to get current location: $e';
        isLoading = false;
        screenState = 'choice';
      });
      if (mounted) {
        _showSnackBar('Failed to get location', isError: true);
      }
    }
  }

  Future<void> _updateAddressFromLatLng(LatLng latLng) async {
    debugPrint('📍 _updateAddressFromLatLng called: ${latLng.latitude}, ${latLng.longitude}');
    
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      
      final placemark = placemarks.first;

      final titleParts = [placemark.subLocality, placemark.locality];
      final detailParts = [
        placemark.street,
        placemark.subLocality,
        placemark.locality,
        placemark.administrativeArea,
        placemark.postalCode,
      ];

      setState(() {
        _currentLatLng = latLng;
        locationTitle = titleParts.where((e) => e != null && e.isNotEmpty).join(', ');
        locationDetails = detailParts.where((e) => e != null && e.isNotEmpty).join(', ');
        isLoading = false;
      });
      
      debugPrint('✅ Updated location - Title: $locationTitle');

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 16),
      );
    } catch (e) {
      debugPrint('❌ Error in _updateAddressFromLatLng: $e');
      setState(() {
        error = 'Failed to get address: $e';
        isLoading = false;
      });
    }
  }

  // ✨ UPDATED: Submit using LocationController
 Future<void> _handleSubmit() async {
  debugPrint('💾 _handleSubmit called');
  
  // Dismiss keyboard first
  FocusManager.instance.primaryFocus?.unfocus();
  
  // Small delay for smooth keyboard dismissal
  await Future.delayed(const Duration(milliseconds: 150));
  
  if (_currentLatLng == null) {
    _showSnackBar('Please select a location', isError: true);
    return;
  }

  if (houseController.text.trim().isEmpty) {
    _showSnackBar('Please enter house/flat number', isError: true);
    houseFocusNode.requestFocus();
    return;
  }

  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFFE47830),
                strokeWidth: 3,
              ),
              SizedBox(height: 20.h),
              Text(
                'Saving location...',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  final fullAddress = '${houseController.text}, ${landmarkController.text}, $locationTitle';
  
  debugPrint('📝 Saving location:');
  debugPrint('   Address: $fullAddress');
  debugPrint('   Label: $selectedLabel');
  debugPrint('   Coordinates: $_currentLatLng');

  final success = await locationController.saveLocation(
    coordinates: _currentLatLng!,
    address: fullAddress,
    label: selectedLabel,
    houseNumber: houseController.text,
    landmark: landmarkController.text.isEmpty ? null : landmarkController.text,
  );

  if (!mounted) return;
  Navigator.pop(context); // Close loading dialog

  if (success) {
    debugPrint('✅ Location saved successfully via controller');
    _showSnackBar('Location saved successfully!');
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    if (_sourceScreen == 'manage_address') {
      debugPrint('↩️ Returning to manage_address');
      Get.back(result: true);
    } else {
      debugPrint('🏠 Navigating to HomeScreen');
      Get.offAll(() => const HomeScreen());
    }
  } else {
    debugPrint('❌ Failed to save location');
    _showSnackBar(
      locationController.error.value.isEmpty
          ? 'Failed to save location'
          : locationController.error.value,
      isError: true,
    );
  }
}

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFFE47830),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          child: _buildCurrentScreen(),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (screenState) {
      case 'choice':
        return _buildChoiceScreen();
      case 'manual_search':
        return _buildManualSearchScreen();
      case 'map_confirm':
        return isLoading ? _buildLoader() : _buildMapConfirmScreen();
      case 'map_detail':
        return _buildMapDetailScreen();
      default:
        return _buildChoiceScreen();
    }
  }

  // 🎯 Initial Choice Screen
  Widget _buildChoiceScreen() {
    return SafeArea(
      child: Column(
        key: const ValueKey('choice'),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  splashRadius: 24,
                ),
              ],
            ),
          ),

          const Spacer(),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE47830).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      size: 60.r,
                      color: const Color(0xFFE47830),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 40.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'Where do you want your service?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: _fetchCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE47830),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.my_location, size: 20, color: Colors.white),
                        SizedBox(width: 10.w),
                        Text(
                          'At my current location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => screenState = 'manual_search');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE47830), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "I'll enter my location manually",
                      style: TextStyle(
                        color: const Color(0xFFE47830),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // 🗺️ Map Confirmation Screen (Like the reference image)
  Widget _buildMapConfirmScreen() {
    return Stack(
      key: const ValueKey('map_confirm'),
      children: [
        // Google Map
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLatLng!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onCameraMove: (position) {
            // Update marker position as user moves map
            setState(() {
              _currentLatLng = position.target;
            });
          },
          onCameraIdle: () async {
            // Update address when user stops moving the map
            if (_currentLatLng != null) {
              await _updateAddressFromLatLng(_currentLatLng!);
            }
          },
          markers: {},
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),

        // Center pin
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Order will be delivered here\nPlace the pin accurately on the map',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Icon(
                Icons.location_on,
                color: const Color(0xFFE47830),
                size: 48.r,
              ),
            ],
          ),
        ),

        // Back button
        Positioned(
          top: 40.h,
          left: 16.w,
          child: Material(
            elevation: 4,
            shape: const CircleBorder(),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  screenState = 'choice';
                  _clearSearch();
                });
              },
              customBorder: const CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
            ),
          ),
        ),

        // My Location Button
        Positioned(
          bottom: 200.h,
          right: 16.w,
          child: Material(
            elevation: 4,
            shape: const CircleBorder(),
            color: Colors.white,
            child: InkWell(
              onTap: () async {
                if (_currentLatLng != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
                  );
                }
              },
              customBorder: const CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: const Icon(Icons.my_location, color: Color(0xFFE47830), size: 24),
              ),
            ),
          ),
        ),

        // Bottom location card
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE47830).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFFE47830),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Location',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                locationTitle,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                locationDetails,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => screenState = 'choice');
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: const Color(0xFFE47830),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => screenState = 'map_detail');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE47830),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Confirm Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📝 Map Detail Screen (Enter house/flat details)
  Widget _buildMapDetailScreen() {
    return Stack(
      key: const ValueKey('map_detail'),
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLatLng!,
            zoom: 16,
          ),
          onMapCreated: (controller) => _mapController = controller,
          markers: _currentLatLng != null
              ? {
                  Marker(
                    markerId: const MarkerId('picked'),
                    position: _currentLatLng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                  ),
                }
              : {},
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),

        _buildBottomSheet(),

        // Back button
        Positioned(
          top: 40.h,
          left: 16.w,
          child: Material(
            elevation: 4,
            shape: const CircleBorder(),
            color: Colors.white,
            child: InkWell(
              onTap: () => setState(() => screenState = 'map_confirm'),
              customBorder: const CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

// 🔍 Manual Search Screen - FIXED VERSION
// In your location_popup_screen.dart
Widget _buildManualSearchScreen() {
  final hasResults = searchController.text.isNotEmpty;

  return SafeArea(
    key: const ValueKey('manual_search'),
    child: Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              hintText: "Search for area, street name...",
              hintStyle: TextStyle(
                fontSize: 15.sp,
                color: Colors.black38,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 22,
                ),
                onPressed: () {
                  _clearSearch();
                  setState(() => screenState = 'choice');
                },
                splashRadius: 20,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                      onPressed: _clearSearch,
                      splashRadius: 20,
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE47830),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              isDense: true,
            ),
          ),
        ),

        // Content area
        Expanded(
          child: !hasResults 
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      // Hint text
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.grey[500],
                              size: 18,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'eg. Marina Road or Redfern or DLF City Phase 4',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.h),
                        child: Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1, indent: 20)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text('Or', style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                            const Expanded(child: Divider(thickness: 1, endIndent: 20)),
                          ],
                        ),
                      ),
                      
                      InkWell(
                        onTap: _fetchCurrentLocation,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFE47830).withOpacity(0.1),
                                const Color(0xFFE47830).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFE47830).withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE47830),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Use current location',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFE47830),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'We\'ll fetch your location automatically',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: const Color(0xFFE47830).withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                      
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'powered by ',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : PlacesSearchWidget(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  googleApiKey: kGoogleApiKey,
                  onPlaceSelected: (place) async {
                    FocusScope.of(context).unfocus();
                    
                    setState(() {
                      isLoading = true;
                      screenState = 'map_confirm';
                    });
                    
                    final latLng = LatLng(place['lat'], place['lng']);
                    await _updateAddressFromLatLng(latLng);
                  },
                  onBackPressed: () {
                    _clearSearch();
                    setState(() => screenState = 'choice');
                  },
                  onClearPressed: _clearSearch,
                  showResultsOnly: true,
                ),
        ),
      ],
    ),
  );
}

  Widget _buildLoader() {
    return Center(
      key: const ValueKey('loader'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE47830).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Color(0xFFE47830), size: 48),
          ),
          SizedBox(height: 24.h),
          Text(
            'Locating you...',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF444444),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'This may take a moment',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 28.h),
          const CircularProgressIndicator(
            color: Color(0xFFE47830),
            strokeWidth: 3,
          ),
        ],
      ),
    );
  }

Widget _buildBottomSheet() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE47830).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFFE47830),
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          locationDetails,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              Divider(height: 32.h, thickness: 1),
              
              _buildInputField('House/Flat Number *', houseController, Icons.home_outlined, houseFocusNode),
              SizedBox(height: 14.h),
              _buildInputField('Landmark (Optional)', landmarkController, Icons.place_outlined, landmarkFocusNode),
              SizedBox(height: 14.h),
              _buildInputField('Phone Number (Optional)', phoneController, Icons.phone_outlined, phoneFocusNode), // ✅ ADDED
              SizedBox(height: 24.h),
              
              Text(
                'Save as',
                style: TextStyle(
                  color: const Color(0xFF757575),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              
              Row(
                children: [
                  _buildOptionChip('Home', Icons.home),
                  SizedBox(width: 10.w),
                  _buildOptionChip('Work', Icons.work),
                  SizedBox(width: 10.w),
                  _buildOptionChip('Other', Icons.location_on),
                ],
              ),
              SizedBox(height: 24.h),
              
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE47830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    'Save and Proceed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildInputField(String hint, TextEditingController controller, IconData icon, FocusNode focusNode) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    textCapitalization: hint.contains('Phone') ? TextCapitalization.none : TextCapitalization.words, // ✅ UPDATED
    keyboardType: hint.contains('Phone') ? TextInputType.phone : TextInputType.text, // ✅ UPDATED
    textInputAction: hint.contains('Optional') ? TextInputAction.done : TextInputAction.next,
    onSubmitted: (_) {
      if (hint.contains('Optional')) {
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        landmarkFocusNode.requestFocus();
      }
    },
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFFABABAB),
        fontSize: 14.sp,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFFE47830), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE47830), width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    ),
  );
}


  Widget _buildOptionChip(String label, IconData icon) {
    final isSelected = selectedLabel == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedLabel = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE47830)
                : const Color(0xFFE47830).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE47830)
                  : const Color(0xFFE47830).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFE47830).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFFE47830),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFE47830),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
