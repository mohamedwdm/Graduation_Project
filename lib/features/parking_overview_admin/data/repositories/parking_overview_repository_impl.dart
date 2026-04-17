import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/network/network_info.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/parking_overview_entity.dart';
import '../../domain/repositories/parking_overview_repository.dart';
import '../datasources/parking_overview_datasource.dart';

class ParkingOverviewRepositoryImpl implements ParkingOverviewRepository {
  final ParkingOverviewDataSource dataSource;
  final NetworkInfo networkInfo;

  ParkingOverviewRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  FutureEither<ParkingOverviewEntity> getParkingOverview() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.fetchParkingOverview();
        return Right(result);
      } on ForbiddenException {
        return const Left(ForbiddenFailure('Access Denied: Admin Only'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
