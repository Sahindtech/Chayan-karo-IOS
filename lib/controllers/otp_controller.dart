import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import '../data/repository/auth_repository.dart';
import '../data/repository/location_repository.dart';
import '../data/local/database.dart';
import '../controllers/profile_controller.dart'; 
import '../../services/notification_service.dart'; // Ensure path is correct

class OtpController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final LocationRepository _locationRepository = Get.find<LocationRepository>();
  final AppDatabase _database = Get.find<AppDatabase>();
  final NotificationService _notificationService = NotificationService();

  // Observable variables
  final _phoneNumber = ''.obs;
  final _otp = ''.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs; // Kept to avoid breaking existing bindings, but we rely on Snackbar now
  final _isButtonEnabled = false.obs;
  final _canResend = false.obs;
  final _secondsRemaining = 30.obs;
  // 1. Add these observables
   final _referralController = TextEditingController();
   final _isExistingUser = false.obs; // This will come from your Login API
   late List<FocusNode> keyboardFocusNodes;

// 2. Add getters
TextEditingController get referralController => _referralController;
bool get isExistingUser => _isExistingUser.value;

  // Controllers and focus nodes for OTP input
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  final TextEditingController otpController = TextEditingController();
final FocusNode otpFocusNode = FocusNode();

  Timer? _resendTimer;

  // Getters
  String get phoneNumber => _phoneNumber.value;
  String get otp => _otp.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isButtonEnabled => _isButtonEnabled.value;
  bool get canResend => _canResend.value;
  int get secondsRemaining => _secondsRemaining.value;

  @override
  void onInit() {
    super.onInit();

    // Get phone number from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('phone')) {
      _phoneNumber.value = args['phone'];
      _isExistingUser.value = args['userExists'] ?? false; // Catch the boolean here
    }

    // Initialize OTP controllers and focus nodes
    otpControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    
  // FIX: Initialize the missing field here
  keyboardFocusNodes = List.generate(4, (index) => FocusNode());
  otpController.addListener(() {
  String text = otpController.text;

  // ✅ keep only digits
  text = text.replaceAll(RegExp(r'\D'), '');

  // ✅ limit to 4 digits
  if (text.length > 4) {
    text = text.substring(0, 4);
  }

  // ✅ update controller safely
  if (otpController.text != text) {
    otpController.text = text;
    otpController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  _otp.value = text;
  _isButtonEnabled.value = text.length == 4;
});

    // Start resend timer
    _startResendTimer();

    print('📱 OtpController initialized for: ${_phoneNumber.value}');
  }

  @override
  void onClose() {
    _resendTimer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in keyboardFocusNodes) {
    focusNode.dispose();
  }
  otpController.dispose();
otpFocusNode.dispose();

    super.onClose();
  }

void _showErrorSnackbar(String message) {
  final overlay = Navigator.of(Get.key.currentContext!, rootNavigator: true).overlay;

  if (overlay == null) {
    print("❌ Overlay still null");
    return;
  }

  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: -100.0, end: 0.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 3), () {
    entry?.remove();
  });
}
void _showSuccessSnackbar(String message) {
  final overlay = Navigator.of(Get.key.currentContext!, rootNavigator: true).overlay;

  if (overlay == null) {
    print("❌ Overlay still null");
    return;
  }

  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: -100.0, end: 0.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.green, // ✅ SUCCESS COLOR
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white), // ✅ SUCCESS ICON
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 3), () {
    entry?.remove();
  });
}
void onOtpChanged(String value, int index) {
  // ✅ SMART PASTE SUPPORT
  final codeMatch = RegExp(r'\d{4}').firstMatch(value);

  if (codeMatch != null) {
    final cleanCode = codeMatch.group(0)!;

    for (int i = 0; i < 4; i++) {
      otpControllers[i].text = cleanCode[i];
    }

    _updateOtpValue();

    // ✅ Keep keyboard open
    focusNodes[3].requestFocus();
    return;
  }

  // ✅ Handle multiple input (paste or fast typing)
  if (value.length > 1) {
    otpControllers[index].text = value.characters.last;
  }

  // ✅ MOVE TO NEXT FIELD (SAFE WAY)
  if (value.isNotEmpty && index < 3) {
    // 🔥 CRITICAL FIX: use addPostFrameCallback instead of delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[index + 1].requestFocus();
    });
  }

  _updateOtpValue();
}
  // --- ADD THIS METHOD FOR BUG-014 (BACKSPACE LOGIC) ---
void handleBackspace(int index) {
  if (index > 0 && otpControllers[index].text.isEmpty) {
    focusNodes[index - 1].requestFocus();
  }
}
  
 void _updateOtpValue() {
  final otpValue =
      otpControllers.map((controller) => controller.text).join();

  _otp.value = otpValue;
  _isButtonEnabled.value = otpValue.length == 4;
}

  Future<void> verifyOTP() async {
  if (_secondsRemaining.value <= 0) {
    _showErrorSnackbar('OTP has expired. Please click Resend OTP.');
    return;
  } 
  if (_otp.value.length != 4) {
    _showErrorSnackbar('Please enter complete OTP');
    return;
  }

  if (_phoneNumber.value.isEmpty) {
    _showErrorSnackbar('Phone number not found');
    return;
  }

  _isLoading.value = true;
  _errorMessage.value = '';

  try {
    // --- ADD THESE LINES TO GET FCM TOKEN ---
    String? fcmToken = await _notificationService.getToken();
    print('🚀 FCM Token for Login: $fcmToken');
    // ----------------------------------------

    print('🔐 Verifying OTP: ${_otp.value} for phone: ${_phoneNumber.value}');

    // --- UPDATE THIS CALL TO PASS FCM TOKEN ---
    final response = await _authRepository.verifyOtp(
      phoneNumber: _phoneNumber.value,
      otp: _otp.value,
      fcmToken: fcmToken, // Pass the token here
      referralCode: _referralController.text.trim(),
    );
    // ----------------------------------------

    print('📥 Verify OTP Response: $response');
    await _handleUniversalResponse(response);
    
  } on DioException catch (e) {
    _handleDioError(e);
    _clearOtpFields();
  } catch (e) {
    _showErrorSnackbar('An unexpected error occurred. Please try again.');
    _clearOtpFields();
  } finally {
    _isLoading.value = false;
  }
}

  Future<void> _handleUniversalResponse(dynamic response) async {
    try {
      String? type;
      String? message;
      String? token;
      String? refreshToken;

      if (response is Map<String, dynamic>) {
        // Handle Map response (direct API call)
        print('📋 Processing Map response');
        type = response['type'] as String?;
        final result = response['result'] as Map<String, dynamic>?;
        message = result?['message'] as String?;
        token = result?['result'] as String?; // JWT token from API
      } else {
        // Handle Object response (Retrofit/Model response)
        print('📋 Processing Object response');

        try {
          // Access the AuthResponse properties
          type = response.type;

          // Get the AuthResult object and extract the JWT
          final authResult = response.result;

          if (authResult != null) {
            print('🔍 Debug - AuthResult type: ${authResult.runtimeType}');

            try {
              // Try to access the message and result (JWT) from AuthResult
              message = authResult.message;
              token = authResult.result; // JWT token string

              print('🔍 Debug - Message from AuthResult: $message');
              print(
                '🔍 Debug - Token from AuthResult: ${token?.substring(0, 30) ?? 'null'}...',
              );
            } catch (e) {
              print('⚠️ Error accessing AuthResult properties: $e');

              // Fallback: try to convert to Map and access
              if (authResult is Map<String, dynamic>) {
                message = authResult['message'] as String?;
                token = authResult['result'] as String?;
              } else {
                // Last resort: try dynamic access
                try {
                  message = (authResult as dynamic).message;
                  token = (authResult as dynamic).result;
                } catch (e2) {
                  print('⚠️ Dynamic access also failed: $e2');
                  message = 'Login successful';
                  // Token will remain null, but we'll still proceed
                }
              }
            }
          }

          // Try to get refresh token if available
          try {
            refreshToken = response.refreshToken;
            if (response.accessToken != null) {
              // Only override token if we don't have one from result
              token ??= response.accessToken;
            }
          } catch (e) {
            print('⚠️ No access/refresh token properties found: $e');
          }
        } catch (e) {
          print('❌ Error accessing object properties: $e');
          // Fallback handling
          final responseStr = response.toString();
          if (responseStr.toLowerCase().contains('success') ||
              responseStr.toLowerCase().contains('login')) {
            type = 'Authentication';
            message = 'Login successful';
          }
        }
      }

      print('📋 Final Extracted Values:');
      print('   Type: $type');
      print('   Message: $message');
      print('   Token available: ${token != null && token!.isNotEmpty}');
      print('   Token length: ${token?.length ?? 0}');

      if (type == 'Authentication' &&
          (message?.toLowerCase().contains('success') == true ||
              message?.toLowerCase().contains('verified') == true ||
              message?.toLowerCase().contains('login') == true)) {
        print('✅ OTP verified successfully');

        // Prepare auth data
        final authData = <String, dynamic>{
          'message': message ?? 'Login successful',
          'type': type,
        };

        if (token != null && token.isNotEmpty) {
          authData['jwt_token'] = token;
          print('🔑 JWT token will be saved: ${token.substring(0, 30)}...');
        } else {
          print(
            '⚠️ WARNING: No JWT token found in response - this will cause profile API to fail!',
          );
        }

        if (refreshToken != null && refreshToken.isNotEmpty) {
          authData['refresh_token'] = refreshToken;
          print('✅ Refresh token extracted');
        }

        await _saveAuthenticationData(authData);

        // Smart navigation based on profile + address
        await _navigateToCorrectScreen();
      } else {
        // ERROR STATE -> Use Snackbar
        String displayMsg = message?.isNotEmpty == true ? message! : 'Invalid OTP. Please try again.';
        _showErrorSnackbar(displayMsg);
        
        print('❌ OTP verification failed: $message');
        _clearOtpFields();
      }
    } catch (e) {
      print('❌ Error in universal response handler: $e');
      _showErrorSnackbar('Response processing failed. Please try again.');
      _clearOtpFields();
    }
  }

  // ✨ Smart navigation: check profile basic fields, then address
  Future<void> _navigateToCorrectScreen() async {
    try {
      print('🔍 OTP Success: Checking profile + customer addresses before navigation...');

      // Ensure token exists (already saved)
      final token = await _database.getAuthToken();
      if (token == null || token.isEmpty) {
        print('⚠️ No auth token found, sending user to location');
        Get.offAllNamed('/location_popup');
        return;
      }

      // 1) Load profile through ProfileController
      final profileController = Get.put(ProfileController(), permanent: true);
      await profileController.loadProfile();

      // 2) Check only necessary fields: firstName, emailId, gender
      final isBasicInfoComplete = profileController.isBasicInfoComplete;
      print('🔍 isBasicInfoComplete: $isBasicInfoComplete');

      if (!isBasicInfoComplete) {
        print('✏️ Incomplete basic profile info - navigating to EditProfileScreen');

        // use the same route + argument style as ProfileScreen/Home
        Get.offAllNamed(
          '/edit-profile',
          arguments: profileController.customer,
        );

        _showSuccessSnackbar("Please complete your profile to continue");
        return;
      }

      // 3) If basic profile is complete, check server addresses
      final addresses = await _locationRepository.getCustomerAddresses();
      final hasAnyAddress = addresses.isNotEmpty;

      if (hasAnyAddress) {
        print('✅ Address found on server - navigating to home');
        Get.offAllNamed('/home');
       _showSuccessSnackbar("Login successful!");
      } else {
        print('📍 No server address - navigating to location screen');
        Get.offAllNamed('/location_popup');
       _showSuccessSnackbar("Login successful! Please set your location");
      }
    } catch (e) {
      print('❌ Error in _navigateToCorrectScreen: $e');
      // Fail-safe: if anything fails, send to edit profile first
      Get.offAllNamed(
        '/edit_profile',
        arguments: {
          'phone': _phoneNumber.value,
          'source': 'otp_flow_error',
        },
      );
    }
  }

  Future<void> _saveAuthenticationData(Map<String, dynamic>? result) async {
    try {
      // Save user as logged in
      await _database.saveUserLoginStatus(true);
      print('✅ User login status saved: true');

      // Prepare user data
      final userData = <String, dynamic>{
        'phone': _phoneNumber.value,
        'login_time': DateTime.now().toIso8601String(),
      };

      if (result != null) {
        // Save JWT token (from different possible fields)
        String? token;

        if (result.containsKey('jwt_token')) {
          token = result['jwt_token'];
        } else if (result.containsKey('access_token')) {
          token = result['access_token'];
        } else if (result.containsKey('result') && result['result'] is String) {
          token = result['result']; // JWT from API response
        }

        if (token != null && token.isNotEmpty) {
          await _database.saveAuthToken(token);
          print(
            '🔑 JWT token saved to database: ${token.substring(0, 30)}...',
          );

          // Verify token was saved correctly
          final savedToken = await _database.getAuthToken();
          if (savedToken == token) {
            print('✅ Token verification successful - database save confirmed');
          } else {
            print('❌ Token verification failed - database save issue!');
          }
        } else {
          print('⚠️ WARNING: No token to save - profile API will fail!');
        }

        // Save refresh token if available
        if (result.containsKey('refresh_token') &&
            result['refresh_token'] != null) {
          await _database.saveRefreshToken(result['refresh_token']);
          print('✅ Refresh token saved');
        }

        // Add additional user data
        if (result.containsKey('user_id')) {
          userData['id'] = result['user_id'];
        }
        if (result.containsKey('name')) {
          userData['name'] = result['name'];
        }
        if (result.containsKey('email')) {
          userData['email'] = result['email'];
        }
        if (result.containsKey('message')) {
          userData['login_message'] = result['message'];
        }
      }

      await _database.saveUserData(userData);
      print('✅ User data saved: ${userData.keys.join(', ')}');
      print('✅ User authentication data saved successfully');
    } catch (e) {
      print('⚠️ Error saving authentication data: $e');
      // Don't throw here, login was successful
    }
  }

  void _clearOtpFields() {
  otpController.clear();
  _otp.value = '';
  _isButtonEnabled.value = false;

  Future.microtask(() {
    otpFocusNode.requestFocus();
  });
}

  Future<void> resendOTP() async {
    if (!_canResend.value || _phoneNumber.value.isEmpty) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      print('🔄 Resending OTP to: ${_phoneNumber.value}');

      // Use generic method that returns Map
      final response = await _authRepository.sendOtpGeneric(_phoneNumber.value);

      final type = response['type'] as String?;
      final result = response['result'] as Map<String, dynamic>?;
      final message = result?['message'] as String? ?? '';

      if (type == 'Authentication' &&
          message.toLowerCase().contains('successfully')) {
        print('✅ OTP resent successfully');

        // Clear current OTP and restart timer
        _clearOtpFields();
        _startResendTimer();

        // Show success message
        _showSuccessSnackbar("A new OTP has been sent");
      } else {
        _showErrorSnackbar('Failed to resend OTP. Please try again.');
        print('❌ Resend OTP failed: $message');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _showErrorSnackbar('Failed to resend OTP. Please try again.');
      print('❌ Error resending OTP: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _startResendTimer() {
    _canResend.value = false;
    _secondsRemaining.value = 30;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        _canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _handleDioError(DioException error) {
    print('🔍 DioError Details:');
    print('   Type: ${error.type}');
    print('   Status Code: ${error.response?.statusCode}');
    print('   Response Data: ${error.response?.data}');
    print('   Message: ${error.message}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        _showErrorSnackbar('Connection timeout. Please check your internet connection.');
        break;
      case DioExceptionType.connectionError:
        _showErrorSnackbar('No internet connection. Please try again.');
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        
        // --- CUSTOM HANDLER FOR WRONG OTP ---
        if (statusCode == 403 || statusCode == 401 || statusCode == 400 ||statusCode == 412) {
          // You explicitly asked for this message for wrong OTP
          _showErrorSnackbar("Wrong OTP, please write valid OTP");
        } 
        else if (statusCode == 429) {
          _showErrorSnackbar('Too many attempts. Please wait before trying again.');
        } else {
          _showErrorSnackbar('Wrong OTP, please write valid OTP');
        }
        break;
      default:
        _showErrorSnackbar('Something went wrong. Please try again.');
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }
}