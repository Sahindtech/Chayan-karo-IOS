import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/auth_models.dart';
import '../../models/home_models.dart';
import '../../models/customer_models.dart';  // Add customer models import

part 'api_service.g.dart';

@RestApi(baseUrl: "http://65.1.234.42:8081")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  // Auth endpoints
  @POST('/Authentication/Login')
  Future<OtpResponse> sendOtp(@Body() SendOtpRequest request);

  @POST('/Authentication/VerifyOTP')
  Future<AuthResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('/Authentication/RefreshToken')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  // Customer Profile endpoint
  @GET('/Customer/GetCustomer')
  Future<CustomerResponse> getCustomer(@Header("Authorization") String authorization);

  // Home endpoints (keeping your existing ones)
  @GET("/home/data")
  Future<HomeData> getHomeData();

  @GET("/categories")
  Future<List<ServiceCategory>> getCategories();

  @GET("/services/goto")
  Future<List<GoToService>> getGoToServices();

  @GET("/services/most-used")
  Future<List<Service>> getMostUsedServices();
}
