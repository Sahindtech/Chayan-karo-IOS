// lib/data/repository/service_repository.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../models/service_models.dart';
import '../remote/network_client.dart';
import '../local/database.dart';

class ServiceRepository {
  // Singleton instance
  static final ServiceRepository _instance = ServiceRepository._internal();

  final NetworkClient _networkClient;

  // Private named constructor
  ServiceRepository._internal() : _networkClient = NetworkClient();

  // Factory pattern
  factory ServiceRepository() => _instance;

  // Get singleton db instance
  AppDatabase get _database => Get.find<AppDatabase>();

  // Get services by category with caching strategy
  Future<List<Service>> getServices(String serviceCategoryId) async {
    try {
      // Try to get from local database first
      final localServices = await _database.getServicesByCategory(serviceCategoryId);
      if (localServices.isNotEmpty) {
        print('📱 Returning ${localServices.length} services for category $serviceCategoryId from local database');
        return localServices;
      }

      // If no local data, fetch from API
      print('🌐 Fetching services for category $serviceCategoryId from API...');
      final token = await _database.getAuthToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await _networkClient.apiService.getServices('Bearer $token', serviceCategoryId);
      final services = response.result;
      
      // Save to local database
      await _database.insertServices(services, serviceCategoryId);
      print('💾 Saved ${services.length} services for category $serviceCategoryId to database');
      
      return services;
    } on DioException catch (e) {
      // Handle 404 - category exists but has no services yet
      if (e.response?.statusCode == 404) {
        print('ℹ️ No services available for category $serviceCategoryId (404 - Not Found)');
        return []; // Return empty list, not an error
      }
      
      print('❌ Error fetching services for category $serviceCategoryId: $e');
      
      // Try to return cached data for other errors
      final cachedServices = await _database.getServicesByCategory(serviceCategoryId);
      if (cachedServices.isNotEmpty) {
        print('🔄 Returning cached services for category $serviceCategoryId due to API error');
        return cachedServices;
      }
      
      throw e;
    } catch (e) {
      print('❌ Error fetching services for category $serviceCategoryId: $e');
      
      // Try to return cached data even if expired
      final cachedServices = await _database.getServicesByCategory(serviceCategoryId);
      if (cachedServices.isNotEmpty) {
        print('🔄 Returning cached services for category $serviceCategoryId due to error');
        return cachedServices;
      }
      
      throw e;
    }
  }

  // Refresh services from API
  Future<List<Service>> refreshServices(String serviceCategoryId) async {
    try {
      print('🔄 Force refreshing services for category $serviceCategoryId from API...');
      final token = await _database.getAuthToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await _networkClient.apiService.getServices('Bearer $token', serviceCategoryId);
      final services = response.result;
      
      // Save to local database
      await _database.clearServicesByCategory(serviceCategoryId);
      await _database.insertServices(services, serviceCategoryId);
      print('💾 Refreshed and saved ${services.length} services for category $serviceCategoryId to database');
      
      return services;
    } on DioException catch (e) {
      // Handle 404 - category exists but has no services yet
      if (e.response?.statusCode == 404) {
        print('ℹ️ No services available for category $serviceCategoryId (404 - Not Found)');
        // Clear any stale cached data
        await _database.clearServicesByCategory(serviceCategoryId);
        return []; // Return empty list, not an error
      }
      
      print('❌ Error refreshing services for category $serviceCategoryId: $e');
      throw e;
    } catch (e) {
      print('❌ Error refreshing services for category $serviceCategoryId: $e');
      throw e;
    }
  }

  // Get service by ID
  Future<Service?> getServiceById(String serviceId, String serviceCategoryId) async {
    try {
      final services = await getServices(serviceCategoryId);
      return services.firstWhere(
        (service) => service.id == serviceId,
        orElse: () => throw Exception('Service not found'),
      );
    } catch (e) {
      print('❌ Error getting service by ID: $e');
      return null;
    }
  }

  // Search services
  Future<List<Service>> searchServices(String serviceCategoryId, String query) async {
    try {
      final services = await getServices(serviceCategoryId);
      return services.where((service) =>
        service.name.toLowerCase().contains(query.toLowerCase()) ||
        service.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('❌ Error searching services: $e');
      return [];
    }
  }
}
