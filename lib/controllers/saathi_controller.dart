import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../data/repository/saathi_repository.dart';
import '../models/saathi_models.dart';

class SaathiController extends GetxController {
  final SaathiRepository _repo;

  SaathiController({SaathiRepository? repo})
      : _repo = repo ?? SaathiRepository();

  // ---------------------------------------------------------
  // CONSTANTS
  // ---------------------------------------------------------
  static const String _kLockedProviderKey = 'locked_spid';
  
  // NEW: Key to store the time we locked the provider
  static const String _kLockedTimeKey = 'locked_timestamp'; 

  // NEW: Auto-clear limit (set to 10 minutes)
  static const int _kLockDurationMinutes = 10; 

  // ---------------------------------------------------------
  // VARIABLES
  // ---------------------------------------------------------

  /// List of fetched providers
  final RxList<SaathiItem> saathiList = <SaathiItem>[].obs;

  /// Local-only: Providers locked by THIS user (Set for quick lookup)
  final RxSet<String> myLockedProviders = <String>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt selectedIndex = 2.obs;

  /// Currently locking provider (Loading indicator ID)
  final RxString lockingProviderId = ''.obs;

  /// Response of last lock
  final Rx<LockProviderResponse?> lastLockResponse =
      Rx<LockProviderResponse?>(null);

  /// Last locked ID (Acts as the active Session ID)
  final RxnString lastLockedProviderId = RxnString(null);

  /// For debounce mode
  final RxString _tapSelection = ''.obs;
  Worker? _debouncer;

  /// Enable / disable immediate lock
  final RxBool preferImmediateLock = true.obs;

  /// We store the date here so we can use it when locking
  DateTime? _currentBookingDate;

  @override
  void onInit() {
    super.onInit();
    
    // 1. RESTORE SESSION: Checks storage AND expiration time
    _restoreLockedSession();

    _debouncer = debounce<String>(
      _tapSelection,
      (spid) async {
        if (spid.isEmpty) return;
        await _lockNow(spid);
      },
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    _debouncer?.dispose();
    super.onClose();
  }

  // -------------------------------------------------------------
  // SHARED PREFERENCES METHODS (UPDATED FOR TIME LOGIC)
  // -------------------------------------------------------------

  /// Load saved SPID from local storage & CHECK TIME
  Future<void> _restoreLockedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_kLockedProviderKey);
      final savedTimeStr = prefs.getString(_kLockedTimeKey); // NEW: Get time
      
      if (savedId != null && savedId.isNotEmpty) {
        
        // CHECK EXPIRATION LOGIC
        if (savedTimeStr != null) {
          final savedTime = DateTime.tryParse(savedTimeStr);
          if (savedTime != null) {
            final difference = DateTime.now().difference(savedTime).inMinutes;

            // If older than 10 minutes, CLEAR IT and stop.
            if (difference >= _kLockDurationMinutes) {
              print("Session expired (> 10 mins). Clearing.");
              await clearBookingSession(); 
              return; 
            }
          }
        }

        // If valid (less than 10 mins), restore it
        lastLockedProviderId.value = savedId;
        myLockedProviders.add(savedId); 
      }
    } catch (e) {
      print("Error restoring locked session: $e");
    }
  }

  /// Save SPID + Current Timestamp
  Future<void> _saveLockedSession(String spid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLockedProviderKey, spid);
      // NEW: Save current time
      await prefs.setString(_kLockedTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      print("Error saving session: $e");
    }
  }

  /// Wipe data (Call this after Booking Success OR Expiration)
  Future<void> clearBookingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kLockedProviderKey);
      await prefs.remove(_kLockedTimeKey); // NEW: Remove time key
      
      lastLockedProviderId.value = null;
      lockingProviderId.value = '';
      myLockedProviders.clear();
      lastLockResponse.value = null;
      _tapSelection.value = '';
    } catch (e) {
      print("Error clearing session: $e");
    }
  }

  // -------------------------------------------------------------
  // HELPER: Check Availability
  // -------------------------------------------------------------

  bool isProviderAvailable(SaathiItem item) {
    if (lastLockedProviderId.value == item.id) {
      return true;
    }
    return !item.isLocked;
  }

  // -------------------------------------------------------------
  // FETCH PROVIDERS
  // -------------------------------------------------------------
  Future<void> fetchProviders({
    required String categoryId,
    required String serviceId,
    required String locationId,
    required String addressId,
    required DateTime bookingDate,
    required int currentBookingDuration,
    String? bookingTime, 
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      _currentBookingDate = bookingDate;

      if (categoryId.trim().isEmpty) throw ArgumentError('categoryId missing');
      if (serviceId.trim().isEmpty) throw ArgumentError('serviceId missing');
      if (locationId.trim().isEmpty) throw ArgumentError('locationId missing');
      if (addressId.trim().isEmpty) throw ArgumentError('addressId missing');

      final items = await _repo.getServiceProviders(
        categoryId: categoryId,
        serviceId: serviceId,
        locationId: locationId,
        addressId: addressId,
        bookingDate: bookingDate,
        currentBookingDuration: currentBookingDuration,
        bookingTime: bookingTime, 
      );

      saathiList.assignAll(items);
      error.value = '';
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------
  // LOCK ON TAP
  // -------------------------------------------------------------
  Future<LockProviderResponse?> lockOnTap(
    String serviceProviderId, {
    DateTime? bookingDate,
  }) async {
    if (serviceProviderId.trim().isEmpty) return null;

    final item = saathiList.firstWhereOrNull((e) => e.id == serviceProviderId);
    if (item == null) return null;

    if (!isProviderAvailable(item)) {
      return null; 
    }

    if (bookingDate != null) {
      _currentBookingDate = bookingDate;
    }

    lockingProviderId.value = serviceProviderId;

    if (preferImmediateLock.value) {
      final res = await _lockNow(
        serviceProviderId,
        dateOverride: bookingDate,
      );

      if (res?.isSuccess == true) {
        _markProviderAsMine(serviceProviderId);
      }

      return res;
    } else {
      _tapSelection.value = serviceProviderId;
      return null;
    }
  }

  // -------------------------------------------------------------
  // Simple selection
  // -------------------------------------------------------------
  void onProviderSelected(String serviceProviderId) {
    if (serviceProviderId.trim().isEmpty) return;
    
    final item = saathiList.firstWhereOrNull((e) => e.id == serviceProviderId);
    
    if (item != null && !isProviderAvailable(item)) return;

    lockingProviderId.value = serviceProviderId;
    _tapSelection.value = serviceProviderId;
  }

  // -------------------------------------------------------------
  // Manual Lock
  // -------------------------------------------------------------
  Future<LockProviderResponse?> lockProviderNow(
      String serviceProviderId) async {
    
    final item = saathiList.firstWhereOrNull((e) => e.id == serviceProviderId);
    if (item != null && !isProviderAvailable(item)) return null;

    final res = await _lockNow(serviceProviderId);

    if (res?.isSuccess == true) {
      _markProviderAsMine(serviceProviderId);
    }

    return res;
  }

  // -------------------------------------------------------------
  // INTERNAL LOCK METHOD
  // -------------------------------------------------------------
  Future<LockProviderResponse?> _lockNow(
    String serviceProviderId, {
    DateTime? dateOverride,
  }) async {
    try {
      error.value = '';

      final dateToUse = dateOverride ?? _currentBookingDate ?? DateTime.now();

      final res = await _repo.lockServiceProvider(
        serviceProviderId: serviceProviderId,
        bookingDate: dateToUse,
      );

      lastLockResponse.value = res;

      if (res.isSuccess) {
        _markProviderAsMine(serviceProviderId);
      }

      return res;
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      if (lockingProviderId.value == serviceProviderId) {
        lockingProviderId.value = '';
      }
    }
  }

  // -------------------------------------------------------------
  // LOCAL USER-LOCK STATE (UPDATED)
  // -------------------------------------------------------------
  void _markProviderAsMine(String id) {
    myLockedProviders.add(id);
    lastLockedProviderId.value = id;
    
    // Save to local storage with timestamp
    _saveLockedSession(id);
  }

  // -------------------------------------------------------------
  void onItemTapped(int index) => selectedIndex.value = index;
}