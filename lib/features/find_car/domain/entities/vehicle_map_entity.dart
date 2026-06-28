import 'package:equatable/equatable.dart';

class VehicleMapEntity extends Equatable {
  final String mapPath;
  final String slot;
  final String section;
  final String floor;

  const VehicleMapEntity({
    required this.mapPath,
    required this.slot,
    required this.section,
    required this.floor,
  });

  @override
  List<Object?> get props => [mapPath, slot, section, floor];
}
