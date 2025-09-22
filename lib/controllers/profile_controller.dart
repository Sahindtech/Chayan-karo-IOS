// lib/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../data/repository/profile_repository.dart';
import '../models/customer_models.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  
  final _customer = Rxn<Customer>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  
  // Getters
  Customer? get customer => _customer.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }
  
  Future<void> loadProfile() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final customerData = await _profileRepository.getCustomer();
      _customer.value = customerData;
      
     // print('✅ Profile loaded successfully: ${customerData.displayName}');
      
    } catch (e) {
      _errorMessage.value = _getErrorMessage(e.toString());
      print('❌ Error loading profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> refreshProfile() async {
    await loadProfile();
  }
  
  String getStatusText() {
    final status = _customer.value?.status;
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      case 2:
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Session expired') || error.contains('401')) {
      return 'Session expired. Please login again.';
    } else if (error.contains('No authentication token')) {
      return 'Please login to view your profile.';
    } else if (error.contains('connection') || error.contains('network') || error.contains('SocketException')) {
      return 'Network error. Check your connection.';
    } else if (error.contains('timeout')) {
      return 'Request timeout. Please try again.';
    } else {
      return 'Failed to load profile. Please try again.';
    }
  }

  // Helper method to check if user needs to login
  bool get needsLogin => _errorMessage.value.contains('login again');
  
  // Helper method to get display information
  String get userDisplayName => _customer.value?.displayName ?? 'User';
  String get userPhone => _customer.value?.mobileNo ?? '';
  double get userRating => _customer.value?.averageRating ?? 0.0;
  String? get userImage => _customer.value?.imgLink;
}
