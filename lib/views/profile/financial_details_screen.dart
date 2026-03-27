import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/financial_controller.dart';
import '../../models/bank_model.dart';
import '../../widgets/chayan_header.dart';
import '../../utils/test_extensions.dart';
import '../../widgets/three_dot_loader.dart';

class FinancialDetailsScreen extends StatefulWidget {
  const FinancialDetailsScreen({super.key});

  @override
  State<FinancialDetailsScreen> createState() => _FinancialDetailsScreenState();
}

class _FinancialDetailsScreenState extends State<FinancialDetailsScreen> {
  final FinancialController _fController = Get.put(FinancialController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fController.fetchFinancialDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isTablet = constraints.maxWidth > 600;
      double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const ChayanHeader(title: "Financial Details"),
            Expanded(
              child: Obx(() {
                if (_fController.isLoading.value) {
                  return Center(
  child: ThreeDotLoader(
    color: const Color(0xFFE47830),
    size: 14,
  ),
);
                }

                return _fController.bankList.isEmpty
                    ? _buildEmptyState(scaleFactor)
                    : _buildBankListView(scaleFactor);
              }),
            ),
          ],
        ),
      );
    });
  }

  // --- BANK LIST VIEW ---
  Widget _buildBankListView(double scaleFactor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w * scaleFactor),
          child: GestureDetector(
            onTap: () => _showAddBankSheet(scaleFactor),
            child: Row(
              children: [
                Icon(Icons.add, color: const Color(0xFFE47830), size: 20 * scaleFactor),
                SizedBox(width: 8.w * scaleFactor),
                Text(
                  'Add another bank account',
                  style: TextStyle(
                    color: const Color(0xFFE47830),
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ).withId('financial_add_bank_btn'),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
            itemCount: _fController.bankList.length,
            itemBuilder: (context, index) {
              final bank = _fController.bankList[index];
              final lastFour = bank.accountNumber != null && bank.accountNumber!.length > 4
                  ? bank.accountNumber!.substring(bank.accountNumber!.length - 4)
                  : bank.accountNumber;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h * scaleFactor),
                padding: EdgeInsets.all(16.r * scaleFactor),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEBEBEB)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEE0),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.account_balance, color: const Color(0xFFE47830), size: 24 * scaleFactor),
                    ),
                    SizedBox(width: 16.w * scaleFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bank.bankName ?? 'Bank Account',
                            style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '**** $lastFour • ${bank.ifscCode}',
                            style: TextStyle(fontSize: 14.sp * scaleFactor, color: const Color(0xFF757575)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.green, size: 20),
                    SizedBox(width: 8.w),
IconButton(
  icon: Icon(Icons.edit_outlined, color: Colors.grey, size: 20 * scaleFactor),
  onPressed: () => _showAddBankSheet(scaleFactor, existingBank: bank), // Pass existing data
),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double scaleFactor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 60 * scaleFactor, color: Colors.grey[300]),
          SizedBox(height: 16.h * scaleFactor),
          const Text('No bank details added yet', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24.h * scaleFactor),
          SizedBox(
            width: 200.w,
            child: _primaryButton("Add Bank", () => _showAddBankSheet(scaleFactor), scaleFactor),
          ),
        ],
      ),
    );
  }

  // --- MODAL BOTTOM SHEET FOR ADDING BANK ---
  void _showAddBankSheet(double scaleFactor,{BankDetail? existingBank}) {
    
    final bool isEdit = existingBank != null; // Helper to check mode

    final formKey = GlobalKey<FormState>();
    final bankNameCtrl = TextEditingController(text: existingBank?.bankName);
  final accNumCtrl = TextEditingController(text: existingBank?.accountNumber);
  final reAccNumCtrl = TextEditingController(text: existingBank?.accountNumber);
  final ifscCtrl = TextEditingController(text: existingBank?.ifscCode);
  final upiCtrl = TextEditingController(text: existingBank?.upiId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        // Dynamic bottom padding for keyboard
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75, // Opened less height
          maxChildSize: 0.95,    // Expand on keyboard
          minChildSize: 0.4,
          expand: false,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r * scaleFactor)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text("Add Bank Details", 
                    style: TextStyle(fontSize: 18.sp * scaleFactor, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: EdgeInsets.symmetric(horizontal: 20.w * scaleFactor),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          _OutlinedIconField(
                            scaleFactor: scaleFactor, 
                            controller: bankNameCtrl, 
                            hintText: 'Bank Name *', 
                            icon: Icons.account_balance, 
                            testId: 'add_bank_name',
                            validator: (v) => (v == null || v.length < 3) ? "Enter valid bank name" : null,
                          ),
                          SizedBox(height: 12.h),
                          _OutlinedIconField(
                            scaleFactor: scaleFactor, 
                            controller: accNumCtrl, 
                            hintText: 'Account Number *', 
                            icon: Icons.numbers, 
                            keyboardType: TextInputType.number, 
                            testId: 'add_bank_acc',
                            validator: (v) => (v == null || v.length < 9) ? "Enter 9-18 digit account number" : null,
                          ),
                          SizedBox(height: 12.h),
                          _OutlinedIconField(
                            scaleFactor: scaleFactor, 
                            controller: reAccNumCtrl, 
                            hintText: 'Re-enter Account Number *', 
                            icon: Icons.replay, 
                            keyboardType: TextInputType.number, 
                            testId: 'add_bank_reacc',
                            validator: (v) => v != accNumCtrl.text ? "Account numbers do not match" : null,
                          ),
                          SizedBox(height: 12.h),
                          _OutlinedIconField(
                            scaleFactor: scaleFactor, 
                            controller: ifscCtrl, 
                            hintText: 'IFSC Code *', 
                            icon: Icons.code, 
                            testId: 'add_bank_ifsc',
                            validator: (v) => !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(v?.toUpperCase() ?? "") 
                                ? "Invalid IFSC format (e.g. SBIN0001234)" : null,
                          ),
                          SizedBox(height: 12.h),
                          _OutlinedIconField(
                            scaleFactor: scaleFactor, 
                            controller: upiCtrl, 
                            hintText: 'UPI ID (Optional)', 
                            icon: Icons.alternate_email, 
                            testId: 'add_bank_upi',
                            validator: (v) {
                              if (v != null && v.isNotEmpty && !v.contains('@')) return "Enter valid UPI ID";
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                // Save Button Footer
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h * scaleFactor,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE47830),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                    onPressed: () async {
  if (formKey.currentState!.validate()) {
    bool success;
    if (isEdit) {
      // ✅ CALL UPDATE LOGIC
      success = await _fController.updateBankDetails(
        bankId: existingBank.id!, // Pass the ID for the update
        bank: bankNameCtrl.text.trim(),
        acc: accNumCtrl.text.trim(),
        ifsc: ifscCtrl.text.trim().toUpperCase(),
        upi: upiCtrl.text.trim(),
      );
    } else {
      // CALL SAVE LOGIC (Existing)
      success = await _fController.saveBankDetails(
        bankNameCtrl.text.trim(),
        accNumCtrl.text.trim(),
        ifscCtrl.text.trim().toUpperCase(),
        upiCtrl.text.trim(),
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
      Get.snackbar(
        "Success", 
        isEdit ? "Bank details updated" : "Bank details added",
        backgroundColor: Colors.green[100], 
        colorText: Colors.green[800]
      );
    }
  }
},
                      child: const Text("Save Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap, double scaleFactor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE47830),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r * scaleFactor)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _OutlinedIconField extends StatelessWidget {
  final double scaleFactor;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String testId;
  final String? Function(String?)? validator; // <--- ADD THIS
  final TextInputType? keyboardType;

  const _OutlinedIconField({
    required this.scaleFactor,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.testId,
    this.validator, // <--- ADD THIS
    this.keyboardType,
  });

 @override
  Widget build(BuildContext context) {
    return TextFormField( // Changed from Container/TextField to TextFormField
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 15 * scaleFactor),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFFE47830), size: 20 * scaleFactor),
        hintStyle: TextStyle(color: const Color(0xFFB9B6B3), fontSize: 14 * scaleFactor),
        filled: true,
        fillColor: const Color(0xFFF8F6F4),
        contentPadding: EdgeInsets.symmetric(horizontal: 12 * scaleFactor, vertical: 14 * scaleFactor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * scaleFactor),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(fontSize: 11, color: Colors.red), // Validation text style
      ),
    ).withId(testId);
  }
}
