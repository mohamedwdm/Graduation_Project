import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/network/network_info.dart';
import 'package:go2car/core/utils/typedefs.dart';
import 'package:go2car/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:go2car/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/websocket/socket_manager.dart';
import 'package:go2car/features/auth/domain/entities/user_entity.dart';
import 'package:go2car/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ApiClient _apiClient;
  final SocketManager _socketManager;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required ApiClient apiClient,
    required SocketManager socketManager,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _apiClient = apiClient,
        _socketManager = socketManager;

  @override
  FutureEither<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }

    try {
      final authResponse = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      
      final token = authResponse.token;
      final user = authResponse.user;

      // Token Orchestration
      await _localDataSource.cacheToken(token);
      _apiClient.updateAuthToken(token);
      _socketManager.updateToken(token);
      
      await _localDataSource.cacheUser(user);
      
      return right(user);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, statusCode: e.statusCode));
    } on UnauthorizedException catch (e) {
      return left(AuthFailure(e.message));
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureVoid register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }

    try {
      await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureVoid logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      return right(null);
    } catch (e) {
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      return right(null);
    }
  }
}
