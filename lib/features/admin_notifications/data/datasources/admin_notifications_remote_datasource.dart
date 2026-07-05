import 'package:go2car/core/errors/exceptions.dart';
import 'package:go2car/core/network/api_client.dart';
import '../models/parking_overview_model.dart';
import 'admin_notifications_datasource.dart';

import '../models/activity_log_entry_model.dart';

class AdminNotificationsRemoteDataSourceImpl implements AdminNotificationsDataSource {
  final ApiClient _apiClient;

  AdminNotificationsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AdminNotificationsModel> fetchAdminNotifications() async {
    try {
      final response = await _apiClient.get('/detection-logs/');

      if (response.statusCode == 200) {
        final List dataList = response.data as List? ?? [];
        final List<ActivityLogEntryModel> activityLog = dataList
            .map((e) => ActivityLogEntryModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return AdminNotificationsModel(
          activityLog: activityLog,
        );
      } else if (response.statusCode == 403) {
        throw const ForbiddenException();
      } else {
        throw ServerException('Failed to fetch detection logs from backend');
      }
    } on ForbiddenException {
      rethrow;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
