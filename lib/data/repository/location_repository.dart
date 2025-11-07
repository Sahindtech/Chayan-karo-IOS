// lib/data/repository/location_repository.dart
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import '../../data/local/database.dart';
import '../../data/remote/api_service.dart';
import '../../models/location_models.dart';

class LocationRepository {
  final ApiService _apiService;
  final AppDatabase _database;

  LocationRepository({
    required ApiService apiService,
    required AppDatabase database,
  })  : _apiService = apiService,
        _database = database;

  // ---------------- Save via API + local cache (unchanged) ----------------
  Future<AddAddressResponse> saveLocation({
    required String latitude,
    required String longitude,
    required String address,
    required String label,
    String? houseNumber,
    String? landmark,
  }) async {
    try {
      final token = await _database.getAuthToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final addressParts = await _parseAddress(
        double.parse(latitude),
        double.parse(longitude),
        address,
      );

      final request = AddAddressRequest(
        addressLine1: houseNumber ?? 'N/A',
        addressLine2: landmark ?? address,
        city: addressParts['city'] ?? 'N/A',
        state: addressParts['state'] ?? 'N/A',
        postCode: addressParts['postCode'] ?? '000000',
        lat: double.parse(latitude),
        long: double.parse(longitude),
      );

      final response = await _apiService.addCustomerAddress('Bearer $token', request);

      await _cacheLocation(
        label: label,
        address: address,
        latitude: double.parse(latitude),
        longitude: double.parse(longitude),
        houseNumber: houseNumber,
        landmark: landmark,
        city: addressParts['city'],
        state: addressParts['state'],
        postCode: addressParts['postCode'],
      );

      return response;
    } catch (e) {
      // Best-effort local cache even if API fails
      try {
        await _cacheLocation(
          label: label,
          address: address,
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
          houseNumber: houseNumber,
          landmark: landmark,
        );
      } catch (_) {}
      rethrow;
    }
  }

  // ---------------- Client-only default persistence ----------------
  Future<void> saveLocalDefaultAddressId(String id) async {
    await _database.saveUserPreference('default_address_id', id);
  }

  Future<String?> getLocalDefaultAddressId() async {
    return await _database.getUserPreference('default_address_id');
  }

  // Persist full cached location JSON (no schema change)
  Future<void> saveCachedLocationJson(CachedLocationData data) async {
    await _database.saveUserPreference('location_json', jsonEncode(data.toJson()));
  }

  // Persist "active" location row (no schema change)
  Future<void> persistActiveLocation(CachedLocationData data) async {
    await _database.saveLocationFull(
      label: data.label,
      address: data.address,
      latitude: data.latitude,
      longitude: data.longitude,
      houseNumber: data.houseNumber,
      landmark: data.landmark,
    );
  }

  // ---------------- Fetch addresses from API ----------------
  Future<List<CustomerAddress>> getCustomerAddresses() async {
    final token = await _database.getAuthToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final response = await _apiService.getCustomerAddresses('Bearer $token');
    return response.result;
  }

  // ---------------- Cached location utilities (unchanged) ----------------
  Future<void> _cacheLocation({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
    String? houseNumber,
    String? landmark,
    String? city,
    String? state,
    String? postCode,
  }) async {
    final locationData = CachedLocationData(
      label: label,
      address: address,
      latitude: latitude,
      longitude: longitude,
      houseNumber: houseNumber,
      landmark: landmark,
      city: city,
      state: state,
      postCode: postCode,
      savedAt: DateTime.now(),
    );

    await _database.saveLocationFull(
      label: label,
      address: address,
      latitude: latitude,
      longitude: longitude,
      houseNumber: houseNumber,
      landmark: landmark,
    );

    await _database.saveUserPreference(
      'location_json',
      jsonEncode(locationData.toJson()),
    );
  }

  Future<CachedLocationData?> getCachedLocation() async {
    try {
      final locationJson = await _database.getUserPreference('location_json');
      if (locationJson == null) {
        final active = await _database.getActiveLocation();
        if (active != null) {
          return CachedLocationData(
            label: active['label'],
            address: active['address'],
            latitude: active['latitude'],
            longitude: active['longitude'],
            houseNumber: active['houseNumber'],
            landmark: active['landmark'],
            savedAt: DateTime.parse(active['updatedAt']),
          );
        }
        return null;
      }
      return CachedLocationData.fromJson(jsonDecode(locationJson));
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasLocationCached() async {
    return await _database.hasLocationCached();
  }

  Future<void> clearLocationCache() async {
    await _database.clearLocationData();
    await _database.removeUserPreference('location_json');
  }

  Future<String?> getLocationSummary() async {
    final l = await getCachedLocation();
    if (l == null) return null;
    return '${l.label} - ${l.address}';
  }

  // ---------------- Address parsing helpers (unchanged) ----------------
  Future<Map<String, String?>> _parseAddress(
    double latitude,
    double longitude,
    String fullAddress,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return _parseAddressFromString(fullAddress);
      final p = placemarks.first;
      return {
        'city': p.locality ?? p.subAdministrativeArea ?? 'Unknown',
        'state': p.administrativeArea ?? 'Unknown',
        'postCode': p.postalCode ?? '000000',
      };
    } catch (_) {
      return _parseAddressFromString(fullAddress);
    }
  }

  Map<String, String?> _parseAddressFromString(String address) {
    final parts = address.split(',').map((e) => e.trim()).toList();
    return {
      'city': parts.length > 1 ? parts[parts.length - 2] : 'Unknown',
      'state': parts.length > 2 ? parts[parts.length - 1] : 'Unknown',
      'postCode': '000000',
    };
  }
}
