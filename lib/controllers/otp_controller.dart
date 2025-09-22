import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import '../data/repository/auth_repository.dart'; // Fixed import path
import '../data/local/database.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AppDatabase _database = Get.find<AppDatabase>();

  // Observable variables
  final _phoneNumber = ''.obs;
  final _otp = ''.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isButtonEnabled = false.obs;
  final _canResend = false.obs;
  final _secondsRemaining = 30.obs;

  // Controllers and focus nodes for OTP input
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  
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
    }

    // Initialize OTP controllers and focus nodes
    otpControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    
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
    
    super.onClose();
  }

  void onOtpChanged(String value, int index) {
    // Clear error when user starts typing
    if (_errorMessage.value.isNotEmpty) {
      _errorMessage.value = '';
    }

    // Auto-move to next field
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
    
    // Auto-move to previous field when deleting
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    // Update OTP value
    _updateOtpValue();
  }

  void _updateOtpValue() {
    final otpValue = otpControllers.map((controller) => controller.text).join();
    _otp.value = otpValue;
    _isButtonEnabled.value = otpValue.length == 4;
  }

  Future<void> verifyOTP() async {
    if (_otp.value.length != 4) {
      _errorMessage.value = 'Please enter complete OTP';
      return;
    }

    if (_phoneNumber.value.isEmpty) {
      _errorMessage.value = 'Phone number not found';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      print('🔐 Verifying OTP: ${_otp.value} for phone: ${_phoneNumber.value}');
      
      // Get response from auth repository
      final response = await _authRepository.verifyOtp(
        phoneNumber: _phoneNumber.value,
        otp: _otp.value,
      );

      print('📥 Verify OTP Response Type: ${response.runtimeType}');
      print('📥 Verify OTP Response: $response');

      // Universal response handler
      await _handleUniversalResponse(response);

    } on DioException catch (e) {
      _handleDioError(e);
      _clearOtpFields();
    } catch (e) {
      _errorMessage.value = 'An unexpected error occurred. Please try again.';
      print('❌ Unexpected error verifying OTP: $e');
      print('❌ Error type: ${e.runtimeType}');
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
          
          // CRITICAL FIX: Get the AuthResult object and extract the JWT
          final authResult = response.result;
          
          if (authResult != null) {
            print('🔍 Debug - AuthResult type: ${authResult.runtimeType}');
            
            try {
              // Try to access the message and result (JWT) from AuthResult
              message = authResult.message;
              token = authResult.result; // This should be the JWT token string
              
              print('🔍 Debug - Message from AuthResult: $message');
              print('🔍 Debug - Token from AuthResult: ${token?.substring(0, 30) ?? 'null'}...');
              
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
      
      if (type == 'Authentication' && (
          message?.toLowerCase().contains('success') == true ||
          message?.toLowerCase().contains('verified') == true ||
          message?.toLowerCase().contains('login') == true
        )) {
        
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
          print('⚠️ WARNING: No JWT token found in response - this will cause profile API to fail!');
        }
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          authData['refresh_token'] = refreshToken;
          print('✅ Refresh token extracted');
        }
        
        await _saveAuthenticationData(authData);
        _navigateToHome();
        
      } else {
        _errorMessage.value = message?.isNotEmpty == true ? message! : 'Invalid OTP. Please try again.';
        print('❌ OTP verification failed: $message');
        _clearOtpFields();
      }
      
    } catch (e) {
      print('❌ Error in universal response handler: $e');
      _errorMessage.value = 'Response processing failed. Please try again.';
      _clearOtpFields();
    }
  }

  void _navigateToHome() {
    Get.offAllNamed('/home');
    
    Get.snackbar(
      'Success',
      'Login successful!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
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
          print('🔑 JWT token saved to database: ${token.substring(0, 30)}...');
          
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
        if (result.containsKey('refresh_token') && result['refresh_token'] != null) {
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
    for (var controller in otpControllers) {
      controller.clear();
    }
    _otp.value = '';
    _isButtonEnabled.value = false;
    
    // Focus on first field
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
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

      if (type == 'Authentication' && message.toLowerCase().contains('successfully')) {
        print('✅ OTP resent successfully');
        
        // Clear current OTP and restart timer
        _clearOtpFields();
        _startResendTimer();
        
        // Show success message
        Get.snackbar(
          'OTP Sent',
          'A new OTP has been sent to +91 ${_phoneNumber.value}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        
      } else {
        _errorMessage.value = 'Failed to resend OTP. Please try again.';
        print('❌ Resend OTP failed: $message');
      }

    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _errorMessage.value = 'Failed to resend OTP. Please try again.';
      print('❌ Error resending OTP: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _startResendTimer() {
    _canResend.value = false;
    _secondsRemaining.value = 30;
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
        _errorMessage.value = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.connectionError:
        _errorMessage.value = 'No internet connection. Please try again.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String message = 'Invalid OTP. Please try again.';
        
        // Handle 403 specifically
        if (statusCode == 403) {
          message = 'OTP verification failed. Please ensure you are using the correct OTP.';
          
          if (responseData is Map<String, dynamic>) {
            final result = responseData['result'] as Map<String, dynamic>?;
            if (result != null && result.containsKey('message')) {
              message = result['message'];
            } else if (responseData.containsKey('message')) {
              message = responseData['message'];
            }
          }
        } else if (statusCode == 400) {
          _errorMessage.value = message;
        } else if (statusCode == 401) {
          _errorMessage.value = 'Invalid or expired OTP. Please try again.';
        } else if (statusCode == 429) {
          _errorMessage.value = 'Too many attempts. Please wait before trying again.';
        } else {
          _errorMessage.value = 'Server error. Please try again later.';
        }
        break;
      default:
        _errorMessage.value = 'Something went wrong. Please try again.';
    }
  }

  void clearError() {
    _errorMessage.value = '';
  }

  // Debug method to test with cURL phone number
  Future<void> debugWithCurlPhoneNumber() async {
    try {
      print('🧪 Testing with cURL phone number (1212121212)...');
      
      final dio = Dio();
      dio.options.headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final data = {
        'mobileNo': '1212121212',
        'otp': '1234',
      };

      print('📤 cURL Phone Test Request: $data');

      final response = await dio.post(
        'http://65.1.234.42:8081/Authentication/VerifyOTP',
        data: data,
        options: Options(
          validateStatus: (status) => status != null,
        ),
      );

      print('📥 cURL Phone Test Status: ${response.statusCode}');
      print('📥 cURL Phone Test Response: ${response.data}');

      if (response.statusCode == 200) {
        print('✅ SUCCESS with cURL phone number!');
        
        // Process the successful response
        await _handleUniversalResponse(response.data);
        
      } else {
        print('❌ Still failed with cURL phone number: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ cURL phone test error: $e');
    }
  }

  // Add this method to test token extraction specifically
  Future<void> debugTokenExtraction() async {
    try {
      print('🧪 Testing token extraction...');
      
      final response = await _authRepository.verifyOtp(
        phoneNumber: _phoneNumber.value,
        otp: _otp.value,
      );
      
      print('🔍 Response type: ${response.runtimeType}');
      print('🔍 Response.type: ${response.type}');
      print('🔍 Response.result type: ${response.result.runtimeType}');
      
      try {
        print('🔍 Response.result.message: ${response.result.message}');
        print('🔍 Response.result.result: ${response.result.result}');
      } catch (e) {
        print('⚠️ Error accessing result properties: $e');
      }
      
    } catch (e) {
      print('❌ Debug token extraction error: $e');
    }
  }
}
