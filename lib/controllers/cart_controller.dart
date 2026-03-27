import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local/database.dart';
import '../models/service_models.dart';

class CartController extends GetxController {
  final AppDatabase _database = Get.find();

  /// Use a list to preserve insertion order.
  /// Key is still id, but order comes from this list.
  final RxList<CartItem> _itemsList = <CartItem>[].obs;
  // ✅ NEW: Separate list for Rebooking Flow (In-Memory Only)
  final RxList<CartItem> _rebookingItemsList = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromDb();
    ever<List<CartItem>>(_itemsList, (_) => _saveToDb());
  }

  Future<void> _loadFromDb() async {
    try {
      final items = await _database.getAllNewCartItems(); // returns List<CartItem>
      _itemsList.assignAll(items);
      print('✅ Loaded ${_itemsList.length} items from database');
    } catch (e) {
      print('❌ Error loading cart from database: $e');
      try {
        final legacyItems = await _database.getAllCartItems();
        final convertedItems = <CartItem>[];

        for (var legacyItem in legacyItems) {
          final cartItem = CartItem(
            id: legacyItem.id,
            name: legacyItem.title,
            price: legacyItem.price,
            originalPrice:
                double.tryParse(legacyItem.originalPrice ?? '0') ??
                    legacyItem.price,
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
          convertedItems.add(cartItem);
        }

        _itemsList.assignAll(convertedItems);
        print('✅ Converted ${convertedItems.length} legacy items');
      } catch (legacyError) {
        print('❌ Error loading legacy cart items: $legacyError');
      }
    }
  }

  Future<void> _saveToDb() async {
    try {
      for (final item in _itemsList) {
        await _database.insertOrUpdateCartItem(item);
      }
    } catch (e) {
      print('❌ Error saving cart to database: $e');
    }
  }

  // ============ CORE HELPERS ============

  /// Always returns list in stable insertion order.
  List<CartItem> get cartItems => List.unmodifiable(_itemsList);

  bool get isCartEmpty => _itemsList.isEmpty;

  int get cartItemCount =>
      _itemsList.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _itemsList.fold(0.0, (sum, item) => sum + item.totalPrice);

  int getQuantity(String id) =>
      _itemsList.firstWhereOrNull((i) => i.id == id)?.quantity ?? 0;

  bool isInCart(String id) =>
      _itemsList.any((element) => element.id == id);

  int _indexOfId(String id) =>
      _itemsList.indexWhere((element) => element.id == id);

  // ============ ADD / UPDATE ITEMS ============

  void addItem(CartItem item) {
    final index = _indexOfId(item.id);
    if (index != -1) {
      final existing = _itemsList[index];
      _itemsList[index] =
          existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _itemsList.add(item); // keeps insertion order
    }
    _showItemAddedFeedback(
        _itemsList[_indexOfId(item.id)]); // updated instance
  }

  void addServiceToCart(
    Service service, {
    String? sourcePage,
    String? sourceTitle,
    String? categoryId,
  }) {
    final index = _indexOfId(service.id);

    if (index != -1) {
      // increment existing; index stays same, so position doesn't move
      incrementQuantity(service.id);
      _showItemAddedFeedback(_itemsList[_indexOfId(service.id)]);
      return;
    }

    var cartItem = service.toCartItem(
      sourcePage: sourcePage ?? 'category_service',
      sourceTitle: sourceTitle ?? 'Services',
    );

    final enforcedCategoryId = (categoryId != null && categoryId.isNotEmpty)
        ? categoryId
        : cartItem.categoryId;

    if (enforcedCategoryId.isNotEmpty &&
        enforcedCategoryId != cartItem.categoryId) {
      cartItem = cartItem.copyWith(categoryId: enforcedCategoryId);
    }

    _itemsList.add(cartItem); // new item goes to end, stable
    _showItemAddedFeedback(cartItem);
  }

  void incrementQuantity(String id) {
    final index = _indexOfId(id);
    if (index == -1) return;
    final item = _itemsList[index];
    _itemsList[index] = item.copyWith(quantity: item.quantity + 1);
  }

  Future<void> decrementQuantity(String id) async {
    final index = _indexOfId(id);
    if (index == -1) return;
    final item = _itemsList[index];
    if (item.quantity > 1) {
      _itemsList[index] =
          item.copyWith(quantity: item.quantity - 1);
    } else {
      await removeService(id);
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeService(id);
      return;
    }
    final index = _indexOfId(id);
    if (index == -1) return;
    final item = _itemsList[index];
    _itemsList[index] = item.copyWith(quantity: quantity);
  }

  Future<void> removeService(String id) async {
    final index = _indexOfId(id);
    if (index == -1) return;
    final service = _itemsList[index];
    _itemsList.removeAt(index);
    await _database.removeCartItem(id);
    _showRemoveFeedback(service.name);
  }

  Future<void> clearCart() async {
    _itemsList.clear();
    await _database.clearAllCartItems();
  }

  void refreshCart() {
    _itemsList.refresh();
  }

  CartItem? getCartItem(String id) =>
      _itemsList.firstWhereOrNull((i) => i.id == id);

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

  // ============ GROUPING (ORDER PRESERVED) ============

  Map<String, List<CartItem>> getItemsGroupedBySource() {
    final Map<String, List<CartItem>> grouped = {};
    for (var item in _itemsList) {
      final key = item.sourceTitle;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item); // adds in list order, no sort
    }
    return grouped;
  }

  Map<String, List<CartItem>> getItemsGroupedByCategory() {
    return getItemsGroupedBySource();
  }

  // ============ VALIDATION & CHECKOUT ============

  Future<bool> validateCartForCheckout() async {
    if (isCartEmpty) {
      _showSimpleFeedback('Cart is empty');
      return false;
    }

    for (var item in _itemsList) {
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
        'Processing $cartItemCount items worth $formattedTotalPrice',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE47830),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(seconds: 2));
      await clearCart();

      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // ============ FEEDBACK (SNACKBARS) ============

  void _showItemAddedFeedback(CartItem item) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE47830).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFFE47830),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Text(
                    item.name,
                    style: const TextStyle(
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
            Text(
              '₹${item.price.toInt()}',
              style: const TextStyle(
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
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: EdgeInsets.zero,
      borderRadius: 12,
      duration: const Duration(milliseconds: 1500),
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [],
      isDismissible: true,
      dismissDirection: DismissDirection.up,
    );
  }

  void _showRemoveFeedback(String itemName) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.remove_circle_outline,
                color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$itemName removed',
                style: const TextStyle(
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
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 1200),
      animationDuration: const Duration(milliseconds: 250),
      boxShadows: [],
    );
  }

  void _showSimpleFeedback(String message) {
    Get.snackbar(
      '',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 1500),
      backgroundColor: const Color(0xFFE47830),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
Future<void> clearCartOnBookingSuccess() async {
  // optional: log
  debugPrint('🧺 Clearing cart after booking success');
  await clearCart();
}
  // ============ EXTRA STATS / HELPERS ============

  Future<void> forceRefreshFromDb() async {
    await _loadFromDb();
    refreshCart();
  }

  Map<String, dynamic> getCartStats() {
    final groupedItems = getItemsGroupedBySource();
    return {
      'totalItems': cartItemCount,
      'uniqueItems': _itemsList.length,
      'totalPrice': totalPrice,
      'averageItemPrice':
          _itemsList.isEmpty ? 0.0 : totalPrice / cartItemCount,
      'categories': groupedItems.keys.toList(),
      'categoryCount': groupedItems.length,
      'mostExpensiveItem': _itemsList.isEmpty
          ? null
          : _itemsList
              .reduce((a, b) => a.price > b.price ? a : b),
      'cheapestItem': _itemsList.isEmpty
          ? null
          : _itemsList
              .reduce((a, b) => a.price < b.price ? a : b),
      'hasDiscounts':
          _itemsList.any((item) => item.hasDiscount),
      'totalSavings': _itemsList.fold(
          0.0, (sum, item) => sum + item.totalSavings),
    };
  }

  List<CartItem> getCartItemsBySource(String sourcePage) {
    return _itemsList
        .where((item) => item.sourcePage == sourcePage)
        .toList();
  }

  int getSourceItemCount(String sourcePage) {
    return _itemsList
        .where((item) => item.sourcePage == sourcePage)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  double getSourceTotalPrice(String sourcePage) {
    return _itemsList
        .where((item) => item.sourcePage == sourcePage)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool hasService(String serviceId) =>
      _itemsList.any((item) => item.id == serviceId);

  CartItem? getCartItemByServiceId(String serviceId) =>
      getCartItem(serviceId);

  String getCartDisplaySummary() {
    if (isCartEmpty) return 'Cart is empty';

    final stats = getCartStats();
    final sources = stats['categoryCount'] as int;

    return '$formattedItemCount from $sources '
        '${sources == 1 ? 'source' : 'sources'} • $formattedTotalPrice';
  }

  bool get hasMultipleSources =>
      getItemsGroupedBySource().length > 1;

  double get totalSavings => _itemsList.fold(
      0.0, (sum, item) => sum + item.totalSavings);

  String get formattedTotalSavings {
    final savings = totalSavings;
    return savings > 0 ? '₹${savings.toInt()}' : '';
  }

  bool get hasDiscountedItems =>
      _itemsList.any((item) => item.hasDiscount);

  CartItem? get mostExpensiveItem {
    if (_itemsList.isEmpty) return null;
    return _itemsList
        .reduce((a, b) => a.price > b.price ? a : b);
  }

  CartItem? get cheapestItem {
    if (_itemsList.isEmpty) return null;
    return _itemsList
        .reduce((a, b) => a.price < b.price ? a : b);
  }
  // ============ REBOOKING FLOW ACTIONS ============

  // ✅ NEW: Add Service specifically to Rebooking Context
  void addServiceToRebooking(
    Service service, {
    required String providerId, // Mandatory for rebooking
    String? sourcePage,
  }) {
    // Check if item exists in REBOOKING list
    final index = _rebookingItemsList.indexWhere((i) => i.id == service.id);

    if (index != -1) {
      // Increment quantity in rebooking list
      final existing = _rebookingItemsList[index];
      _rebookingItemsList[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      // Create new item with REBOOK context
      final cartItem = service.toCartItem(
        sourcePage: sourcePage ?? 'rebooking_flow',
        sourceTitle: 'Rebooking',
        bookingContextId: 'REBOOK_${DateTime.now().millisecondsSinceEpoch}',
        bookingSource: 'REBOOK',
        providerId: providerId,
      );
      _rebookingItemsList.add(cartItem);
    }
    // Optional: Add simple Get.snackbar feedback here if needed, 
    // or rely on UI state update.
  }

  // ✅ NEW: Remove from Rebooking Context
  void removeServiceFromRebooking(String id) {
    _rebookingItemsList.removeWhere((item) => item.id == id);
  }

  // ✅ NEW: Update Quantity in Rebooking Context
  void updateRebookingQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeServiceFromRebooking(id);
      return;
    }
    final index = _rebookingItemsList.indexWhere((i) => i.id == id);
    if (index != -1) {
      _rebookingItemsList[index] = _rebookingItemsList[index].copyWith(quantity: quantity);
    }
  }

  // ✅ NEW: Clear Rebooking Context
  void clearRebookingCart() {
    _rebookingItemsList.clear();
  }

  // ============ REBOOKING GETTERS ============

  // ✅ NEW: Public getters for Rebooking UI
  List<CartItem> get rebookingItems => List.unmodifiable(_rebookingItemsList);
  bool get isRebookingCartEmpty => _rebookingItemsList.isEmpty;
  
  int get rebookingItemCount => 
      _rebookingItemsList.fold(0, (sum, item) => sum + item.quantity);

  double get rebookingTotalPrice => 
      _rebookingItemsList.fold(0.0, (sum, item) => sum + item.totalPrice);
      
  String get formattedRebookingTotalPrice => '₹${rebookingTotalPrice.toInt()}';

  // ✅ NEW: Get service IDs for API call
  List<String> get rebookingServiceIds => 
      _rebookingItemsList.map((e) => e.id).toList();

  // ✅ NEW: Check if specific service is in rebooking cart
  int getRebookingQuantity(String id) =>
      _rebookingItemsList.firstWhereOrNull((i) => i.id == id)?.quantity ?? 0;
}

