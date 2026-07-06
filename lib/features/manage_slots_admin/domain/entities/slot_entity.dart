import 'package:equatable/equatable.dart';

enum SlotStatus { available, maintenance, occupied, booked }

class SlotEntity extends Equatable {
  final String id;
  final String name;
  final int floor;
  final SlotStatus status;
  final String location;
  final String slotType;

  const SlotEntity({
    required this.id,
    required this.name,
    required this.floor,
    required this.status,
    required this.location,
    required this.slotType,
  });

  bool get isEV => slotType == 'ev';
  bool get isAccessible => slotType == 'handicap' || slotType == 'accessible' || slotType == 'disabled';

  @override
  List<Object?> get props => [
        id,
        name,
        floor,
        status,
        location,
        slotType,
      ];
}
