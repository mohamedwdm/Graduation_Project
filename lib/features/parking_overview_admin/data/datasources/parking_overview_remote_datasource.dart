import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/network/api_constants.dart';
import '../models/parking_overview_model.dart';
import 'parking_overview_datasource.dart';

class ParkingOverviewRemoteDataSourceImpl implements ParkingOverviewDataSource {
  final ApiClient _apiClient;

  ParkingOverviewRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ParkingOverviewModel> fetchParkingOverview() async {
    try {
      final response = await _apiClient.get(ApiConstants.adminParkingOverview);
      
      if (response.statusCode == 200) {
        return ParkingOverviewModel.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw const ForbiddenException();
      } else {
        throw ServerException(
          'Failed to fetch parking overview',
          statusCode: response.statusCode,
          responseBody: response.data,
        );
      }
    } on ForbiddenException {
      rethrow;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
