// lib/data/repository/booking_read_repository.dart
import '../remote/api_service.dart';
import '../remote/network_client.dart';
import '../../data/local/database.dart';
import '../../models/booking_read_models.dart';
import 'package:retrofit/retrofit.dart'; // HttpResponse

class BookingReadRepository {
  BookingReadRepository({AppDatabase? database})
      : _db = database ?? AppDatabase(),
        _api = NetworkClient().apiService;

  final AppDatabase _db;
  final ApiService _api;

  Future<List<CustomerBooking>> getCustomerBookings() async {
    final token = await _db.getAuthToken();
    if (token == null) throw Exception('User not authenticated');

    final HttpResponse<Object?> httpRes =
        await _api.getCustomerBookingsRaw('Bearer $token');

    final data = httpRes.data;

    // 1) Handle array-at-root responses
    if (data is List) {
      final payloadList = data
          .whereType<Map<String, dynamic>>()
          .map((e) {
            // Normalize fields expected by the model
            e['status'] = (e['status'] ?? '').toString();
            e['rescheduleReason'] = e['rescheduleReason']?.toString();
            e['cancelReason'] = e['cancelReason']?.toString();
            return e;
          })
          .toList();

      final list = payloadList.map((e) => CustomerBooking.fromJson(e)).toList()
        ..sort((a, b) => DateTime.parse(b.creationTime)
            .compareTo(DateTime.parse(a.creationTime)));
      return list;
    }

    // 2) Expect object wrapper otherwise
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Invalid response format from server');
    }
    final Map<String, dynamic> raw = data;

    // Common wrappers
    dynamic payload =
        raw['result'] ?? raw['data'] ?? raw['items'] ?? raw['list'] ?? raw;

    if (payload is Map<String, dynamic>) {
      payload = payload['list'] ??
          payload['items'] ??
          payload['data'] ??
          payload['bookings'];
    }

    if (payload is! List) {
      if (payload is Map<String, dynamic>) {
        payload = [payload];
      } else {
        throw Exception('Unexpected bookings payload shape');
      }
    }

    final payloadList = (payload).whereType<Map<String, dynamic>>().map((e) {
      // Normalize fields the model expects (status is required in model)
      e['status'] = (e['status'] ?? '').toString();
      e['rescheduleReason'] = e['rescheduleReason']?.toString();
      e['cancelReason'] = e['cancelReason']?.toString();
      return e;
    }).toList();

    final list = payloadList.map((e) => CustomerBooking.fromJson(e)).toList();

    list.sort((a, b) =>
        DateTime.parse(b.creationTime).compareTo(DateTime.parse(a.creationTime)));

    return list;
  }
}
