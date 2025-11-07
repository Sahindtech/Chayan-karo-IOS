import 'package:get/get.dart';
import '../models/salon_service.dart';

class SalonServicesController extends GetxController {
  var groupedServices = <String, List<SalonService>>{}.obs;
  var cartQuantities = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    groupedServices.value = _initializeServices();
  }

  Map<String, List<SalonService>> _initializeServices() {
    final Map<String, List<Map<String, String>>> rawData = {
      'Cleanup': [
        {'image': 'assets/z2.webp', 'title': 'Cleanup', 'price': '₹200', 'rating': '4.76', 'duration': '55 mins'},
        {'image': 'assets/z2.webp', 'title': 'Deep Cleanup', 'price': '₹250', 'rating': '4.76', 'duration': '65 mins'},
      ],
      'Bleach & Detan': [
        {'image': 'assets/z1.webp', 'title': 'Bleach', 'price': '₹200', 'rating': '4.76', 'duration': '55 mins'},
        {'image': 'assets/s4.webp', 'title': 'Detan', 'price': '₹180', 'rating': '4.76', 'duration': '45 mins'},
      ],
      'Threading': [
        {'image': 'assets/saloon_threading.webp', 'title': 'Threading', 'price': '₹150', 'rating': '4.8', 'duration': '30 mins'},
      ],
      'Waxing': [
        {'image': 'assets/saloon_waxing.webp', 'title': 'Waxing', 'price': '₹400', 'rating': '4.7', 'duration': '60 mins'},
      ],
      'Manicure': [
        {'image': 'assets/saloon_manicure.webp', 'title': 'Manicure', 'price': '₹300', 'rating': '4.75', 'duration': '45 mins'},
      ],
      'Pedicure': [
        {'image': 'assets/saloon_pedicure.webp', 'title': 'Pedicure', 'price': '₹350', 'rating': '4.8', 'duration': '50 mins'},
      ],
      'Facial': [
        {
          'image': 'assets/x1.jpg',
          'title': 'Diamond Facial',
          'price': '₹499',
          'originalPrice': '₹599',
          'rating': '4.76',
          'duration': '55 mins',
          'desc': '• 45 mins\n• For all skin types. Pinacolada mask.\n• 6-step process. Includes 10-min massage',
        },
        {
          'image': 'assets/x2.jpg',
          'title': 'Gold Facial',
          'price': '₹699',
          'originalPrice': '₹799',
          'rating': '4.76',
          'duration': '60 mins',
          'desc': '• 60 mins\n• Anti-aging treatment\n• 7-step process. Includes face massage',
        },
        {
          'image': 'assets/x3.jpg',
          'title': 'Platinum Facial',
          'price': '₹899',
          'originalPrice': '₹999',
          'rating': '4.76',
          'duration': '75 mins',
          'desc': '• 75 mins\n• For all skin types. Charcoal mask.\n• 8-step process. Includes 15-min massage',
        },
      
        {
          'image': 'assets/x5.jpg',
          'title': 'Oxygen Facial',
          'price': '₹999',
          'originalPrice': '₹1199',
          'rating': '4.76',
          'duration': '90 mins',
          'desc': '• 90 mins\n• For all skin types. Oxygen infusion.\n• 9-step process. Includes 20-min massage',
        },
        {
          'image': 'assets/x4.jpg',
          'title': 'Hydra Facial',
          'price': '₹1299',
          'originalPrice': '₹1499',
          'rating': '4.76',
          'duration': '90 mins',
          'desc': '• 90 mins\n• For all skin types. Hydra mask.\n• 10-step process. Includes 20-min massage',
        },
      ],
    };

    Map<String, List<SalonService>> groupedServices = {};
    
    rawData.forEach((category, services) {
      groupedServices[category] = services.asMap().entries.map((entry) {
        // Generate a unique ID by combining category and index
        String uniqueId = '${category.toLowerCase().replaceAll(' ', '_')}_${entry.key}';
        return SalonService.fromMap(
          entry.value, 
          category, 
          uniqueId  // Convert int index to meaningful String ID
        );
      }).toList();
    });

    return groupedServices;
  }

  SalonService? findServiceById(String serviceId) {
    for (var services in groupedServices.values) {
      try {
        return services.firstWhere((service) => service.id == serviceId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  int getQuantity(String serviceId) => cartQuantities[serviceId] ?? 0;
  bool isInCart(String serviceId) => getQuantity(serviceId) > 0;

  void incrementQuantity(String serviceId) {
    cartQuantities[serviceId] = (cartQuantities[serviceId] ?? 0) + 1;
  }

  void decrementQuantity(String serviceId) {
    final currentQuantity = cartQuantities[serviceId] ?? 0;
    if (currentQuantity > 0) {
      cartQuantities[serviceId] = currentQuantity - 1;
      if (cartQuantities[serviceId] == 0) {
        cartQuantities.remove(serviceId);
      }
    }
  }

  int get cartItemCount => cartQuantities.values.fold(0, (sum, qty) => sum + qty);
  bool get isCartEmpty => cartItemCount == 0;

  double get totalPrice {
    double total = 0;
    cartQuantities.forEach((serviceId, quantity) {
      final service = findServiceById(serviceId);
      if (service != null && quantity > 0) {
        final priceString = service.price.replaceAll(RegExp(r'[^\\d.]'), '');
        final price = double.tryParse(priceString) ?? 0;
        total += price * quantity;
      }
    });
    return total;
  }

  void clearCart() {
    cartQuantities.clear();
  }
}
