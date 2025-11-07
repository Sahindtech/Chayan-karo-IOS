import 'package:get/get.dart';
import '../../../data/repository/location_repository.dart';

class AddressGuard extends GetMiddleware {
  final LocationRepository _locationRepo = Get.find<LocationRepository>();

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    try {
      final addresses = await _locationRepo.getCustomerAddresses();
      if (addresses.isEmpty) {
        return GetNavConfig.fromRoute('/location_popup');
      }
      return route; // allow
    } catch (_) {
      return GetNavConfig.fromRoute('/location_popup');
    }
  }
}
