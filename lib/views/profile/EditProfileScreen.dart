import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../widgets/chayan_header.dart';
import '../../models/customer_models.dart';

class EditProfileScreen extends StatefulWidget {
  final Customer? customer;
  
  const EditProfileScreen({Key? key, this.customer}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for editable fields
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with API data or empty strings
    final customer = widget.customer;
    
    _fullNameController = TextEditingController(
      text: customer?.fullName ?? ''
    );
    _emailController = TextEditingController(
      text: customer?.emailId ?? ''
    );
    _genderController = TextEditingController(
      text: customer?.gender ?? ''
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEDE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            // Fix keyboard overflow with resizeToAvoidBottomInset
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    // Header
                    ChayanHeader(
                      title: 'Edit Profile',
                      onBackTap: () => Get.back(),
                    ),

                    // Profile image
                    Container(
                      margin: EdgeInsets.only(top: 40.h * scaleFactor),
                      child: Stack(
                        children: [
                          Container(
                            width: 100.w * scaleFactor,
                            height: 100.w * scaleFactor,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(62 * scaleFactor),
                              image: widget.customer?.imgLink != null
                                  ? DecorationImage(
                                      image: NetworkImage(widget.customer!.imgLink!),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {
                                        // Fallback to default image on error
                                      },
                                    )
                                  : const DecorationImage(
                                      image: AssetImage('assets/userprofile.webp'),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 25.w * scaleFactor,
                              height: 25.w * scaleFactor,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE47830),
                                borderRadius: BorderRadius.circular(9 * scaleFactor),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 15 * scaleFactor,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form fields
                    Padding(
                      padding: EdgeInsets.all(16.w * scaleFactor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30.h * scaleFactor),
                          
                          // Editable Full Name
                          editableProfileField(
                            label: 'Full Name',
                            controller: _fullNameController,
                            scaleFactor: scaleFactor,
                            hintText: 'Enter your full name',
                          ),
                          
                          // Editable Email
                          editableProfileField(
                            label: 'Email',
                            controller: _emailController,
                            scaleFactor: scaleFactor,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter your email address',
                          ),
                          
                          // Read-only Mobile Number
                          readOnlyProfileField(
                            label: 'Mobile Number',
                            value: widget.customer?.mobileNo != null 
                                ? '+91 ${widget.customer!.mobileNo}' 
                                : 'Not provided',
                            scaleFactor: scaleFactor,
                            hasValue: widget.customer?.mobileNo != null,
                          ),
                          
                          // Gender Selection Field
                          genderSelectionField(
                            label: 'Gender',
                            controller: _genderController,
                            scaleFactor: scaleFactor,
                          ),
                          
                          SizedBox(height: 40.h * scaleFactor),
                          
                          // Save button
                          SizedBox(
                            width: double.infinity,
                            height: 47.h * scaleFactor,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE47830),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10 * scaleFactor),
                                ),
                              ),
                              child: Text(
                                'Save changes',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 16.sp * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 30.h * scaleFactor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget editableProfileField({
    required String label,
    required TextEditingController controller,
    required double scaleFactor,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final hasValue = controller.text.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp * scaleFactor,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
        SizedBox(height: 4.h * scaleFactor),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    // Trigger rebuild to update icon
                  });
                },
              ),
            ),
            _buildStatusIcon(hasValue, scaleFactor),
          ],
        ),
        SizedBox(height: 12.h * scaleFactor),
        Container(
          height: 2.h * scaleFactor,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 20.h * scaleFactor),
      ],
    );
  }

  Widget readOnlyProfileField({
    required String label,
    required String value,
    required double scaleFactor,
    required bool hasValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp * scaleFactor,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
        SizedBox(height: 4.h * scaleFactor),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: hasValue ? Colors.black : Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            _buildStatusIcon(hasValue, scaleFactor),
          ],
        ),
        SizedBox(height: 12.h * scaleFactor),
        Container(
          height: 2.h * scaleFactor,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 20.h * scaleFactor),
      ],
    );
  }

  // New Gender Selection Field with Popup
  Widget genderSelectionField({
    required String label,
    required TextEditingController controller,
    required double scaleFactor,
  }) {
    final hasValue = controller.text.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp * scaleFactor,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
        SizedBox(height: 4.h * scaleFactor),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showGenderSelectionDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h * scaleFactor),
                  child: Text(
                    hasValue ? controller.text : 'Select your gender',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp * scaleFactor,
                      fontWeight: FontWeight.w600,
                      color: hasValue ? Colors.black : Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
            _buildStatusIcon(hasValue, scaleFactor),
          ],
        ),
        SizedBox(height: 12.h * scaleFactor),
        Container(
          height: 2.h * scaleFactor,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 20.h * scaleFactor),
      ],
    );
  }

  Widget _buildStatusIcon(bool hasValue, double scaleFactor) {
    if (hasValue) {
      // Show green check icon for filled fields
      return SvgPicture.asset(
        'assets/icons/check.svg',
        width: 18.w * scaleFactor,
        height: 18.h * scaleFactor,
      );
    } else {
      // Show red cross icon for empty fields
      return Container(
        width: 18.w * scaleFactor,
        height: 18.h * scaleFactor,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          size: 12.sp * scaleFactor,
          color: Colors.white,
        ),
      );
    }
  }

  // Full Width Gender Selection Dialog
  void _showGenderSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w), // Full width with margins
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Select your gender',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30.h),
                
                // Gender Options in a column layout
                Column(
                  children: [
                    // Male and Female in same row
                    Row(
                      children: [
                        Expanded(child: _buildGenderOption('Male')),
                        SizedBox(width: 15.w),
                        Expanded(child: _buildGenderOption('Female')),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    
                    // Other centered in its own row
                    Center(
                      child: Container(
                        width: 120.w,
                        child: _buildGenderOption('Other'),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(String gender) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _genderController.text = gender;
          });
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Text(
          gender,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    // Validate required fields
    if (_fullNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your full name',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Basic email validation
    if (!GetUtils.isEmail(_emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Implement save functionality with API call
    print('Saving changes:');
    print('Full Name: ${_fullNameController.text.trim()}');
    print('Email: ${_emailController.text.trim()}');
    print('Gender: ${_genderController.text.trim()}');
    
    // Show success message
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // Go back to profile screen
    Get.back();
  }
}
