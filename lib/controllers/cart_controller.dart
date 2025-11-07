import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import '../data/local/database.dart';
import '../models/service_models.dart';

class CartController extends GetxController {
  final AppDatabase _database = Get.find();

  // Observable map to store cart items
  var _items = <String, CartItem>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromDb();
    ever(_items, (_) => _saveToDb());
  }

  Future<void> _loadFromDb() async {
    try {
      final items = await _database.getAllNewCartItems();
      _items.value = {for (var item in items) item.id: item};
      print('✅ Loaded ${_items.length} items from database');
    } catch (e) {
      print('❌ Error loading cart from database: $e');
      try {
        final legacyItems = await _database.getAllCartItems();
        final convertedItems = <String, CartItem>{};

        for (var legacyItem in legacyItems) {
          final cartItem = CartItem(
            id: legacyItem.id,
            name: legacyItem.title,
            price: legacyItem.price,
            originalPrice: double.tryParse(legacyItem.originalPrice ?? '0') ?? legacyItem.price,
            image: legacyItem.image,
            duration: legacyItem.duration ?? '',
            rating: legacyItem.rating ?? '0.0',
            description: legacyItem.description ?? '',
            discountPercentage: 0,
            sourcePage: legacyItem.sourcePage ?? 'unknown',
            sourceTitle: legacyItem.sourceTitle ?? 'Unknown Service',
            quantity: legacyItem.quantity,
            dateAdded: legacyItem.dateAdded,
          );
          convertedItems[cartItem.id] = cartItem;
        }

        _items.value = convertedItems;
        print('✅ Converted ${convertedItems.length} legacy items');
      } catch (legacyError) {
        print('❌ Error loading legacy cart items: $legacyError');
      }
    }
  }

  Future<void> _saveToDb() async {
    try {
      for (final item in _items.values) {
        await _database.insertOrUpdateCartItem(item);
      }
    } catch (e) {
      print('❌ Error saving cart to database: $e');
    }
  }

  // Core getters
  List<CartItem> get cartItems {
    final items = _items.values.toList();
    items.sort((a, b) => b.quantity.compareTo(a.quantity));
    return items;
  }

  bool get isCartEmpty => _items.isEmpty;
  int get cartItemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  int getQuantity(String id) => _items[id]?.quantity ?? 0;
  bool isInCart(String id) => _items.containsKey(id);

  // Add a ready CartItem
  void addItem(CartItem item) {
    final id = item.id;
    if (_items.containsKey(id)) {
      _items[id] = _items[id]!.copyWith(quantity: _items[id]!.quantity + item.quantity);
    } else {
      _items[id] = item;
    }
    _showItemAddedFeedback(item);
  }

  // Add service to cart
  void addServiceToCart(
    Service service, {
    String? sourcePage,
    String? sourceTitle,
    String? categoryId,
  }) {
    if (_items.containsKey(service.id)) {
      incrementQuantity(service.id);
    } else {
      var cartItem = service.toCartItem(
        sourcePage: sourcePage ?? 'category_service',
        sourceTitle: sourceTitle ?? 'Services',
      );

      final enforcedCategoryId = (categoryId != null && categoryId.isNotEmpty)
          ? categoryId
          : cartItem.categoryId;

      if (enforcedCategoryId.isNotEmpty && enforcedCategoryId != cartItem.categoryId) {
        cartItem = cartItem.copyWith(categoryId: enforcedCategoryId);
      }

      _items[service.id] = cartItem;
    }
    _showItemAddedFeedback(_items[service.id]!);
  }

  void incrementQuantity(String id) {
    if (_items.containsKey(id)) {
      _items[id] = _items[id]!.copyWith(quantity: _items[id]!.quantity + 1);
    }
  }

  Future<void> decrementQuantity(String id) async {
    if (_items.containsKey(id)) {
      final currentQty = _items[id]!.quantity;
      if (currentQty > 1) {
        _items[id] = _items[id]!.copyWith(quantity: currentQty - 1);
      } else {
        await removeService(id);
      }
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeService(id);
    } else if (_items.containsKey(id)) {
      _items[id] = _items[id]!.copyWith(quantity: quantity);
    }
  }

  Future<void> removeService(String id) async {
    final service = _items[id];
    if (service != null) {
      _items.remove(id);
      await _database.removeCartItem(id);
      _showRemoveFeedback(service.name);
      refreshCart();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _database.clearAllCartItems();
    //_showSimpleFeedback('Cart cleared');
    refreshCart();
  }

  void refreshCart() {
    _items.refresh();
  }

  CartItem? getCartItem(String id) => _items[id];

  String get formattedTotalPrice => '₹${totalPrice.toInt()}';
  String get formattedItemCount {
    final count = cartItemCount;
    return count == 1 ? '$count item' : '$count items';
  }

  Map<String, dynamic> getCartSummary() {
    return {
      'totalItems': cartItemCount,
      'totalPrice': totalPrice,
      'formattedTotalPrice': formattedTotalPrice,
      'formattedItemCount': formattedItemCount,
      'hasItems': !isCartEmpty,
    };
  }

  Map<String, List<CartItem>> getItemsGroupedBySource() {
    Map<String, List<CartItem>> grouped = {};

    for (var item in cartItems) {
      String sourceKey = item.sourceTitle;
      if (!grouped.containsKey(sourceKey)) {
        grouped[sourceKey] = [];
      }
      grouped[sourceKey]!.add(item);
    }

    return grouped;
  }

  Map<String, List<CartItem>> getItemsGroupedByCategory() {
    return getItemsGroupedBySource();
  }

  Future<bool> validateCartForCheckout() async {
    if (isCartEmpty) {
      _showSimpleFeedback('Cart is empty');
      return false;
    }

    for (var item in _items.values) {
      if (item.price <= 0) {
        _showSimpleFeedback('Invalid item price found');
        return false;
      }
      if (item.quantity <= 0) {
        _showSimpleFeedback('Invalid item quantity found');
        return false;
      }
    }

    return true;
  }

  Future<void> completeCheckout() async {
    if (await validateCartForCheckout()) {
      Get.snackbar(
        'Processing Order',
        'Processing ${cartItemCount} items worth ${formattedTotalPrice}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFE47830),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      await Future.delayed(Duration(seconds: 2));
      await clearCart();

      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // ============================================
  // IMPROVED: Sleek "Item Added" notification
  // ============================================
  
  void _showItemAddedFeedback(CartItem item) {
    Get.snackbar(
      '', // No title
      '',
      titleText: SizedBox.shrink(), // Hide title
      messageText: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Success icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFE47830).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Color(0xFFE47830),
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Added to Cart',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Price
            Text(
              '₹${item.price.toInt()}',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFE47830),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: EdgeInsets.zero,
      borderRadius: 12,
      duration: Duration(milliseconds: 1500), // Very brief - 1.5 seconds
      animationDuration: Duration(milliseconds: 300),
      boxShadows: [],
      isDismissible: true,
      dismissDirection: DismissDirection.up,
    );
  }

  void _showRemoveFeedback(String itemName) {
    Get.snackbar(
      '',
      '',
      titleText: SizedBox.shrink(),
      messageText: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.remove_circle_outline, color: Colors.red, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '$itemName removed',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: EdgeInsets.zero,
      duration: Duration(milliseconds: 1200),
      animationDuration: Duration(milliseconds: 250),
      boxShadows: [],
    );
  }

  void _showSimpleFeedback(String message) {
    Get.snackbar(
      '',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: 1500),
      backgroundColor: Color(0xFFE47830),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Future<void> forceRefreshFromDb() async {
    await _loadFromDb();
    refreshCart();
  }

  Map<String, dynamic> getCartStats() {
    final groupedItems = getItemsGroupedBySource();
    return {
      'totalItems': cartItemCount,
      'uniqueItems': _items.length,
      'totalPrice': totalPrice,
      'averageItemPrice': _items.isEmpty ? 0.0 : totalPrice / cartItemCount,
      'categories': groupedItems.keys.toList(),
      'categoryCount': groupedItems.length,
      'mostExpensiveItem': _items.isEmpty ? null : _items.values.reduce((a, b) => a.price > b.price ? a : b),
      'cheapestItem': _items.isEmpty ? null : _items.values.reduce((a, b) => a.price < b.price ? a : b),
      'hasDiscounts': _items.values.any((item) => item.hasDiscount),
      'totalSavings': _items.values.fold(0.0, (sum, item) => sum + item.totalSavings),
    };
  }

  List<CartItem> getCartItemsBySource(String sourcePage) {
    return _items.values.where((item) => item.sourcePage == sourcePage).toList();
  }

  int getSourceItemCount(String sourcePage) {
    return _items.values.where((item) => item.sourcePage == sourcePage).fold(0, (sum, item) => sum + item.quantity);
  }

  double getSourceTotalPrice(String sourcePage) {
    return _items.values.where((item) => item.sourcePage == sourcePage).fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool hasService(String serviceId) => _items.containsKey(serviceId);
  CartItem? getCartItemByServiceId(String serviceId) => getCartItem(serviceId);

  String getCartDisplaySummary() {
    if (isCartEmpty) return 'Cart is empty';

    final stats = getCartStats();
    final sources = stats['categoryCount'] as int;

    return '$formattedItemCount from $sources ${sources == 1 ? 'source' : 'sources'} • $formattedTotalPrice';
  }

  bool get hasMultipleSources => getItemsGroupedBySource().length > 1;
  double get totalSavings => _items.values.fold(0.0, (sum, item) => sum + item.totalSavings);
  String get formattedTotalSavings {
    final savings = totalSavings;
    return savings > 0 ? '₹${savings.toInt()}' : '';
  }

  bool get hasDiscountedItems => _items.values.any((item) => item.hasDiscount);

  CartItem? get mostExpensiveItem {
    if (_items.isEmpty) return null;
    return _items.values.reduce((a, b) => a.price > b.price ? a : b);
  }

  CartItem? get cheapestItem {
    if (_items.isEmpty) return null;
    return _items.values.reduce((a, b) => a.price < b.price ? a : b);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
