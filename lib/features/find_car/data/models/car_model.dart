import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/car_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    required super.id,
    required super.model,
    required super.color,
    required super.plateNumber,
    required super.parkingLocation,
    super.imagePath,
    super.slotId,
  });

  factory CarModel.fromJson(JsonMap json) {
    return CarModel(
      id: json['id']?.toString() ?? json['plate_number']?.toString() ?? '',
      model: (json['model'] ?? json['type'] ?? json['vehicle_type']) as String? ?? 'Unknown',
      color: (json['color'] ?? json['vehicle_color']) as String? ?? 'Unknown',
      plateNumber: json['plate_number'] as String? ?? '',
      parkingLocation: json['parking_location'] as String? ?? '',
      imagePath: json['image_path'] as String?,
      slotId: json['slot_id'] != null ? int.tryParse(json['slot_id'].toString()) : null,
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      id: entity.id,
      model: entity.model,
      color: entity.color,
      plateNumber: entity.plateNumber,
      parkingLocation: entity.parkingLocation,
      imagePath: entity.imagePath,
      slotId: entity.slotId,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'model': model,
      'color': color,
      'plate_number': plateNumber,
      'parking_location': parkingLocation,
      'image_path': imagePath,
      'slot_id': slotId,
    };
  }
}
