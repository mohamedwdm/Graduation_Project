import 'package:go2car/core/usecase/usecase.dart';
import 'package:go2car/core/utils/typedefs.dart';
import '../entities/parking_overview_entity.dart';
import '../repositories/admin_notifications_repository.dart';

class GetParkingOverviewUseCase implements UseCase<AdminNotificationsEntity, bool> {
  final AdminNotificationsRepository _repository;

  GetParkingOverviewUseCase(this._repository);

  @override
  FutureEither<AdminNotificationsEntity> call(bool onlyFlagged) async {
    return await _repository.getAdminNotifications(onlyFlagged: onlyFlagged);
  }
}
