import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/dashboard_summary_model.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardSummaryModel> fetchDashboardSummary();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DashboardSummaryModel> fetchDashboardSummary() async {
    final response = await _apiClient.get(ApiConstants.dashboard);
    return DashboardSummaryModel.fromJson(response.data);
  }
}
