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
  FutureEither<List<CarEntity>> getUserCars() async {
    if (isMockMode) {
      return const Right([
        CarEntity(
          id: '1',
          model: 'Tesla Model S',
          color: 'Red',
          plateNumber: 'ABC-1234',
          parkingLocation: 'Parking Lot A, Slot 32',
        ),
        CarEntity(
          id: '2',
          model: 'Ford Mustang',
          color: 'White',
          plateNumber: 'XYZ-9876',
          parkingLocation: 'Parking Lot C, Slot 11',
        ),
        CarEntity(
          id: '3',
          model: 'BMW i8',
          color: 'Blue',
          plateNumber: 'CAR-5555',
          parkingLocation: 'Parking Garage B, Level 2',
        ),
      ]);
    }

    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final cars = await _remoteDataSource.getUserCars();
      return Right(cars);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
