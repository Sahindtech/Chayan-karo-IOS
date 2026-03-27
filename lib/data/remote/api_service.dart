// lib/data/remote/api_service.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/auth_models.dart';
import '../../models/customer_models.dart';
import '../../models/category_models.dart';
import '../../models/service_models.dart';
import '../../models/location_models.dart';
import '../../models/saathi_models.dart';
import '../../models/payment_models.dart';
import '../../models/booking_models.dart';
import '../../models/reschedule_models.dart';
import '../../models/cancel_models.dart';
import 'dart:io'; // Add this for File
//import '../../models/booking_read_models.dart';
import '../../models/feedback_req_model.dart'; // Add this import
import '../../models/search_model.dart'; // Add this import
import '../../models/most_used_service_model.dart';
import '../../models/booked_saathi_model.dart';
import '../../models/saathi_rating_model.dart'; // Add this import
import '../../models/provider_service_model.dart';
import '../../models/check_availability_model.dart';
// Add this import
import '../../models/bank_response_model.dart';
import '../../models/banner_model.dart'; // Add this import
import '../../models/coupon_models.dart'; // Add this import

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.chayankaro.com")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // Auth
  @POST('/user/login')
  Future<OtpResponse> sendOtp(@Body() SendOtpRequest request);

  @POST('/user/verifyOTP')
  Future<AuthResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('/user/refreshToken')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  // Customer
  @GET('/user/getCustomer')
  Future<CustomerResponse> getCustomer(@Header("Authorization") String authorization);

  @POST('/user/updateCustomerProfile')
  Future<void> updateCustomerProfile(
    @Header("Authorization") String authorization,
    @Body() Map<String, dynamic> updateBody,
  );
  @POST('/user/uploadUserProfile')
  @MultiPart()
  Future<void> uploadProfilePicture(
    @Header("Authorization") String authorization,
    @Part(name: "file") File file, // Matches 'file' key in backend
  );

  // Category
  @GET('/user/getCategory')
  Future<CategoryResponse> getCategories(@Header("Authorization") String authorization);

  // Services
  @GET('/user/getServices')
  Future<ServiceResponse> getServices(
    @Header("Authorization") String authorization,
    @Query("serviceCategoryId") String serviceCategoryId,
  );

  // Location
  @POST('/user/addCustomerAddress')
  Future<AddAddressResponse> addCustomerAddress(
    @Header("Authorization") String authorization,
    @Body() AddAddressRequest request,
  );

  @GET('/user/getCustomerAddress')
  Future<GetCustomerAddressesResponse> getCustomerAddresses(
    @Header("Authorization") String token,
  );
// Add this to your ApiService interface
  @DELETE("/user/deleteCustomerAddress")
  Future<BaseResponse> deleteCustomerAddress(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );
  @POST('/user/updateCustomerAddress')
Future<BaseResponse> updateCustomerAddress(
  @Header('Authorization') String token,
  @Body() Map<String, dynamic> body,
);
  // Saathi
 @POST('/user/getServiceProvider')
  Future<SaathiResponse> getServiceProvider(
    @Header("Authorization") String token,
    @Body() GetProvidersRequest body,
  );
// In your ApiService file (e.g., api_service.dart)

@GET('/user/lockServiceProvider')
Future<LockProviderResponse> lockServiceProvider(
  @Header("Authorization") String authorization,
  @Query("serviceProviderId") String serviceProviderId,
  @Query("date") String date, // <--- ADDED THIS
);
@GET('/user/getServiceProviderRating')
  Future<RatingResponse> getProviderRatings(
    @Header("Authorization") String token,
    @Query("serviceProviderId") String serviceProviderId,
  );

  @GET('/user/getServiceProviderBookedByCustomer')
  Future<BookedSaathiResponse> getBookedServiceProviders(
    @Header("Authorization") String token,
  );
@GET('/user/getServicesByProviderId')
  Future<ProviderServicesResponse> getServicesByProviderId(
    @Header("Authorization") String token,
    @Query("serviceProviderId") String serviceProviderId,
  );
  // Inside api_service.dart

@POST('/user/checkServiceProviderAvailability')
Future<CheckAvailabilityResponse> checkServiceProviderAvailability(
  @Header("Authorization") String token,
  @Body() Map<String, dynamic> body,
);

  // Booking (model-based)
  @POST('/user/addBooking')
  Future<AddBookingResponse> addBooking(
    @Header('Authorization') String authorization,
    @Body() AddBookingRequest body,
  );

  // Booking (raw-map fallback) — add this
  @POST('/user/addBooking')
  Future<AddBookingResponse> addBookingRaw(
    @Header('Authorization') String authorization,
    @Body() Map<String, dynamic> body,
  );

  // Payment
  @POST('/user/createOrder')
  Future<CreateOrderResponse> createOrder(
    @Header("Authorization") String authorization,
    @Body() CreateOrderRequest request,
  );
    @POST('/user/updatePayment')
  Future<dynamic> updatePayment(
    @Header("Authorization") String authorization,
    @Body() Map<String, dynamic> body, // { bookingId, orderId, paymentId, signature }
  );
@GET('/user/getCustomerBooking')
Future<HttpResponse<Object?>> getCustomerBookingsRaw(
  @Header("Authorization") String authorization,
);

// Location coverage
@GET('/user/getLocation')
Future<ServiceLocationsResponse> getServiceableLocations(
  @Header("Authorization") String authorization,
);
@POST('/user/rescheduleBooking')
Future<RescheduleBookingEnvelope> rescheduleBooking(
  @Header('Authorization') String bearer,
  @Body() RescheduleBookingRequest body,
);

@POST('/user/rescheduleBooking')
Future<RescheduleBookingEnvelope> rescheduleBookingRaw(
  @Header('Authorization') String bearer,
  @Body() Map<String, dynamic> body,
);

 @POST('/user/cancelBooking')
Future<CancelBookingEnvelope> cancelBookingRaw(
  @Header('Authorization') String bearer,
  @Body() Map<String, dynamic> body,
);
@POST('/user/serviceProviderRating')
  Future<void> rateServiceProvider(
    @Header("Authorization") String token,
    @Body() ServiceProviderRatingRequest body,
  );

  @POST('/user/serviceBookingRating')
  Future<void> rateServiceBooking(
    @Header("Authorization") String token,
    @Body() ServiceBookingRatingRequest body,
  );
  
  @GET("/user/searchActiveService")
  Future<SearchResponse> searchActiveServices(
    @Header("Authorization") String token,
    @Query("search") String query,
  );
  // Add this to your ApiService interface
  @GET("/user/mostUsedServices")
  Future<MostUsedServiceResponse> getMostUsedServices(
    @Header("Authorization") String token,
  );
  @POST('/user/addRefundBankDetail')
Future<void> addRefundBankDetail(
  @Header("Authorization") String authorization,
  @Body() Map<String, dynamic> bankBody,
);

@GET('/user/getRefundBank')
Future<BankListResponse> getRefundBank(
  @Header("Authorization") String authorization,
);
@POST('/user/refundBookingAmount')
Future<void> refundBookingAmount(
  @Header("Authorization") String authorization,
  @Body() Map<String, dynamic> refundBody,
);
@POST('/user/updateRefundBankDetail') 
Future<void> updateRefundBankDetail(
  @Header('Authorization') String token, 
  @Body() Map<String, dynamic> body
);

@GET("/user/getAllSlideBanners")
Future<BannerResponse> getHomeBanners(@Header("Authorization") String token);
@GET('/user/getAllCoupons')
Future<CouponResponse> getAllCoupons(
  @Header("Authorization") String token,
  @Query("categoryId") String categoryId,
);

@POST('/user/validateCoupon')
Future<ValidateCouponResponse> validateCoupon(
  @Header("Authorization") String token,
  @Body() Map<String, dynamic> body,
);
}
