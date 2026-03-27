import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // <--- Required for FileImage
import '../../widgets/chayan_header.dart';
import '../../models/customer_models.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/test_extensions.dart';
import 'package:image_picker/image_picker.dart'; // <--- ADD THIS
import '../../widgets/discard_changes_sheet.dart'; // <--- IMPORT YOUR DIALOG FILE HERE
import '../../widgets/app_snackbar.dart';


class EditProfileScreen extends StatefulWidget {
  final Customer? customer;
  const EditProfileScreen({super.key, this.customer});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;

  final ProfileController _profileController = Get.find();
  // To track initial values for comparison
  late String _initialName;
  late String _initialEmail;
  late String _initialGender;
  // --- ADD THESE VARIABLES ---
  String? _nameError;
  String? _emailError;
  String? _genderError;

  @override
  void initState() {
    super.initState();
    // 1. Get the current customer data
    final c = widget.customer ?? _profileController.customer;
    
    // 2. FIX: Initialize the comparison variables so they are not null/late error
    _initialName = c?.fullName ?? '';
    _initialEmail = c?.emailId ?? '';
    _initialGender = c?.gender ?? '';

    // 3. Initialize the Controllers
    _fullNameController = TextEditingController(text: _initialName);
    _emailController = TextEditingController(text: _initialEmail);
    _genderController = TextEditingController(text: _initialGender);
  }
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    super.dispose();
  }
  // --- VALIDATION HELPERS ---
  bool _isNameValid(String name) {
    final trimmed = name.trim();
    if (trimmed.length <= 3) return false;
    // Regex allows letters and spaces only
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) return false;
    return true;
  }

  bool _isEmailValid(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false; // Optional field, so empty is valid
    // Strict Email Regex
    return RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(trimmed);
  }

  bool _isGenderValid(String gender) {
    return gender.trim().isNotEmpty;
  }
  // Helper to check for changes
  bool get _hasChanges {
    return _fullNameController.text.trim() != _initialName ||
           _emailController.text.trim() != _initialEmail ||
           _genderController.text.trim() != _initialGender;
  }

  // Unified Back Handler
// Unified Back Handler
  Future<void> _handleBack() async {
    // 1. MANDATORY CHECK (From Controller)
    // If the profile currently saved on the server is incomplete, BLOCK exit.
    // We check the controller because it holds the "source of truth" data.
    if (!_profileController.isBasicInfoComplete) {
    AppSnackbar.showWarning('Please complete your profile details to continue.');
      return; // <--- STOP. Do not pop.
    }

    // 2. Standard "Discard Changes" Logic
    // Only reachable if the profile is already valid/complete
    if (_hasChanges) {
      final shouldDiscard = await showDiscardChangesSheet(context);
      if (shouldDiscard && mounted) {
        _safePop();
      }
    } else {
      _safePop();
    }
  }

  // Helper to prevent Black Screen if navigation history is empty
  void _safePop() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Get.offAllNamed('/profile');
    }
  }
  ImageProvider _getImageProvider({File? localImage, String? networkUrl}) {
  // 1. Priority: Show Local Image (Instant feedback)
  if (localImage != null) {
    return FileImage(localImage);
  }

  // 2. Secondary: Show Network Image with Cache Busting
  if (networkUrl != null && networkUrl.isNotEmpty) {
    // Append timestamp to force refresh
    return NetworkImage('$networkUrl?v=${_profileController.imageVersion.value}');
  }

  // 3. Fallback: Default Placeholder
  return const AssetImage('assets/userprofile.webp');
}
// NEW: Bottom Sheet to choose Camera or Gallery (Fixes BUG-022/023)
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFE47830)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Calls controller with Gallery source
                  _profileController.pickAndUploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFE47830)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Calls controller with Camera source
                  _profileController.pickAndUploadImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;
        
        // 1. Wrap Scaffold in PopScope
        return PopScope(
          canPop: false, // Disable automatic popping
          onPopInvoked: (didPop) async {
            if (didPop) return;
            await _handleBack(); // Use our custom logic
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: const Color(0xFFFFEDE0),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                     ChayanHeader(
                      title: 'Edit Profile',
                      onBack: _handleBack,
                    ),
                    
                    // UPDATED: Profile Image Section with Upload Logic
                    Container(
                      margin: EdgeInsets.only(top: 40.h * scaleFactor),
                      child: Obx(() {
                        // Prioritize live data from controller to show updates immediately
                        final currentCustomer = _profileController.customer ?? widget.customer;
                        final isUploading = _profileController.isUploading;
                        
                        return Stack(
                          children: [
                            // 1. Profile Image Circle
                            Container(
                              width: 100.w * scaleFactor,
                              height: 100.w * scaleFactor,
                             decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(62 * scaleFactor),
  color: Colors.grey[200],
  image: DecorationImage(
    fit: BoxFit.cover,
    
    // --- UPDATED LOGIC ---
    // Uses the helper to check Local File -> Network URL -> Asset
    image: _getImageProvider(
      localImage: _profileController.localImage.value,
      networkUrl: currentCustomer?.imageUrl,
    ),
    // ---------------------
  ),
),
                            ),
                            
                            // 2. Edit/Upload Icon Button
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: isUploading 
                                    ? null 
                                 : () => _showImageSourceOptions(), // <--- NEW CODE
                                child: Container(
                                  width: 32.w * scaleFactor,
                                  height: 32.w * scaleFactor,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE47830),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isUploading
                                        ? SizedBox(
                                            width: 14.w * scaleFactor,
                                            height: 14.w * scaleFactor,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Icon(
                                            Icons.camera_alt, // Changed to camera icon for better context
                                            color: Colors.white,
                                            size: 16.sp * scaleFactor,
                                          ),
                                  ),
                                ),
                              ),
                            ).withId('edit_profile_image_btn'),
                          ],
                        );
                      }),
                    ),

                    Padding(
                      padding: EdgeInsets.all(16.w * scaleFactor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30.h * scaleFactor),
                          editableProfileField(
                            label: 'Full Name',
                            controller: _fullNameController,
                            scaleFactor: scaleFactor,
                            testId: 'edit_profile_name_input', // <--- Added ID
                            hintText: 'Enter your full name',
                            validator: _isNameValid,
                            errorText: _nameError,
                            // ADD THIS: Allows only letters (a-z, A-Z) and spaces
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          editableProfileField(
                            label: 'Email',
                            controller: _emailController,
                            scaleFactor: scaleFactor,
                            keyboardType: TextInputType.emailAddress,
                            testId: 'edit_profile_email_input', // <--- Added ID
                            hintText: 'Enter your email address',
                            validator: _isEmailValid,
                            errorText: _emailError,
                          ),
                          readOnlyProfileField(
                            label: 'Mobile Number',
                            value: widget.customer?.mobileNo != null
                                ? '+91 ${widget.customer!.mobileNo}'
                                : 'Not provided',
                            scaleFactor: scaleFactor,
                            hasValue: widget.customer?.mobileNo != null,
                          ),
                          genderSelectionField(
                            label: 'Gender',
                            controller: _genderController,
                            scaleFactor: scaleFactor,
                            testId: 'edit_profile_gender_select',
                            errorText: _genderError, // <--- PASS IT HERE // <--- Added ID
                            
                          ),
                          SizedBox(height: 40.h * scaleFactor),
                          SizedBox(
                            width: double.infinity,
                            height: 47.h * scaleFactor,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE47830),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Save changes',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.32,
                                  color: Colors.white,
                                ),
                              ),
                            ).withId('edit_profile_save_btn'),
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
        )
        );
      },
    );
  }

Widget editableProfileField({
    required String label,
    required TextEditingController controller,
    required double scaleFactor,
    required String hintText,
    required String testId, // <--- 1. ADD THIS
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters, // <--- Added this parameter
    bool Function(String)? validator, // <--- NEW PARAMETER
    String? errorText, // <--- NEW PARAMETER
  }) {
// UPDATED LOGIC: Use validator if provided, otherwise default to non-empty check
    final isValid = validator != null 
        ? validator(controller.text) 
        : controller.text.isNotEmpty;
            return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top so error text doesn't misalign icon
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  // --- VISUAL ERROR HANDLING ---
                  errorText: errorText,
                  errorStyle: TextStyle(fontSize: 12.sp, color: Colors.red[800]),
                  // Turn lines red on error
                  border: errorText != null 
                      ? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)) 
                      : InputBorder.none,
                  enabledBorder: errorText != null 
                      ? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)) 
                      : InputBorder.none,
                  focusedBorder: errorText != null 
                      ? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)) 
                      : InputBorder.none,
                  // -----------------------------
                  contentPadding: EdgeInsets.zero,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                onChanged: (value) {
  // 1. Clear specific error when user types
  if (errorText != null) {
    setState(() {
      if (label == 'Full Name') _nameError = null;
      if (label == 'Email') _emailError = null;
    });
  }
  
  // 2. Add this to force the checkmark/X icon to update instantly
  setState(() {}); 
},
              ).withId(testId),
            ),
            // Only show the Checkmark/X icon if there is NO error to avoid clutter
            if (errorText == null) _buildStatusIcon(isValid),
          ],
        ),
        
        // Hide the custom gray divider if InputDecorator is showing the red error line
        if (errorText == null) ...[
          SizedBox(height: 12.h),
          Container(
            height: 2.h,
            width: double.infinity,
            color: const Color(0xFFEBEBEB),
          ),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget readOnlyProfileField({
    required String label,
    required String value,
    required bool hasValue,
    required double scaleFactor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: hasValue
                      ? Colors.black
                      : Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            _buildStatusIcon(hasValue),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 2.h,
          width: double.infinity,
          color: const Color(0xFFEBEBEB),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget genderSelectionField({
    required String label,
    required TextEditingController controller,
    required double scaleFactor,
    required String testId, // <--- 1. ADD THIS
    String? errorText, // <--- 1. NEW PARAMETER
  }) {
   final isValid = _isGenderValid(controller.text) && errorText == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.83,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Clear error as soon as user opens the dialog
                  if (errorText != null) setState(() => _genderError = null);
                  _showGenderDialog();
                },
                  child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    controller.text.isNotEmpty
                        ? controller.text
                        : 'Select your gender',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                     color: isValid ? Colors.black : Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
               ).withId(testId), // <--- 2. USE IT HERE
            ),
       if (errorText == null) _buildStatusIcon(isValid),
          ],
        ),
        // --- 2. ERROR DISPLAY LOGIC ---
        if (errorText != null) ...[
           // Show RED line and Error Text
           Container(height: 2.h, width: double.infinity, color: Colors.red),
           SizedBox(height: 4.h),
           Text(errorText, style: TextStyle(color: Colors.red[800], fontSize: 12.sp)),
        ] else ...[
           // Show Standard Grey Line
           SizedBox(height: 12.h),
           Container(height: 2.h, width: double.infinity, color: const Color(0xFFEBEBEB)),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildStatusIcon(bool hasValue) {
    if (hasValue) {
      return SvgPicture.asset(
        'assets/icons/check.svg',
        width: 18.w,
        height: 18.h,
      );
    } else {
      return Container(
        width: 18.w,
        height: 18.h,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          size: 12.sp,
          color: Colors.white,
        ),
      );
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select your gender',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(child: _genderOption('Male').withId('gender_option_male')),
                  SizedBox(width: 15.w),
                  Expanded(child: _genderOption('Female').withId('gender_option_female')),
                ],
              ),
              SizedBox(height: 15.h),
              Center(
                child: SizedBox(
                  width: 120.w,
                  child: _genderOption('Other').withId('gender_option_other'),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderOption(String gender) {
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
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Text(
          gender,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    // 1. Reset Errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _genderError = null;
    });

    final name = _fullNameController.text.trim();
    bool hasError = false; // Flag to stop execution if any error is found

    // 2. Validation: Name
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter your full name');
      hasError = true;
    } else if (name.length <= 3) {
      setState(() => _nameError = 'Name must be more than 3 characters');
      hasError = true;
    } else {
      final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
      if (!nameRegExp.hasMatch(name)) {
        setState(() => _nameError = 'Special characters are not allowed');
        hasError = true;
      }
    }

    // 3. Validation: Gender
    if (_genderController.text.trim().isEmpty) {
      setState(() => _genderError = 'Please select your gender');
      hasError = true;
    }

    // 4. Validation: Email
    final rawEmail = _emailController.text.trim();
    if (rawEmail.isNotEmpty) {
      final emailRegExp = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegExp.hasMatch(rawEmail)) {
        setState(() => _emailError = 'Please enter a valid email address');
        hasError = true;
      }
    }

    // STOP execution here if there are errors (Visuals will update automatically)
    if (hasError) {
      // Optional: Keep a generic snackbar if you want extra feedback
      AppSnackbar.showError('Please correct the highlighted fields');
      return; 
    }

    // 5. Proceed with API Call
    final String? emailToSend = rawEmail.isEmpty ? null : rawEmail;

    final success = await _profileController.updateProfile(
      emailId: emailToSend,
      fullName: name,
      gender: _genderController.text.trim(),
    );

    if (success) {
     AppSnackbar.showSuccess('Profile updated successfully');
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/profile');
    } else {
      AppSnackbar.showError(_profileController.errorMessage);
    }
  }
}