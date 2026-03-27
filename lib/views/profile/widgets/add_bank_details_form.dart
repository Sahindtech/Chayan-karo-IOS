import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/financial_controller.dart';

class AddBankDetailsForm extends StatefulWidget {
  const AddBankDetailsForm({super.key});

  @override
  _AddBankDetailsFormState createState() => _AddBankDetailsFormState();
}

class _AddBankDetailsFormState extends State<AddBankDetailsForm> {
  final FinancialController _controller = Get.find<FinancialController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bankNameController;
  late TextEditingController _accNumController;
  late TextEditingController _ifscController;
  late TextEditingController _upiController;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController(text: _controller.bankName.value);
    _accNumController = TextEditingController(text: _controller.accountNumber.value);
    _ifscController = TextEditingController(text: _controller.ifscCode.value);
    _upiController = TextEditingController(text: _controller.upiId.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Update Bank Details", style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInput("Bank Name", _bankNameController, Icons.account_balance),
                _buildInput("Account Number", _accNumController, Icons.credit_card, isNumber: true),
                _buildInput("IFSC Code", _ifscController, Icons.pin),
                _buildInput("UPI ID", _upiController, Icons.alternate_email),
                SizedBox(height: 40.h),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE47830),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _controller.isLoading.value ? null : _handleSave,
                    child: _controller.isLoading.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFE47830)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE47830)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) => value!.isEmpty ? "This field is required" : null,
      ),
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _controller.saveBankDetails(
        _bankNameController.text.trim(),
        _accNumController.text.trim(),
        _ifscController.text.trim(),
        _upiController.text.trim(),
      );
      if (success) {
        Get.back();
        Get.snackbar("Success", "Bank details saved!", backgroundColor: Colors.green[100]);
      }
    }
  }
}