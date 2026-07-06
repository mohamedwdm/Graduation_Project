import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/network/api_constants.dart';
import 'package:go2car/features/auth/data/models/auth_response_model.dart';
import 'package:go2car/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String userType,
  });

  Future<void> logout();
  
  Future<AuthResponseModel> loginAsGuest({required String userType});

  Future<void> verifyEmail({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login({required String email, required String password}) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    await _apiClient.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'user_type': userType,
      },
    );
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.logout);
  }

  @override
  Future<AuthResponseModel> loginAsGuest({required String userType}) async {
    final response = await _apiClient.post(
      ApiConstants.loginGuest,
      queryParameters: {'user_type': userType},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    await _apiClient.get(
      ApiConstants.verifyEmail,
      queryParameters: {'token': token},
    );
  }
}
