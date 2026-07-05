import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/network/api_client.dart';
import '../models/analysis_data_model.dart';
import 'analysis_datasource.dart';

class AnalysisRemoteDataSourceImpl implements AnalysisDataSource {
  final ApiClient _apiClient;

  AnalysisRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AnalysisDataModel> fetchAnalysisData() async {
    try {
      final responses = await Future.wait([
        _apiClient.get('/admin/analytics/summary'),
        _apiClient.get('/cameras/stats'),
        // _apiClient.get('/admin/analytics/history'),
      ]);

      final summaryRes = responses[0];
      final camerasRes = responses[1];

      if (summaryRes.statusCode == 200 &&
          camerasRes.statusCode == 200) {
        
        final summaryData = summaryRes.data['data'] as Map<String, dynamic>? ?? {};
        final camerasData = camerasRes.data as Map<String, dynamic>? ?? {};

        final totalCapacity = summaryData['total_slots'] as int? ?? 0;
        final occupiedCount = summaryData['occupied_slots'] as int? ?? 0;
        final freeCount = summaryData['free_slots'] as int? ?? 0;
        final occupancyPercent = (summaryData['occupancy_percentage'] as num?)?.toDouble() ?? 0.0;

        final onlineCameras = camerasData['active'] as int? ?? 0;
        final offlineCameras = camerasData['inactive'] as int? ?? 0;

        return AnalysisDataModel(
          occupancyPercent: occupancyPercent,
          occupiedCount: occupiedCount,
          freeCount: freeCount,
          totalCapacity: totalCapacity,
          onlineCameras: onlineCameras,
          offlineCameras: offlineCameras,
        );
      } else if (summaryRes.statusCode == 403 ||
                 camerasRes.statusCode == 403) {
        throw const ForbiddenException();
      } else {
        throw ServerException('Failed to fetch analysis data from backend');
      }
    } on ForbiddenException {
      rethrow;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
