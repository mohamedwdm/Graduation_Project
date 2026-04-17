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
  });

  Future<void> logout();
  
  Future<AuthResponseModel> loginAsGuest();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponseModel> login({required String email, required String password}) async {
    // Simulated remote call
    await Future.delayed(const Duration(seconds: 1));
    
    return AuthResponseModel(
      token: 'mock_jwt_token_for_${email.split('@')[0]}',
      user: UserModel.fromJson({
        'userid': 'user_123',
        'name': email.split('@')[0],
        'email': email,
        'role': email == 'admin@go2car.com' ? 'admin' : 'user',
      }),
    );
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulated remote call
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiConstants.logout);
  }

  @override
  Future<AuthResponseModel> loginAsGuest() async {
    // This is currently a dummy implementation until the backend endpoint is ready.
    // In the future, this will call:
    // await _apiClient.post(ApiConstants.loginGuest);
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return AuthResponseModel(
      token: 'guest_token_from_server',
      user: UserModel.fromJson(const {
        'userid': 'guest_id_from_server',
        'name': 'Guest User',
        'email': 'guest@go2car.com',
      }),
    );
  }
}
