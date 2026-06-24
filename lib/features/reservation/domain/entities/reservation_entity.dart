import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final int id;
  final int userId;
  final int slotId;
  final int? vehicleId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;

  const ReservationEntity({
    required this.id,
    required this.userId,
    required this.slotId,
    this.vehicleId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        slotId,
        vehicleId,
        startTime,
        endTime,
        status,
        createdAt,
      ];
}
