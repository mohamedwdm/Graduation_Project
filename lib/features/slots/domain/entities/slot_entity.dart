import 'package:equatable/equatable.dart';

class SlotEntity extends Equatable {
  final String id;
  final String label;
  final bool isOccupied;
  final int floor;
  final String section;
  final String slotType;
  final DateTime? lastUpdated;
  final String status;
  final String slotNumber;
  final String sectionDisplay;
  final String sectionNameDisplay;

  const SlotEntity({
    required this.id,
    required this.label,
    required this.isOccupied,
    required this.floor,
    required this.section,
    required this.slotNumber,
    required this.sectionDisplay,
    required this.sectionNameDisplay,
    required this.slotType,
    this.lastUpdated,
    this.status = 'available',
  });

  bool get hasEvCharging => slotType == 'ev';
  bool get isAccessible => slotType == 'handicap' || slotType == 'accessible' || slotType == 'disabled';

  // UI Compatibility Getters
  String get slotId => label;
  String get locationNote => 'Floor $floor, $sectionNameDisplay';
  bool get isAvailable => status == 'available';
  int get floorIndex => floor;

  @override
  List<Object?> get props => [
        id,
        label,
        isOccupied,
        floor,
        section,
        slotType,
        lastUpdated,
        status,
        slotNumber,
        sectionDisplay,
        sectionNameDisplay,
      ];
}
