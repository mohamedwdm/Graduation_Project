import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/car_entity.dart';
import '../../domain/repositories/find_car_repository.dart';
import '../datasources/find_car_remote_datasource.dart';

class FindCarRepositoryImpl implements FindCarRepository {
  final FindCarRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final bool isMockMode;

  FindCarRepositoryImpl({
    required FindCarRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
    required this.isMockMode,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;



  @override
  FutureEither<List<CarEntity>> searchCars(String query) async {
    if (isMockMode) {
      return const Right([]);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final cars = await _remoteDataSource.searchCars(query);
      return Right(cars);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
