import 'package:equatable/equatable.dart';

class CarLocationEntity extends Equatable {
  final String slotId;
  final String slotLabel;
  final int floor;
  final String section;
  final DateTime parkedAt;
  final Duration? estimatedWalkTime;

  const CarLocationEntity({
    required this.slotId,
    required this.slotLabel,
    required this.floor,
    required this.section,
    required this.parkedAt,
    this.estimatedWalkTime,
  });

  @override
  List<Object?> get props => [
        slotId,
        slotLabel,
        floor,
        section,
        parkedAt,
        estimatedWalkTime,
      ];
}
