import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    String? id,
    String? label,
    bool? isOccupied,
    int? floor,
    String? section,
    bool hasEvCharging = false,
    bool isAccessible = false,
    DateTime? lastUpdated,
    // Legacy support for older code in repos/
    String? slotId,
    String? locationNote,
    bool? isAvailable,
    int? floorIndex,
  }) : super(
          id: id ?? slotId ?? '',
          label: label ?? slotId ?? '',
          isOccupied: isOccupied ?? !(isAvailable ?? true),
          floor: floor ?? floorIndex ?? 0,
          section: section ?? locationNote ?? '',
          hasEvCharging: hasEvCharging,
          isAccessible: isAccessible,
          lastUpdated: lastUpdated,
        );

  factory SlotModel.fromJson(JsonMap json) {
    int parsedFloor = 0;
    if (json['floor'] is int) {
      parsedFloor = json['floor'] as int;
    } else if (json['floorIndex'] is int) {
      parsedFloor = json['floorIndex'] as int;
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

    String parsedSection = '';
    final sectionData = json['section'];
    if (sectionData is Map) {
      parsedSection = (sectionData['section_name'] ?? sectionData['section_code'] ?? '').toString();
    } else if (sectionData != null) {
      parsedSection = sectionData.toString();
    } else {
      parsedSection = (json['locationNote'] ?? '').toString();
    }

    return SlotModel(
      id: json['id']?.toString() ?? json['slotId']?.toString() ?? '',
      label: json['label']?.toString() ?? json['slot_code']?.toString() ?? json['slotId']?.toString() ?? '',
      isOccupied: json['is_occupied'] as bool? ?? !(json['isAvailable'] as bool? ?? true),
      floor: parsedFloor,
      section: parsedSection,
      hasEvCharging: json['has_ev_charging'] as bool? ?? json['hasEvCharging'] as bool? ?? false,
      isAccessible: json['is_accessible'] as bool? ?? json['isAccessible'] as bool? ?? false,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'label': label,
      'is_occupied': isOccupied,
      'floor': floor,
      'section': section,
      'has_ev_charging': hasEvCharging,
      'is_accessible': isAccessible,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  factory SlotModel.fromSocketEvent(JsonMap json) {
    // Socket data might be slightly different or nested, but based on the plan:
    return SlotModel.fromJson(json);
  }
}
