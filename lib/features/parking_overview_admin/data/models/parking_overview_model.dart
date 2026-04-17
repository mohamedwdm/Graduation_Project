import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/parking_overview_entity.dart';
import 'camera_status_model.dart';
import 'activity_log_entry_model.dart';

class ParkingOverviewModel extends ParkingOverviewEntity {
  const ParkingOverviewModel({
    required super.totalSlots,
    required super.freeSlots,
    required super.occupiedSlots,
    required super.cameraCount,
    required super.cameras,
    required super.activityLog,
    required super.mapImageUrl,
  });

  factory ParkingOverviewModel.fromJson(JsonMap json) {
    return ParkingOverviewModel(
      totalSlots: json['total_slots'] ?? 0,
      freeSlots: json['free_slots'] ?? 0,
      occupiedSlots: json['occupied_slots'] ?? 0,
      cameraCount: json['camera_count'] ?? 0,
      cameras: (json['cameras'] as List? ?? [])
          .map((i) => CameraStatusModel.fromJson(i))
          .toList(),
      activityLog: (json['activity_log'] as List? ?? [])
          .map((i) => ActivityLogEntryModel.fromJson(i))
          .toList(),
      mapImageUrl: json['map_image_url']?.toString() ?? '',
    );
  }

  JsonMap toJson() {
    return {
      'total_slots': totalSlots,
      'free_slots': freeSlots,
      'occupied_slots': occupiedSlots,
      'camera_count': cameraCount,
      'cameras': cameras.map((i) => (i as CameraStatusModel).toJson()).toList(),
      'activity_log': activityLog.map((i) => (i as ActivityLogEntryModel).toJson()).toList(),
      'map_image_url': mapImageUrl,
    };
  }
}
