import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/car_model.dart';

abstract class FindCarRemoteDataSource {
  Future<List<CarModel>> searchCars(String query);
}

class FindCarRemoteDataSourceImpl implements FindCarRemoteDataSource {
  final ApiClient _apiClient;

  FindCarRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CarModel>> searchCars(String query) async {
    final List<CarModel> allResults = [];
    final Set<String> uniquePlates = {};

    void addCars(List dataList) {
      for (final item in dataList) {
        final json = item as Map<String, dynamic>;
        final plate = json['plate_number'] as String? ?? '';
        if (plate.isNotEmpty && !uniquePlates.contains(plate)) {
          uniquePlates.add(plate);
          final floor = json['floor'] ?? '';
          final section = json['section'] ?? '';
          final slot = json['slot'] ?? '';
          allResults.add(CarModel(
            id: plate,
            model: json['vehicle_type'] as String? ?? 'Unknown',
            color: json['vehicle_color'] as String? ?? 'Unknown',
            plateNumber: plate,
            parkingLocation: '$floor, $section - Slot $slot',
          ));
        }
      }
    }

    // 1. Query by Plate
    try {
      final response = await _apiClient.get(
        ApiConstants.searchPlate,
        queryParameters: {'plate': query},
      );
      if (response.data != null && response.data['data'] != null) {
        addCars(response.data['data'] as List);
      }
    } catch (_) {
      // Ignore errors / no records found
    }

    // 2. Query by Color attribute
    try {
      final response = await _apiClient.get(
        ApiConstants.searchAttributes,
        queryParameters: {'color': query},
      );
      if (response.data != null && response.data['data'] != null) {
        addCars(response.data['data'] as List);
      }
    } catch (_) {
      // Ignore errors / no records found
    }

    // 3. Query by Vehicle Type attribute
    try {
      final response = await _apiClient.get(
        ApiConstants.searchAttributes,
        queryParameters: {'vehicle_type': query},
      );
      if (response.data != null && response.data['data'] != null) {
        addCars(response.data['data'] as List);
      }
    } catch (_) {
      // Ignore errors / no records found
    }

    return allResults;
  }
}
