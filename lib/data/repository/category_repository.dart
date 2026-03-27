// lib/data/repository/category_repository.dart
import 'package:get/get.dart';
import '../../models/category_models.dart';
import '../remote/network_client.dart';
import '../local/database.dart';

class CategoryRepository {
  // Singleton instance
  static final CategoryRepository _instance = CategoryRepository._internal();

  final NetworkClient _networkClient;

  // Private named constructor
  CategoryRepository._internal() : _networkClient = NetworkClient();

  // Factory pattern
  factory CategoryRepository() => _instance;

  // Get singleton db instance
  AppDatabase get _database => Get.find<AppDatabase>();

  // Get categories with caching strategy
  Future<List<Category>> getCategories() async {
    try {
      // Try to get from local database first
      final localCategories = await _database.getAllCategories();
      if (localCategories.isNotEmpty) {
        print('📱 Returning ${localCategories.length} categories from local database');
        return localCategories;
      }

      // If no local data, fetch from API
      print('🌐 Fetching categories from API...');
      final token = await _database.getAuthToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await _networkClient.apiService.getCategories('Bearer $token');
      final categories = response.result;
      
      // Save to local database
      await _database.clearCategories();
      await _database.insertCategories(categories);
      print('💾 Saved ${categories.length} categories to database');
      
      return categories;
    } catch (e) {
      print('❌ Error fetching categories: $e');
      
      // Try to return cached data even if expired
      final cachedCategories = await _database.getAllCategories();
      if (cachedCategories.isNotEmpty) {
        print('🔄 Returning cached categories due to API error');
        return cachedCategories;
      }
      
      rethrow;
    }
  }

  // Refresh categories from API
  Future<List<Category>> refreshCategories() async {
    try {
      print('🔄 Force refreshing categories from API...');
      final token = await _database.getAuthToken();
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await _networkClient.apiService.getCategories('Bearer $token');
      final categories = response.result;
      
      // Save to local database
      await _database.clearCategories();
      await _database.insertCategories(categories);
      print('💾 Refreshed and saved ${categories.length} categories to database');
      
      return categories;
    } catch (e) {
      print('❌ Error refreshing categories: $e');
      rethrow;
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      final categories = await getCategories();
      return categories.firstWhere(
        (category) => category.categoryId == categoryId,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (e) {
      print('❌ Error getting category by ID: $e');
      return null;
    }
  }

  // Get service subcategories for a category
  Future<List<ServiceSubCategory>> getServiceSubCategories(String categoryId) async {
    try {
      final category = await getCategoryById(categoryId);
      return category?.serviceCategory ?? [];
    } catch (e) {
      print('❌ Error getting service subcategories: $e');
      return [];
    }
  }

  // Search categories
  Future<List<Category>> searchCategories(String query) async {
    try {
      final categories = await getCategories();
      return categories.where((category) =>
        category.categoryName.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('❌ Error searching categories: $e');
      return [];
    }
  }
}
