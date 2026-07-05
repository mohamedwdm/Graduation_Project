import 'package:equatable/equatable.dart';
import 'activity_log_entry_entity.dart';

class AdminNotificationsEntity extends Equatable {

  final List<ActivityLogEntryEntity> activityLog;

  const AdminNotificationsEntity({
    required this.activityLog,
  });

  @override
  List<Object?> get props => [

        activityLog,
      ];
}
