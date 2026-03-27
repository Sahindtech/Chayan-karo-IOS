import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/financial_controller.dart';
import '../../../models/bank_model.dart';
import '../profile/financial_details_screen.dart'; // Adjust path to your bank list screen

Future<BankDetail?> showBankSelectorPopup(BuildContext context) {
  return showModalBottomSheet<BankDetail>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const _BankSelectorSheet(),
        ),
      );
    },
  );
}

class _BankSelectorSheet extends StatefulWidget {
  const _BankSelectorSheet({super.key});

  @override
  State<_BankSelectorSheet> createState() => _BankSelectorSheetState();
}

class _BankSelectorSheetState extends State<_BankSelectorSheet> {
  bool isSelected = false;
  BankDetail? _selected;
  late final FinancialController _fin;

  @override
  void initState() {
    super.initState();
    _fin = Get.find<FinancialController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fin.fetchFinancialDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final sheetHeight = screenH * 0.55; // Slightly taller for bank info

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletDevice = constraints.maxWidth > 600;
        final double scaleFactor = isTabletDevice ? constraints.maxWidth / 411 : 1.0;

        return Container(
          height: sheetHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.h * scaleFactor)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor, vertical: 16.h * scaleFactor),
            child: Obx(() {
              final loading = _fin.isLoading.value;
              final banks = _fin.bankList;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select bank account',
                        style: TextStyle(
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          // Navigate to your manage bank screen
                          await Get.to(() => const FinancialDetailsScreen());
                          await _fin.fetchFinancialDetails();
                        },
                        icon: Icon(Icons.add, color: const Color(0xFFFF7900), size: 18 * scaleFactor),
                        label: Text(
                          'Add new bank',
                          style: TextStyle(
                            fontSize: 14.sp * scaleFactor,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF7900),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF7900),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h * scaleFactor),
                  Divider(height: 1.h * scaleFactor),
                  SizedBox(height: 8.h * scaleFactor),

                  /// List
                  Expanded(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF7900)),
                          )
                        : banks.isEmpty
                            ? Center(
                                child: Text(
                                  'No saved bank accounts yet',
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                                ),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(vertical: 6.h * scaleFactor),
                                itemCount: banks.length,
                                separatorBuilder: (_, __) => SizedBox(height: 10.h * scaleFactor),
                                itemBuilder: (_, i) {
                                  final b = banks[i];
                                  final lastFour = b.accountNumber != null && b.accountNumber!.length > 4
                                      ? b.accountNumber!.substring(b.accountNumber!.length - 4)
                                      : b.accountNumber;

                                  return InkWell(
                                    splashColor: Colors.orange.withOpacity(0.1),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isSelected = true;
                                        _selected = b;
                                      });
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio<String>(
                                          value: b.id ?? '',
                                          groupValue: _selected?.id,
                                          activeColor: const Color(0xFFFF7900),
                                          onChanged: (_) {
                                            setState(() {
                                              isSelected = true;
                                              _selected = b;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 6.w * scaleFactor),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                b.bankName ?? 'Bank Account',
                                                style: TextStyle(
                                                  fontSize: 14.sp * scaleFactor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4.h * scaleFactor),
                                              Text(
                                                'A/c: **** $lastFour | IFSC: ${b.ifscCode}',
                                                style: TextStyle(
                                                  fontSize: 13.sp * scaleFactor,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.verified_user_outlined, color: Colors.green, size: 18),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),

                  /// Proceed button
                  SizedBox(height: 12.h * scaleFactor),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h * scaleFactor,
                    child: ElevatedButton(
                      onPressed: isSelected && _selected != null
                          ? () => Navigator.pop(context, _selected)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFFFF7900) : const Color(0xFFE0E0E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scaleFactor),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontSize: 16.sp * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}