import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/camera_status_entity.dart';

class CameraStatusModel extends CameraStatusEntity {
  const CameraStatusModel({
    required super.id,
    required super.label,
    required super.isOnline,
    required super.lastEvent,
    required super.lastEventTime,
  });

  factory CameraStatusModel.fromJson(JsonMap json) {
    return CameraStatusModel(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      isOnline: json['is_online'] ?? false,
      lastEvent: json['last_event']?.toString() ?? '',
      lastEventTime: json['last_event_time'] != null
          ? DateTime.parse(json['last_event_time'])
          : DateTime.now(),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'label': label,
      'is_online': isOnline,
      'last_event': lastEvent,
      'last_event_time': lastEventTime.toIso8601String(),
    };
  }
}
