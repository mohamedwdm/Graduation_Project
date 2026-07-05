import 'package:dartz/dartz.dart';
import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/errors/failures.dart';
import 'package:go2car/core/network/network_info.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/parking_overview_entity.dart';
import '../../domain/repositories/admin_notifications_repository.dart';
import '../datasources/admin_notifications_datasource.dart';

class AdminNotificationsRepositoryImpl implements AdminNotificationsRepository {
  final AdminNotificationsDataSource dataSource;
  final NetworkInfo networkInfo;

  AdminNotificationsRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  FutureEither<AdminNotificationsEntity> getAdminNotifications({bool onlyFlagged = false}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.fetchAdminNotifications(onlyFlagged: onlyFlagged);
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
