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
    final profileResponse = await _apiClient.get(ApiConstants.profile);
    final profileData = profileResponse.data as Map<String, dynamic>;
    final userName = profileData['name']?.toString() ?? 'User';

    final occupancyResponse = await _apiClient.get('/slots/occupancy');
    final occupancyData = occupancyResponse.data as Map<String, dynamic>;
    
    return DashboardSummaryModel(
      totalSlots: occupancyData['total_slots'] as int? ?? 0,
      availableSlots: occupancyData['free_slots'] as int? ?? 0,
      userName: userName,
      currentReservationId: null,
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
    );
  }
}
