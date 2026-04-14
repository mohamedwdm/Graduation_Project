import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/slots_repository.dart';
import '../datasources/slots_remote_datasource.dart';
import '../datasources/slots_socket_datasource.dart';

class SlotsRepositoryImpl implements SlotsRepository {
  final SlotsRemoteDataSource _remoteDataSource;
  final SlotsSocketDataSource _socketDataSource;
  final NetworkInfo _networkInfo;

  SlotsRepositoryImpl({
    required SlotsRemoteDataSource remoteDataSource,
    required SlotsSocketDataSource socketDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _socketDataSource = socketDataSource,
        _networkInfo = networkInfo;

  @override
  FutureEither<List<SlotEntity>> getSlots() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final remoteSlots = await _remoteDataSource.fetchAllSlots();
      return Right(remoteSlots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<SlotEntity> getSlotById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final remoteSlot = await _remoteDataSource.fetchSlotById(id);
      return Right(remoteSlot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  StreamEither<List<SlotEntity>> watchSlots() {
    _socketDataSource.connect();
    
    return _socketDataSource.watchSlotUpdates()
        .map<Either<Failure, List<SlotEntity>>>((slots) => Right(slots))
        .handleError((error) {
          if (error is ServerException) {
            return Left(ServerFailure(error.message, statusCode: error.statusCode));
          }
          return Left(ServerFailure(error.toString()));
        });
  }
}
