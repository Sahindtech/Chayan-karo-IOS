import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class SendOtpRequest {
  @JsonKey(name: 'mobileNo')
  final String mobileNo;

  const SendOtpRequest({required this.mobileNo});

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$SendOtpRequestToJson(this);
    print('🔍 SendOtpRequest JSON: $json');
    return json;
  }
}

@JsonSerializable()
class OtpResponse {
  final String type;
  final OtpResult result;

  const OtpResponse({required this.type, required this.result});

  factory OtpResponse.fromJson(Map<String, dynamic> json) => _$OtpResponseFromJson(json);

  bool get success => type == "Authentication";
  String get message => result.message;
  
  // NEW: Helper to check if the user exists based on the 'result' field
  bool get isExistingUser => result.result == true; 
}

@JsonSerializable()
class OtpResult {
  final String message;
  final dynamic result; // Changed from String to dynamic to accept bool

  const OtpResult({required this.message, required this.result});

  factory OtpResult.fromJson(Map<String, dynamic> json) => _$OtpResultFromJson(json);
}
@JsonSerializable()
class VerifyOtpRequest {
  @JsonKey(name: 'mobileNo')
  final String mobileNo;
  
  @JsonKey(name: 'otp')
  final String otp;
  @JsonKey(name: 'fcmToken') // Added
  final String? fcmToken;

  @JsonKey(name: 'referralCode') // Added
  final String? referralCode;

  const VerifyOtpRequest({
    required this.mobileNo,
    required this.otp,
    this.fcmToken,
    this.referralCode = "",
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$VerifyOtpRequestToJson(this);
    print('🔍 VerifyOtpRequest JSON: $json');
    return json;
  }
}

// You'll need to create this model based on the actual verify OTP response
// For now, let's create a flexible response model
@JsonSerializable()
class AuthResponse {
  final String type;
  final AuthResult result;

  const AuthResponse({
    required this.type,
    required this.result,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  // Helper methods
  bool get success => type == "Authentication";
  String get message => result.message;
  String? get accessToken => result.accessToken;
  String? get refreshToken => result.refreshToken;
  UserData? get user => result.user;
}

@JsonSerializable()
class AuthResult {
  final String message;
  final String result;
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  final UserData? user;

  const AuthResult({
    required this.message,
    required this.result,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);
}

@JsonSerializable()
class UserData {
  final String id;
  final String name;
  @JsonKey(name: 'mobile_no')
  final String mobileNo;
  final String email;

  const UserData({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
