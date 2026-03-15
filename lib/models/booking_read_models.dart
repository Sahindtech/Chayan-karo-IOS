// lib/models/booking_read_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'booking_read_models.g.dart';

@JsonSerializable()
class BookingAmount {
  final num actualAmount;
  final num plateFormFee;
  final num gstAmount;
  final num gstPercentage;

  BookingAmount({
    required this.actualAmount,
    required this.plateFormFee,
    required this.gstAmount,
    required this.gstPercentage,
  });

  factory BookingAmount.fromJson(Map<String, dynamic> json) =>
      _$BookingAmountFromJson(json);

  Map<String, dynamic> toJson() => _$BookingAmountToJson(this);
}

@JsonSerializable()
class CustomerInfo {
  final String id;
  final String mobileNo;
  final String? emailId;
  final String? firstName;
  final String? middleName;
  final String lastName;
  final String? gender;

  CustomerInfo({
    required this.id,
    required this.mobileNo,
    this.emailId,
    this.firstName,
    this.middleName,
    required this.lastName,
    this.gender,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerInfoToJson(this);
}

@JsonSerializable()
class AddressInfo {
  final String id;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postCode;
  final String? addressType;

  final String? geoBoundary;

  AddressInfo({
    required this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postCode,
    this.addressType,

    this.geoBoundary,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressInfoToJson(this);
}

@JsonSerializable()
class ServiceProviderInfo {
  final String id;
  final String mobileNo;
  final String? emailId;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;

  ServiceProviderInfo({
    required this.id,
    required this.mobileNo,
    this.emailId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
  });

  factory ServiceProviderInfo.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderInfoToJson(this);
}

@JsonSerializable()
class BookingServiceRead {
  final String id;
  final String bookingId;
  final String categoryId;
  final String categoryName;
  final String serviceId;
  final String serviceIName; // matches backend typo
  final int discountPercentage;
  final num price;
  final num discountPrice;
  final int? serviceDuration;

  BookingServiceRead({
    required this.id,
    required this.bookingId,
    required this.categoryId,
    required this.categoryName,
    required this.serviceId,
    required this.serviceIName,
    required this.discountPercentage,
    required this.price,
    required this.discountPrice,
    this.serviceDuration,

  });

  factory BookingServiceRead.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceReadFromJson(json);

  Map<String, dynamic> toJson() => _$BookingServiceReadToJson(this);
}

@JsonSerializable()
class Coupon {
  final String id;
  final String couponType;
  final String couponCode;
  final num amount;
  final num minPurchaseAmount;
  final int discountPercentage;
  final int sameUserLimit;

  Coupon({
    required this.id,
    required this.couponType,
    required this.couponCode,
    required this.amount,
    required this.minPurchaseAmount,
    required this.discountPercentage,
    required this.sameUserLimit,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);
}

@JsonSerializable()
class CustomerBooking {
  final String id;
  final String spId;
  final String bookingReferenceNumber;
  final int totalDuration;
  final String bookingTime; // server "HHmm" string
  final String bookingDate; // server ISO date at midnight UTC
  final String? rescheduleReason;
  final String? cancelReason;
  final String creationTime; // ISO datetime string
  final int bookingPin;

  // NEW FIELDS from backend
  final String? paymentMode;   // "ONLINE", "CASH"
  final String? paymentStatus; // "Paid", "UnPaid"
  final BookingAmount? bookingAmount;
  final Coupon? coupon;
  @JsonKey(defaultValue: false)
  final bool feedbackSubmitted;

  final List<BookingServiceRead> bookingService;
  final CustomerInfo customerDetails;
  final AddressInfo customerAddress;
  final ServiceProviderInfo serviceProvider;

  // status from backend ("Pending", "Cancelled", "completed")
  final String status;

  CustomerBooking({
    required this.id,
    required this.spId,
    required this.bookingReferenceNumber,
    required this.totalDuration,
    required this.bookingTime,
    required this.bookingDate,
    this.rescheduleReason,
    this.cancelReason,
    required this.creationTime,
    required this.bookingPin,
    this.paymentMode,
    this.paymentStatus,
    this.bookingAmount, // ✅ ADD THIS
    this.coupon, // ✅ ADD THIS
    this.feedbackSubmitted = false, // ✅
    required this.bookingService,
    required this.customerDetails,
    required this.customerAddress,
    required this.serviceProvider,
    required this.status,
  });

  factory CustomerBooking.fromJson(Map<String, dynamic> json) =>
      _$CustomerBookingFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerBookingToJson(this);
}

// NEW: Non-breaking helpers for correct local display without timezone drift.
// These do NOT affect serialization or existing fields.
extension CustomerBookingDisplay on CustomerBooking {
  // Safely returns local wall-clock DateTime by combining date-only (yyyy-MM-dd)
  // with bookingTime "HHmm". Ignores the UTC time component from bookingDate.
  DateTime? get displayDateTimeLocal {
    try {
      // bookingDate example: "2025-11-18T00:00:00.000+00:00"
      // Take only the leading date part "yyyy-MM-dd"
      if (bookingDate.length < 10) return null;
      final datePart = bookingDate.substring(0, 10);
      final y = int.parse(datePart.substring(0, 4));
      final m = int.parse(datePart.substring(5, 7));
      final d = int.parse(datePart.substring(8, 10));

      // bookingTime is "HHmm"
      if (bookingTime.length < 4) return DateTime(y, m, d); // fallback to midnight local
      final hh = int.parse(bookingTime.substring(0, 2));
      final mm = int.parse(bookingTime.substring(2, 4));

      // Construct local DateTime without any UTC conversion
      return DateTime(y, m, d, hh, mm);
    } catch (_) {
      return null;
    }
  }

  // Convenience: date-only local object for grouping or headers.
  DateTime? get displayDateOnlyLocal {
    try {
      if (bookingDate.length < 10) return null;
      final datePart = bookingDate.substring(0, 10);
      final y = int.parse(datePart.substring(0, 4));
      final m = int.parse(datePart.substring(5, 7));
      final d = int.parse(datePart.substring(8, 10));
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }
}

@JsonSerializable()
class CustomerBookingResponse {
  // In case backend returns an array or a single object in future,
  // keep both fields optional and use a convenience getter.
  final List<CustomerBooking>? list;
  final CustomerBooking? item;

  CustomerBookingResponse({this.list, this.item});

  List<CustomerBooking> get items => list ?? (item != null ? [item!] : []);

  factory CustomerBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerBookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerBookingResponseToJson(this);
}
