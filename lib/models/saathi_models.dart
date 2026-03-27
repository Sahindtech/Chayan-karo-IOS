import 'package:json_annotation/json_annotation.dart';

part 'saathi_models.g.dart';

// ----------------------------------------------------------------
// REQUEST BODY MODEL
// ----------------------------------------------------------------
@JsonSerializable()
class GetProvidersRequest {
  final String categoryId;
  final String serviceId;
  final String locationId;
  final String addressId;
  final String bookingDate;
  final String bookingTime; // <--- ADDED THIS FIELD
  final int currentBookingDuration;

  GetProvidersRequest({
    required this.categoryId,
    required this.serviceId,
    required this.locationId,
    required this.addressId,
    required this.bookingDate,
    required this.bookingTime, // <--- ADDED THIS PARAMETER
    this.currentBookingDuration = 0,
  });

  Map<String, dynamic> toJson() => _$GetProvidersRequestToJson(this);
}

// ----------------------------------------------------------------
// RESPONSE MODELS
// ----------------------------------------------------------------

@JsonSerializable()
class SaathiResponse {
  final String type;
  final List<SaathiProviderDto> result;

  SaathiResponse({required this.type, required this.result});

  factory SaathiResponse.fromJson(Map<String, dynamic> json) => _$SaathiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SaathiResponseToJson(this);
}

/// Helper DTO for the nested "availabilityResult" object
@JsonSerializable()
class AvailabilityResultDto {
  // We capture ALL fields from the nested object
  final bool isAvailable;
  final int waitingTimeMinutes;
  final String? nextAvailableSlot;

  AvailabilityResultDto({
    required this.isAvailable,
    required this.waitingTimeMinutes,
    this.nextAvailableSlot,
  });

  factory AvailabilityResultDto.fromJson(Map<String, dynamic> json) => 
      _$AvailabilityResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AvailabilityResultDtoToJson(this);
}

// DTO: Captures EVERY field from the backend response
@JsonSerializable()
class SaathiProviderDto {
  final String id;
  final String mobileNo;
  final String? emailId;
  final String? firstName;
  final String? middleName;
  final String? lastName;

  @JsonKey(name: 'averageRating')
  final num? averageRating; 

  @JsonKey(name: 'totalReview')
  final int? totalReview;

  @JsonKey(name: 'imgLink')
  final String? imgLink;

  @JsonKey(name: 'isLocked')
  final bool isLocked;

  @JsonKey(name: 'freeFromTime')
  final int? freeFromTime;

  // The nested availability object
  @JsonKey(name: 'availabilityResult')
  final AvailabilityResultDto? availabilityResult;

  SaathiProviderDto({
    required this.id,
    required this.mobileNo,
    this.emailId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.averageRating,
    this.totalReview,
    this.imgLink,
    required this.isLocked,
    this.freeFromTime,
    this.availabilityResult,
  });

  factory SaathiProviderDto.fromJson(Map<String, dynamic> json) =>
      _$SaathiProviderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SaathiProviderDtoToJson(this);

  // Helper to convert to UI model
  // We map all available data here so the UI/Controller can choose what to use.
  SaathiItem toUi() {
    final parts = <String>[
      (firstName ?? '').trim(),
      (middleName ?? '').trim(),
      (lastName ?? '').trim(),
    ].where((e) => e.isNotEmpty).toList();
    final fullName = parts.isNotEmpty ? parts.join(' ') : 'Provider';

    // Extract minutes from nested object, fallback to flat field
    int minutes = availabilityResult?.waitingTimeMinutes ?? freeFromTime ?? 0;

    return SaathiItem(
      id: id,
      name: fullName,
      mobileNo: mobileNo, // Mapped in case UI needs it
      imageUrl: (imgLink ?? '').trim().isNotEmpty ? imgLink : null,
      rating: averageRating?.toDouble(),
      jobsCompleted: totalReview,
      description: null,
      isLocked: isLocked, 
      freeFromTime: minutes,
      // Map the nested boolean 'isAvailable' to the UI model
      isAvailable: availabilityResult?.isAvailable, 
      // Map the slot string
      nextAvailableSlot: availabilityResult?.nextAvailableSlot, 
    );
  }
}

// ----------------------------------------------------------------
// UI MODEL (Used by Screens & Controller)
// ----------------------------------------------------------------
@JsonSerializable()
class SaathiItem {
  final String id;
  final String name;
  final String? mobileNo; // Added just in case you need it later
  final String? description;

  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  final double? rating;
  final int? jobsCompleted;

  // Locked status
  final bool isLocked;
  
  // Free time in minutes
  final int? freeFromTime;

  // Availability status (True/False)
  final bool? isAvailable;

  // Specific slot time string (e.g. "08:30:00")
  final String? nextAvailableSlot;

  SaathiItem({
    required this.id,
    required this.name,
    this.mobileNo,
    this.description,
    this.imageUrl,
    this.rating,
    this.jobsCompleted,
    required this.isLocked,
    this.freeFromTime,
    this.isAvailable,
    this.nextAvailableSlot,
  });

  factory SaathiItem.fromJson(Map<String, dynamic> json) => _$SaathiItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaathiItemToJson(this);
}

// ----------------------------------------------------------------
// LOCK RESPONSE
// ----------------------------------------------------------------
@JsonSerializable()
class LockProviderResponse {
  final String type;
  final String result;

  LockProviderResponse({
    required this.type,
    required this.result,
  });

  factory LockProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$LockProviderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LockProviderResponseToJson(this);

  bool get isSuccess => result.toLowerCase().contains('success');
}