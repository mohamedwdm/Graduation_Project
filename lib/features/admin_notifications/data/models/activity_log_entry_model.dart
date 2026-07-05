import 'package:go2car/core/utils/typedefs.dart';
import '../../domain/entities/activity_log_entry_entity.dart';

class ActivityLogEntryModel extends ActivityLogEntryEntity {
  const ActivityLogEntryModel({
    required super.id,
    required super.cameraName,
    super.slotCode,
    super.plateNumber,
    super.vehicleColor,
    super.vehicleType,
    super.detectedAt,
    required super.flaggedForReview,
  });

  factory ActivityLogEntryModel.fromJson(JsonMap json) {
    return ActivityLogEntryModel(
      id: json['id']?.toString() ?? '',
      cameraName: json['camera_name']?.toString() ?? '',
      slotCode: json['slot_code']?.toString(),
      plateNumber: json['plate_number']?.toString(),
      vehicleColor: json['vehicle_color']?.toString(),
      vehicleType: json['vehicle_type']?.toString(),
      detectedAt: json['detected_at'] != null
          ? DateTime.parse(json['detected_at'])
          : null,
      flaggedForReview: json['flagged_for_review'] as bool? ?? false,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'camera_name': cameraName,
      'slot_code': slotCode,
      'plate_number': plateNumber,
      'vehicle_color': vehicleColor,
      'vehicle_type': vehicleType,
      'detected_at': detectedAt?.toIso8601String(),
      'flagged_for_review': flaggedForReview,
    };
  }
}
