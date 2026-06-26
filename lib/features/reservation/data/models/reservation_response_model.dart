import '../../domain/entities/reservation_entity.dart';

class ReservationResponseModel extends ReservationEntity {
  const ReservationResponseModel({
    required super.id,
    required super.userId,
    required super.slotId,
    super.vehicleId,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
    super.userName,
    super.userEmail,
    super.plateNumber,
    super.slotCode,
  });

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationResponseModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      slotId: json['slot_id'] as int,
      vehicleId: json['vehicle_id'] as int?,
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: DateTime.parse(json['end_time'] as String).toLocal(),
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      plateNumber: json['plate_number'] as String?,
      slotCode: json['slot_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'slot_id': slotId,
      'vehicle_id': vehicleId,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'user_name': userName,
      'user_email': userEmail,
      'plate_number': plateNumber,
      'slot_code': slotCode,
    };
  }
}

