import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.id,
    required super.name,
    required super.floor,
    required super.status,
    required super.location,
    required super.isEV,
    required super.isAccessible,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      floor: json['floor'] ?? 0,
      status: _parseSlotStatus(json['status']),
      location: json['location'] ?? '',
      isEV: json['isEV'] ?? false,
      isAccessible: json['isAccessible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'floor': floor,
      'status': status.name,
      'location': location,
      'isEV': isEV,
      'isAccessible': isAccessible,
    };
  }

  static SlotStatus _parseSlotStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return SlotStatus.available;
      case 'maintenance':
        return SlotStatus.maintenance;
      case 'occupied':
        return SlotStatus.occupied;
      default:
        return SlotStatus.available;
    }
  }
}
