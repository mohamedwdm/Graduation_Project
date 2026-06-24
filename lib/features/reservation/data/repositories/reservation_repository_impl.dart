import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_remote_datasource.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReservationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureEither<ReservationEntity> createReservation({
    required String slotCode,
    required String plateNumber,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createReservation(
          slotCode: slotCode,
          plateNumber: plateNumber,
          startTime: startTime,
          endTime: endTime,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<List<ReservationEntity>> getMyReservations() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.fetchMyReservations();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  FutureEither<ReservationEntity> cancelReservation(int reservationId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.cancelReservation(reservationId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
