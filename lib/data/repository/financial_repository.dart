import '../remote/api_service.dart';
import '../remote/network_client.dart';
import '../../data/local/database.dart';
import '../../models/bank_response_model.dart';

class FinancialRepository {
  FinancialRepository({AppDatabase? database})
      : _db = database ?? AppDatabase(),
        _api = NetworkClient().apiService; //

  final AppDatabase _db;
  final ApiService _api;

 Future<BankListResponse> getBankDetails() async {
  final token = await _db.getAuthToken();
  if (token == null) throw Exception('User not authenticated');

  try {
    return await _api.getRefundBank('Bearer $token'); 
  } catch (e) {
    rethrow;
  }
}

  Future<void> addBankDetails(Map<String, dynamic> details) async {
    final token = await _db.getAuthToken(); //
    if (token == null) throw Exception('User not authenticated');

    try {
      await _api.addRefundBankDetail('Bearer $token', details); //
    } catch (e) {
      rethrow;
    }
  }
  // 1. Add the update endpoint to your existing repository
Future<void> updateBankDetails(Map<String, dynamic> details) async {
  final token = await _db.getAuthToken();
  if (token == null) throw Exception('User not authenticated');

  try {
    // This calls the @PUT or @POST endpoint in your ApiService
    await _api.updateRefundBankDetail('Bearer $token', details);
  } catch (e) {
    rethrow;
  }
}
}