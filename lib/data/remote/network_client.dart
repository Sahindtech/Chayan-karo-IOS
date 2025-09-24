import 'package:dio/dio.dart';
import 'api_service.dart';

class NetworkClient {
  // Singleton instance, initialized lazily and thread-safe
  static final NetworkClient _instance = NetworkClient._internal();

  late final Dio _dio;
  late final ApiService _apiService;

  // Private named constructor
  NetworkClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://65.1.234.42:8081',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());

    _apiService = ApiService(_dio);
  }

  // Dart recommended singleton factory
  factory NetworkClient() => _instance;

  ApiService get apiService => _apiService;
  Dio get dio => _dio;

  LogInterceptor _createLoggingInterceptor() => LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: false,
    error: true,
    logPrint: (obj) => print('🌐 API: $obj'),
  );

  InterceptorsWrapper _createAuthInterceptor() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await _getStoredToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  );

  InterceptorsWrapper _createErrorInterceptor() => InterceptorsWrapper(
    onError: (error, handler) {
      _handleDioError(error);
      handler.next(error);
    },
  );

  Future<String?> _getStoredToken() async {
    // Implement your token fetch logic here
    return null;
  }

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        print('❌ Connection timeout');
        break;
      case DioExceptionType.sendTimeout:
        print('❌ Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('❌ Receive timeout');
        break;
      case DioExceptionType.badResponse:
        print('❌ Bad response: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('❌ Request cancelled');
        break;
      case DioExceptionType.connectionError:
        print('❌ Connection error');
        break;
      case DioExceptionType.badCertificate:
        print('❌ Bad certificate error');
        break;
      case DioExceptionType.unknown:
        print('❌ Unknown error: ${error.message}');
        break;
    }
  }
}
