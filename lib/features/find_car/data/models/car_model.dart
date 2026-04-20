import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/car_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    required super.id,
    required super.model,
    required super.color,
    required super.plateNumber,
    required super.parkingLocation,
  });

  factory CarModel.fromJson(JsonMap json) {
    return CarModel(
      id: json['id'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      plateNumber: json['plate_number'] as String,
      parkingLocation: json['parking_location'] as String,
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      id: entity.id,
      model: entity.model,
      color: entity.color,
      plateNumber: entity.plateNumber,
      parkingLocation: entity.parkingLocation,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'model': model,
      'color': color,
      'plate_number': plateNumber,
      'parking_location': parkingLocation,
    };
  }
}
