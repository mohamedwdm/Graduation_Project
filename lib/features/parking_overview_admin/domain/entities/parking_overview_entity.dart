import 'package:equatable/equatable.dart';
import 'camera_status_entity.dart';
import 'activity_log_entry_entity.dart';

class ParkingOverviewEntity extends Equatable {
  final int totalSlots;
  final int freeSlots;
  final int occupiedSlots;
  final int cameraCount;
  final List<CameraStatusEntity> cameras;
  final List<ActivityLogEntryEntity> activityLog;
  final String mapImageUrl;

  const ParkingOverviewEntity({
    required this.totalSlots,
    required this.freeSlots,
    required this.occupiedSlots,
    required this.cameraCount,
    required this.cameras,
    required this.activityLog,
    required this.mapImageUrl,
  });

  @override
  List<Object?> get props => [
        totalSlots,
        freeSlots,
        occupiedSlots,
        cameraCount,
        cameras,
        activityLog,
        mapImageUrl,
      ];
}
