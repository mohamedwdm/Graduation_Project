import 'dart:developer';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/car_model.dart';

abstract class FindCarRemoteDataSource {
  Future<List<CarModel>> searchCars(
    String query, {
    String? floor,
    String? section,
    String? brand,
    String? color,
  });
  Future<List<String>> getFloors();
  Future<List<String>> getSections();
  Future<String> getSlotMap(int slotId);
  Future<Map<String, dynamic>> getVehicleMap(String plate);
}

class FindCarRemoteDataSourceImpl implements FindCarRemoteDataSource {
  final ApiClient _apiClient;

  FindCarRemoteDataSourceImpl(this._apiClient);

  @override
  Future<String> getSlotMap(int slotId) async {
    final response = await _apiClient.get(ApiConstants.slotMap(slotId));
    final data = response.data;
    if (data != null) {
      if (data is String) {
        return data.replaceAll('"', '').replaceAll("'", "").trim();
      }
      if (data is Map) {
        final Map mapData = data['data'] is Map ? data['data'] : data;
        final keys = ['map_path', 'map_image_path', 'image_path', 'path', 'map'];
        for (final key in keys) {
          if (mapData[key] != null) {
            return mapData[key].toString().replaceAll('"', '').replaceAll("'", "").trim();
          }
        }
        if (data['data'] is String) {
          return data['data'].toString().replaceAll('"', '').replaceAll("'", "").trim();
        }
      }
    }
    throw Exception('Failed to retrieve slot map. Response was: $data');
  }

  @override
  Future<Map<String, dynamic>> getVehicleMap(String plate) async {
    final response = await _apiClient.get(ApiConstants.vehicleMap(plate));
    final data = response.data;
    if (data != null && data is Map) {
      final Map<String, dynamic> mapData = data['data'] is Map ? Map<String, dynamic>.from(data['data']) : {};
      return mapData;
    }
    throw Exception('Failed to retrieve vehicle map. Response was: $data');
  }

  @override
  Future<List<CarModel>> searchCars(
    String query, {
    String? floor,
    String? section,
    String? brand,
    String? color,
  }) async {
    final List<CarModel> allResults = [];
    final Set<String> uniquePlates = {};

    void addCars(List dataList) {
      for (final item in dataList) {
        final json = item as Map<String, dynamic>;
        final plate = json['plate_number'] as String? ?? '';
        if (plate.isNotEmpty && !uniquePlates.contains(plate)) {
          uniquePlates.add(plate);
          final floorVal = (json['floor'] ?? '').toString();
          final floorStr = floorVal.toLowerCase().startsWith('floor') ? floorVal : 'Floor $floorVal';
          
          final sectionVal = (json['section_name_display'] ?? json['section_display'] ?? json['section'] ?? '').toString();
          final sectionStr = sectionVal.toLowerCase().startsWith('section') ? sectionVal : 'Section $sectionVal';
          
          final slotVal = (json['slot_number'] ?? json['slot'] ?? '').toString();
          final slotStr = 'Slot $slotVal';

          allResults.add(CarModel(
            id: plate,
            model: (json['type'] ?? json['vehicle_type']) as String? ?? 'Unknown',
            color: (json['color'] ?? json['vehicle_color']) as String? ?? 'Unknown',
            plateNumber: plate,
            parkingLocation: '$floorStr, $sectionStr - $slotStr',
            imagePath: json['image_path'] as String?,
            slotId: json['slot_id'] != null ? int.tryParse(json['slot_id'].toString()) : null,
          ));
        }
      }
    }

    Future<List<dynamic>> queryField(Map<String, String> extraParams) async {
      try {
        final Map<String, String> queryParameters = {};
        if (floor != null && floor.isNotEmpty) {
          queryParameters['floor'] = floor;
        }
        if (section != null && section.isNotEmpty) {
          queryParameters['section'] = section;
        }
        if (brand != null && brand.isNotEmpty) {
          queryParameters['type'] = brand;
        }
        if (color != null && color.isNotEmpty) {
          queryParameters['color'] = color;
        }
        queryParameters.addAll(extraParams);

        final response = await _apiClient.get(
          ApiConstants.searchAdvanced,
          queryParameters: queryParameters,
        );
        if (response.data != null && response.data['data'] != null) {
          return response.data['data'] as List;
        }
      } catch (_) {
        // Ignore 404 or connection errors
      }
      return [];
    }

    final List<Future<List<dynamic>>> futures = [];

    if (query.isNotEmpty) {
      futures.add(queryField({'plate_number': query}));
    } else {
      futures.add(queryField({}));
    }

    final results = await Future.wait(futures);

    for (final list in results) {
      addCars(list);
    }

    return allResults;
  }

  @override
  Future<List<String>> getFloors() async {
    try {
      final response = await _apiClient.get(ApiConstants.floors);
      if (response.data != null) {
        final List list = response.data is List ? response.data : (response.data['data'] ?? []);
        final parsed = list
            .map((item) => (item['floor_name']?.toString() ?? '').trim())
            .where((name) => name.isNotEmpty)
            .toList();
        if (parsed.isNotEmpty) return parsed;
      }
      throw Exception('Floors list is empty in response');
    } catch (e, stack) {
      // Diagnostic logging
      log('FindCarRemoteDataSourceImpl.getFloors error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<String>> getSections() async {
    try {
      final response = await _apiClient.get(ApiConstants.sections);
      if (response.data != null) {
        final List list = response.data is List ? response.data : (response.data['data'] ?? []);
        final seen = <String>{};
        final result = <String>[];
        for (final item in list) {
          final display = (item['section_display']?.toString() ??
                  item['section_name_display']?.toString() ??
                  item['section_name']?.toString() ??
                  '')
              .trim();
          if (display.isNotEmpty && seen.add(display)) {
            result.add(display);
          }
        }
        if (result.isNotEmpty) return result;
      }
      throw Exception('Sections list is empty in response');
    } catch (e, stack) {
      // Diagnostic logging
      log('FindCarRemoteDataSourceImpl.getSections error: $e\n$stack');
      rethrow;
    }
  }
}
