import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/car_location_model.dart';

abstract class FindCarRemoteDataSource {
  Future<CarLocationModel> findMyCar();
}

class FindCarRemoteDataSourceImpl implements FindCarRemoteDataSource {
  final ApiClient _apiClient;

  FindCarRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CarLocationModel> findMyCar() async {
    // Simulated remote call
    await Future.delayed(const Duration(milliseconds: 1200));
    
    return CarLocationModel.fromJson({
      'slot_id': 'slot_12',
      'slot_label': 'B-13',
      'floor': 2,
      'section': 'Section B',
      'parked_at': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'walk_time_seconds': 180,
    });
  }
}
