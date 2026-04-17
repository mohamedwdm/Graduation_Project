import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/network/api_client.dart';
import 'package:go2car/core/network/api_constants.dart';
import '../models/analysis_data_model.dart';
import 'analysis_datasource.dart';

class AnalysisRemoteDataSourceImpl implements AnalysisDataSource {
  final ApiClient _apiClient;

  AnalysisRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AnalysisDataModel> fetchAnalysisData() async {
    try {
      final response = await _apiClient.get(ApiConstants.adminAnalysis);
      
      if (response.statusCode == 200) {
        return AnalysisDataModel.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw const ForbiddenException();
      } else {
        throw ServerException(
          'Failed to fetch analysis data',
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
