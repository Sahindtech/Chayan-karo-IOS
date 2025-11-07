// lib/data/remote/api_service.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/auth_models.dart';
import '../../models/home_models.dart';
import '../../models/customer_models.dart';
import '../../models/category_models.dart';
import '../../models/service_models.dart';
import '../../models/location_models.dart'; // NEW
import '../../models/saathi_models.dart'; // NEW
import '../../models/payment_models.dart'; // NEW



part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.chayankaro.com")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // Auth endpoints
  @POST('/user/login')
  Future<OtpResponse> sendOtp(@Body() SendOtpRequest request);

  @POST('/user/verifyOTP')
  Future<AuthResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('/user/refreshToken')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  // Customer Profile endpoints
  @GET('/user/getCustomer')
  Future<CustomerResponse> getCustomer(@Header("Authorization") String authorization);

  @POST('/user/updateCustomerProfile')
  Future<void> updateCustomerProfile(
    @Header("Authorization") String authorization,
    @Body() Map<String, dynamic> updateBody
  );

  // Category endpoints
  @GET('/user/getCategory')
  Future<CategoryResponse> getCategories(@Header("Authorization") String authorization);

  // Service endpoints - CORRECTED
  @GET('/user/getServices')
  Future<ServiceResponse> getServices(
    @Header("Authorization") String authorization,
    @Query("serviceCategoryId") String serviceCategoryId,
  );
   // ✨ NEW: Location endpoint
  @POST('/user/addCustomerAddress')
  Future<AddAddressResponse> addCustomerAddress(
    @Header("Authorization") String authorization,
    @Body() AddAddressRequest request,
  );

  /// Get all customer addresses
 @GET('/user/getCustomerAddress')
  Future<GetCustomerAddressesResponse> getCustomerAddresses(
    @Header("Authorization") String token,
  );
    // Swagger: /user/getServiceProvider?categoryId=..&serviceId=..&locationId=..
  @GET('/user/getServiceProvider')
  Future<SaathiResponse> getServiceProvider(
    @Header("Authorization") String token,
    @Query("categoryId") String categoryId,
    @Query("serviceId") String serviceId,
    @Query("locationId") String locationId,
  );
   // ✨ Payment endpoint
  @POST('/user/createOrder')
  Future<CreateOrderResponse> createOrder(
    @Header("Authorization") String authorization,
    @Body() CreateOrderRequest request,
  );
}
