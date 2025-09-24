import '../remote/network_client.dart';
import '../../models/auth_models.dart';
import 'package:dio/dio.dart';


class AuthRepository {
  // Singleton instance
  static final AuthRepository _instance = AuthRepository._internal();

  final NetworkClient _networkClient;

  // Private named constructor
  AuthRepository._internal() : _networkClient = NetworkClient();

  // Factory pattern
  factory AuthRepository() => _instance;

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      final request = SendOtpRequest(mobileNo: phoneNumber);
      print('📤 Sending OTP request: ${request.toJson()}');
      return await _networkClient.apiService.sendOtp(request);
    } catch (e) {
      print('❌ Auth Repository - Send OTP Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendOtpGeneric(String phoneNumber) async {
    try {
      final data = {'mobileNo': phoneNumber};
      print('📤 Sending OTP request (generic): $data');
      final response = await _networkClient.dio.post(
        '/Authentication/login',
        data: data,
      );
      print('📥 Raw send OTP response: ${response.data}');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Auth Repository - Send OTP Error (generic): $e');
      rethrow;
    }
  }

  Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final request = VerifyOtpRequest(
        mobileNo: phoneNumber,
        otp: otp,
      );
      print('📤 Verifying OTP request: ${request.toJson()}');
      return await _networkClient.apiService.verifyOtp(request);
    } catch (e) {
      print('❌ Auth Repository - Verify OTP Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtpGeneric({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final data = {
        'mobileNo': phoneNumber,
        'otp': otp,
      };
      print('📤 Verifying OTP request (generic): $data');
      final response = await _networkClient.dio.post(
        '/Authentication/verifyOTP',
        data: data,
      );
      print('📥 Raw verify response: ${response.data}');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Auth Repository - Verify OTP Error (generic): $e');
      rethrow;
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      return await _networkClient.apiService.refreshToken(request);
    } catch (e) {
      print('❌ Auth Repository - Refresh Token Error: $e');
      rethrow;
    }
  }

  Future<void> testApiRequest(String phoneNumber) async {
    try {
      print('🧪 Testing API request format...');
      final data = {
        'mobileNo': phoneNumber,
      };
      print('📤 Test request data: $data');
      final response = await _networkClient.dio.post(
        '/Authentication/login',
        data: data,
      );
      print('✅ Test request successful: ${response.statusCode}');
      print('📥 Response: ${response.data}');
    } catch (e) {
      print('❌ Test request failed: $e');
      if (e is DioException) {
        print('   Status Code: ${e.response?.statusCode}');
        print('   Response Data: ${e.response?.data}');
        print('   Request Data: ${e.requestOptions.data}');
      }
    }
  }

  Future<void> testVerifyOtpRequest(String phoneNumber, String otp) async {
    try {
      print('🧪 Testing OTP verification request...');
      final data = {
        'mobileNo': phoneNumber,
        'otp': otp,
      };
      print('📤 Test verify request data: $data');
      final response = await _networkClient.dio.post(
        '/Authentication/verifyOTP',
        data: data,
      );
      print('✅ Test verify request successful: ${response.statusCode}');
      print('📥 Response: ${response.data}');
    } catch (e) {
      print('❌ Test verify request failed: $e');
      if (e is DioException) {
        print('   Status Code: ${e.response?.statusCode}');
        print('   Response Data: ${e.response?.data}');
        print('   Request Data: ${e.requestOptions.data}');
      }
    }
  }
}
