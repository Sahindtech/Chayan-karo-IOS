// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequest _$SendOtpRequestFromJson(Map<String, dynamic> json) =>
    SendOtpRequest(mobileNo: json['mobileNo'] as String);

Map<String, dynamic> _$SendOtpRequestToJson(SendOtpRequest instance) =>
    <String, dynamic>{'mobileNo': instance.mobileNo};

OtpResponse _$OtpResponseFromJson(Map<String, dynamic> json) => OtpResponse(
  type: json['type'] as String,
  result: OtpResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OtpResponseToJson(OtpResponse instance) =>
    <String, dynamic>{'type': instance.type, 'result': instance.result};

OtpResult _$OtpResultFromJson(Map<String, dynamic> json) =>
    OtpResult(message: json['message'] as String, result: json['result']);

Map<String, dynamic> _$OtpResultToJson(OtpResult instance) => <String, dynamic>{
  'message': instance.message,
  'result': instance.result,
};

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      mobileNo: json['mobileNo'] as String,
      otp: json['otp'] as String,
      fcmToken: json['fcmToken'] as String?,
      referralCode: json['referralCode'] as String? ?? "",
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
      'otp': instance.otp,
      'fcmToken': instance.fcmToken,
      'referralCode': instance.referralCode,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  type: json['type'] as String,
  result: AuthResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'type': instance.type, 'result': instance.result};

AuthResult _$AuthResultFromJson(Map<String, dynamic> json) => AuthResult(
  message: json['message'] as String,
  result: json['result'] as String,
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  user: json['user'] == null
      ? null
      : UserData.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResultToJson(AuthResult instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String,
  name: json['name'] as String,
  mobileNo: json['mobile_no'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'mobile_no': instance.mobileNo,
  'email': instance.email,
};

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(refreshToken: json['refresh_token'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{'refresh_token': instance.refreshToken};
