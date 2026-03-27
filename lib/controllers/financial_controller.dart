import 'package:get/get.dart';
import '../data/repository/financial_repository.dart';
import '../../models/bank_model.dart';
import '../../models/bank_response_model.dart';
import 'package:flutter/material.dart';

class FinancialController extends GetxController {
  final FinancialRepository _repository = FinancialRepository();

  var isLoading = false.obs;

  // --- CHANGE: Reactive List for multiple accounts ---
  // This allows the UI to build a ListView of all bank details
  var bankList = <BankDetail>[].obs;

  // Keep these for the 'Primary' view or legacy single-card support if needed
  var bankName = "".obs;
  var accountNumber = "".obs;
  var accLastFour = "".obs;
  var ifscCode = "".obs;
  var upiId = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchFinancialDetails();
  }

  Future<void> fetchFinancialDetails() async {
    try {
      isLoading(true);
      
      // 1. Get the typed response object from the Repository
      final BankListResponse response = await _repository.getBankDetails();
      
      // 2. Map all bank details from the result list
      final List<BankDetail> details = response.result ?? []; 
      
      // 3. Update the observable list to trigger UI rebuild
      bankList.assignAll(details);

      // 4. Update primary variables based on the first account (if list not empty)
      if (details.isNotEmpty) {
        final data = details.first; 
        
        bankName.value = data.bankName ?? "";
        String fullAcc = data.accountNumber ?? "";
        accountNumber.value = fullAcc;
        
        if (fullAcc.length > 4) {
          accLastFour.value = fullAcc.substring(fullAcc.length - 4);
        } else {
          accLastFour.value = fullAcc;
        }
        
        ifscCode.value = data.ifscCode ?? "";
        upiId.value = data.upiId ?? "";
      } else {
        bankName.value = ""; // Trigger Empty State
      }
    } catch (e) {
      debugPrint("Financial Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> saveBankDetails(String bank, String acc, String ifsc, String upi) async {
  try {
    isLoading(true);
    final body = {
      "bankName": bank,
      "accountNumber": acc,
      "ifscCode": ifsc,
      "upiId": upi
    };
    
    await _repository.addBankDetails(body);
    await fetchFinancialDetails(); 
    return true;
  } catch (e) {
    String errorMsg = e.toString();
    
    // Check for "Failed to lookup host" (No Internet)
    if (errorMsg.contains("Failed host lookup") || errorMsg.contains("SocketException")) {
      Get.snackbar(
        "Connection Error", 
        "Please check your internet connection.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } else {
      // General user-friendly error
      Get.snackbar(
        "Upload Failed", 
        "Something went wrong. Please try again later.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  } finally {
    isLoading(false);
  }
}
Future<bool> updateBankDetails({
  required String bankId,
  required String bank,
  required String acc,
  required String ifsc,
  required String upi,
}) async {
  try {
    isLoading(true);
    final body = {
      "bankId": bankId, // Required for update
      "bankName": bank,
      "accountNumber": acc,
      "ifscCode": ifsc,
      "upiId": upi
    };

    await _repository.updateBankDetails(body);
    await fetchFinancialDetails(); // Refresh the list
    return true;
  } catch (e) {
    _handleError(e); // Use your existing snackbar error logic
    return false;
  } finally {
    isLoading(false);
  }
}

  void _handleError(dynamic e) {
    String errorMsg = e.toString();
    
    if (errorMsg.contains("Failed host lookup") || errorMsg.contains("SocketException")) {
      Get.snackbar(
        "Connection Error", 
        "Please check your internet connection.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } else {
      Get.snackbar(
        "Operation Failed", 
        "Something went wrong. Please try again later.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
}
}