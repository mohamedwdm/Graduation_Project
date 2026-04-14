import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/car_location_entity.dart';

class CarLocationModel extends CarLocationEntity {
  const CarLocationModel({
    required super.slotId,
    required super.slotLabel,
    required super.floor,
    required super.section,
    required super.parkedAt,
    super.estimatedWalkTime,
  });

  factory CarLocationModel.fromJson(JsonMap json) {
    return CarLocationModel(
      slotId: json['slot_id'] as String,
      slotLabel: json['slot_label'] as String,
      floor: json['floor'] as int,
      section: json['section'] as String,
      parkedAt: DateTime.parse(json['parked_at'] as String),
      estimatedWalkTime: json['walk_time_seconds'] != null
          ? Duration(seconds: json['walk_time_seconds'] as int)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'slot_id': slotId,
      'slot_label': slotLabel,
      'floor': floor,
      'section': section,
      'parked_at': parkedAt.toIso8601String(),
      'walk_time_seconds': estimatedWalkTime?.inSeconds,
    };
  }
}
