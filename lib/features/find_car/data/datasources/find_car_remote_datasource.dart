import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/utils/typedefs.dart';
import '../models/car_model.dart';

abstract class FindCarRemoteDataSource {
  Future<List<CarModel>> getUserCars();
}

class FindCarRemoteDataSourceImpl implements FindCarRemoteDataSource {
  final ApiClient _apiClient;

  FindCarRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CarModel>> getUserCars() async {
    final response = await _apiClient.get(ApiConstants.findCar);
    final List vehiclesList = response.data['data'] as List;

    final List<CarModel> cars = [];
    for (final v in vehiclesList) {
      final json = v as Map<String, dynamic>;
      final plate = json['plate_number'] as String? ?? '';
      
      String parkingLocation = 'Not parked';
      try {
        final locRes = await _apiClient.get('/vehicles/$plate/location');
        if (locRes.statusCode == 200 && locRes.data != null && locRes.data['data'] != null) {
          final locData = locRes.data['data'];
          final floor = locData['floor'] ?? '';
          final section = locData['section'] ?? '';
          final slot = locData['slot'] ?? '';
          parkingLocation = '$floor, $section - Slot $slot';
        }
      } catch (_) {
        // Safe to ignore, defaults to 'Not parked' if vehicle not found or not parked
      }

      cars.add(CarModel(
        id: plate,
        model: json['vehicle_type'] as String? ?? 'Unknown',
        color: json['color'] as String? ?? 'Unknown',
        plateNumber: plate,
        parkingLocation: parkingLocation,
      ));
    }
    return cars;
  }
}
