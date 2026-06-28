import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/vehicle_map_entity.dart';

class VehicleMapModel extends VehicleMapEntity {
  const VehicleMapModel({
    required super.mapPath,
    required super.slot,
    required super.section,
    required super.floor,
  });

  factory VehicleMapModel.fromJson(JsonMap json) {
    return VehicleMapModel(
      mapPath: json['map_path'] as String? ?? '',
      slot: json['slot'] as String? ?? '',
      section: json['section'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
    );
  }

  JsonMap toJson() {
    return {
      'map_path': mapPath,
      'slot': slot,
      'section': section,
      'floor': floor,
    };
  }
}
