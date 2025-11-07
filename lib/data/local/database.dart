// lib/data/local/database.dart
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import your models with prefixes to avoid conflicts
import '../../models/home_models.dart' as models;
import '../../models/cart_models.dart' as cart_models;
import '../../models/category_models.dart';
import '../../models/service_models.dart' as service_models;

part 'database.g.dart';

// Service Categories table
class ServiceCategoriesTable extends Table {
  @override
  String get tableName => 'service_categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get icon => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Categories table for API categories
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  TextColumn get imgLink => text()();
  TextColumn get serviceCategory => text()(); // JSON string of ServiceSubCategory array
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {categoryId};
}

// Services table (Legacy)
class ServicesTable extends Table {
  @override
  String get tableName => 'services';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  TextColumn get type => text()(); // For example: 'mostUsed', 'acRepair'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// API Services table for service API integration
class ApiServicesTable extends Table {
  @override
  String get tableName => 'api_services';

  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get description => text()();
  IntColumn get duration => integer()();
  TextColumn get imgLink => text()();
  RealColumn get discountPercentage => real()();
  TextColumn get categoryId => text()(); // To link services to categories
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// User Preferences table
class UserPreferencesTable extends Table {
  @override
  String get tableName => 'user_preferences';

  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

// ✨ ENHANCED Location Data table with full address details
class LocationDataTable extends Table {
  @override
  String get tableName => 'location_data';

  TextColumn get id => text()(); // ✨ NEW: Unique ID for each location
  TextColumn get label => text()(); // HOME, WORK, OTHER
  TextColumn get address => text()();
  RealColumn get latitude => real()(); // ✨ NEW: Latitude coordinate
  RealColumn get longitude => real()(); // ✨ NEW: Longitude coordinate
  TextColumn get houseNumber => text().nullable()(); // ✨ NEW: House/Flat number
  TextColumn get landmark => text().nullable()(); // ✨ NEW: Landmark
  BoolColumn get isActive => boolean().withDefault(const Constant(true))(); // ✨ NEW: Active flag
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // ✨ NEW
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id}; // ✨ CHANGED: id is now primary key
}

// UPDATED: Cart Items table - Enhanced to support new cart functionality
class CartItemsTable extends Table {
  @override
  String get tableName => 'cart_items';

  TextColumn get id => text()();
  TextColumn get title => text()(); // Keep title for backward compatibility
  TextColumn get name => text().nullable()(); // NEW: Add name column for new cart model
  TextColumn get image => text()();
  RealColumn get price => real()();
  RealColumn get originalPrice => real().nullable()(); // UPDATED: Changed to RealColumn
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get description => text().nullable()();
  TextColumn get rating => text().nullable()();
  TextColumn get duration => text().nullable()();
  IntColumn get discountPercentage => integer().withDefault(const Constant(0))(); // NEW: Added discount percentage
  TextColumn get type => text().withDefault(const Constant('general'))(); // ServiceType enum
  TextColumn get sourcePage => text().nullable()(); // Source page identifier
  TextColumn get sourceTitle => text().nullable()(); // Human-readable source title
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateAdded => dateTime().nullable()(); // NEW: Support for new model dateAdded
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Authentication Data table
class AuthDataTable extends Table {
  @override
  String get tableName => 'auth_data';

  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    ServiceCategoriesTable,
    CategoriesTable,
    ServicesTable,
    ApiServicesTable,
    UserPreferencesTable,
    LocationDataTable,
    CartItemsTable,
    AuthDataTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Singleton pattern to prevent multiple instances
  static AppDatabase? _instance;
  
  // Private constructor
  AppDatabase._internal() : super(_openConnection());
  
  // Factory constructor that returns the same instance
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 7; // ✨ UPDATED: Increment for location table changes

  // Migration strategy to handle schema updates
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add auth_data table in version 2
          await m.createTable(authDataTable);
        }
        if (from < 3) {
          // Update cart items table structure in version 3
          await m.addColumn(cartItemsTable, cartItemsTable.rating);
          await m.addColumn(cartItemsTable, cartItemsTable.duration);
          await m.addColumn(cartItemsTable, cartItemsTable.originalPrice);
          await m.addColumn(cartItemsTable, cartItemsTable.type);
          await m.addColumn(cartItemsTable, cartItemsTable.sourcePage);
          await m.addColumn(cartItemsTable, cartItemsTable.sourceTitle);
        }
        if (from < 4) {
          // Add categories table in version 4
          await m.createTable(categoriesTable);
        }
        if (from < 5) {
          // Add api_services table in version 5
          await m.createTable(apiServicesTable);
        }
        if (from < 6) {
          // NEW: Enhanced cart support in version 6
          await m.addColumn(cartItemsTable, cartItemsTable.name);
          await m.addColumn(cartItemsTable, cartItemsTable.discountPercentage);
          await m.addColumn(cartItemsTable, cartItemsTable.dateAdded);
        }
        if (from < 7) {
          // ✨ NEW: Enhanced location table with coordinates and details
          await m.deleteTable('location_data');
          await m.createTable(locationDataTable);
        }
      },
    );
  }

  // =================================
  // ✨ ENHANCED LOCATION METHODS
  // =================================

  /// Save complete location data to cache
  Future<void> saveLocationFull({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
    String? houseNumber,
    String? landmark,
  }) async {
    try {
      final locationId = 'loc_${DateTime.now().millisecondsSinceEpoch}';
      
      await transaction(() async {
        // Mark all existing locations as inactive
        await (update(locationDataTable)).write(
          LocationDataTableCompanion(
            isActive: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
        
        // Insert new active location
        await into(locationDataTable).insert(
          LocationDataTableCompanion(
            id: Value(locationId),
            label: Value(label.toUpperCase()),
            address: Value(address),
            latitude: Value(latitude),
            longitude: Value(longitude),
            houseNumber: Value(houseNumber),
            landmark: Value(landmark),
            isActive: const Value(true),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });
      
      print('✅ Location saved to cache: $label - $address');
    } catch (e) {
      print('❌ Error saving location: $e');
      throw e;
    }
  }

  /// Get active (current) location
  Future<Map<String, dynamic>?> getActiveLocation() async {
    try {
      final query = select(locationDataTable)..where((l) => l.isActive.equals(true));
      final result = await query.getSingleOrNull();
      
      if (result == null) {
        print('⚠️ No active location found');
        return null;
      }
      
      return {
        'id': result.id,
        'label': result.label,
        'address': result.address,
        'latitude': result.latitude,
        'longitude': result.longitude,
        'houseNumber': result.houseNumber,
        'landmark': result.landmark,
        'createdAt': result.createdAt.toIso8601String(),
        'updatedAt': result.updatedAt.toIso8601String(),
      };
    } catch (e) {
      print('❌ Error getting active location: $e');
      return null;
    }
  }

  /// Check if location exists in cache
  Future<bool> hasLocationCached() async {
    try {
      final location = await getActiveLocation();
      return location != null;
    } catch (e) {
      print('❌ Error checking location cache: $e');
      return false;
    }
  }

  /// Get location coordinates
  Future<Map<String, double>?> getLocationCoordinates() async {
    try {
      final location = await getActiveLocation();
      if (location == null) return null;
      
      return {
        'latitude': location['latitude'],
        'longitude': location['longitude'],
      };
    } catch (e) {
      print('❌ Error getting location coordinates: $e');
      return null;
    }
  }

  /// Get all saved locations (history)
  Future<List<Map<String, dynamic>>> getAllLocations() async {
    try {
      final locations = await (select(locationDataTable)
        ..orderBy([
          (l) => OrderingTerm(expression: l.updatedAt, mode: OrderingMode.desc)
        ])
      ).get();
      
      return locations.map((loc) => {
        'id': loc.id,
        'label': loc.label,
        'address': loc.address,
        'latitude': loc.latitude,
        'longitude': loc.longitude,
        'houseNumber': loc.houseNumber,
        'landmark': loc.landmark,
        'isActive': loc.isActive,
        'createdAt': loc.createdAt.toIso8601String(),
        'updatedAt': loc.updatedAt.toIso8601String(),
      }).toList();
    } catch (e) {
      print('❌ Error getting all locations: $e');
      return [];
    }
  }

  /// Delete location by ID
  Future<void> deleteLocation(String locationId) async {
    try {
      await (delete(locationDataTable)..where((l) => l.id.equals(locationId))).go();
      print('🗑️ Location deleted: $locationId');
    } catch (e) {
      print('❌ Error deleting location: $e');
      throw e;
    }
  }

  /// Override: Get location label
  Future<String?> getLocationLabel() async {
    try {
      final location = await getActiveLocation();
      return location?['label'] ?? 'Home';
    } catch (e) {
      return 'Home';
    }
  }

  /// Override: Get location address
  Future<String?> getLocationAddress() async {
    try {
      final location = await getActiveLocation();
      if (location == null) return 'Not Available';
      
      final parts = <String>[];
      if (location['houseNumber'] != null) parts.add(location['houseNumber']);
      if (location['landmark'] != null) parts.add(location['landmark']);
      parts.add(location['address']);
      
      return parts.join(', ');
    } catch (e) {
      return 'Not Available';
    }
  }

  /// Override: Save location (legacy method for compatibility)
  Future<void> saveLocation(String label, String address) async {
    // Redirect to enhanced version with default coordinates
    await saveLocationFull(
      label: label,
      address: address,
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  /// Override: Clear location data
  Future<void> clearLocationData() async {
    try {
      await delete(locationDataTable).go();
      print('🗑️ All location data cleared');
    } catch (e) {
      print('❌ Error clearing location data: $e');
      throw e;
    }
  }

  // =================================
  // ALL YOUR EXISTING METHODS BELOW
  // (Exactly as they are in paste.txt)
  // =================================

  // --- Authentication Methods ---

  /// Check if user is currently logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final result = await getUserPreference('is_logged_in');
      return result == 'true';
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  /// Check if user has seen onboarding
  Future<bool> hasSeenOnboarding() async {
    try {
      final result = await getUserPreference('has_seen_onboarding');
      return result == 'true';
    } catch (e) {
      print('❌ Error checking onboarding status: $e');
      return false;
    }
  }

  /// Save user login state and data
  Future<void> saveLoginState({
    required bool isLoggedIn,
    String? userId,
    String? userToken,
    String? userPhone,
    String? userName,
  }) async {
    try {
      await saveUserPreference('is_logged_in', isLoggedIn.toString());
      
      if (userId != null) await saveUserPreference('user_id', userId);
      if (userToken != null) await saveUserPreference('user_token', userToken);
      if (userPhone != null) await saveUserPreference('user_phone', userPhone);
      if (userName != null) await saveUserPreference('user_name', userName);
      
      await saveUserPreference('login_timestamp', DateTime.now().toIso8601String());
      
      print('✅ Login state saved: isLoggedIn=$isLoggedIn, userId=$userId');
    } catch (e) {
      print('❌ Error saving login state: $e');
      throw e;
    }
  }

  /// Mark onboarding as completed
  Future<void> markOnboardingComplete() async {
    try {
      await saveUserPreference('has_seen_onboarding', 'true');
      await saveUserPreference('onboarding_completed_at', DateTime.now().toIso8601String());
      print('✅ Onboarding marked as complete');
    } catch (e) {
      print('❌ Error marking onboarding complete: $e');
      throw e;
    }
  }

  /// Clear all authentication data (logout)
  Future<void> clearAuthData() async {
    try {
      final authKeys = [
        'is_logged_in',
        'user_id', 
        'user_token',
        'user_phone',
        'user_name',
        'login_timestamp'
      ];
      
      for (String key in authKeys) {
        await removeUserPreference(key);
      }
      
      print('✅ Authentication data cleared');
    } catch (e) {
      print('❌ Error clearing auth data: $e');
      throw e;
    }
  }

  /// Get all authentication data
  Future<Map<String, String?>> getAuthData() async {
    try {
      return {
        'userId': await getUserPreference('user_id'),
        'userToken': await getUserPreference('user_token'),
        'userPhone': await getUserPreference('user_phone'),
        'userName': await getUserPreference('user_name'),
        'loginTimestamp': await getUserPreference('login_timestamp'),
      };
    } catch (e) {
      print('❌ Error getting auth data: $e');
      return {};
    }
  }

  /// Get current user info
  Future<Map<String, String?>> getCurrentUser() async {
    final authData = await getAuthData();
    return {
      'id': authData['userId'],
      'name': authData['userName'],
      'phone': authData['userPhone'],
      'token': authData['userToken'],
    };
  }

  /// Check if user session is valid (not expired)
  Future<bool> isSessionValid() async {
    try {
      final isLoggedIn = await isUserLoggedIn();
      if (!isLoggedIn) return false;

      final loginTimestamp = await getUserPreference('login_timestamp');
      if (loginTimestamp == null) return false;

      final loginTime = DateTime.parse(loginTimestamp);
      final now = DateTime.now();
      final daysDifference = now.difference(loginTime).inDays;

      // Session expires after 30 days
      return daysDifference < 30;
    } catch (e) {
      print('❌ Error checking session validity: $e');
      return false;
    }
  }

  /// Update user profile data
  Future<void> updateUserProfile({
    String? name,
    String? phone,
  }) async {
    try {
      if (name != null) await saveUserPreference('user_name', name);
      if (phone != null) await saveUserPreference('user_phone', phone);
      
      await saveUserPreference('profile_updated_at', DateTime.now().toIso8601String());
      print('✅ User profile updated');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      throw e;
    }
  }

  // --- Service Categories (Legacy) - RENAMED to avoid conflicts ---

  Future<List<models.ServiceCategory>> getAllServiceCategories() async {
    final categories = await select(serviceCategoriesTable).get();
    return categories
        .map((c) => models.ServiceCategory(title: c.title, icon: c.icon))
        .toList();
  }

  Future<void> insertServiceCategories(List<models.ServiceCategory> categories) async {
    await batch((batch) {
      batch.insertAll(
        serviceCategoriesTable,
        categories
            .map((c) =>
                ServiceCategoriesTableCompanion(title: Value(c.title), icon: Value(c.icon)))
            .toList(),
      );
    });
  }

  Future<void> clearServiceCategories() async {
    await delete(serviceCategoriesTable).go();
  }

  // --- API Categories Methods (Primary category methods) ---

  /// Insert categories from API
  Future<void> insertCategories(List<Category> categories) async {
    try {
      await transaction(() async {
        for (final category in categories) {
          await into(categoriesTable).insertOnConflictUpdate(
            CategoriesTableCompanion(
              categoryId: Value(category.categoryId),
              categoryName: Value(category.categoryName),
              imgLink: Value(category.imgLink),
              serviceCategory: Value(jsonEncode(category.serviceCategory.map((e) => e.toJson()).toList())),
              createdAt: Value(DateTime.now()),
            ),
          );
        }
      });
      print('💾 Inserted ${categories.length} API categories into database');
    } catch (e) {
      print('❌ Error inserting API categories: $e');
      throw e;
    }
  }

  /// Get all API categories
  Future<List<Category>> getAllCategories() async {
    try {
      final results = await (select(categoriesTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
      ).get();
      
      return results.map((row) {
        final serviceCategories = (jsonDecode(row.serviceCategory) as List)
            .map((e) => ServiceSubCategory.fromJson(e as Map<String, dynamic>))
            .toList();
        
        return Category(
          categoryId: row.categoryId,
          categoryName: row.categoryName,
          imgLink: row.imgLink,
          serviceCategory: serviceCategories,
        );
      }).toList();
    } catch (e) {
      print('❌ Error getting API categories: $e');
      return [];
    }
  }

  /// Clear API categories
  Future<void> clearCategories() async {
    try {
      await delete(categoriesTable).go();
      print('🗑️ Cleared API categories table');
    } catch (e) {
      print('❌ Error clearing API categories: $e');
      throw e;
    }
  }

  /// Get category by ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      final query = select(categoriesTable)..where((c) => c.categoryId.equals(categoryId));
      final result = await query.getSingleOrNull();
      
      if (result == null) return null;
      
      final serviceCategories = (jsonDecode(result.serviceCategory) as List)
          .map((e) => ServiceSubCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      
      return Category(
        categoryId: result.categoryId,
        categoryName: result.categoryName,
        imgLink: result.imgLink,
        serviceCategory: serviceCategories,
      );
    } catch (e) {
      print('❌ Error getting category by ID: $e');
      return null;
    }
  }

  /// Search categories by name
  Future<List<Category>> searchCategories(String query) async {
    try {
      final results = await (select(categoriesTable)
        ..where((c) => c.categoryName.like('%$query%'))
        ..orderBy([
          (t) => OrderingTerm(expression: t.categoryName, mode: OrderingMode.asc)
        ])
      ).get();
      
      return results.map((row) {
        final serviceCategories = (jsonDecode(row.serviceCategory) as List)
            .map((e) => ServiceSubCategory.fromJson(e as Map<String, dynamic>))
            .toList();
        
        return Category(
          categoryId: row.categoryId,
          categoryName: row.categoryName,
          imgLink: row.imgLink,
          serviceCategory: serviceCategories,
        );
      }).toList();
    } catch (e) {
      print('❌ Error searching categories: $e');
      return [];
    }
  }

  /// Get categories count
  Future<int> getCategoriesCount() async {
    try {
      final result = await (selectOnly(categoriesTable)..addColumns([countAll()])).getSingleOrNull();
      return result?.read(countAll()) ?? 0;
    } catch (e) {
      print('❌ Error getting categories count: $e');
      return 0;
    }
  }

  /// Check if categories exist
  Future<bool> hasCachedCategories() async {
    final count = await getCategoriesCount();
    return count > 0;
  }

  /// Get categories cache age
  Future<Duration?> getCategoriesCacheAge() async {
    try {
      final query = select(categoriesTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(1);
      
      final result = await query.getSingleOrNull();
      if (result == null) return null;
      
      return DateTime.now().difference(result.createdAt);
    } catch (e) {
      print('❌ Error getting categories cache age: $e');
      return null;
    }
  }

  // --- API Services Methods ---

  /// Insert services from API
  Future<void> insertServices(List<service_models.Service> services, String categoryId) async {
    try {
      await transaction(() async {
        for (final service in services) {
          await into(apiServicesTable).insertOnConflictUpdate(
            ApiServicesTableCompanion(
              id: Value(service.id),
              name: Value(service.name),
              price: Value(service.price),
              description: Value(service.description),
              duration: Value(service.duration),
              imgLink: Value(service.imgLink),
              discountPercentage: Value(service.discountPercentage),
              categoryId: Value(categoryId),
              createdAt: Value(DateTime.now()),
            ),
          );
        }
      });
      print('💾 Inserted ${services.length} API services for category $categoryId into database');
    } catch (e) {
      print('❌ Error inserting API services: $e');
      throw e;
    }
  }

  /// Get services by category from local database
  Future<List<service_models.Service>> getServicesByCategory(String categoryId) async {
    try {
      final results = await (select(apiServicesTable)
        ..where((s) => s.categoryId.equals(categoryId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
      ).get();
      
      return results.map((row) => service_models.Service(
        id: row.id,
        name: row.name,
        price: row.price,
        description: row.description,
        duration: row.duration,
        imgLink: row.imgLink,
        discountPercentage: row.discountPercentage,
      )).toList();
    } catch (e) {
      print('❌ Error getting services by category: $e');
      return [];
    }
  }

  /// Get all API services
  Future<List<service_models.Service>> getAllServices() async {
    try {
      final results = await (select(apiServicesTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
      ).get();
      
      return results.map((row) => service_models.Service(
        id: row.id,
        name: row.name,
        price: row.price,
        description: row.description,
        duration: row.duration,
        imgLink: row.imgLink,
        discountPercentage: row.discountPercentage,
      )).toList();
    } catch (e) {
      print('❌ Error getting all API services: $e');
      return [];
    }
  }

  /// Clear services by category
  Future<void> clearServicesByCategory(String categoryId) async {
    try {
      await (delete(apiServicesTable)..where((s) => s.categoryId.equals(categoryId))).go();
      print('🗑️ Cleared services for category $categoryId');
    } catch (e) {
      print('❌ Error clearing services by category: $e');
      throw e;
    }
  }

  /// Clear all API services
  Future<void> clearServices() async {
    try {
      await delete(apiServicesTable).go();
      print('🗑️ Cleared all API services table');
    } catch (e) {
      print('❌ Error clearing API services: $e');
      throw e;
    }
  }

  /// Get service by ID
  Future<service_models.Service?> getServiceById(String serviceId) async {
    try {
      final query = select(apiServicesTable)..where((s) => s.id.equals(serviceId));
      final result = await query.getSingleOrNull();
      
      if (result == null) return null;
      
      return service_models.Service(
        id: result.id,
        name: result.name,
        price: result.price,
        description: result.description,
        duration: result.duration,
        imgLink: result.imgLink,
        discountPercentage: result.discountPercentage,
      );
    } catch (e) {
      print('❌ Error getting service by ID: $e');
      return null;
    }
  }

  /// Search services by name or description
  Future<List<service_models.Service>> searchServices(String query) async {
    try {
      final results = await (select(apiServicesTable)
        ..where((s) => s.name.like('%$query%') | s.description.like('%$query%'))
        ..orderBy([
          (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
        ])
      ).get();
      
      return results.map((row) => service_models.Service(
        id: row.id,
        name: row.name,
        price: row.price,
        description: row.description,
        duration: row.duration,
        imgLink: row.imgLink,
        discountPercentage: row.discountPercentage,
      )).toList();
    } catch (e) {
      print('❌ Error searching services: $e');
      return [];
    }
  }

  /// Get services count for a category
  Future<int> getServicesCategoryCount(String categoryId) async {
    try {
      final result = await (selectOnly(apiServicesTable)
        ..addColumns([countAll()])
        ..where(apiServicesTable.categoryId.equals(categoryId))
      ).getSingleOrNull();
      return result?.read(countAll()) ?? 0;
    } catch (e) {
      print('❌ Error getting services count for category: $e');
      return 0;
    }
  }

  /// Get total services count
  Future<int> getTotalServicesCount() async {
    try {
      final result = await (selectOnly(apiServicesTable)..addColumns([countAll()])).getSingleOrNull();
      return result?.read(countAll()) ?? 0;
    } catch (e) {
      print('❌ Error getting total services count: $e');
      return 0;
    }
  }

  /// Check if services exist for category
  Future<bool> hasCachedServices(String categoryId) async {
    final count = await getServicesCategoryCount(categoryId);
    return count > 0;
  }

  /// Get services cache age for category
  Future<Duration?> getServicesCacheAge(String categoryId) async {
    try {
      final query = select(apiServicesTable)
        ..where((s) => s.categoryId.equals(categoryId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(1);
      
      final result = await query.getSingleOrNull();
      if (result == null) return null;
      
      return DateTime.now().difference(result.createdAt);
    } catch (e) {
      print('❌ Error getting services cache age: $e');
      return null;
    }
  }

  /// Get popular services (placeholder logic)
  Future<List<service_models.Service>> getPopularServices({int limit = 10}) async {
    try {
      final results = await (select(apiServicesTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(limit)
      ).get();
      
      return results.map((row) => service_models.Service(
        id: row.id,
        name: row.name,
        price: row.price,
        description: row.description,
        duration: row.duration,
        imgLink: row.imgLink,
        discountPercentage: row.discountPercentage,
      )).toList();
    } catch (e) {
      print('❌ Error getting popular services: $e');
      return [];
    }
  }

  // --- Legacy Services (keeping existing functionality) ---

  Future<List<models.Service>> getServicesByType(String type) async {
    final services = await (select(servicesTable)..where((s) => s.type.equals(type))).get();
    return services.map((s) => models.Service(title: s.title, image: s.image)).toList();
  }

  Future<void> insertLegacyServices(List<models.Service> services, String type) async {
    await (delete(servicesTable)..where((s) => s.type.equals(type))).go();
    await batch((batch) {
      batch.insertAll(
        servicesTable,
        services
            .map((s) => ServicesTableCompanion(
                title: Value(s.title), image: Value(s.image), type: Value(type)))
            .toList(),
      );
    });
  }

  // --- User Preferences ---

  Future<String?> getUserPreference(String key) async {
    final query = select(userPreferencesTable)..where((p) => p.key.equals(key));
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  Future<void> saveUserPreference(String key, String value) async {
    await into(userPreferencesTable).insertOnConflictUpdate(
      UserPreferencesTableCompanion(
          key: Value(key), value: Value(value), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> removeUserPreference(String key) async {
    await (delete(userPreferencesTable)..where((p) => p.key.equals(key))).go();
  }

  Future<Map<String, String>> getAllUserPreferences() async {
    final prefs = await select(userPreferencesTable).get();
    return {for (var pref in prefs) pref.key: pref.value};
  }

  // --- ENHANCED Cart Items - Supporting both old and new cart models ---

  /// Get all cart items (Legacy support with cart_models)
  Future<List<cart_models.CartItem>> getAllCartItems() async {
    final items = await (select(cartItemsTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc)
      ])
    ).get();
    
    return items
        .map((item) => cart_models.CartItem(
              id: item.id,
              title: item.title,
              image: item.image,
              price: item.price,
              quantity: item.quantity,
              description: item.description,
              rating: item.rating,
              duration: item.duration,
              originalPrice: item.originalPrice?.toString(),
              type: _parseServiceType(item.type),
              sourcePage: item.sourcePage,
              sourceTitle: item.sourceTitle,
              dateAdded: item.dateAdded ?? item.addedAt,
            ))
        .toList();
  }

  /// NEW: Get all cart items using new service_models.CartItem
  Future<List<service_models.CartItem>> getAllNewCartItems() async {
    try {
      final items = await (select(cartItemsTable)
        ..orderBy([
          (t) => OrderingTerm(expression: t.dateAdded, mode: OrderingMode.desc)
        ])
      ).get();
      
      return items.map((item) => service_models.CartItem(
        id: item.id,
        name: item.name ?? item.title, // Use name if available, fallback to title
        image: item.image,
        price: item.price,
        originalPrice: item.originalPrice ?? item.price,
        quantity: item.quantity,
        description: item.description ?? '',
        rating: item.rating ?? '0.0',
        duration: item.duration ?? '',
        discountPercentage: item.discountPercentage,
        sourcePage: item.sourcePage ?? 'unknown',
        sourceTitle: item.sourceTitle ?? 'Unknown Service',
        dateAdded: item.dateAdded ?? item.addedAt,
      )).toList();
    } catch (e) {
      print('❌ Error getting new cart items: $e');
      return [];
    }
  }

  /// Legacy cart item insertion (backward compatibility)
  Future<void> insertCartItem(cart_models.CartItem item) async {
    // Check if item already exists
    final existingItem = await (select(cartItemsTable)
      ..where((tbl) => tbl.id.equals(item.id))
    ).getSingleOrNull();
    
    if (existingItem != null) {
      // Update existing item but PRESERVE original addedAt
      await (update(cartItemsTable)..where((tbl) => tbl.id.equals(item.id))).write(
        CartItemsTableCompanion(
          quantity: Value(item.quantity),
          price: Value(item.price),
          title: Value(item.title),
          name: Value(item.title), // Set name same as title for compatibility
          image: Value(item.image),
          description: Value(item.description),
          rating: Value(item.rating),
          duration: Value(item.duration),
          originalPrice: Value(double.tryParse(item.originalPrice ?? '0') ?? item.price),
          type: Value(item.type.toString().split('.').last),
          sourcePage: Value(item.sourcePage),
          sourceTitle: Value(item.sourceTitle),
          discountPercentage: Value(0), // Default for legacy items
          // Keep original addedAt, only update updatedAt
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Insert new item with its dateAdded
      await into(cartItemsTable).insert(
        CartItemsTableCompanion(
          id: Value(item.id),
          title: Value(item.title),
          name: Value(item.title), // Set name same as title for compatibility
          image: Value(item.image),
          price: Value(item.price),
          originalPrice: Value(double.tryParse(item.originalPrice ?? '0') ?? item.price),
          quantity: Value(item.quantity),
          description: Value(item.description),
          rating: Value(item.rating),
          duration: Value(item.duration),
          type: Value(item.type.toString().split('.').last),
          sourcePage: Value(item.sourcePage),
          sourceTitle: Value(item.sourceTitle),
          discountPercentage: Value(0), // Default for legacy items
          addedAt: Value(item.dateAdded),
          dateAdded: Value(item.dateAdded),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  /// NEW: Insert or update cart item using new service_models.CartItem
  Future<void> insertOrUpdateCartItem(service_models.CartItem item) async {
    try {
      await into(cartItemsTable).insertOnConflictUpdate(
        CartItemsTableCompanion(
          id: Value(item.id),
          title: Value(item.name), // Use name for title (backward compatibility)
          name: Value(item.name),
          image: Value(item.image),
          price: Value(item.price),
          originalPrice: Value(item.originalPrice),
          quantity: Value(item.quantity),
          description: Value(item.description),
          rating: Value(item.rating),
          duration: Value(item.duration),
          discountPercentage: Value(item.discountPercentage),
          sourcePage: Value(item.sourcePage),
          sourceTitle: Value(item.sourceTitle),
          addedAt: Value(item.dateAdded),
          dateAdded: Value(item.dateAdded),
          updatedAt: Value(DateTime.now()),
        ),
      );
      print('💾 Cart item saved: ${item.name}');
    } catch (e) {
      print('❌ Error inserting/updating cart item: $e');
      throw e;
    }
  }

  Future<void> updateCartItemQuantity(String id, int quantity) async {
    await (update(cartItemsTable)..where((tbl) => tbl.id.equals(id))).write(
      CartItemsTableCompanion(
        quantity: Value(quantity),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> removeCartItem(String id) async {
    await (delete(cartItemsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> clearCart() async {
    await delete(cartItemsTable).go();
  }

  /// NEW: Clear all cart items (alias for clearCart)
  Future<void> clearAllCartItems() async => clearCart();

  Future<int> getCartItemCount() async {
    final result =
        await (selectOnly(cartItemsTable)..addColumns([cartItemsTable.quantity.sum()]))
            .getSingleOrNull();
    return result?.read(cartItemsTable.quantity.sum()) ?? 0;
  }

  Future<double> getTotalAmount() async {
    double total = 0;
    final items = await getAllCartItems();
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  /// NEW: Get total cart amount (alias for getTotalAmount)
  Future<double> getTotalCartAmount() async => getTotalAmount();

  /// NEW: Get cart items by source
  Future<List<service_models.CartItem>> getCartItemsBySource(String sourcePage) async {
    try {
      final items = await (select(cartItemsTable)
        ..where((item) => item.sourcePage.equals(sourcePage))
        ..orderBy([
          (t) => OrderingTerm(expression: t.dateAdded, mode: OrderingMode.desc)
        ])
      ).get();
      
      return items.map((item) => service_models.CartItem(
        id: item.id,
        name: item.name ?? item.title,
        image: item.image,
        price: item.price,
        originalPrice: item.originalPrice ?? item.price,
        quantity: item.quantity,
        description: item.description ?? '',
        rating: item.rating ?? '0.0',
        duration: item.duration ?? '',
        discountPercentage: item.discountPercentage,
        sourcePage: item.sourcePage ?? 'unknown',
        sourceTitle: item.sourceTitle ?? 'Unknown Service',
        dateAdded: item.dateAdded ?? item.addedAt,
      )).toList();
    } catch (e) {
      print('❌ Error getting cart items by source: $e');
      return [];
    }
  }

  /// NEW: Get comprehensive cart statistics
  Future<Map<String, dynamic>> getCartStats() async {
    try {
      final items = await getAllNewCartItems();
      final totalItems = items.fold(0, (sum, item) => sum + item.quantity);
      final totalPrice = items.fold(0.0, (sum, item) => sum + item.totalPrice);
      final totalSavings = items.fold(0.0, (sum, item) => sum + item.totalSavings);
      
      // Group by source
      final sourceGroups = <String, List<service_models.CartItem>>{};
      for (var item in items) {
        if (!sourceGroups.containsKey(item.sourceTitle)) {
          sourceGroups[item.sourceTitle] = [];
        }
        sourceGroups[item.sourceTitle]!.add(item);
      }
      
      return {
        'totalItems': totalItems,
        'uniqueItems': items.length,
        'totalPrice': totalPrice,
        'totalSavings': totalSavings,
        'sourceCount': sourceGroups.length,
        'sources': sourceGroups.keys.toList(),
        'averageItemPrice': totalItems > 0 ? totalPrice / totalItems : 0.0,
        'hasDiscounts': items.any((item) => item.hasDiscount),
      };
    } catch (e) {
      print('❌ Error getting cart statistics: $e');
      return {};
    }
  }

  // Helper method to parse ServiceType from string (for legacy compatibility)
  cart_models.ServiceType _parseServiceType(String typeString) {
    switch (typeString) {
      case 'salon':
        return cart_models.ServiceType.salon;
      case 'spa':
        return cart_models.ServiceType.spa;
      default:
        return cart_models.ServiceType.general;
    }
  }

  // --- Enhanced Authentication Methods ---

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    try {
      await into(authDataTable).insertOnConflictUpdate(
        AuthDataTableCompanion(
          key: const Value('auth_token'),
          value: Value(token),
          updatedAt: Value(DateTime.now()),
        ),
      );
      print('🔑 Auth token saved: ${token.substring(0, 20)}...');
    } catch (e) {
      print('❌ Error saving auth token: $e');
      throw e;
    }
  }

  /// Get stored authentication token
  Future<String?> getAuthToken() async {
    try {
      final query = select(authDataTable)..where((auth) => auth.key.equals('auth_token'));
      final result = await query.getSingleOrNull();
      final token = result?.value;
      
      if (token != null) {
        print('🔍 Auth token retrieved: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No auth token found in database');
      }
      
      return token;
    } catch (e) {
      print('❌ Error getting auth token: $e');
      return null;
    }
  }

  /// Save user data as JSON-like key-value pairs
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      // Use transaction for atomic operation
      await transaction(() async {
        for (final entry in userData.entries) {
          await into(authDataTable).insertOnConflictUpdate(
            AuthDataTableCompanion(
              key: Value('user_${entry.key}'),
              value: Value(entry.value.toString()),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      });
      
      print('✅ User data saved: ${userData.keys.join(', ')}');
    } catch (e) {
      print('❌ Error saving user data: $e');
      throw e;
    }
  }

  /// Get all user data
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final query = select(authDataTable)..where((auth) => auth.key.like('user_%'));
      final results = await query.get();
      
      final userData = <String, dynamic>{};
      for (final result in results) {
        // Remove 'user_' prefix from key
        final key = result.key.substring(5);
        userData[key] = result.value;
      }
      
      return userData;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return {};
    }
  }

  /// Save user login status (simplified)
  Future<void> saveUserLoginStatus(bool isLoggedIn) async {
    try {
      await saveUserPreference('is_logged_in', isLoggedIn.toString());
      await saveUserPreference('login_timestamp', DateTime.now().toIso8601String());
      print('✅ User login status saved: $isLoggedIn');
    } catch (e) {
      print('❌ Error saving user login status: $e');
      throw e;
    }
  }

  /// Clear all user and auth data (comprehensive logout)
  Future<void> clearUserAndAuthData() async {
    try {
      // Clear auth data table
      await delete(authDataTable).go();
      
      // Clear auth-related preferences
      final authKeys = [
        'is_logged_in',
        'user_id', 
        'user_token',
        'user_phone',
        'user_name',
        'login_timestamp'
      ];
      
      for (String key in authKeys) {
        await removeUserPreference(key);
      }
      
      print('✅ All user and auth data cleared');
    } catch (e) {
      print('❌ Error clearing user and auth data: $e');
      throw e;
    }
  }

  /// Check if refresh token exists and is valid
  Future<bool> hasValidRefreshToken() async {
    try {
      final query = select(authDataTable)..where((auth) => auth.key.equals('refresh_token'));
      final result = await query.getSingleOrNull();
      
      if (result == null) return false;
      
      // You can add expiration logic here if needed
      return result.value.isNotEmpty;
    } catch (e) {
      print('❌ Error checking refresh token: $e');
      return false;
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await into(authDataTable).insertOnConflictUpdate(
        AuthDataTableCompanion(
          key: const Value('refresh_token'),
          value: Value(refreshToken),
          updatedAt: Value(DateTime.now()),
        ),
      );
      print('✅ Refresh token saved');
    } catch (e) {
      print('❌ Error saving refresh token: $e');
      throw e;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      final query = select(authDataTable)..where((auth) => auth.key.equals('refresh_token'));
      final result = await query.getSingleOrNull();
      return result?.value;
    } catch (e) {
      print('❌ Error getting refresh token: $e');
      return null;
    }
  }

  /// Enhanced session validation with token check
  Future<bool> isSessionValidEnhanced() async {
    try {
      // Check basic login status
      final isLoggedIn = await isUserLoggedIn();
      if (!isLoggedIn) return false;
      
      // Check if we have a valid token
      final token = await getAuthToken();
      if (token == null || token.isEmpty) return false;
      
      // Check timestamp-based expiration
      final loginTimestamp = await getUserPreference('login_timestamp');
      if (loginTimestamp == null) return false;
      
      final loginTime = DateTime.parse(loginTimestamp);
      final now = DateTime.now();
      final daysDifference = now.difference(loginTime).inDays;
      
      // Session expires after 30 days
      return daysDifference < 30;
    } catch (e) {
      print('❌ Error checking enhanced session validity: $e');
      return false;
    }
  }

  /// Get complete authentication state
  Future<Map<String, dynamic>> getAuthenticationState() async {
    try {
      final isLoggedIn = await isUserLoggedIn();
      final isSessionValid = await isSessionValidEnhanced();
      final userData = await getUserData();
      final token = await getAuthToken();
      final refreshToken = await getRefreshToken();
      
      return {
        'isLoggedIn': isLoggedIn,
        'isSessionValid': isSessionValid,
        'hasToken': token != null && token.isNotEmpty,
        'hasRefreshToken': refreshToken != null && refreshToken.isNotEmpty,
        'userData': userData,
        'tokenExists': token != null,
      };
    } catch (e) {
      print('❌ Error getting authentication state: $e');
      return {
        'isLoggedIn': false,
        'isSessionValid': false,
        'hasToken': false,
        'hasRefreshToken': false,
        'userData': {},
        'tokenExists': false,
      };
    }
  }

  // --- Utility Methods ---

  Future<void> clearAllCache() async {
    await Future.wait([
      clearCategories(), // API categories
      clearServices(), // API services
      clearServiceCategories(), // Legacy service categories
      delete(servicesTable).go(),
      delete(userPreferencesTable).go(),
      clearLocationData(),
      clearCart(),
    ]);
  }

  /// Clear all data except authentication (for app reset)
  Future<void> clearAllDataExceptAuth() async {
    await Future.wait([
      clearCategories(),
      clearServices(),
      clearServiceCategories(),
      delete(servicesTable).go(),
      clearLocationData(),
      clearCart(),
    ]);
  }

  // Database Stats for Debugging
  Future<Map<String, int>> getDatabaseStats() async {
    final serviceCategoriesCount =
        await (selectOnly(serviceCategoriesTable)..addColumns([countAll()])).getSingleOrNull();
    final categoriesCount =
        await (selectOnly(categoriesTable)..addColumns([countAll()])).getSingleOrNull();
    final servicesCount =
        await (selectOnly(servicesTable)..addColumns([countAll()])).getSingleOrNull();
    final apiServicesCount =
        await (selectOnly(apiServicesTable)..addColumns([countAll()])).getSingleOrNull();
    final preferencesCount =
        await (selectOnly(userPreferencesTable)..addColumns([countAll()])).getSingleOrNull();
    final cartCount = await (selectOnly(cartItemsTable)..addColumns([countAll()])).getSingleOrNull();
    final authCount = await (selectOnly(authDataTable)..addColumns([countAll()])).getSingleOrNull();

    return {
      'service_categories': serviceCategoriesCount?.read(countAll()) ?? 0,
      'api_categories': categoriesCount?.read(countAll()) ?? 0,
      'services': servicesCount?.read(countAll()) ?? 0,
      'api_services': apiServicesCount?.read(countAll()) ?? 0,
      'preferences': preferencesCount?.read(countAll()) ?? 0,
      'cart_items': cartCount?.read(countAll()) ?? 0,
      'auth_data': authCount?.read(countAll()) ?? 0,
    };
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return NativeDatabase(File(p.join(dbFolder.path, 'chazan_karo_db.sqlite')));
  });
}
