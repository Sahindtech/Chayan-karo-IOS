import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../remote/network_client.dart';
import '../local/database.dart';
import '../../models/customer_models.dart';

class ProfileRepository {
  // Singleton instance
  static final ProfileRepository _instance = ProfileRepository._internal();

  // Network client singleton instance
  final NetworkClient _networkClient;

  // Private named constructor
  ProfileRepository._internal() : _networkClient = NetworkClient();

  // Factory constructor returns the singleton instance
  factory ProfileRepository() => _instance;

  // Use Get.find to get the singleton database instance
  AppDatabase get _database => Get.find<AppDatabase>();

  Future<Customer> getCustomer() async {
    try {
      final token = await _database.getAuthToken();

      print('🔍 Profile Repository Debug:');
      print('   Token retrieved: ${token?.substring(0, 20) ?? 'null'}...');
      print('   Token length: ${token?.length ?? 0}');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found. Please login again.');
      }

      print('📤 Fetching customer profile using ApiService...');
      print('📤 Using token: ${token.substring(0, 20)}...');

      final response = await _networkClient.apiService.getCustomer('Bearer $token');

      print('📥 Profile API Response Type: ${response.type}');
      print('📥 Profile API Customer: ${response.result.displayName}');
      print('📥 Customer ID: ${response.result.id}');
      print('📥 Customer Phone: ${response.result.mobileNo}');
      print('📥 Customer Email: ${response.result.emailId ?? 'Not provided'}');

      await _cacheCustomerData(response.result);

      return response.result;

    } on DioException catch (e) {
      print('❌ DioException in Profile Repository: ${e.type}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Error Message: ${e.message}');
      print('❌ Response Data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        print('🔓 401 Unauthorized - Token may be expired or invalid');
        throw Exception('Session expired. Please login again.');
      } else if (e.response?.statusCode == 403) {
        print('🚫 403 Forbidden - Access denied');
        throw Exception('Access denied. Please check your permissions.');
      } else if (e.response?.statusCode == 404) {
        print('❓ 404 Not Found - Profile not found');
        throw Exception('Profile not found. Please contact support.');
      } else if (e.response?.statusCode == 500) {
        print('💥 500 Server Error - Internal server error');
        throw Exception('Server error. Please try again later.');
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {

        print('⏱️ Network timeout occurred');

        final cachedData = await _getCachedCustomerData();
        if (cachedData != null) {
          print('📋 Using cached customer data due to timeout');
          return cachedData;
        }

        throw Exception('Connection timeout. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.connectionError) {
        print('🌐 Connection error occurred');

        final cachedData = await _getCachedCustomerData();
        if (cachedData != null) {
          print('📋 Using cached customer data due to connection error');
          return cachedData;
        }

        throw Exception('No internet connection. Please check your network.');
      }

      throw Exception('Network error: ${e.message}');

    } catch (e) {
      print('❌ Generic error in Profile Repository: $e');

      if (!e.toString().contains('No authentication token') &&
          !e.toString().contains('Session expired')) {
        final cachedData = await _getCachedCustomerData();
        if (cachedData != null) {
          print('📋 Using cached customer data due to generic error');
          return cachedData;
        }
      }

      rethrow;
    }
  }

  Future<void> _cacheCustomerData(Customer customer) async {
    try {
      final customerMap = customer.toJson();
      customerMap['cached_at'] = DateTime.now().toIso8601String();

      await _database.saveUserData(customerMap);

      print('✅ Customer data cached locally:');
      print('   Name: ${customer.fullName}');
      print('   Phone: ${customer.mobileNo}');
      print('   Email: ${customer.emailId ?? 'Not provided'}');
      print('   Status: ${customer.statusText}');
      print('   Rating: ${customer.averageRating}');
    } catch (e) {
      print('⚠️ Failed to cache customer data: $e');
    }
  }

  Future<Customer?> _getCachedCustomerData() async {
    try {
      final userData = await _database.getUserData();

      print('🔍 Checking cached data:');
      print('   User data keys: ${userData.keys.toList()}');
      print('   Has ID: ${userData.containsKey('id')}');

      if (userData.isNotEmpty && userData.containsKey('id')) {
        print('📋 Loading cached customer data...');

        if (userData.containsKey('cached_at')) {
          final cachedAt = DateTime.parse(userData['cached_at']);
          final ageInHours = DateTime.now().difference(cachedAt).inHours;

          if (ageInHours > 24) {
            print('⚠️ Cached data is ${ageInHours} hours old, might be stale');
          } else {
            print('✅ Using fresh cached data (${ageInHours} hours old)');
          }
        }

        userData.remove('cached_at');
        userData.remove('login_time');
        userData.remove('login_message');
        userData.remove('phone');

        if (userData.containsKey('averageRating') && userData['averageRating'] is String) {
          userData['averageRating'] = double.tryParse(userData['averageRating'] as String) ?? 0.0;
        }
        if (userData.containsKey('status') && userData['status'] is String) {
          userData['status'] = int.tryParse(userData['status'] as String) ?? 1;
        }

        print('📋 Creating Customer from cached data: ${userData.keys.toList()}');

        return Customer.fromJson(userData);
      } else {
        print('📋 No cached customer data found');
      }
    } catch (e) {
      print('⚠️ Failed to load cached customer data: $e');
      print('⚠️ Error type: ${e.runtimeType}');
    }
    return null;
  }

  Future<void> clearCachedProfile() async {
    try {
      await _database.clearUserAndAuthData();
      print('✅ Cached profile data cleared');
    } catch (e) {
      print('⚠️ Failed to clear cached profile data: $e');
    }
  }

  Future<bool> hasCachedProfile() async {
    try {
      final userData = await _database.getUserData();
      return userData.isNotEmpty && userData.containsKey('id');
    } catch (e) {
      print('⚠️ Error checking cached profile: $e');
      return false;
    }
  }

  Future<Duration?> getCacheAge() async {
    try {
      final userData = await _database.getUserData();
      if (userData.containsKey('cached_at')) {
        final cachedAt = DateTime.parse(userData['cached_at']);
        return DateTime.now().difference(cachedAt);
      }
    } catch (e) {
      print('⚠️ Failed to get cache age: $e');
    }
    return null;
  }

  Future<Customer> refreshProfile() async {
    print('🔄 Refreshing profile data (bypassing cache)...');
    return await getCustomer();
  }

  Future<void> debugAuthState() async {
    try {
      print('🔍 Debug Auth State:');

      final token = await _database.getAuthToken();
      print('   Auth Token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');

      final userData = await _database.getUserData();
      print('   User Data Keys: ${userData.keys.toList()}');

      final authState = await _database.getAuthenticationState();
      print('   Is Logged In: ${authState['isLoggedIn']}');
      print('   Has Token: ${authState['hasToken']}');
      print('   Session Valid: ${authState['isSessionValid']}');
    } catch (e) {
      print('❌ Error debugging auth state: $e');
    }
  }
}
