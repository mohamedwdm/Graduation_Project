import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/network/network_info.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/analysis_data_entity.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_datasource.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDataSource dataSource;
  final NetworkInfo networkInfo;

  AnalysisRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  FutureEither<AnalysisDataEntity> getAnalysisData() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.fetchAnalysisData();
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
