import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/parking_overview_entity.dart';
import 'activity_log_entry_model.dart';

class AdminNotificationsModel extends AdminNotificationsEntity {
  const AdminNotificationsModel({
    required super.activityLog,

  });

  factory AdminNotificationsModel.fromJson(JsonMap json) {
    return AdminNotificationsModel(
    
      activityLog: (json['activity_log'] as List? ?? [])
          .map((i) => ActivityLogEntryModel.fromJson(i))
          .toList(),
   
    );
  }

  JsonMap toJson() {
    return {
      'activity_log': activityLog.map((i) => (i as ActivityLogEntryModel).toJson()).toList(),
    };
  }
}
