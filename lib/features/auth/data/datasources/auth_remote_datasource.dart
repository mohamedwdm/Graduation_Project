import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/network/api_constants.dart';
import 'package:go2car/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login({required String email, required String password}) async {
    final response = await _apiClient.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await _apiClient.post(ApiConstants.register, data: {
      'email': email,
      'password': password,
      'name': name,
    });
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.logout);
  }
}
