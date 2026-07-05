import 'package:equatable/equatable.dart';

class VehicleMapEntity extends Equatable {
  final String mapPath;
  final String slot;
  final String section;
  final String floor;
  final String slotNumber;
  final String sectionDisplay;
  final String sectionNameDisplay;

  const VehicleMapEntity({
    required this.mapPath,
    required this.slot,
    required this.section,
    required this.floor,
    required this.slotNumber,
    required this.sectionDisplay,
    required this.sectionNameDisplay,
  });

  @override
  List<Object?> get props => [
        mapPath,
        slot,
        section,
        floor,
        slotNumber,
        sectionDisplay,
        sectionNameDisplay,
      ];
}
