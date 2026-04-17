import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/activity_log_entry_entity.dart';

class ActivityLogEntryModel extends ActivityLogEntryEntity {
  const ActivityLogEntryModel({
    required super.id,
    required super.eventType,
    required super.description,
    required super.timestamp,
  });

  factory ActivityLogEntryModel.fromJson(JsonMap json) {
    return ActivityLogEntryModel(
      id: json['id']?.toString() ?? '',
      eventType: json['event_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'event_type': eventType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
