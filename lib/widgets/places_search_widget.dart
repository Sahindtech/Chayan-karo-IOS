// lib/views/location/widgets/places_search_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PlacesSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String googleApiKey;
  final Function(Map<String, dynamic> place) onPlaceSelected;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClearPressed;
  final bool showResultsOnly;

  const PlacesSearchWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.googleApiKey,
    required this.onPlaceSelected,
    this.onBackPressed,
    this.onClearPressed,
    this.showResultsOnly = false,
  }) : super(key: key);

  @override
  State<PlacesSearchWidget> createState() => _PlacesSearchWidgetState();
}

class _PlacesSearchWidgetState extends State<PlacesSearchWidget> {
  List<Map<String, dynamic>> predictions = [];
  bool isLoading = false;
  Timer? _debounce;
  String? sessionToken;

  @override
  void initState() {
    super.initState();
    sessionToken = _generateSessionToken();
    widget.controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  String _generateSessionToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (widget.controller.text.trim().isNotEmpty) {
        _fetchPlaces(widget.controller.text.trim());
      } else {
        setState(() {
          predictions = [];
        });
      }
    });
  }

  Future<void> _fetchPlaces(String input) async {
    if (input.length < 2) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=${Uri.encodeComponent(input)}'
        '&key=${widget.googleApiKey}'
        '&sessiontoken=$sessionToken'
        '&components=country:in'
        '&language=en'
      );

      print('🔍 Fetching places: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final List<dynamic> results = data['predictions'] ?? [];
          
          setState(() {
            predictions = results.map((p) => {
              'place_id': p['place_id'],
              'description': p['description'],
              'structured_formatting': p['structured_formatting'],
              'types': p['types'] ?? [],
            }).toList();
            isLoading = false;
          });

          print('✅ Found ${predictions.length} places');
        } else {
          print('⚠️ API Status: ${data['status']}');
          setState(() {
            predictions = [];
            isLoading = false;
          });
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        setState(() {
          predictions = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching places: $e');
      setState(() {
        predictions = [];
        isLoading = false;
      });
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&key=${widget.googleApiKey}'
        '&sessiontoken=$sessionToken'
        '&fields=geometry,formatted_address,name,address_components'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final result = data['result'];
          
          widget.onPlaceSelected({
            'lat': result['geometry']['location']['lat'],
            'lng': result['geometry']['location']['lng'],
            'address': result['formatted_address'],
            'name': result['name'],
          });

          sessionToken = _generateSessionToken();
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error getting place details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getLocationCategory(List<dynamic> types) {
    if (types.isEmpty) return '';
    
    const typeMap = {
      'locality': 'City',
      'sublocality': 'Locality',
      'sublocality_level_1': 'Area',
      'sublocality_level_2': 'Area',
      'route': 'Street',
      'premise': 'Building',
      'establishment': 'Place',
      'point_of_interest': 'Landmark',
      'university': 'University',
      'school': 'School',
      'hospital': 'Hospital',
      'shopping_mall': 'Mall',
      'restaurant': 'Restaurant',
    };
    
    for (var type in types) {
      if (typeMap.containsKey(type)) {
        return typeMap[type]!;
      }
    }
    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // ✨ Results-only mode (used inside Expanded)
    if (widget.showResultsOnly) {
      return Column(
        children: [
          // Loading indicator
          if (isLoading)
            Container(
              padding: EdgeInsets.all(16.h),
              child: const CircularProgressIndicator(
                color: Color(0xFFE47830),
                strokeWidth: 2,
              ),
            ),

          // Results list
          if (!isLoading && predictions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  final structuredFormatting = prediction['structured_formatting'];
                  
                  final mainText = structuredFormatting['main_text'] ?? '';
                  final secondaryText = structuredFormatting['secondary_text'] ?? '';
                  final category = _getLocationCategory(prediction['types']);

                  return InkWell(
                    onTap: () {
                      _getPlaceDetails(prediction['place_id']);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
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
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mainText,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                if (secondaryText.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    secondaryText,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                
                                if (category.isNotEmpty) ...[
                                  SizedBox(height: 6.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF8C42).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: const Color(0xFFFF8C42),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 8.w),
                          
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    }

    // Normal mode (not used in your case now)
    return const SizedBox();
  }
}
