// lib/models/location_models.dart
import 'package:json_annotation/json_annotation.dart';
part 'location_models.g.dart';

@JsonSerializable()
class AddAddressRequest {
  @JsonKey(name: 'addressLine1') final String addressLine1;
  @JsonKey(name: 'addressLine2') final String addressLine2;
  @JsonKey(name: 'city') final String city;
  @JsonKey(name: 'state') final String state;
  @JsonKey(name: 'postCode') final String postCode;
  @JsonKey(name: 'lat') final double lat;
  @JsonKey(name: 'long') final double long;

  AddAddressRequest({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postCode,
    required this.lat,
    required this.long,
  });

  factory AddAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddAddressRequestToJson(this);
}

@JsonSerializable()
class AddAddressResponse {
  final bool success;
  final String message;
  final String? addressId;
  AddAddressResponse({required this.success, required this.message, this.addressId});

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddAddressResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AddAddressResponseToJson(this);
}

// UPDATED: extra optional fields + copyWith to help local default + header sync
@JsonSerializable()
class CustomerAddress {
  final String id;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postCode;
  final bool isDefault;
  final String? label;      // optional
  final String? latitude;   // optional (string if API returns as string)
  final String? longitude;  // optional

  CustomerAddress({
    required this.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postCode,
    required this.isDefault,
    this.label,
    this.latitude,
    this.longitude,
  });

  CustomerAddress copyWith({
    String? id,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postCode,
    bool? isDefault,
    String? label,
    String? latitude,
    String? longitude,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postCode: postCode ?? this.postCode,
      isDefault: isDefault ?? this.isDefault,
      label: label ?? this.label,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerAddressToJson(this);
}

@JsonSerializable()
class GetCustomerAddressesResponse {
  final String type;
  final List<CustomerAddress> result;
  GetCustomerAddressesResponse({required this.type, required this.result});

  factory GetCustomerAddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCustomerAddressesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetCustomerAddressesResponseToJson(this);
}

@JsonSerializable()
class CachedLocationData {
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final String? houseNumber;
  final String? landmark;
  final String? city;
  final String? state;
  final String? postCode;
  final DateTime savedAt;

  CachedLocationData({
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.houseNumber,
    this.landmark,
    this.city,
    this.state,
    this.postCode,
    required this.savedAt,
  });

  factory CachedLocationData.fromJson(Map<String, dynamic> json) =>
      _$CachedLocationDataFromJson(json);
  Map<String, dynamic> toJson() => _$CachedLocationDataToJson(this);
}
