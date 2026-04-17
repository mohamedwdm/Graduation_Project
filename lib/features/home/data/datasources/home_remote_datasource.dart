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
    // Simulated remote call
    await Future.delayed(const Duration(milliseconds: 800));
    
    return DashboardSummaryModel.fromJson({
      'total_slots': 120,
      'available_slots': 45,
      'user_name': 'Ali Mohamed',
      'current_reservation_id': null,
      'last_activity': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    });
  }
}
