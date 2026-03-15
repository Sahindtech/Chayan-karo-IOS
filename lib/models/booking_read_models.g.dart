// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_read_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingAmount _$BookingAmountFromJson(Map<String, dynamic> json) =>
    BookingAmount(
      actualAmount: json['actualAmount'] as num,
      plateFormFee: json['plateFormFee'] as num,
      gstAmount: json['gstAmount'] as num,
      gstPercentage: json['gstPercentage'] as num,
    );

Map<String, dynamic> _$BookingAmountToJson(BookingAmount instance) =>
    <String, dynamic>{
      'actualAmount': instance.actualAmount,
      'plateFormFee': instance.plateFormFee,
      'gstAmount': instance.gstAmount,
      'gstPercentage': instance.gstPercentage,
    };

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) => CustomerInfo(
  id: json['id'] as String,
  mobileNo: json['mobileNo'] as String,
  emailId: json['emailId'] as String?,
  firstName: json['firstName'] as String?,
  middleName: json['middleName'] as String?,
  lastName: json['lastName'] as String,
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$CustomerInfoToJson(CustomerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mobileNo': instance.mobileNo,
      'emailId': instance.emailId,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'gender': instance.gender,
    };

AddressInfo _$AddressInfoFromJson(Map<String, dynamic> json) => AddressInfo(
  id: json['id'] as String,
  addressLine1: json['addressLine1'] as String,
  addressLine2: json['addressLine2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  postCode: json['postCode'] as String,
  addressType: json['addressType'] as String?,
  geoBoundary: json['geoBoundary'] as String?,
);

Map<String, dynamic> _$AddressInfoToJson(AddressInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postCode': instance.postCode,
      'addressType': instance.addressType,
      'geoBoundary': instance.geoBoundary,
    };

ServiceProviderInfo _$ServiceProviderInfoFromJson(Map<String, dynamic> json) =>
    ServiceProviderInfo(
      id: json['id'] as String,
      mobileNo: json['mobileNo'] as String,
      emailId: json['emailId'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$ServiceProviderInfoToJson(
  ServiceProviderInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'mobileNo': instance.mobileNo,
  'emailId': instance.emailId,
  'firstName': instance.firstName,
  'middleName': instance.middleName,
  'lastName': instance.lastName,
  'gender': instance.gender,
};

BookingServiceRead _$BookingServiceReadFromJson(Map<String, dynamic> json) =>
    BookingServiceRead(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      serviceId: json['serviceId'] as String,
      serviceIName: json['serviceIName'] as String,
      discountPercentage: (json['discountPercentage'] as num).toInt(),
      price: json['price'] as num,
      discountPrice: json['discountPrice'] as num,
      serviceDuration: (json['serviceDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookingServiceReadToJson(BookingServiceRead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'serviceId': instance.serviceId,
      'serviceIName': instance.serviceIName,
      'discountPercentage': instance.discountPercentage,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'serviceDuration': instance.serviceDuration,
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
  id: json['id'] as String,
  couponType: json['couponType'] as String,
  couponCode: json['couponCode'] as String,
  amount: json['amount'] as num,
  minPurchaseAmount: json['minPurchaseAmount'] as num,
  discountPercentage: (json['discountPercentage'] as num).toInt(),
  sameUserLimit: (json['sameUserLimit'] as num).toInt(),
);

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
  'id': instance.id,
  'couponType': instance.couponType,
  'couponCode': instance.couponCode,
  'amount': instance.amount,
  'minPurchaseAmount': instance.minPurchaseAmount,
  'discountPercentage': instance.discountPercentage,
  'sameUserLimit': instance.sameUserLimit,
};

CustomerBooking _$CustomerBookingFromJson(Map<String, dynamic> json) =>
    CustomerBooking(
      id: json['id'] as String,
      spId: json['spId'] as String,
      bookingReferenceNumber: json['bookingReferenceNumber'] as String,
      totalDuration: (json['totalDuration'] as num).toInt(),
      bookingTime: json['bookingTime'] as String,
      bookingDate: json['bookingDate'] as String,
      rescheduleReason: json['rescheduleReason'] as String?,
      cancelReason: json['cancelReason'] as String?,
      creationTime: json['creationTime'] as String,
      bookingPin: (json['bookingPin'] as num).toInt(),
      paymentMode: json['paymentMode'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      bookingAmount: json['bookingAmount'] == null
          ? null
          : BookingAmount.fromJson(
              json['bookingAmount'] as Map<String, dynamic>,
            ),
      coupon: json['coupon'] == null
          ? null
          : Coupon.fromJson(json['coupon'] as Map<String, dynamic>),
      feedbackSubmitted: json['feedbackSubmitted'] as bool? ?? false,
      bookingService: (json['bookingService'] as List<dynamic>)
          .map((e) => BookingServiceRead.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerDetails: CustomerInfo.fromJson(
        json['customerDetails'] as Map<String, dynamic>,
      ),
      customerAddress: AddressInfo.fromJson(
        json['customerAddress'] as Map<String, dynamic>,
      ),
      serviceProvider: ServiceProviderInfo.fromJson(
        json['serviceProvider'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
    );

Map<String, dynamic> _$CustomerBookingToJson(CustomerBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spId': instance.spId,
      'bookingReferenceNumber': instance.bookingReferenceNumber,
      'totalDuration': instance.totalDuration,
      'bookingTime': instance.bookingTime,
      'bookingDate': instance.bookingDate,
      'rescheduleReason': instance.rescheduleReason,
      'cancelReason': instance.cancelReason,
      'creationTime': instance.creationTime,
      'bookingPin': instance.bookingPin,
      'paymentMode': instance.paymentMode,
      'paymentStatus': instance.paymentStatus,
      'bookingAmount': instance.bookingAmount,
      'coupon': instance.coupon,
      'feedbackSubmitted': instance.feedbackSubmitted,
      'bookingService': instance.bookingService,
      'customerDetails': instance.customerDetails,
      'customerAddress': instance.customerAddress,
      'serviceProvider': instance.serviceProvider,
      'status': instance.status,
    };

CustomerBookingResponse _$CustomerBookingResponseFromJson(
  Map<String, dynamic> json,
) => CustomerBookingResponse(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => CustomerBooking.fromJson(e as Map<String, dynamic>))
      .toList(),
  item: json['item'] == null
      ? null
      : CustomerBooking.fromJson(json['item'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomerBookingResponseToJson(
  CustomerBookingResponse instance,
) => <String, dynamic>{'list': instance.list, 'item': instance.item};
