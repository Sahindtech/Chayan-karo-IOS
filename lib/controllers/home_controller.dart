// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../data/repository/home_repository.dart';
import '../models/home_models.dart';
import '../services/cache_service.dart';
import '../data/local/database.dart';

class HomeController extends GetxController {
  // Dependencies
  HomeRepository get _homeRepository => Get.find<HomeRepository>();
  CacheService get _cacheService => Get.find<CacheService>();
  AppDatabase get _database => Get.find<AppDatabase>();

  // Existing reactive variables (REMOVED: categories)
  final _address = 'Fetching location...'.obs;
  final _locationLabel = 'Home'.obs;
  final _isLoading = false.obs;

  // REMOVED: final RxList<ServiceCategory> _categories = <ServiceCategory>[].obs;
  final RxList<GoToService> _goToServices = <GoToService>[].obs;
  final RxList<Service> _mostUsedServices = <Service>[].obs;

  // Authentication reactive variables
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<Map<String, String?>>();
  final _isSessionValid = true.obs;

  // Getters (REMOVED: categories getter)
  String get address => _address.value;
  String get locationLabel => _locationLabel.value;
  bool get isLoading => _isLoading.value;
  
  bool get isLoggedIn => _isLoggedIn.value;
  Map<String, String?>? get currentUser => _currentUser.value;
  String get userName => _currentUser.value?['name'] ?? 'User';
  String get userPhone => _currentUser.value?['phone'] ?? '';
  bool get isSessionValid => _isSessionValid.value;
  
  RxList<GoToService> get goToServices => _goToServices;
  RxList<Service> get mostUsedServices => _mostUsedServices;

  // ADD: AC Repair Items (static data for AC repair section)
  final List<Map<String, String>> acRepairItems = [
    {'imagePath': 'assets/ac_services.webp', 'title': 'AC Services'},
    {'imagePath': 'assets/ac_repair.webp', 'title': 'AC Repair & Gas Refill'},
    {'imagePath': 'assets/ac_installation.webp', 'title': 'AC Installation'},
    {'imagePath': 'assets/ac_uninstallation.webp', 'title': 'AC Uninstallation'},
    {'imagePath': 'assets/ac_cleaning.webp', 'title': 'AC Deep Cleaning'},
  ];

  @override
  void onInit() {
    super.onInit();
    print('🏠 HomeController initialized');
    initialize();
  }

  // Initialize (REMOVED: _loadCategories call)
  Future<void> initialize() async {
    print('🏠 Starting initialization...');
    _isLoading.value = true;

    try {
      await Future.wait([
        _loadAuthState(),
        _loadSavedAddress(),
        // REMOVED: _loadCategories(), // Categories now handled by CategoryController
        _loadGoToServices(),
        _loadMostUsedServices(),
      ]);
      
      print('🏠 Initialization completed successfully');
      print('🔐 Auth State: ${_isLoggedIn.value} | User: $userName');
      print('📊 GoTo Services: ${_goToServices.length}');
      print('📊 Most Used Services: ${_mostUsedServices.length}');
      
    } catch (e) {
      print('❌ Error during initialization: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Load authentication state (NEW)
  Future<void> _loadAuthState() async {
    try {
      final isLoggedIn = await _database.isUserLoggedIn();
      final sessionValid = await _database.isSessionValid();
      final userData = await _database.getCurrentUser();
      
      _isLoggedIn.value = isLoggedIn && sessionValid;
      _isSessionValid.value = sessionValid;
      _currentUser.value = userData;
      
      print('✅ Auth state loaded: isLoggedIn=$isLoggedIn, sessionValid=$sessionValid');
      if (userData['name'] != null) {
        print('👤 Current user: ${userData['name']} (${userData['phone']})');
      }

      // If session expired but user was logged in, handle logout
      if (isLoggedIn && !sessionValid) {
        print('⚠️ Session expired, logging out user');
        await logout();
      }
    } catch (e) {
      print('❌ Error loading auth state: $e');
      _isLoggedIn.value = false;
      _isSessionValid.value = false;
      _currentUser.value = null;
    }
  }

  // Handle successful login (NEW)
  Future<void> handleSuccessfulLogin({
    required String userId,
    required String userToken,
    String? userPhone,
    String? userName,
  }) async {
    try {
      await _database.saveLoginState(
        isLoggedIn: true,
        userId: userId,
        userToken: userToken,
        userPhone: userPhone,
        userName: userName,
      );

      // Reload auth state
      await _loadAuthState();
      
      print('✅ Login state saved and loaded successfully');
      
      // Show success message
      Get.snackbar(
        'Welcome!',
        'Successfully logged in as ${userName ?? 'User'}',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      
    } catch (e) {
      print('❌ Error handling successful login: $e');
      Get.snackbar(
        'Login Error',
        'Failed to save login state. Please try again.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Logout method (NEW)
  Future<void> logout() async {
    try {
      await _database.clearAuthData();
      
      // Reset auth state
      _isLoggedIn.value = false;
      _isSessionValid.value = true;
      _currentUser.value = null;
      
      print('🚪 User logged out successfully');
      
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        backgroundColor: Colors.blue[100],
        colorText: Colors.blue[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Navigate to login screen
      Get.offAllNamed('/login');
      
    } catch (e) {
      print('❌ Error during logout: $e');
      Get.snackbar(
        'Logout Error',
        'Failed to logout. Please try again.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Update user profile (NEW)
  Future<void> updateUserProfile({
    String? name,
    String? phone,
  }) async {
    try {
      await _database.updateUserProfile(name: name, phone: phone);
      
      // Reload auth state to get updated data
      await _loadAuthState();
      
      Get.snackbar(
        'Profile Updated',
        'Your profile has been updated successfully',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      
    } catch (e) {
      print('❌ Error updating profile: $e');
      Get.snackbar(
        'Update Failed',
        'Failed to update profile. Please try again.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Check authentication status (NEW)
  Future<bool> checkAuthStatus() async {
    try {
      final isLoggedIn = await _database.isUserLoggedIn();
      final sessionValid = await _database.isSessionValid();
      
      return isLoggedIn && sessionValid;
    } catch (e) {
      print('❌ Error checking auth status: $e');
      return false;
    }
  }

  // REMOVED: _loadCategories method entirely

  Future<void> _loadGoToServices() async {
    try {
      final goToServices = await _homeRepository.getGoToServices();
      _goToServices.assignAll(goToServices);
      print('✅ GoTo services loaded: ${goToServices.length}');
    } catch (e) {
      print('❌ Error loading goto services: $e');
    }
  }

  Future<void> _loadMostUsedServices() async {
    try {
      final mostUsedServices = await _homeRepository.getMostUsedServices();
      _mostUsedServices.assignAll(mostUsedServices);
      print('✅ Most used services loaded: ${mostUsedServices.length}');
    } catch (e) {
      print('❌ Error loading most used services: $e');
    }
  }

  Future<void> _loadSavedAddress() async {
    try {
      _locationLabel.value = await _cacheService.getLocationLabel() ?? 'Home';
      _address.value = await _cacheService.getLocationAddress() ?? 'Not Available';
      print('✅ Address loaded: ${_locationLabel.value} - ${_address.value}');
    } catch (e) {
      print('❌ Error loading address: $e');
    }
  }

  Future<void> updateLocation(String label, String address) async {
    try {
      await _cacheService.saveLocation(label, address);
      _locationLabel.value = label;
      _address.value = address;
      print('✅ Location updated: $label - $address');
    } catch (e) {
      print('❌ Error updating location: $e');
    }
  }

  Future<void> refreshData() async {
    print('🔄 Refreshing data...');
    await initialize();
  }
}
