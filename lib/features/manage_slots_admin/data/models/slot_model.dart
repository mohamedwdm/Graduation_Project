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
    int parsedFloor = 0;
    if (json['floor'] is int) {
      parsedFloor = json['floor'] as int;
    } else {
      final sectionData = json['section'];
      if (sectionData is Map) {
        final floorData = sectionData['floor'];
        if (floorData is Map) {
          final floorVal = floorData['floor_code'] ?? floorData['floor_name'] ?? '';
          parsedFloor = int.tryParse(floorVal.toString().replaceAll(RegExp(r'\D'), '')) ?? 0;
        }
      }
    }

    String parsedLocation = '';
    final sectionData = json['section'];
    if (sectionData is Map) {
      parsedLocation = (sectionData['section_name'] ?? sectionData['section_code'] ?? '').toString();
    } else {
      parsedLocation = (json['location'] ?? '').toString();
    }

    SlotStatus parsedStatus = SlotStatus.available;
    if (json['is_occupied'] == true) {
      parsedStatus = SlotStatus.occupied;
    } else if (json['status'] != null) {
      parsedStatus = _parseSlotStatus(json['status']?.toString());
    }

    return SlotModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['slot_code'] ?? '').toString(),
      floor: parsedFloor,
      status: parsedStatus,
      location: parsedLocation,
      isEV: json['isEV'] as bool? ?? json['has_ev_charging'] as bool? ?? false,
      isAccessible: json['isAccessible'] as bool? ?? json['is_accessible'] as bool? ?? false,
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
