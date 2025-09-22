import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import your models with a prefix to avoid conflicts
import '../../models/home_models.dart' as models;
import '../../models/cart_models.dart' as cart_models;

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

// Services table
class ServicesTable extends Table {
  @override
  String get tableName => 'services';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  TextColumn get type => text()(); // For example: 'mostUsed', 'acRepair'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
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

// Location Data table
class LocationDataTable extends Table {
  @override
  String get tableName => 'location_data';

  TextColumn get label => text()();
  TextColumn get address => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {label};
}

// Cart Items table - UPDATED to store source page and title
class CartItemsTable extends Table {
  @override
  String get tableName => 'cart_items';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  RealColumn get price => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get description => text().nullable()();
  TextColumn get rating => text().nullable()();
  TextColumn get duration => text().nullable()();
  TextColumn get originalPrice => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('general'))(); // ServiceType enum
  TextColumn get sourcePage => text().nullable()(); // NEW: Source page identifier
  TextColumn get sourceTitle => text().nullable()(); // NEW: Human-readable source title
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
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
    ServicesTable,
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
  int get schemaVersion => 3; // Increment schema version for cart table updates

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
      },
    );
  }

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

  // --- Service Categories ---

  Future<List<models.ServiceCategory>> getAllCategories() async {
    final categories = await select(serviceCategoriesTable).get();
    return categories
        .map((c) => models.ServiceCategory(title: c.title, icon: c.icon))
        .toList();
  }

  Future<void> insertCategories(List<models.ServiceCategory> categories) async {
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

  Future<void> clearCategories() async {
    await delete(serviceCategoriesTable).go();
  }

  // --- Services ---

  Future<List<models.Service>> getServicesByType(String type) async {
    final services = await (select(servicesTable)..where((s) => s.type.equals(type))).get();
    return services.map((s) => models.Service(title: s.title, image: s.image)).toList();
  }

  Future<void> insertServices(List<models.Service> services, String type) async {
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

  // --- Location Data ---

  Future<String?> getLocationLabel() async {
    final label = await getUserPreference('location_display_label');
    return label ?? 'Home';
  }

  Future<String?> getLocationAddress() async {
    final query = select(locationDataTable)..where((l) => l.label.equals('current_location'));
    final result = await query.getSingleOrNull();
    return result?.address ?? 'Not Available';
  }

  Future<void> saveLocation(String label, String address) async {
    await into(locationDataTable).insertOnConflictUpdate(
      LocationDataTableCompanion(
          label: Value('current_location'),
          address: Value(address),
          updatedAt: Value(DateTime.now())),
    );
    await saveUserPreference('location_display_label', label);
  }

  Future<void> clearLocationData() async {
    await delete(locationDataTable).go();
  }

  // --- Cart Items - UPDATED to handle new model structure ---

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
              originalPrice: item.originalPrice,
              type: _parseServiceType(item.type),
              sourcePage: item.sourcePage,
              sourceTitle: item.sourceTitle,
              dateAdded: item.addedAt,
            ))
        .toList();
  }

  // Fixed: Remove the null-aware operator since dateAdded is non-nullable
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
          image: Value(item.image),
          description: Value(item.description),
          rating: Value(item.rating),
          duration: Value(item.duration),
          originalPrice: Value(item.originalPrice),
          type: Value(item.type.toString().split('.').last),
          sourcePage: Value(item.sourcePage),
          sourceTitle: Value(item.sourceTitle),
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
          image: Value(item.image),
          price: Value(item.price),
          quantity: Value(item.quantity),
          description: Value(item.description),
          rating: Value(item.rating),
          duration: Value(item.duration),
          originalPrice: Value(item.originalPrice),
          type: Value(item.type.toString().split('.').last),
          sourcePage: Value(item.sourcePage),
          sourceTitle: Value(item.sourceTitle),
          addedAt: Value(item.dateAdded), // FIXED: Removed ?? DateTime.now()
          updatedAt: Value(DateTime.now()),
        ),
      );
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

  // Helper method to parse ServiceType from string
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

  // --- Utility ---

  Future<void> clearAllCache() async {
    await Future.wait([
      clearCategories(),
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
      delete(servicesTable).go(),
      clearLocationData(),
      clearCart(),
    ]);
  }

  // --- NEW AUTHENTICATION METHODS ---

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

  /// Save user data as JSON-like key-value pairs (FIXED)
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

  // Database Stats for Debugging
  Future<Map<String, int>> getDatabaseStats() async {
    final categoriesCount =
        await (selectOnly(serviceCategoriesTable)..addColumns([countAll()])).getSingleOrNull();
    final servicesCount =
        await (selectOnly(servicesTable)..addColumns([countAll()])).getSingleOrNull();
    final preferencesCount =
        await (selectOnly(userPreferencesTable)..addColumns([countAll()])).getSingleOrNull();
    final cartCount = await (selectOnly(cartItemsTable)..addColumns([countAll()])).getSingleOrNull();
    final authCount = await (selectOnly(authDataTable)..addColumns([countAll()])).getSingleOrNull();

    return {
      'categories': categoriesCount?.read(countAll()) ?? 0,
      'services': servicesCount?.read(countAll()) ?? 0,
      'preferences': preferencesCount?.read(countAll()) ?? 0,
      'cart_items': cartCount?.read(countAll()) ?? 0,
      'auth_data': authCount?.read(countAll()) ?? 0,
    };
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chazan_karo_db.sqlite'));
    return NativeDatabase(file);
  });
}
