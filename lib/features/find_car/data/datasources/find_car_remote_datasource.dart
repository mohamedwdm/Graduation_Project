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
    final List data = response.data as List;
    return data.map((json) => CarModel.fromJson(json as JsonMap)).toList();
  }
}
