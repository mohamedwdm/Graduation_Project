import 'package:equatable/equatable.dart';

class SlotEntity extends Equatable {
  final String id;
  final String label;
  final bool isOccupied;
  final int floor;
  final String section;
  final bool hasEvCharging;
  final bool isAccessible;
  final DateTime? lastUpdated;

  const SlotEntity({
    required this.id,
    required this.label,
    required this.isOccupied,
    required this.floor,
    required this.section,
    this.hasEvCharging = false,
    this.isAccessible = false,
    this.lastUpdated,
  });

  // UI Compatibility Getters
  String get slotId => label;
  String get locationNote => 'Floor $floor, Section $section';
  bool get isAvailable => !isOccupied;
  int get floorIndex => floor;

  @override
  List<Object?> get props => [
        id,
        label,
        isOccupied,
        floor,
        section,
        hasEvCharging,
        isAccessible,
        lastUpdated,
      ];
}
