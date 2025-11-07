// lib/data/repository/home_repository.dart
import '../../models/home_models.dart' as models;
import '../local/database.dart';

class HomeRepository {
  final AppDatabase _database;

  HomeRepository({
    required AppDatabase database,
  }) : _database = database;

  // Dummy most used services data
  List<models.Service> _getDummyMostUsedServices() {
    return [
      models.Service(title: 'Hair Keratin Treatment', image: 'assets/x1.jpg'),
      models.Service(title: 'Hair Trimming', image: 'assets/x2.jpg'),
      models.Service(title: 'Full Body Bleach-Oxylife', image: 'assets/x3.jpg'),
      models.Service(title: 'Chest Bleach-O3+', image: 'assets/x4.jpg'),
      models.Service(title: 'Deep Tissue Massage-Back', image: 'assets/x5.jpg'),
      models.Service(title: 'Swedish Massage-Full Body', image: 'assets/x6.jpg'),
    ];
  }

  // Get most used services - dummy data first strategy with database persistence
  Future<List<models.Service>> getMostUsedServices() async {
    final dummyServices = _getDummyMostUsedServices();
    
    try {
      final localServices = await _database.getServicesByType('mostUsed');
      if (localServices.isNotEmpty) {
        print('📱 Returning ${localServices.length} most used services from local database');
        return localServices;
      }

      // Use dummy data instead of API call
      print('🔄 Using dummy services data for development');
      
      try {
        // Use the correct method name for legacy services
        await _database.insertLegacyServices(dummyServices, 'mostUsed');
        print('💾 Saved ${dummyServices.length} dummy most used services to database');
      } catch (dbError) {
        print('❌ Could not save dummy services to database: $dbError');
      }
      
      return dummyServices;
    } catch (e) {
      print('🔄 Using dummy services data for development: $e');
      return dummyServices;
    }
  }

  // Dummy GoTo services data
  List<models.GoToService> _getDummyGoToServices() {
    return [
      models.GoToService(
        title: 'Beauty & Wellness (Men)',
        subtitle: '10 services',
        images: ['assets/m1.webp', 'assets/m2.webp', 'assets/m3.webp', 'assets/m4.webp'],
      ),
      models.GoToService(
        title: 'Appliance and Repair',
        subtitle: '4 services',
        images: ['assets/a1.webp', 'assets/a2.webp', 'assets/a3.webp', 'assets/a4.webp'],
      ),
      models.GoToService(
        title: 'Carpenter & Plumber',
        subtitle: '2 services',
        images: ['assets/c1.webp', 'assets/c2.webp', 'assets/c3.webp', 'assets/c4.webp'],
      ),
      models.GoToService(
        title: 'Cleaning Services',
        subtitle: '6 services',
        images: ['assets/cleaning1.webp', 'assets/cleaning2.webp', 'assets/cleaning3.webp', 'assets/cleaning4.webp'],
      ),
      models.GoToService(
        title: 'Women Spa & Wellness',
        subtitle: '8 services',
        images: ['assets/w1.webp', 'assets/w2.webp', 'assets/w3.webp', 'assets/w4.webp'],
      ),
    ];
  }

  // Get GoTo services - dummy data first strategy
  Future<List<models.GoToService>> getGoToServices() async {
    final dummyGoToServices = _getDummyGoToServices();
    
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy goto services data for development');
      return dummyGoToServices;
    } catch (e) {
      print('🔄 Using dummy goto services data for development: $e');
      return dummyGoToServices;
    }
  }

  // Dummy banner data
  models.Banner _getDummyBanner() {
    return models.Banner(
      title: "Let's make a package just\nfor you, Manvi!",
      subtitle: "Salon for women",
      image: 'assets/banner_woman.webp',
    );
  }

  // Get banner data
  Future<models.Banner> getBanner() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy banner data for development');
      return _getDummyBanner();
    } catch (e) {
      print('🔄 Using dummy banner data for development: $e');
      return _getDummyBanner();
    }
  }

  // Dummy appliance repair services
  List<Map<String, String>> _getDummyApplianceRepairServices() {
    return [
      {'title': 'Chimney', 'image': 'assets/chimney.webp'},
      {'title': 'Washing Machine', 'image': 'assets/washing_machine.webp'},
      {'title': 'Water Purifier', 'image': 'assets/water_purifier.webp'},
      {'title': 'Refrigerator', 'image': 'assets/refrigerator.webp'},
      {'title': 'Air Cooler', 'image': 'assets/air_cooler.webp'},
      {'title': 'Television', 'image': 'assets/television.webp'},
      {'title': 'AC Services and Repair', 'image': 'assets/ac_repair.webp'},
      {'title': 'Microwave', 'image': 'assets/microwave.webp'},
    ];
  }

  // Get appliance repair services
  Future<List<Map<String, String>>> getApplianceRepairServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy appliance repair services for development');
      return _getDummyApplianceRepairServices();
    } catch (e) {
      print('🔄 Using dummy appliance repair services for development: $e');
      return _getDummyApplianceRepairServices();
    }
  }

  // Dummy AC repair services
  List<Map<String, String>> _getDummyAcRepairServices() {
    return [
      {'imagePath': 'assets/ac_services.webp', 'title': 'AC Services'},
      {'imagePath': 'assets/ac_repair.webp', 'title': 'AC Repair & Gas Refill'},
      {'imagePath': 'assets/ac_installation.webp', 'title': 'AC Installation'},
      {'imagePath': 'assets/ac_uninstallation.webp', 'title': 'AC Uninstallation'},
      {'imagePath': 'assets/ac_cleaning.webp', 'title': 'AC Deep Cleaning'},
    ];
  }

  // Get AC repair services
  Future<List<Map<String, String>>> getAcRepairServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy AC repair services for development');
      return _getDummyAcRepairServices();
    } catch (e) {
      print('🔄 Using dummy AC repair services for development: $e');
      return _getDummyAcRepairServices();
    }
  }

  // Dummy male spa services
  List<Map<String, String>> _getDummyMaleSpaServices() {
    return [
      {'imagePath': 'assets/spa_men_swedish.webp', 'label': 'Swedish Massage'},
      {'imagePath': 'assets/spa_men_backrelief.webp', 'label': 'Back Relief'},
      {'imagePath': 'assets/spa_men_bodypolish.webp', 'label': 'Body Polish'},
      {'imagePath': 'assets/spa_men_facial.webp', 'label': 'Deep Cleansing Facial'},
      {'imagePath': 'assets/spa_men_aromatherapy.webp', 'label': 'Aromatherapy'},
    ];
  }

  // Get male spa services
  Future<List<Map<String, String>>> getMaleSpaServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy male spa services for development');
      return _getDummyMaleSpaServices();
    } catch (e) {
      print('🔄 Using dummy male spa services for development: $e');
      return _getDummyMaleSpaServices();
    }
  }

  // Dummy salon men services
  List<Map<String, String>> _getDummySalonMenServices() {
    return [
      {'imagePath': 'assets/salon_men_haircut_beard.webp', 'label': 'Haircut & Beard Styling'},
      {'imagePath': 'assets/salon_men_haircolor_spa.webp', 'label': 'Hair Colour & Hair Spa'},
      {'imagePath': 'assets/salon_men_facial_cleanup.webp', 'label': 'Facial & Cleanup'},
      {'imagePath': 'assets/salon_men_massage.webp', 'label': 'Head Massage'},
    ];
  }

  // Get salon men services
  Future<List<Map<String, String>>> getSalonMenServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy salon men services for development');
      return _getDummySalonMenServices();
    } catch (e) {
      print('🔄 Using dummy salon men services for development: $e');
      return _getDummySalonMenServices();
    }
  }

  // Dummy women salon services
  List<Map<String, String>> _getDummyWomenSalonServices() {
    return [
      {
        'title1': 'Bleach & Detan',
        'image1': 'assets/saloon_bleach.webp',
        'title2': 'Facial & Cleanup',
        'image2': 'assets/saloon_facial.webp',
      },
      {
        'title1': 'Pedicure',
        'image1': 'assets/saloon_pedicure.webp',
        'title2': 'Threading',
        'image2': 'assets/saloon_threading.webp',
      },
      {
        'title1': 'Waxing',
        'image1': 'assets/saloon_waxing.webp',
        'title2': 'Manicure',
        'image2': 'assets/saloon_manicure.webp',
      },
      {
        'title1': 'Hair Styling',
        'image1': 'assets/saloon_styling.webp',
        'title2': 'Hair Spa',
        'image2': 'assets/saloon_spa.webp',
      },
    ];
  }

  // Get women salon services
  Future<List<Map<String, String>>> getWomenSalonServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy women salon services for development');
      return _getDummyWomenSalonServices();
    } catch (e) {
      print('🔄 Using dummy women salon services for development: $e');
      return _getDummyWomenSalonServices();
    }
  }

  // Dummy women spa services
  List<Map<String, String>> _getDummyWomenSpaServices() {
    return [
      {'imagePath': 'assets/spa_massage.webp', 'label': 'Full Body Massage'},
      {'imagePath': 'assets/spa_scrub.webp', 'label': 'Body Scrub'},
      {'imagePath': 'assets/spa_steam.webp', 'label': 'Steam Therapy'},
      {'imagePath': 'assets/spa_facial.webp', 'label': 'Relaxing Facial'},
      {'imagePath': 'assets/spa_aromatherapy.webp', 'label': 'Aromatherapy'},
    ];
  }

  // Get women spa services
  Future<List<Map<String, String>>> getWomenSpaServices() async {
    try {
      // Return dummy data directly (bypass API)
      print('🔄 Using dummy women spa services for development');
      return _getDummyWomenSpaServices();
    } catch (e) {
      print('🔄 Using dummy women spa services for development: $e');
      return _getDummyWomenSpaServices();
    }
  }

  // Get complete home data - return dummy data structure
  Future<models.HomeData?> getHomeData() async {
    try {
      print('🔄 Creating dummy home data for development');
      
      // Create a complete HomeData object with dummy data
      return models.HomeData(
        banner: _getDummyBanner(),
        mostUsedServices: _getDummyMostUsedServices(),
        goToServices: _getDummyGoToServices(), categories: [], acRepairItems: [], appliancesRepairItems: [], maleSpaItems: [], salonMenItems: [], saloonWomenItems: [], spaWomenItems: [],
        // Add any other properties your HomeData model requires
      );
    } catch (e) {
      print('🔄 Using dummy home data fallback: $e');
      return null;
    }
  }

  // Refresh methods (return fresh dummy data)
  Future<List<models.Service>> refreshMostUsedServices() async {
    print('🔄 Refreshing most used services with dummy data');
    final dummyServices = _getDummyMostUsedServices();
    
    try {
      await _database.insertLegacyServices(dummyServices, 'mostUsed');
      print('💾 Refreshed and saved ${dummyServices.length} dummy services to database');
    } catch (e) {
      print('❌ Could not save refreshed dummy services: $e');
    }
    
    return dummyServices;
  }

  Future<List<models.GoToService>> refreshGoToServices() async {
    print('🔄 Refreshing GoTo services with dummy data');
    return _getDummyGoToServices();
  }

  Future<models.Banner> refreshBanner() async {
    print('🔄 Refreshing banner with dummy data');
    return _getDummyBanner();
  }

  Future<models.HomeData?> refreshHomeData() async {
    print('🔄 Refreshing home data with dummy data');
    return getHomeData();
  }

  // Helper method to clear cached data
  Future<void> clearCache() async {
    try {
      // Clear any cached data if needed
      print('🗑️ Clearing home repository cache');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }
}
