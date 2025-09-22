import 'package:get/get.dart';
import 'package:dio/dio.dart';

// Controllers
import '../controllers/male_salon_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/salon_service_controller.dart';
import '../controllers/female_spa_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/otp_controller.dart';
import '../controllers/male_spa_controller.dart';
import '../controllers/profile_controller.dart'; // Add this

// Services and Data
import '../services/cache_service.dart';
import '../data/repository/home_repository.dart';     // Fixed path
import '../data/repository/auth_repository.dart';     // Fixed path
import '../data/repository/profile_repository.dart';  // Fixed path
import '../data/local/database.dart';
import '../data/remote/network_client.dart';
import '../data/remote/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    print('🔧 Registering GetX dependencies...');
    
    // STEP 1: Core Infrastructure (permanent dependencies)
    _registerCoreServices();
    
    // STEP 2: Network Layer (singleton pattern)
    _registerNetworkLayer();
    
    // STEP 3: Repositories (lazy loading for memory efficiency)
    _registerRepositories();
    
    // STEP 4: Controllers (based on usage patterns)
    _registerControllers();
    
    print('🎉 All GetX dependencies registered successfully');
    
    // Debug: Print all registered dependencies
    _debugRegisteredDependencies();
  }
  
  void _registerCoreServices() {
    print('📦 Registering core services...');
    
    // Database - Use singleton pattern to prevent multiple instances
    Get.put<AppDatabase>(AppDatabase(), permanent: true);
    print('✅ AppDatabase registered (permanent, singleton)');
    
    // Cache Service - Permanent
    Get.put<CacheService>(CacheService(), permanent: true);
    print('✅ CacheService registered (permanent)');
  }
  
  void _registerNetworkLayer() {
    print('🌐 Registering network layer...');
    
    // Singleton NetworkClient - will handle Dio configuration internally
    final networkClient = NetworkClient();
    Get.put<NetworkClient>(networkClient, permanent: true);
    
    // API Service from NetworkClient singleton
    Get.put<ApiService>(networkClient.apiService, permanent: true);
    print('✅ NetworkClient & ApiService registered (singleton pattern)');
  }
  
  void _registerRepositories() {
    print('📚 Registering repositories...');
    
    // Home Repository - Lazy loading with dependency injection
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        apiService: Get.find<ApiService>(),
        database: Get.find<AppDatabase>(),
      ),
      fenix: true,
    );
    print('✅ HomeRepository registered (lazy)');

    // Profile Repository - Lazy loading
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    print('✅ ProfileRepository registered (lazy)');
    
    // Auth Repository - Lazy loading for login/auth screens
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    print('✅ AuthRepository registered (lazy)');
  }
  
  void _registerControllers() {
    print('🎮 Registering controllers...');
    
    // Service Controllers - Permanent (used across multiple screens)
    Get.put<SalonServicesController>(SalonServicesController(), permanent: true);
    Get.put<FemaleSpaController>(FemaleSpaController(), permanent: true); 
    Get.put<MaleSpaController>(MaleSpaController(), permanent: true); 
    Get.put<MaleSalonController>(MaleSalonController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    print('✅ Service & Cart controllers registered (permanent)');
    
    // Navigation Controllers - Lazy (only created when screens are accessed)
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
    print('✅ Auth controllers registered (lazy)');
    
    // Home Controller - Lazy (main screen but not always needed immediately)
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    print('✅ HomeController registered (lazy)');
    
    // Profile Controller - Lazy (only needed when accessing profile screens)
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    print('✅ ProfileController registered (lazy)');
  }

  // Debug method to verify all dependencies are registered
  void _debugRegisteredDependencies() {
    print('🔍 Debugging registered dependencies:');
    
    try {
      // Test core services
      final database = Get.find<AppDatabase>();
      print('   ✅ AppDatabase: ${database.runtimeType}');
      
      final cacheService = Get.find<CacheService>();
      print('   ✅ CacheService: ${cacheService.runtimeType}');
      
      // Test network layer
      final networkClient = Get.find<NetworkClient>();
      print('   ✅ NetworkClient: ${networkClient.runtimeType}');
      
      final apiService = Get.find<ApiService>();
      print('   ✅ ApiService: ${apiService.runtimeType}');
      
      // Test if lazy repositories can be found (without instantiating)
      print('   📚 Repositories ready for lazy instantiation:');
      print('      - HomeRepository: ${Get.isRegistered<HomeRepository>()}');
      print('      - AuthRepository: ${Get.isRegistered<AuthRepository>()}');
      print('      - ProfileRepository: ${Get.isRegistered<ProfileRepository>()}');
      
      // Test if lazy controllers can be found (without instantiating)
      print('   🎮 Controllers ready:');
      print('      - LoginController (lazy): ${Get.isRegistered<LoginController>()}');
      print('      - OtpController (lazy): ${Get.isRegistered<OtpController>()}');
      print('      - HomeController (lazy): ${Get.isRegistered<HomeController>()}');
      print('      - ProfileController (lazy): ${Get.isRegistered<ProfileController>()}');
      
      // Test permanent controllers
      print('   🎮 Permanent Controllers:');
      print('      - CartController: ${Get.isRegistered<CartController>()}');
      print('      - SalonServicesController: ${Get.isRegistered<SalonServicesController>()}');
      
      print('✅ All dependencies successfully registered and accessible');
      
    } catch (e) {
      print('❌ Error in dependency registration: $e');
    }
  }
}
