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
    final response = await _apiClient.get(ApiConstants.findCar);
    return CarLocationModel.fromJson(response.data);
  }
}
