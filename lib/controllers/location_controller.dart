// lib/controllers/location_controller.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/repository/location_repository.dart';
import '../models/location_models.dart';

class LocationController extends GetxController {
  final LocationRepository _repository;
  LocationController({required LocationRepository repository}) : _repository = repository;

  // Existing state
  final Rx<CachedLocationData?> cachedLocation = Rx<CachedLocationData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasLocation = false.obs;
  final RxString error = ''.obs;

  // Addresses state
  final RxList<CustomerAddress> addresses = <CustomerAddress>[].obs;
  final RxBool isLoadingAddresses = false.obs;
  final RxBool isMutatingAddress = false.obs;
  final RxString localDefaultAddressId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedLocation();
    _loadLocalDefault();
  }

  Future<void> _loadLocalDefault() async {
    final id = await _repository.getLocalDefaultAddressId();
    if (id != null && id.isNotEmpty) {
      localDefaultAddressId.value = id;
    }
  }

  Future<void> _loadCachedLocation() async {
    try {
      final location = await _repository.getCachedLocation();
      cachedLocation.value = location;
      hasLocation.value = location != null;
    } catch (_) {}
  }

  // Save from popup (unchanged)
  Future<bool> saveLocation({
    required LatLng coordinates,
    required String address,
    required String label,
    String? houseNumber,
    String? landmark,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _repository.saveLocation(
        latitude: coordinates.latitude.toString(),
        longitude: coordinates.longitude.toString(),
        address: address,
        label: label,
        houseNumber: houseNumber,
        landmark: landmark,
      );
      if (response.success) {
        await _loadCachedLocation();
        await fetchCustomerAddresses(silent: true);
        return true;
      } else {
        error.value = response.message;
        return false;
      }
    } catch (e) {
      error.value = e.toString();
      await _loadCachedLocation();
      return hasLocation.value;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkLocationExists() async {
    final exists = await _repository.hasLocationCached();
    hasLocation.value = exists;
    return exists;
  }

  Future<void> clearLocation() async {
    try {
      await _repository.clearLocationCache();
      cachedLocation.value = null;
      hasLocation.value = false;
    } catch (e) {
      error.value = e.toString();
    }
  }

  String getLocationSummary() {
    if (cachedLocation.value == null) return 'No location set';
    final l = cachedLocation.value!;
    return '${l.label} - ${l.address.split(',').first}';
  }
  String? getFullAddress() => cachedLocation.value?.address;

  // Fetch addresses and reapply local default
  Future<void> fetchCustomerAddresses({bool silent = false}) async {
    try {
      if (!silent) isLoadingAddresses.value = true;
      error.value = '';
      final fetched = await _repository.getCustomerAddresses();

      final localId = localDefaultAddressId.value;
      final list = fetched.map((a) {
        final markDefault = a.isDefault || (localId.isNotEmpty && a.id == localId);
        return a.copyWith(isDefault: markDefault);
      }).toList();

      addresses.value = list;

      final def = list.firstWhereOrNull((a) => a.isDefault);
      if (def != null) {
        final composed = '${def.addressLine1}, ${def.addressLine2}, ${def.city}, ${def.state} - ${def.postCode}';
        final prev = cachedLocation.value?.address ?? '';
        if (prev != composed) {
          _syncCachedFromAddress(def);
          final cl = cachedLocation.value!;
          // Persist selection to DB so it survives restarts
          await _repository.persistActiveLocation(cl);    // writes LocationDataTable
          await _repository.saveCachedLocationJson(cl);   // writes location_json
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      if (!silent) isLoadingAddresses.value = false;
    }
  }

  // Client-only default setter with persistence
  Future<void> setDefaultAddressLocal(String addressId) async {
    try {
      isMutatingAddress.value = true;

      addresses.value = addresses.map((a) => a.copyWith(isDefault: a.id == addressId)).toList();
      localDefaultAddressId.value = addressId;
      await _repository.saveLocalDefaultAddressId(addressId);

      final selected = addresses.firstWhereOrNull((a) => a.id == addressId);
      if (selected != null) {
        _syncCachedFromAddress(selected);
        final cl = cachedLocation.value!;
        // Persist selection to DB (no schema changes)
        await _repository.persistActiveLocation(cl);    // ensure active row matches
        await _repository.saveCachedLocationJson(cl);   // ensure location_json matches
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isMutatingAddress.value = false;
    }
  }

  // Sync chosen address to cached header state
  void _syncCachedFromAddress(CustomerAddress a) {
    cachedLocation.value = CachedLocationData(
      label: a.label ?? 'HOME',
      address: '${a.addressLine1}, ${a.addressLine2}, ${a.city}, ${a.state} - ${a.postCode}',
      latitude: double.tryParse(a.latitude ?? '') ?? 0.0,
      longitude: double.tryParse(a.longitude ?? '') ?? 0.0,
      houseNumber: a.addressLine1,
      landmark: a.addressLine2,
      city: a.city,
      state: a.state,
      postCode: a.postCode,
      savedAt: DateTime.now(),
    );
    hasLocation.value = true;
  }
}
