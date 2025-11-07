import 'package:meta/meta.dart';
import '../remote/api_service.dart';
import '../remote/network_client.dart';
import '../../models/saathi_models.dart';

@immutable
class SaathiRepository {
  SaathiRepository();

  ApiService get _api => NetworkClient().apiService; // use singleton

  Future<List<SaathiItem>> getServiceProviders({
    required String categoryId,
    required String serviceId,
    required String locationId,
  }) async {
    // Token header is injected by NetworkClient interceptor.
    final res = await _api.getServiceProvider(
      '', // header param exists in retrofit; interceptor will override
      categoryId,
      serviceId,
      locationId,
    );
    return res.result;
  }
}
