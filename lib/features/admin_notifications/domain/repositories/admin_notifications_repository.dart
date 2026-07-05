import 'package:go2car/core/utils/typedefs.dart';
import '../entities/parking_overview_entity.dart';

abstract class AdminNotificationsRepository {
  FutureEither<AdminNotificationsEntity> getAdminNotifications();
}
