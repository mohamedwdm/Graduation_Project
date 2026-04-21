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
      id: json['id'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      plateNumber: json['plate_number'] as String,
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
      'id': id,
      'model': model,
      'color': color,
      'plate_number': plateNumber,
    };
  }
}
