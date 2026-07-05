import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/vehicle_map_entity.dart';

class VehicleMapModel extends VehicleMapEntity {
  const VehicleMapModel({
    required super.mapPath,
    required super.slot,
    required super.section,
    required super.floor,
    required super.slotNumber,
    required super.sectionDisplay,
    required super.sectionNameDisplay,
  });

  factory VehicleMapModel.fromJson(JsonMap json) {
    final slot = json['slot']?.toString() ?? '';
    final section = json['section']?.toString() ?? '';
    final floor = json['floor']?.toString() ?? '';

    // Derivation helpers if backend doesn't supply cleaned fields
    String deriveSlotNumber(String s) {
      return s.replaceAll(RegExp(r'slot\s*', caseSensitive: false), '').trim();
    }

    String deriveSectionDisplay(String sec) {
      return sec.replaceAll(RegExp(r'section\s*', caseSensitive: false), '').trim();
    }

    String deriveSectionNameDisplay(String sec) {
      final clean = deriveSectionDisplay(sec);
      return clean.isNotEmpty ? 'Section $clean' : '';
    }

    return VehicleMapModel(
      mapPath: json['map_path']?.toString() ?? '',
      slot: slot,
      section: section,
      floor: floor,
      slotNumber: json['slot_number']?.toString() ?? deriveSlotNumber(slot),
      sectionDisplay: json['section_display']?.toString() ?? deriveSectionDisplay(section),
      sectionNameDisplay: json['section_name_display']?.toString() ?? deriveSectionNameDisplay(section),
    );
  }

  JsonMap toJson() {
    return {
      'map_path': mapPath,
      'slot': slot,
      'section': section,
      'floor': floor,
      'slot_number': slotNumber,
      'section_display': sectionDisplay,
      'section_name_display': sectionNameDisplay,
    };
  }
}
