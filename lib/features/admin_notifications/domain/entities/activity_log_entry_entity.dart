import 'package:equatable/equatable.dart';

class ActivityLogEntryEntity extends Equatable {
  final String id;
  final String cameraName;
  final String? slotCode;
  final String? plateNumber;
  final String? vehicleColor;
  final String? vehicleType;
  final DateTime? detectedAt;
  final bool flaggedForReview;

  const ActivityLogEntryEntity({
    required this.id,
    required this.cameraName,
    this.slotCode,
    this.plateNumber,
    this.vehicleColor,
    this.vehicleType,
    this.detectedAt,
    required this.flaggedForReview,
  });

  @override
  List<Object?> get props => [
        id,
        cameraName,
        slotCode,
        plateNumber,
        vehicleColor,
        vehicleType,
        detectedAt,
        flaggedForReview,
      ];
}
