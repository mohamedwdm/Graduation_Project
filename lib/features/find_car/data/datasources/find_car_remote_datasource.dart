import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/car_model.dart';

abstract class FindCarRemoteDataSource {
  Future<List<CarModel>> searchCars(String query, {String? floor, String? section});
  Future<List<String>> getFloors();
  Future<List<String>> getSections();
}

class FindCarRemoteDataSourceImpl implements FindCarRemoteDataSource {
  final ApiClient _apiClient;

  FindCarRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CarModel>> searchCars(String query, {String? floor, String? section}) async {
    final List<CarModel> allResults = [];
    final Set<String> uniquePlates = {};

    void addCars(List dataList) {
      for (final item in dataList) {
        final json = item as Map<String, dynamic>;
        final plate = json['plate_number'] as String? ?? '';
        if (plate.isNotEmpty && !uniquePlates.contains(plate)) {
          uniquePlates.add(plate);
          final floorVal = json['floor'] ?? '';
          final sectionVal = json['section'] ?? '';
          final slotVal = json['slot'] ?? '';
          allResults.add(CarModel(
            id: plate,
            model: (json['type'] ?? json['vehicle_type']) as String? ?? 'Unknown',
            color: (json['color'] ?? json['vehicle_color']) as String? ?? 'Unknown',
            plateNumber: plate,
            parkingLocation: '$floorVal, $sectionVal - Slot $slotVal',
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
      futures.add(queryField({'color': query}));
      futures.add(queryField({'type': query}));
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
        return list
            .map((item) => (item['floor_name'] as String? ?? '').trim())
            .where((name) => name.isNotEmpty)
            .toList();
      }
    } catch (_) {
      // Return empty list on error
    }
    return [];
  }

  @override
  Future<List<String>> getSections() async {
    try {
      final response = await _apiClient.get(ApiConstants.sections);
      if (response.data != null) {
        final List list = response.data is List ? response.data : (response.data['data'] ?? []);
        return list
            .map((item) => (item['section_name'] as String? ?? '').trim())
            .where((name) => name.isNotEmpty)
            .toList();
      }
    } catch (_) {
      // Return empty list on error
    }
    return [];
  }
}
