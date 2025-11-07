import 'package:get/get.dart';
import '../data/repository/saathi_repository.dart';
import '../models/saathi_models.dart';

class SaathiController extends GetxController {
  final SaathiRepository _repo;

  SaathiController({SaathiRepository? repo}) : _repo = repo ?? SaathiRepository();

  final RxList<SaathiItem> saathiList = <SaathiItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt selectedIndex = 2.obs;

  Future<void> fetchProviders({
    required String categoryId,
    required String serviceId,
    required String locationId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final list = await _repo.getServiceProviders(
        categoryId: categoryId,
        serviceId: serviceId,
        locationId: locationId,
      );
      saathiList.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onItemTapped(int index) => selectedIndex.value = index;
}
