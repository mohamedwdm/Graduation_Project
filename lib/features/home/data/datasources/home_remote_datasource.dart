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
    // Guest users: skip protected endpoints — return minimal summary
    if (_apiClient.isGuest) {
      try {
        final occupancyResponse = await _apiClient.get(ApiConstants.availableSlots);
        final List data = occupancyResponse.data is List
            ? occupancyResponse.data as List
            : [];
        return DashboardSummaryModel(
          totalSlots: data.length,
          availableSlots: data.length,
          userName: 'Guest',
          currentReservationId: null,
          lastActivity: null,
        );
      } catch (_) {
        return const DashboardSummaryModel(
          totalSlots: 0,
          availableSlots: 0,
          userName: 'Guest',
          currentReservationId: null,
          lastActivity: null,
        );
      }
    }

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
