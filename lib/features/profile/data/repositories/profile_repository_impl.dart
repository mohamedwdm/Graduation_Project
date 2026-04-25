import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/network/network_info.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/saved_car_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import '../models/saved_car_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final bool isMockMode;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    this.isMockMode = true,
  });

  @override
  FutureEither<ProfileEntity> getProfile() async {
    if (isMockMode) {
      return Right(await remoteDataSource.fetchProfile());
    }

    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.fetchProfile();
        await localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localProfile = await localDataSource.getCachedProfile();
        if (localProfile != null) {
          return Right(localProfile);
        } else {
          return const Left(CacheFailure('No cached profile found'));
        }
      } catch (e) {
        return const Left(CacheFailure('Local database error'));
      }
    }
  }

  @override
  FutureEither<ProfileEntity> updateProfileName(String newName) async {
    if (isMockMode) {
      return Right(await remoteDataSource.updateProfileName(newName));
    }

    if (await networkInfo.isConnected) {
      try {
        final updatedProfile = await remoteDataSource.updateProfileName(newName);
        await localDataSource.cacheProfile(updatedProfile);
        return Right(updatedProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<List<SavedCarEntity>> getSavedCars() async {
    if (isMockMode) {
      return Right(await remoteDataSource.fetchSavedCars());
    }

    if (await networkInfo.isConnected) {
      try {
        final remoteCars = await remoteDataSource.fetchSavedCars();
        return Right(remoteCars);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<SavedCarEntity> addSavedCar(SavedCarEntity car) async {
    if (isMockMode) {
      return Right(await remoteDataSource.addSavedCar(SavedCarModel.fromEntity(car)));
    }

    if (await networkInfo.isConnected) {
      try {
        final remoteCar = await remoteDataSource.addSavedCar(SavedCarModel.fromEntity(car));
        return Right(remoteCar);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<SavedCarEntity> updateSavedCar(SavedCarEntity car) async {
    if (isMockMode) {
      return Right(await remoteDataSource.updateSavedCar(SavedCarModel.fromEntity(car)));
    }

    if (await networkInfo.isConnected) {
      try {
        final remoteCar = await remoteDataSource.updateSavedCar(SavedCarModel.fromEntity(car));
        return Right(remoteCar);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<void> deleteSavedCar(String id) async {
    if (isMockMode) {
      await remoteDataSource.deleteSavedCar(id);
      return const Right(null);
    }

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSavedCar(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
