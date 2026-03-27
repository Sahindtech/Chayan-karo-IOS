// lib/core/bindings/app_binding.dart
import 'package:get/get.dart';
import '../controllers/financial_controller.dart';
import '../data/repository/financial_repository.dart';
// Controllers
import '../../controllers/male_salon_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/salon_service_controller.dart';
import '../../controllers/female_spa_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/otp_controller.dart';
import '../../controllers/male_spa_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/saathi_controller.dart';
import '../../controllers/payment_controller.dart';
import '../controllers/coupon_controller.dart';
import '../data/repository/coupon_repository.dart';
// NEW
import '../../controllers/booking_controller.dart';
import '../../controllers/booking_read_controller.dart'; // if you have a list reader

// Services and Data
import '../../services/cache_service.dart';
import '../../data/repository/home_repository.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/profile_repository.dart';
import '../../data/repository/location_repository.dart';
import '../../data/repository/banner_repository.dart';
import '../controllers/banner_controller.dart';
// NEW
import '../../data/repository/booking_repository.dart';

import '../../data/local/database.dart';
import '../../data/remote/network_client.dart';
import '../../data/remote/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    print('🔧 Registering GetX dependencies...');

    _registerCoreServices();
    _registerNetworkLayer();
    _registerRepositories();
    _registerControllers();

    print('🎉 All GetX dependencies registered successfully');

    _debugRegisteredDependencies();
  }

  void _registerCoreServices() {
    print('📦 Registering core services...');
    Get.put<AppDatabase>(AppDatabase(), permanent: true);
    print('✅ AppDatabase registered (permanent, singleton)');

    Get.put<CacheService>(CacheService(), permanent: true);
    print('✅ CacheService registered (permanent)');
  }

  void _registerNetworkLayer() {
    print('🌐 Registering network layer...');

    final networkClient = NetworkClient(); // singleton
    Get.put<NetworkClient>(networkClient, permanent: true);

    Get.put<ApiService>(networkClient.apiService, permanent: true);
    print('✅ NetworkClient & ApiService registered (singleton pattern)');
  }

  void _registerRepositories() {
    print('📚 Registering repositories...');

    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        database: Get.find<AppDatabase>(),
      ),
      fenix: true,
    );
    print('✅ HomeRepository registered (lazy)');

    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    print('✅ ProfileRepository registered (lazy)');

    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    print('✅ AuthRepository registered (lazy)');

    Get.lazyPut<LocationRepository>(
      () => LocationRepository(
        apiService: Get.find<ApiService>(),
        database: Get.find<AppDatabase>(),
      ),
      fenix: true,
    );
    print('✅ LocationRepository registered (lazy)');

    // NEW: BookingRepository (uses NetworkClient->ApiService internally for tokenized calls)
    Get.lazyPut<BookingRepository>(
      () => BookingRepository(
        database: Get.find<AppDatabase>(),
      ),
      fenix: true,
    );
    print('✅ BookingRepository registered (lazy)');
    Get.lazyPut<FinancialRepository>(
    () => FinancialRepository(
      database: Get.find<AppDatabase>(),
    ),
    fenix: true,
  );
  print('✅ FinancialRepository registered (lazy)');
  Get.lazyPut<BannerRepository>(
      () => BannerRepository(),
      fenix: true,
    );
    Get.lazyPut<CouponRepository>(
  () => CouponRepository(
    database: Get.find<AppDatabase>(), // Using Find as requested
  ),
  fenix: true,
);
print('✅ CouponRepository registered (lazy)');
  }

  void _registerControllers() {
    print('🎮 Registering controllers...');

    // Permanent controllers
    Get.put<SalonServicesController>(SalonServicesController(), permanent: true);
    Get.put<FemaleSpaController>(FemaleSpaController(), permanent: true);
    Get.put<MaleSpaController>(MaleSpaController(), permanent: true);
    Get.put<MaleSalonController>(MaleSalonController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    print('✅ Service & Cart controllers registered (permanent)');

    // Lazy controllers
    Get.lazyPut<LocationController>(
      () => LocationController(
        repository: Get.find<LocationRepository>(),
      ),
      fenix: true,
    );
    print('✅ LocationController registered (lazy)');

    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
    print('✅ Auth controllers registered (lazy)');

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    print('✅ Home & Category controllers registered (lazy)');

    Get.lazyPut<ServiceController>(() => ServiceController(), fenix: true);

    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    print('✅ ProfileController registered (lazy)');

    Get.lazyPut<SaathiController>(() => SaathiController(), fenix: true);
    print('✅ SaathiController registered (lazy)');

    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    print('✅ PaymentController registered (lazy)');

    // NEW: Booking controllers
    Get.lazyPut<BookingController>(
      () => BookingController(repo: Get.find<BookingRepository>()),
      fenix: true,
    );
    print('✅ BookingController registered (lazy)');

    // Optional: list reader if your cancel/reschedule triggers refresh
    Get.lazyPut<BookingReadController>(() => BookingReadController(), fenix: true);
    print('✅ BookingReadController registered (lazy)');
    Get.lazyPut<FinancialController>(
    () => FinancialController(),
    fenix: true,
  );
  print('✅ FinancialController registered (lazy)');
 Get.lazyPut<BannerController>(
      () => BannerController(), 
      fenix: true,
    );
   Get.lazyPut<CouponController>(
  () => CouponController(
    repo: Get.find<CouponRepository>(), // Inject repo into controller
  ),
  fenix: true,
);
print('✅ CouponController registered (lazy)');
  }

  void _debugRegisteredDependencies() {
    print('🔍 Debugging registered dependencies:');

    try {
      final database = Get.find<AppDatabase>();
      print('   ✅ AppDatabase: ${database.runtimeType}');

      final cacheService = Get.find<CacheService>();
      print('   ✅ CacheService: ${cacheService.runtimeType}');

      final networkClient = Get.find<NetworkClient>();
      print('   ✅ NetworkClient: ${networkClient.runtimeType}');

      final apiService = Get.find<ApiService>();
      print('   ✅ ApiService: ${apiService.runtimeType}');

      print('   📚 Repositories ready for lazy instantiation:');
      print('      - HomeRepository: ${Get.isRegistered<HomeRepository>()}');
      print('      - AuthRepository: ${Get.isRegistered<AuthRepository>()}');
      print('      - ProfileRepository: ${Get.isRegistered<ProfileRepository>()}');
      print('      - LocationRepository: ${Get.isRegistered<LocationRepository>()}');
      print('      - BookingRepository: ${Get.isRegistered<BookingRepository>()}');

      print('   🎮 Controllers ready:');
      print('      - LoginController (lazy): ${Get.isRegistered<LoginController>()}');
      print('      - OtpController (lazy): ${Get.isRegistered<OtpController>()}');
      print('      - HomeController (lazy): ${Get.isRegistered<HomeController>()}');
      print('      - CategoryController (lazy): ${Get.isRegistered<CategoryController>()}');
      print('      - ProfileController (lazy): ${Get.isRegistered<ProfileController>()}');
      print('      - LocationController (lazy): ${Get.isRegistered<LocationController>()}');
      print('      - SaathiController (lazy): ${Get.isRegistered<SaathiController>()}');
      print('      - PaymentController (lazy): ${Get.isRegistered<PaymentController>()}');
      print('      - BookingController (lazy): ${Get.isRegistered<BookingController>()}');
      print('      - BookingReadController (lazy): ${Get.isRegistered<BookingReadController>()}');

      print('✅ All dependencies successfully registered and accessible');
    } catch (e) {
      print('❌ Error in dependency registration: $e');
      rethrow;
    }
  }
}
