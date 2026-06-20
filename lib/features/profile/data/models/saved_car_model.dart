import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/saved_car_entity.dart';

class SavedCarModel extends SavedCarEntity {
  const SavedCarModel({
    required super.id,
    required super.model,
    required super.color,
    required super.plateNumber,
  });

  factory SavedCarModel.fromJson(JsonMap json) {
    return SavedCarModel(
      id: (json['id'] ?? json['plate_number'] ?? '').toString(),
      model: (json['vehicle_type'] ?? json['model'] ?? '').toString(),
      color: (json['color'] ?? '').toString(),
      plateNumber: (json['plate_number'] ?? '').toString(),
    );
  }

  factory SavedCarModel.fromEntity(SavedCarEntity entity) {
    return SavedCarModel(
      id: entity.id,
      model: entity.model,
      color: entity.color,
      plateNumber: entity.plateNumber,
    );
  }

  JsonMap toJson() {
    return {
      'plate_number': plateNumber,
      'color': color,
      'vehicle_type': model,
    };
  }
}
