import 'package:equatable/equatable.dart';

enum SlotStatus { available, maintenance, occupied }

class SlotEntity extends Equatable {
  final String id;
  final String name;
  final int floor;
  final SlotStatus status;
  final String location;
  final bool isEV;
  final bool isAccessible;

  const SlotEntity({
    required this.id,
    required this.name,
    required this.floor,
    required this.status,
    required this.location,
    required this.isEV,
    required this.isAccessible,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        floor,
        status,
        location,
        isEV,
        isAccessible,
      ];
}
