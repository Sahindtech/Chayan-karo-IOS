// ServiceResponse unchanged
class ServiceResponse {
  final String type;
  final List<Service> result;

  ServiceResponse({
    required this.type,
    required this.result,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      type: json['type'] ?? 'services',
      result: (json['result'] as List? ?? [])
          .map((service) => Service.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'result': result.map((service) => service.toJson()).toList(),
    };
  }
}

class Service {
  final String id;
  final String name;
  final double price; // Changed from int to double
  final String description;
  final int duration;
  final String imgLink;
  final double discountPercentage; // Changed from int to double

  // NEW: carry category id coming from API (common keys: serviceCategoryId/categoryId)
  final String categoryId;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.duration,
    required this.imgLink,
    required this.discountPercentage,
    this.categoryId = '',
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    // try multiple keys to be resilient to backend naming
    final serviceCatId = json['serviceCategoryId']?.toString() ?? '';
    final catId = json['categoryId']?.toString() ?? '';
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: _parseDouble(json['price']),
      description: json['description']?.toString() ?? '',
      duration: _parseInt(json['duration']),
      imgLink: json['imgLink']?.toString() ?? '',
      discountPercentage: _parseDouble(json['discountPercentage']),
      categoryId: serviceCatId.isNotEmpty ? serviceCatId : catId,
    );
  }

  // Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to safely parse int values
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'duration': duration,
      'imgLink': imgLink,
      'discountPercentage': discountPercentage,
      if (categoryId.isNotEmpty) 'categoryId': categoryId,
    };
  }

  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    return price - (price * discountPercentage / 100);
  }

  String get formattedDuration {
    if (duration < 60) {
      return '${duration}min';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      if (minutes == 0) {
        return '${hours}hr';
      } else {
        return '${hours}hr ${minutes}min';
      }
    }
  }

  String get formattedPrice => '₹${discountedPrice.toInt()}';
  String get formattedOriginalPrice => discountPercentage > 0 ? '₹${price.toInt()}' : '';

  // Rating simulation (you can replace with actual API data later)
  String get rating => '4.8';

  // Check if service has discount
  bool get hasDiscount => discountPercentage > 0;

  // Convert to CartItem format (NEW: pass categoryId through)
  CartItem toCartItem({String? sourcePage, String? sourceTitle}) {
    return CartItem(
      id: id,
      name: name,
      price: discountedPrice,
      originalPrice: price,
      image: imgLink,
      duration: formattedDuration,
      rating: rating,
      description: description,
      discountPercentage: discountPercentage.toInt(),
      sourcePage: sourcePage ?? 'unknown',
      sourceTitle: sourceTitle ?? 'Unknown Service',
      categoryId: categoryId, // carry forward
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Service{id: $id, name: $name, price: $price, discountedPrice: $discountedPrice, categoryId: $categoryId}';
  }
}

// Complete CartItem Model with all required getters and methods
class CartItem {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String image;
  final String duration;
  final String rating;
  final String description;
  final int discountPercentage;
  final String sourcePage;
  final String sourceTitle;

  // NEW: carry category id with the cart item
  final String categoryId;

  int quantity;
  final DateTime dateAdded;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.duration,
    required this.rating,
    required this.description,
    required this.discountPercentage,
    required this.sourcePage,
    required this.sourceTitle,
    this.categoryId = '',
    this.quantity = 1,
    DateTime? dateAdded,
  }) : dateAdded = dateAdded ?? DateTime.now();

  // Basic calculation getters
  double get totalPrice => price * quantity;
  double get totalOriginalPrice => originalPrice * quantity;

  // ADDED: Missing formatted getters that were causing errors
  String get formattedPrice => '₹${price.toInt()}';
  String get formattedTotalPrice => '₹${totalPrice.toInt()}';
  String get formattedOriginalPrice => '₹${originalPrice.toInt()}';

  // ADDED: Discount related getters
  bool get hasDiscount => discountPercentage > 0;
  double get discountAmount => originalPrice - price;
  double get totalDiscountAmount => discountAmount * quantity;

  // ADDED: Savings calculation
  double get savingsPerItem => hasDiscount ? (originalPrice - price) : 0.0;
  double get totalSavings => savingsPerItem * quantity;
  String get formattedSavings => hasDiscount ? '₹${totalSavings.toInt()}' : '';

  // ADDED: Utility getters for UI
  String get quantityText => quantity == 1 ? '$quantity item' : '$quantity items';
  String get priceDisplayText => hasDiscount ? formattedPrice : formattedOriginalPrice;

  // ADDED: Service type detection (can be extended based on your needs)
  String get serviceType {
    if (sourcePage.contains('salon')) return 'Salon';
    if (sourcePage.contains('spa')) return 'Spa';
    if (sourcePage.contains('repair')) return 'Repair';
    if (sourcePage.contains('cleaning')) return 'Cleaning';
    return 'Service';
  }

  // ADDED: Time and date utilities
  String get addedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(dateAdded);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Enhanced copyWith method
  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    double? originalPrice,
    String? image,
    String? duration,
    String? rating,
    String? description,
    int? discountPercentage,
    String? sourcePage,
    String? sourceTitle,
    String? categoryId,
    int? quantity,
    DateTime? dateAdded,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      sourcePage: sourcePage ?? this.sourcePage,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
      dateAdded: dateAdded ?? this.dateAdded,
    );
    }

  // ADDED: Comprehensive JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'duration': duration,
      'rating': rating,
      'description': description,
      'discountPercentage': discountPercentage,
      'sourcePage': sourcePage,
      'sourceTitle': sourceTitle,
      'categoryId': categoryId, // NEW
      'quantity': quantity,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  // ADDED: JSON deserialization
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      image: json['image']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      description: json['description']?.toString() ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toInt() ?? 0,
      sourcePage: json['sourcePage']?.toString() ?? 'unknown',
      sourceTitle: json['sourceTitle']?.toString() ?? 'Unknown Service',
      categoryId: json['categoryId']?.toString() ?? '', // NEW
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // ADDED: Create from Service object
  factory CartItem.fromService(
    Service service, {
    String? sourcePage,
    String? sourceTitle,
    int quantity = 1,
  }) {
    return CartItem(
      id: service.id,
      name: service.name,
      price: service.discountedPrice,
      originalPrice: service.price,
      image: service.imgLink,
      duration: service.formattedDuration,
      rating: service.rating,
      description: service.description,
      discountPercentage: service.discountPercentage.toInt(),
      sourcePage: sourcePage ?? 'unknown',
      sourceTitle: sourceTitle ?? 'Unknown Service',
      categoryId: service.categoryId, // NEW: carry forward
      quantity: quantity,
    );
  }

  // ADDED: Validation methods
  bool get isValid {
    return id.isNotEmpty &&
        name.isNotEmpty &&
        price >= 0 &&
        originalPrice >= 0 &&
        quantity > 0;
  }

  bool get hasValidImage =>
      image.isNotEmpty && (image.startsWith('http') || image.startsWith('assets'));

  bool get hasValidRating =>
      rating.isNotEmpty &&
      double.tryParse(rating) != null &&
      double.parse(rating) >= 0 &&
      double.parse(rating) <= 5;

  // ADDED: Comparison methods
  bool hasSameService(CartItem other) => id == other.id;

  bool hasSameSource(CartItem other) =>
      sourcePage == other.sourcePage && sourceTitle == other.sourceTitle;

  // ADDED: Cart item summary for display
  Map<String, dynamic> getSummary() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': formattedPrice,
      'totalPrice': formattedTotalPrice,
      'hasDiscount': hasDiscount,
      'savings': formattedSavings,
      'source': sourceTitle,
      'serviceType': serviceType,
      'addedTime': addedTimeAgo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItem{id: $id, name: $name, categoryId: $categoryId, quantity: $quantity, totalPrice: $totalPrice, source: $sourceTitle}';
  }
}

// ADDED: Cart summary helper class (unchanged)
class CartSummary {
  final List<CartItem> items;

  CartSummary(this.items);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueItems => items.length;
  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalOriginalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);
  double get totalSavings => totalOriginalPrice - totalPrice;

  String get formattedTotalPrice => '₹${totalPrice.toInt()}';
  String get formattedTotalSavings =>
      totalSavings > 0 ? '₹${totalSavings.toInt()}' : '';
  String get formattedItemCount =>
      totalItems == 1 ? '$totalItems item' : '$totalItems items';

  bool get hasDiscounts => items.any((item) => item.hasDiscount);

  Map<String, List<CartItem>> get groupedBySource {
    Map<String, List<CartItem>> grouped = {};
    for (var item in items) {
      String key = item.sourceTitle;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Map<String, List<CartItem>> get groupedByServiceType {
    Map<String, List<CartItem>> grouped = {};
    for (var item in items) {
      String key = item.serviceType;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  List<CartItem> get discountedItems =>
      items.where((item) => item.hasDiscount).toList();
  List<CartItem> get regularItems =>
      items.where((item) => !item.hasDiscount).toList();

  CartItem? get mostExpensiveItem =>
      items.isEmpty ? null : items.reduce((a, b) => a.price > b.price ? a : b);

  CartItem? get cheapestItem =>
      items.isEmpty ? null : items.reduce((a, b) => a.price < b.price ? a : b);
}
