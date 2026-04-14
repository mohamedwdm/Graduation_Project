import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  FutureEither<ProfileEntity> getProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteProfile = await _remoteDataSource.fetchProfile();
        await _localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cachedProfile = await _localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        return Right(cachedProfile);
      }
      return const Left(CacheFailure('No cached profile found'));
    }
  }

  @override
  FutureEither<ProfileEntity> updateProfile(ProfileEntity updated) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = ProfileModel.fromEntity(updated);
      final remoteUpdated = await _remoteDataSource.updateProfile(model);
      await _localDataSource.cacheProfile(remoteUpdated);
      return Right(remoteUpdated);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<String> uploadAvatar(String filePath) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final avatarUrl = await _remoteDataSource.uploadAvatar(filePath);
      return Right(avatarUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
