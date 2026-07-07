import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../network/api_client.dart';
import '../websocket/socket_manager.dart';
import '../config/app_router.dart';

class AuthInterceptor extends Interceptor {
  String? _token;

  AuthInterceptor(this._token);

  String? get token => _token;

  void updateToken(String? token) => _token = token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('REQUEST[${options.method}] => PATH: ${options.path}');
    if (options.data != null) {
      log('DATA: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log('ErrorInterceptor: Token expired or unauthorized (401). Clearing session and redirecting to login.');
      final getIt = GetIt.instance;
      try {
        final localDataSource = getIt<AuthLocalDataSource>();
        await localDataSource.clearUser();
        await localDataSource.clearToken();
        
        final apiClient = getIt<ApiClient>();
        apiClient.updateAuthToken(null);
        apiClient.setGuestMode(false);
        
        final socketManager = getIt<SocketManager>();
        socketManager.updateToken(null);
      } catch (e) {
        log('Error clearing session: $e');
      }

      // Redirect user to the login screen
      AppRouter.router.go(AppRouter.loginPath);
    }
    super.onError(err, handler);
  }
}
