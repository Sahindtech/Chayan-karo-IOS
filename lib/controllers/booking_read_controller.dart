// lib/controllers/booking_read_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../data/repository/booking_read_repository.dart';
import '../models/booking_read_models.dart';
// Import your Feedback Screen
import '../views/booking/feedback_screen.dart'; // ADJUST PATH IF NEEDED

class BookingReadController extends GetxController {
  BookingReadController({BookingReadRepository? repo})
      : _repo = repo ?? BookingReadRepository();

  final BookingReadRepository _repo;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<CustomerBooking> bookings = <CustomerBooking>[].obs;

  int _reqId = 0;

  // --- Getters ---
  List<CustomerBooking> get previous {
    final list = bookings.toList();
    return list.where((b) {
      final s = (b.status ?? '').toLowerCase();
      return s == 'cancelled' || s == 'completed';
    }).toList();
  }

  List<CustomerBooking> get upcoming {
    final list = bookings.toList();
    return list.where((b) {
      final s = (b.status ?? '').toLowerCase();
      return s != 'cancelled' && s != 'completed';
    }).toList();
  }

  Future<void> fetchCustomerBookings({bool force = true}) async {
    final int cur = ++_reqId; 
    try {
      isLoading.value = true;
      error.value = '';
      
      var list = await _repo.getCustomerBookings();

      // Filter Logic
      list = list.where((b) {
        final mode = (b.paymentMode ?? '').toLowerCase();
        final status = (b.paymentStatus ?? '').toLowerCase();
        bool isInvalidOnlineBooking = mode == 'online' && 
                                     (status == 'unpaid' || status == 'not paid');
        return !isInvalidOnlineBooking;
      }).toList();

      bookings.assignAll(List<CustomerBooking>.from(list));

      // --- CHANGE: REMOVED AUTOMATIC CHECK HERE ---
      // We removed "await _checkForOneTimeFeedback(bookings);" 
      // so it doesn't pop up randomly during navigation.
      
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      if (cur == _reqId) {
        isLoading.value = false;
      }
    }
  }

  /// Call this explicitly from Home Screen
 Future<void> checkForPendingFeedback() async {
  // If bookings are empty, try to fetch silently first
  if (bookings.isEmpty) {
    try {
      await fetchCustomerBookings(force: false);
    } catch (e) {
      return; // If fetch fails, just stop
    }
  }

  final prefs = await SharedPreferences.getInstance();

  // Only look at completed bookings
  final completedList = bookings.where(
    (b) => (b.status ?? '').toLowerCase() == 'completed',
  );

  for (var booking in completedList) {
    final String bookingId = booking.id ?? '';
    if (bookingId.isEmpty) continue;

    // ✅ 1. BACKEND CHECK (HIGHEST PRIORITY 🚨)
    // Replace 'feedback' with your actual field if different
    final bool isFeedbackGiven = booking.feedbackSubmitted == true;

    if (isFeedbackGiven) {
      continue; // ❌ NEVER show popup
    }

    // ✅ 2. LOCAL CHECK (show only once)
    final String key = 'shown_feedback_for_$bookingId';
    final bool alreadyShown = prefs.getBool(key) ?? false;

    if (alreadyShown) {
      continue; // ❌ Already shown once → skip
    }

    // ✅ 3. MARK AS SHOWN IMMEDIATELY (avoid duplicate popup)
    await prefs.setBool(key, true);

    // ✅ 4. Extract Data
    String spId = booking.spId ?? '';
    String serviceName = 'Service';

    if (booking.bookingService.isNotEmpty) {
      var s = booking.bookingService.first;
      serviceName = s.serviceIName ?? 'Service';
    }

    // ✅ 5. Navigate to Feedback Screen
    Get.to(
      () => const FeedbackScreen(),
      arguments: {
        'spId': spId,
        'bookingId': bookingId,
        'serviceName': serviceName,
      },
    );

    // ✅ 6. Only ONE popup per app open
    break;
  }
}
}